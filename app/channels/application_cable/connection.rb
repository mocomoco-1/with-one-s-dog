module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      Rails.logger.info "✅ ActionCable connected: user_id=#{current_user&.id}"
    end

    private

    def find_verified_user
      # Deviseのwarden経由でユーザーを取得
      if verified_user = env["warden"]&.user
        return verified_user
      end
      # クッキーからuser_idを取得する方法（フォールバック）
      if user_id = cookies.encrypted[:user_id]
        user = User.find_by(id: user_id)
        return user if user
      end
      # 認証できない場合
      Rails.logger.warn "⚠️ ActionCable: User not authenticated"
      reject_unauthorized_connection
    end
  end
end
