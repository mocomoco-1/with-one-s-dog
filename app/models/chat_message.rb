class ChatMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :chat_room

  # メッセージ作成時に自動でブロードキャスト
  after_create_commit do
    Rails.logger.info "🔄 ChatMessage created - id=#{self.id}"
    # ジョブの詳細な情報をログ出力
    job = ChatMessageBroadcastJob.perform_later(self)
    Rails.logger.info "📤 Job enqueued - job_id=#{job.job_id}, queue=#{job.queue_name}"
    # GoodJobのレコードも確認
    good_job_record = GoodJob::Job.find_by(active_job_id: job.job_id)
    if good_job_record
      Rails.logger.info "✅ GoodJob record created - id=#{good_job_record.id}"
    else
      Rails.logger.error "❌ GoodJob record not found for job_id=#{job.job_id}"
    end
  end
end
