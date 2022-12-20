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
#### 4. 結果を返す
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
# @contents内にはデータベースの中身が全て入っているのでひとつづつ表示させるにはeachを使って配列の中身をひとつづつ見ていく
<% @contents.each do |content| %>
  <div>
    <p><%= content.name %></p>
    <p><%= content.body %></p>
  </div>
<% end %>
```
ここまでコードを書くと以下の画像のように投稿と投稿した内容の表示はできるようになる
<img width="1440" alt="スクリーンショット 2022-12-21 1 25 06" src="https://user-images.githubusercontent.com/61648667/208715933-2b244905-8bf4-43d6-8aa0-ff915b8a714a.png">

#### 5. 見た目を整える
index.erbにBootstrapを導入し、classを指定すると以下のようなコードになる
```HTML
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>掲示板</title>
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"> 
</head>
<body>
  <div class="container-fluid">
    <div class="row d-flex justify-content-center">
      <div class="card col-lg-6 m-5">
        <div class="card-body">
          <form action="/new" method="post">
            <p>名前：<input type="text" name="user_name" class="form-control"></p>
            <p>本文：<input type="text" name="body" class="form-control"></p>
            <p><input type="submit" value="POST" class="btn btn-dark float-end"></p>
          </form>
        </div>
      </div>
      
      <% @contents.each do |content| %>
        <div class="card col-lg-6 mb-2 mx-5">
          <div class="card-body">
            <p><%= content.name %></p>
            <p><%= content.body %></p>
          </div>
        </div>
      <% end %>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>
```
ここまでできると見た目も画像のようにある程度整う
<img width="1434" alt="スクリーンショット 2022-12-21 1 30 35" src="https://user-images.githubusercontent.com/61648667/208717090-b36ab49a-e58e-4661-bf91-66ed60e84513.png">

## 機能追加
まずは削除、編集、いいね機能用ボタンをまとめて追加する
投稿した内容の表示部分のコードを以下のように追加する(以下コードはBootstrap適応済)
```HTML
<% @contents.each do |content| %>
  <div class="card col-lg-6 mb-2 mx-5">
    <div class="card-body">
      <p><%= content.name %></p>
      <p><%= content.body %></p>
      
      # ここから追加したコード部分
      <div class="d-flex justify-content-end align-items-center mt-3">
        <span><%= content.good %></span>
         
        # formのactionを/good/<%= content.id %>のように/good/だけでなく<%= content.id %>も追加することによってボタンが押された投稿のidもapp.rbで扱うことができる
        <form action="/good/<%= content.id %>" method="post">
          <input type="submit" value="LIKE" class="btn">
        </form>
        
        <form action="/delete/<%= content.id %>" method="post">
          <input type="submit" value="DELETE" class="btn">
        </form>

        <a href="/edit/<%= content.id %>" class="btn">EDIT</a>
      </div>
    </div>
    # ここまで
  </div>
<% end %>
```
削除、編集、いいねについてはformで機能を発動できるようにした
いいねに関してはいいねの数が表示されるようにした

#### 削除機能の作り方
app.rbに以下のコードを追加する
```ruby
post '/delete/:id' do
    # /delete/:idのidと一致するデータのレコードを探し、見つけたデータを削除する
    Contribution.find(params[:id]).destroy
    redirect '/'
end
```

#### 編集機能の作り方
app.rbに以下のコードを追加する
```ruby
get '/edit/:id' do
    # /edit/:idのidと一致するデータのレコードを探し、見つけたデータを@contentに入れてedit.erbに画面を飛ばす
    @content = Contribution.find(params[:id])
    erb :edit
end
```
edit.erbファイルを新規作成して以下編集画面のコードを追加する
```HTML
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>編集ページ</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"> 
  <link href="https://fonts.googleapis.com/css2?family=M+PLUS+Rounded+1c&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="../style.css">
</head>
<body>
  <div class="card col-lg-6 mx-auto mt-5">
    <div class="card-body"> 
      <form action="/renew/<%= @content.id %>" method="post">
        <p>名前：<input type="text" name="user_name" value="<%= @content.name%>" class="form-control"></p>
        <p>本文：<input type="text" name="body" value="<%= @content.body%>" class="form-control"></p>
        <p><input type="submit" value="編集完了" class="btn btn-dark float-end"></p>
      </form>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>
```

編集した内容が反映されるように以下のコードをapp.rbに追加する
```ruby
post '/renew/:id' do
    # /renew/:idのidと一致するデータのレコードを探し、見つけたデータをcontentに入れる
    content = Contribution.find(params[:id])
    # 見つけたデータを編集されたデータに更新する
    content.update({
        name: params[:user_name],
        body: params[:body]
    })
    redirect '/'
end
```

#### いいね機能の作り方
app.rbに以下のコードを追加する
```ruby
post '/good/:id' do
    # /good/:idのidと一致するデータのレコードを探し、見つけたデータをcontentに入れる
    content = Contribution.find(params[:id])
    good = content.good
    # 見つけたデータのgood(いいね)部分の数の1つ増やす
    content.update({
        good: good + 1
    })
    redirect '/'
end
```
