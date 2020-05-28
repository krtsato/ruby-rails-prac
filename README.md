# ruby-rails-rspec-prac

サービス自体ではなく，それに付随する顧客管理システムの制作．

Ruby 2.7 on Rails 6.0 でサーバサイドを学習した．  
モデル間で発生する CRUD や Rails 特有の機能を把握した．

[成果物](#成果物)から得られること

- チュートリアル以上の実践的な Rails の使い方
  - 詳細は [references/ruby-rails/rails-proc.md](https://github.com/krtsato/references/blob/master/ruby-rails/rails-proc.md) を参照
- RSpec, Capybara を用いたテストコードの書き方
  - 詳細は [references/ruby-rails/rspec-syntax.md](https://github.com/krtsato/references/blob/master/ruby-rails/rspec-syntax.md) を参照
- ワンコマンドで環境構築を完了させるスクリプト群

<br>

リポジトリ概要

- [成果物](#成果物)
- [機能](#機能)
- [環境](#環境)
- [環境構築](#環境構築)
  - [development 環境](#development-環境)
  - [production 環境](#production-環境)

<br>

## 成果物

- [https://rrrp.customer-manage.work](https://rrrp.customer-manage.work)
- ログインデータ
  - 管理者
    - E メール : hanako@example.com
    - パスワード : password
  - 職員
    - E メール : taro@example.com
    - パスワード : password

<br>

## 機能

- ユーザ認証・認可
  - 管理者 : Administrator
  - 職員 : StaffMember
  - 顧客 : Customer
- 管理者の機能
  - 職員に対する CRUD
  - 職員のログイン・ログアウト記録の閲覧
  - ページネーション
  - 職員の強制ログアウト
- 職員の機能
  - アカウント閲覧・編集
  - N + 1 問題への対応
- 顧客の機能
  - アカウントの CRUD
  - 任意入力への対応
  - 電話番号への対応
- Rails 独自の共通化機能
  - フォームオブジェクト
  - サービスオブジェクト
  - プレゼンタ
  - ActiveSupport::Concern
- RSpec・Capybara によるテスト
  - shared_examples による共通化
  - FactoryBot の活用
- その他
  - エラーハンドリング
  - セッションタイムアウト
  - モデルの正規化・バリデーション
  - BCrypt によるパスワードのハッシュ化
  - DB インデックスによるクエリ高速化
  - タスク は [Issue](https://github.com/krtsato/ruby-rails-rspec-prac/issues) で管理する
  - Issue 毎にブランチを切って実装完了後にプルリク・マージ

<br>

## 環境

- Docker
- Puma
- Nginx
- Ruby
- Rails
- PostgreSQL
- RSpec
- Capybara
- RuboCop
- Webpacker
- ERB
- AWS (ACM, ALB, EC2, RDS)

フロントエンドは今回の学習範囲に含めないため Rails モノリスで仕上げる．  
なお，モダンなフロントエンドの構成・設計については [react-redux-ts-prac](https://github.com/krtsato/react-redux-ts-prac) および [redux-arch](https://github.com/krtsato/references/blob/master/react-redux-ts/redux-arch.md) を参照されたい．

AWS は初学のためシンプルな構成にまとめた．  
EC2 上で docker-compose を展開し HTTPS 通信で Rails に繋げる．

![rrrp-aws](https://user-images.githubusercontent.com/32429977/83172936-48905f00-a153-11ea-8daf-7a48cbe038a5.png)

<br>

## 環境構築

### development 環境

- 要件
  - init_proj 配下のシェルスクリプト
  - リポジトリに含まれない .env ファイル
  - ２種類のシェル
    - zsh : ホストマシン側
    - bash : コンテナ側
    - 普段は zsh を使うが Docker 内で Linux 標準の bash を動かしたかった

- 注意
  - 開発環境では，アプリの性質上 macOS における /etc/hosts に追記する
    - ルート権限を行使するため，シェルスクリプトが一時停止したときパスワードを入力する
  - 本番環境に対して mac からアクセスする前に，追記箇所を削除する
    - お名前.com に登録した DNS の参照ができくなるため

- 実行内容
  - create-setup-files.sh
    - 各種設定ファイルを生成する
      - Docker 関連
      - RuboCop 関連
      - config/ 配下の一部ファイル
      - lib/ 配下の一部ファイル
      - Gemfile
      - Rakefile
      - nginx.conf
      - .gitignore
  - create-rc-files.sh
    - コンテナのホームディレクトリに rc ファイルを生成する
      - .gemrc
      - .psqlrc
    - Dockerfile 内で実行される
  - setup-dev.sh
    - 環境構築のメインスレッド
      - bundle install
      - rails new
      - yarn check
      - rails db:create
      - rails g rspec:install
      - rails g kaminari 関連
      - rubocop --auto-gen-config
      - 自動生成後のファイル編集
      - 最終的に start-puma-server.sh を呼び出す
  - start-puma-server.sh
    - db コンテナが起動しているか確認する
    - web サーバを起動する
      - bundle check
      - pid ファイルの削除
      - puma の起動

```zsh
# init_proj/ 配下と .env を配置後
% ./init_proj/setup/setup-dev.sh

# 途中で入力する
Password: **********
```

- 構築後の確認
  - コンテナ
    - rrrp-db-cont
    - rrrp-nginx-cont
    - rrrp-web-cont
  - ブラウザから以下のアドレスにアクセスする
    - [http://rrrp.customer-manage.work:3000/admin](http://rrrp.customer-manage.work:3000/admin)
    - [http://rrrp.customer-manage.work:3000/](http://rrrp.customer-manage.work:3000/)
    - [http://rrrp.customer-manage.work:3000/mypage](http://rrrp.customer-manage.work:3000/mypage)

```zsh
# サーバを起動する
% docker-compose up -d
```

<br>

### production 環境

- setup-prod.sh
  - 初回起動の場合
    - `bundle install -j4`
    - `db:create`
    - `db:migrate`
    - `db:seed`
    - `assets:precompile`
  - 最終的に `docker-compose up -d`

```zsh
# Puma, Nginx, PostgreSQL を起動する
$ ./init_proj/setup/setup-prod.sh
```
