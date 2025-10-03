class DogDiagnosis::DiagnosesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :questions, :result ]
  def index; end

  def questions
    @questions = Question.includes(:choices).order(:id)
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

  def to_diary
    diagnosis = Diagnosis.find(params[:id])
    redirect_to new_diary_path(
      diary: {
        content: "今日のうちの子のきもち診断は「#{diagnosis.title}」でした！\n#{diagnosis.dog_message}って言っているみたい💭"
      }
    )
  end

  private

  def diagnose_params
    params.permit(choice_ids: [])
  end
end
