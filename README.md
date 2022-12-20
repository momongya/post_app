# 投稿機能を持ったサービス

## 実際の動き方
https://user-images.githubusercontent.com/61648667/208627914-221fdc1a-e5b3-40c8-a171-0aaab42529dc.mov


## データ保存の流れ

## 解説進め方
基本的な掲示板の作り方に関しては以下の画像のような手順で進める
<img width="1000" alt="スクリーンショット 2022-12-20 11 37 15" src="https://user-images.githubusercontent.com/61648667/208569105-ef5e25f2-0972-4943-a1a5-534b7da47598.png">
その後にtips的に削除、編集、いいね機能の作り方を紹介する

#### 1. Formを作成する
index.erbにformを設置する
以下のようにコードを記入する(/views/index.erb)
```HTML
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>掲示板</title>
</head>
<body>
  <form action="/new" method="post">
    <p>名前：<input type="text" name="user_name"></p>
    <p>本文：<input type="text" name="body"></p>
    <p><input type="submit" value="POST"></p>
  </form>
</body>
</html>
```

サーバーまで設置したら以下のように表示される
<img width="1000" alt="スクリーンショット 2022-12-20 18 12 51" src="https://user-images.githubusercontent.com/61648667/208628811-c5f6a828-7e47-41f9-9044-bcf7ad3fd4aa.png">

#### 2. DBを作成する
まず次のコマンドでデータベースを生成する
```
rake db:create
```
次のコマンドでデータベースの構成と構造を定義するmigrateファイルを作成する
```
rake db:create_migration NAME=create_contributions
```
作成したmigrationファイルには以下のコードを記入する(/db/migrate/[何かしら日時情報]_create_contributions.rb)
```ruby
class CreateContributions < ActiveRecord::Migration[6.1]
  def change
    # contributionsという名前のデータベーステーブルを作成する
    create_table :contributions do |t|
      # データベースの中身には名前と本文、日時情報、いいねのカラムを用意する
      # name, bodyどちらにもデータとしては文字列を入れるのでstring型
      t.string :name
      t.string :body
      # あとで作成するいいね機能追加のためにカラムを入れておく
      t.integer :good, default: 0
      t.timestamps null: false
    end
  end
end
```
次に作成したmigrationファイルの内容をデータベースに反映させるために以下のコマンドを入力する
```
rake db:migrate
```

#### 3. サーバー作成
作成したindex.erbの内容をサイトに反映させるために以下コードを書いていく(app.rb)
```ruby
require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './models/contribution.rb'

get '/' do
    erb :index
end
```
ここまで行うとサイトにアクセスできるようになる

フォームで入力された内容をデータベースに保存するために以下のコードをapp.rbに追記する
```ruby
post '/new' do
    Contribution.create({
        # paramsを使うとinputタグで入力された内容を取得することができる
        name: params[:user_name],
        body: params[:body]
    })
    redirect '/'
end
```
投稿された内容を時系列順に並べるためにapp.rbのget '/' doを以下のように変更する
```ruby
get '/' do
    # contentsという名前のインスタンス変数にContributionデータベースの中身全てをidの降順で読み込む
    @contents = Contribution.all.order('id desc')
    erb :index
end
```
app.rb側で取得したデータベースの中身を表示させるためにindex.erbに以下内容を追加する
```HTML

```

