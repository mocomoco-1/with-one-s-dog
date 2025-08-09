#!/bin/bash
set -e

# PostgreSQLが完全に起動するまで待機（改良版）
echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h db -p 5432 -U postgres; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

echo "PostgreSQL is up - continuing..."

# 追加の接続テスト
until PGPASSWORD=password psql -h db -U postgres -d postgres -c '\q' 2>/dev/null; do
  echo "PostgreSQL is not accepting connections - sleeping"
  sleep 2
done

echo "PostgreSQL is accepting connections!"

# サーバーPIDファイルの削除
rm -f /app/tmp/pids/server.pid

# データベースの準備
echo "Preparing database..."
bundle exec rails db:prepare

# 渡されたコマンドを実行
exec "$@"