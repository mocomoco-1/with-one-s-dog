if Rails.application.credentials.openai.present? && Rails.application.credentials.openai[:api_key].present?
  OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.openai[:api_key]
  end
end
