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

# # PostgreSQLが完全に起動するまで待機（改良版）
# echo "Waiting for PostgreSQL to be ready..."
# until pg_isready -h db -p 5432 -U postgres; do
#   echo "PostgreSQL is unavailable - sleeping"
#   sleep 2
# done

# echo "PostgreSQL is up - continuing..."

# # 追加の接続テスト
# until PGPASSWORD=password psql -h db -U postgres -d postgres -c '\q' 2>/dev/null; do
#   echo "PostgreSQL is not accepting connections - sleeping"
#   sleep 2
# done

# echo "PostgreSQL is accepting connections!"
