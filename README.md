# ruby-rails-rspec-prac

※現在開発途中のため書きかけです．  

Ruby 2.7 on Rails 6.0 でサーバサイドを勉強するために作成．  
成果物から得られること

- チュートリアル以上の実践的な Rails の使い方
  - 詳細は [references/ruby-rails/rails-proc.md](https://github.com/krtsato/references/blob/master/ruby-rails/rails-proc.md) を参照
- RSpec, Capybara を用いたテストコードの書き方
  - 詳細は [references/ruby-rails/rspec-syntax.md](https://github.com/krtsato/references/blob/master/ruby-rails/rspec-syntax.md) を参照
- ワンコマンドで環境構築を完了させるスクリプト群

<br>

リポジトリ概要

- [機能](#機能)
- [環境](#環境)
- [環境構築](#環境構築)

<br>

## 機能

- 随時追加
- タスク は [Issue](https://github.com/krtsato/ruby-rails-rspec-prac/issues) で管理する
- Issue 毎にブランチを切って実装完了後にプルリク・マージ

<br>

## 環境

- Docker
- Ruby
- Rails
- PostgreSQL
- RSpec
- Capybara
- RuboCop
- Webpacker
- jQuery
- ERB

フロントエンドは今回の学習範囲に含めないため jQuery のコピペで済ませる．  
なお，モダンなフロントエンドの構成・設計については [react-redux-ts-prac](https://github.com/krtsato/react-redux-ts-prac) および [redux-arch](https://github.com/krtsato/references/blob/master/react-redux-ts/redux-arch.md) を参照されたい．

<br>

## 環境構築

- 要件
  - init_proj 配下のシェルスクリプト
  - リポジトリに含まれない .env ファイル
  - ２種類のシェル
    - zsh : ホストマシン側
    - bash : コンテナ側
    - 普段は zsh を使うが Docker 内で Linux 標準の bash を動かしたかった

- 注意
  - アプリの性質上 macOS における /etc/hosts に追記する
    - ローカルで稼働させない場合は追記箇所を削除する
    - ルート権限を行使するため，シェルスクリプトが一時停止したときパスワードを入力する

- 実行内容
  - create-setup-files.sh
    - 各種設定ファイルを生成する
      - Docker 関連
      - RuboCop 関連
      - config/ 配下の一部ファイル
      - Gemfile
      - Rakefile
      - .gitignore
  - create-rc-files.sh
    - コンテナのホームディレクトリに rc ファイルを生成する
      - .gemrc
      - .psqlrc
    - Dockerfile 内で実行される
  - setup.sh
    - 環境構築のメインスレッド
      - bundle install
      - rails new
      - yarn check
      - rails db:create
      - rails g rspec:install
      - rubocop --auto-gen-config
      - 最終的に start-rails-server.sh を呼び出す
  - start-rails-server.sh
    - web サーバを起動する
      - bundle check
      - pid ファイルの削除
      - rails s

```zsh
# init_proj/*.sh と .env を配置後
% ./init_proj/setup.sh

# 途中で入力する
Password: **********
```

- 構築後の確認
  - コンテナ
    - rrrp-web-cont
    - rrrp-db-cont
  - ブラウザから以下のアドレスにアクセスする
    - [http://example.com:3000](http://example.com:3000)
    - [http://rrrp.example.com:3000](http://rrrp.example.com:3000)

```zsh
# web サーバを起動する
% docker-compose up -d web
```
