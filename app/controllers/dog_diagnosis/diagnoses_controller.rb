class DogDiagnosis::DiagnosesController < ApplicationController
  def index; end

  def questions
    @questions = Question.includes(:choices).order(:id)
    Rails.logger.info "💡 @questions: #{@questions.inspect}"
    # 本番環境でブラウザから確認できるように debug 出力
    @questions_count = @questions.count
    @questions_debug = @questions.map do |q|
      { id: q.id, text: q.text, choices: q.choices.map { |c| { id: c.id, text: c.text } } }
    end
  end

  def result
    puts "受け取ったparams: #{params}"
    puts "params[:answers]: #{params[:answers]}"
    puts "params[:answers]の型: #{params[:answers].class}"
    if params[:answers].present?
      parsed_answers = JSON.parse(params[:answers])
      puts "パース後のanswers: #{parsed_answers}"
      selected_choice_ids = parsed_answers.values.map(&:to_i)
      puts "変換後のchoice_ids: #{selected_choice_ids}"
      @result = Diagnosis.diagnose(selected_choice_ids)
    else
      puts "answersパラメータが存在しません"
      redirect_to dog_diagnosis_questions_path, alert: "診断データが見つかりませんでした。もう一度お試しください。"
    end
  end

  private

  def diagnose_params
    params.permit(choice_ids: [])
  end
end
