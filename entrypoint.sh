#!/bin/bash
set -e

# Rails に対応したファイル server.pid が存在しているかもしれないので削除する。
rm -f /app/tmp/pids/server.pid
# 本番環境の場合のみアセットプリコンパイル
if [ "$RAILS_ENV" = "production" ]; then
  echo "Precompiling assets for production..."
  bundle exec rails assets:clean
  bundle exec rails assets:precompile
fi
# データベース準備
bundle exec rails db:prepare
# サーバー起動
exec bundle exec rails server -b 0.0.0.0
