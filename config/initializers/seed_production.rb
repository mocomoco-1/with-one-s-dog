if Rails.env.production? && Question.count == 0
  Rails.logger.info "💡 本番DBにSeedデータを作成します"
  load Rails.root.join("db/seeds/diagnosis.rb")
end