FROM ruby:3.2.5

# タイムゾーンと文字コード設定
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ENV RAILS_ENV=production

# 必要なシステムライブラリをインストール
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    ca-certificates \
    curl \
    gnupg \
    vim \
    nano \
    postgresql-client \
    imagemagick \
    libvips \
    # Node.js 20.x をインストール
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    # Yarn をインストール
    && npm install --global yarn \
    # 不要なパッケージを削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# 作業ディレクトリを設定
WORKDIR /app

# Gemfileを先にコピー（Docker キャッシュ効率化）
COPY Gemfile Gemfile.lock ./

# bundler をインストールしてから bundle install
RUN gem install bundler:2.6.9 && bundle install

# package.jsonがある場合は先にコピー（将来的にフロントエンド依存関係用）
COPY package*.json yarn.lock* ./
RUN if [ -f "package.json" ]; then yarn install; fi

# entrypoint.sh をコピーして実行権限を付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# アプリケーション全体をコピー
COPY . .

# secret_key_baseを一時的に設定してアセットプリコンパイル
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:clean
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# entrypoint を設定
ENTRYPOINT ["entrypoint.sh"]

# デフォルトコマンド
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]