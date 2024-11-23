---
title: docker+poetry基本.md
tags:
  - docker
---

## 環境構築方法

docker+poetryで環境構築する方法を記載する  

基本的に以下の3ファイルを任意のディレクトリにおいて    
docker composeすれば立ち上がる  

## dockerfile

```Dockerfile
# Pythonの軽量バージョンをベースイメージに
FROM python:3.11-slim

# 作業ディレクトリを/appに設定
WORKDIR /app

# poetryのPATHを通す
ENV PATH="/root/.local/bin:$PATH"

# curlのインストールとキャッシュ削除
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Poetryインストールとシンボリックリンク作成
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create false --no-interaction && \
    rm -rf /root/.cache/pypoetry

# カレントディレクトリの全ファイルをコンテナにコピー
COPY . . 

# Poetryで依存関係をインストール（対話なし、色なし）
RUN poetry install --no-interaction --no-ansi
```

<br>

### 詳細解説

```dockerfile
FROM python:3.11-slim
```
- 公式Pythonイメージの軽量版を使用
- `slim`は必要最小限のパッケージのみ含む  
- サイズ: 通常版約900MB → slim版約130MB

<br>

```dockerfile
WORKDIR /app
```
- コンテナ内の作業ディレクトリを設定  
- 以降のCOPYやRUNコマンドはこのパスで実行  
- コンテナ起動時のデフォルトディレクトリにもなる  

<br>

```dockerfile
ENV PATH="/root/.local/bin:$PATH"
```
- Poetryコマンドのパスを環境変数に追加   
- `/root/.local/bin`: Poetryのインストール先  
- システム全体でpoetryコマンドを使用可能に  

<br>

```dockerfile
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*
```
- `apt-get update`: パッケージリスト更新  
- `curl`: インストール（Poetry用）  
- `rm -rf`: キャッシュ削除でイメージサイズ削減  

<br>

```dockerfile
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create false --no-interaction && \
    rm -rf /root/.cache/pypoetry
```
- Poetryインストール（-sSL: 進捗非表示、リダイレクト追跡）  
- 仮想環境作成を無効化(poetryで仮想環境を作成することを防ぐため)   
- インストールキャッシュ削除  

<br>

```dockerfile
COPY . .
```
- ビルドコンテキストの全ファイルを`/app`にコピー
- `.dockerignore`で除外可能

<br>

```dockerfile
RUN poetry install --no-interaction --no-ansi
```
- 依存関係インストール  
- `--no-interaction`: プロンプト無効  
- `--no-ansi`: カラー出力無効  

## compose.yml

```yml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/app
    ports:
      - "8001:8000"
    command: bash
    stdin_open: true
    tty: true
```

### 詳細解説

```yaml
services:
  app:
```
- サービスの名前を`app`として定義  
- 複数のサービスを定義可能  

<br>

```yaml
build:
  context: .
  dockerfile: Dockerfile
```
- `context`: ビルドに使用するディレクトリ（`.`は現在のディレクトリ）  
- `dockerfile`: 使用するDockerfileのパス  

<br>

```yaml
volumes:
  - .:/app
```
- ホストの現在のディレクトリ(.)をコンテナの/appにマウント  
- 開発時のソースコード変更がリアルタイムに反映される  

<br>

```yaml
ports:
  - "8001:8000"
```
- ホスト:コンテナのポートマッピング  
- ホストの8001がコンテナの8000にマッピング  

<br>

```yaml
command: bash
```
- コンテナ起動時に実行するコマンド  
- `bash`で対話的シェルを起動  

<br>

```yaml
stdin_open: true
tty: true
```
- `stdin_open`: 標準入力を開いたまま（docker run -i）  
- `tty`: 疑似TTY割り当て（docker run -t）  
- シェルを対話的に使用するために必要  

## pyproject.toml

nameの箇所に任意の名前(ディレクトリ名)を入れる  
poetry initで作成する場合はAuthoerをnにする以外はenterを教えておけばok  

```toml
[tool.poetry]
name = "test"
version = "0.1.0"
description = ""
authors = ["Your Name <you@example.com>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.10"


[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```