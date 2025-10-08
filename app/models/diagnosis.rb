class Diagnosis < ApplicationRecord
  has_many :choices_diagnoses, dependent: :destroy
  has_many :choices, through: :choices_diagnoses

  validates :title, presence: true, length: { maximum: 255 }
  validates :explanation, presence: true, length: { maximum: 1000 }
  validates :dog_message, presence: true, length: { maximum: 255 }

  def self.diagnose(selected_choice_ids)
    puts "受け取った選択肢ID: #{selected_choice_ids}"
    puts "選択肢IDの型: #{selected_choice_ids.class}"
    # 引数のバリデーション
    return nil if selected_choice_ids.nil? || selected_choice_ids.empty?
    # 存在する選択肢を確認
    existing_choices = Choice.where(id: selected_choice_ids)
    if existing_choices.size != selected_choice_ids.size
      Rails.logger.info "存在しない選択肢IDが含まれています:#{selected_choice_ids - existing_choices.pluck(:id)}"
      return nil
    end
    # 1. 各選択肢に関連するdiagnosis_idを取得
    diagnosis_ids = ChoicesDiagnosis.where(choice_id: selected_choice_ids).pluck(:diagnosis_id)
    puts "取得したdiagnosis_ids: #{diagnosis_ids}"
    puts "diagnosis_idsが空?: #{diagnosis_ids.empty?}"
    # 2. diagnosis_idごとの出現回数をカウント
    diagnosis_counts = diagnosis_ids.each_with_object(Hash.new(0)) do |diagnosis_id, counts|
    counts[diagnosis_id] += 1
    end
    puts "diagnosis_idのカウント: #{diagnosis_counts}"
    # diagnosis_idsという配列を使って、each_with_objectメソッドを呼び出しているんだ。このメソッドは、配列の各要素を順番に処理しながら、指定したオブジェクト（ここではハッシュ）を作ることができる
    # 0を引数に渡すことで、ハッシュにまだ存在しないキー（diagnosis_id）を参照したときに自動的に0が返される。これのおかげで、カウントを簡単にできるようになる
    # ここで、現在のdiagnosis_idのカウントを1増やしてる。例えば、最初のdiagnosis_idが1だったとき、counts[1]が0から1になり、次にまた1が来たときにはcounts[1]が1から2になる

    # 3. 最後の質問（質問5）の選択肢なら重み2倍
    choice_questions = Choice.where(id: selected_choice_ids).pluck(:id, :question_id)
    puts "選んだ選択肢IDと質問ID: #{choice_questions}"
    question5_choice_ids = choice_questions.select { |choice_id, question_id| question_id == 5 }.map { |choice_id, question_id| choice_id }
    question5_diagnosis_ids = ChoicesDiagnosis.where(choice_id: question5_choice_ids).pluck(:diagnosis_id)
    question5_diagnosis_ids.each do |diagnosis_id|
      diagnosis_counts[diagnosis_id] += 2
    end
    puts "重み付け後のカウント: #{diagnosis_counts}"
    # 質問と選択肢idをChoicesテーブルから取得
    # そこからquestion_id==5のもののみselect、choice_idのみ配列に入れる。
    # 取得したchoice_idを中間テーブルを利用してdiagnosis_idを取得。
    # diagnosis_idのカウントを2を追加している
    # 4. 最も多いdiagnosis_idを特定
    max_count = diagnosis_counts.values.max
    puts "最大カウント: #{max_count}"
    max_diagnosis_ids = diagnosis_counts.select { |k, v| v == max_count }.keys
    puts "最大カウントのdiagnosis_id一覧: #{max_diagnosis_ids}"
    most_common_diagnosis_id = max_diagnosis_ids.sample
    puts "選択されたdiagnosis_id: #{most_common_diagnosis_id}"

    # 一番多い診断結果の回数を数えて最大値を格納
    # selectで選ばれた要素のキー（ここではdiagnosis_id）だけを取り出して、max_diagnosis_idsに格納
    # 5. 該当するResultオブジェクトを返す
    Diagnosis.find(most_common_diagnosis_id)
  end
end
