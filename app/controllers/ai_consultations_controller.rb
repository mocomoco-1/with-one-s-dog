require 'json'
class AiConsultationsController < ApplicationController
  def new
    @advice = nil
    @ai_consultation = AiConsultation.new
  end

  def create
    @ai_consultation = current_user.ai_consultations.build(
    category: params[:category],
    situation: params[:situation],
    dog_reaction: params[:dog_reaction],
    goal: params[:goal],
    details: params[:details]
    )
    if @ai_consultation.save
      prompt = <<-PROMPT
        以下保護犬の飼い主さんからの相談です。
        1. 悩みの内容: #{@ai_consultation.category}
        2. いつ起こるか: #{@ai_consultation.situation}
        3. 愛犬の様子: #{@ai_consultation.dog_reaction}
        4. 愛犬にどうなってほしいか、一緒に何がしたいか: #{@ai_consultation.goal}
        5. その他補足: #{@ai_consultation.details}

        保護犬に詳しいトレーナー兼アドバイザーとして、保護犬特有の背景（トラウマ・社会化不足・環境変化への敏感さ）を考慮して回答してください。
        回答には最新の犬の行動科学や動物福祉の知見（ポジティブ強化、罰を避ける、ストレスサインの読み取りなど）も取り入れてください。
        また、日本の一般的な飼育環境（住宅街、室内飼育、近隣への配慮など）を想定したアドバイスを心がけてください。
        安全面を第一に考え、初心者でも実践可能な手順で具体的に説明してください。保護犬特有の背景を考慮して回答してください。
        以下のJSON形式で、キーや値の型も完全に守って応答してください。
        {
          "summary": "どんなことに悩みを持っているかをわかりやすく2～3行要約してください",
          "empathy": "飼い主のきもちに寄り添い、安心でき、前向きに改善していこうと思えるような共感的メッセージ",
          "advice": {
            "short_term": ["今日からすぐできる工夫やコツを初心者でもわかる用意具体的に3つ以上書いてください"
            "例：環境調整、声掛けの工夫、飼い主の行動の工夫など"],
            "long_term": ["時間をかけて少しずつ取り組むトレーニング方法や習慣づけをわかりやすく、ステップに分けて2～3個書いてください",
            "例：社会化トレーニング、信頼関係づくり、行動を分けて練習する方法など"]
          },
          "cheer": "飼い主が前向きに行動できるように、優しい応援、励ましの言葉を書いてください"
        }
      PROMPT

      client = OpenAI::Client.new

      begin
        response = client.chat(
          parameters:{
            model: "gpt-4o-mini",
            messages: [ { role: "user", content: prompt } ],
            response_format: { type: "json_object" },
            temperature: 0.7,
          }
        )
        raw_response = response.dig("choices", 0, "message", "content")
        @advice = JSON.parse(raw_response)
        @ai_consultation.update(initial_response: @advice.to_json)
      rescue OpenAI::Error => e
        # APIエラーが発生した場合の処理
        @error_message = "AIとの通信中にエラーが発生しました: #{e.message}"
      rescue JSON::ParserError => e
        # JSONのパースに失敗した場合の処理
        @error_message = "AIからの応答を正しく解析できませんでした。もう一度お試しください。"
      end
    else
      @error_message = "相談の保存に失敗しました"
    end
    respond_to do |format|
      format.turbo_stream  # app/views/ai_consultations/create.turbo_stream.erb が呼ばれる
      format.html { render :new, status: :ok }
    end
  end

  def followup
    @ai_consultation = AiConsultation.find(params[:id])
    question = params[:question]

    messages = [
      { role: "system", content: "あなたは保護犬専門のトレーナー兼アドバイザーです。
      自由形式の自然な文章で、改行や箇条書きで見やすい回答してください。
      Markdown形式を一切使わず、テキストのみで書いてください。絵文字は使用してください。
      自由形式では、飼い主の具体的な状況に合わせた補足や追加アドバイスを柔軟に提供してください。
      ただし、必ず飼い主への共感と励ましの言葉を含めること、保護犬特有の背景を考慮すること、最新の犬の行動科学の知見を参考にすることは含めてください。" },
      { role: "assistant", content: @ai_consultation.initial_response },
      { role: "user", content: question }
    ]

    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: messages,
        temperature: 0.7
      }
    )

    answer = response.dig("choices", 0, "message", "content")
    @followup = @ai_consultation.ai_followups.create!(question: question, response: answer)
    respond_to do |format|
    format.turbo_stream
    format.html { render :new, status: :ok }
    end
  end
end
