require 'json'
class AiConsultationsController < ApplicationController
  def new
    @advice = nil
  end

  def create
    category = params[:category]
    situation = params[:situation]
    dog_reaction = params[:dog_reaction]
    goal = params[:goal]
    details = params[:details]

    prompt = <<-PROMPT
      以下保護犬の飼い主さんからの相談です。
      1. 悩みの内容: #{params[:category]}
      2. いつ起こるか: #{params[:situation]}
      3. 愛犬の様子: #{params[:dog_reaction]}
      4. 愛犬にどうなってほしいか、一緒に何がしたいか: #{params[:goal]}
      5. その他補足: #{params[:details]}

      保護犬に詳しいトレーナー兼アドバイザーとして回答してください。
      共感の姿勢をもちつつ、優しく実用的なアドバイスをしてください。
      以下のJSON形式で、キーや値の型も完全に守って応答してください。
      {
        "summary": "どんなことに悩みを持っているか要約",
        "empathy": "共感的メッセージ",
        "advice": "実用的なアドバイス3つ以上",
        "cheer": "応援、励ましの言葉"
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
    rescue OpenAI::Error => e
      # APIエラーが発生した場合の処理
      @error_message = "AIとの通信中にエラーが発生しました: #{e.message}"
    rescue JSON::ParserError => e
      # JSONのパースに失敗した場合の処理
      @error_message = "AIからの応答を正しく解析できませんでした。もう一度お試しください。"
    end
    render :new, status: :ok
  end
end
