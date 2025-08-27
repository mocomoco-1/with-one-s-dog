if Rails.env.production? && defined?(Question)
  if Question.count == 0
    Rails.logger.info "💡 本番DBにSeedデータを作成します"
    load Rails.root.join("db/seeds/diagnosis.rb")
  end
end