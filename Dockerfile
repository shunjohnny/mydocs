FROM python:3.11-slim

# 作業ディレクトリを設定
WORKDIR /app

# 必要な依存関係をインストール
RUN pip install --upgrade pip

# 依存関係のインストールをまとめる
RUN pip install \
    mkdocs \
    mkdocs-material 

# デフォルトで mkdocs サーバーを起動する
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]