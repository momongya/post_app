# 投稿機能を持ったサービス

## 実際の動き方
https://user-images.githubusercontent.com/61648667/208627914-221fdc1a-e5b3-40c8-a171-0aaab42529dc.mov


## データ保存の流れ

## 解説進め方
<img width="1000" alt="スクリーンショット 2022-12-20 11 37 15" src="https://user-images.githubusercontent.com/61648667/208569105-ef5e25f2-0972-4943-a1a5-534b7da47598.png">

#### 1. Formを作成する
index.erbにformを設置する
以下のようにコードを記入する
```HTML
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>掲示板</title>
</head>
<body>
  <form action="/new" method="post">
    <p>名前：<input type="text" name="user_name" class="form-control"></p>
    <p>本文：<input type="text" name="body" class="form-control"></p>
    <p><input type="submit" value="POST" class="btn btn-dark float-end"></p>
  </form>
</body>
</html>
```

サーバーまで設置したら以下のように表示される
<img width="1000" alt="スクリーンショット 2022-12-20 18 12 51" src="https://user-images.githubusercontent.com/61648667/208628811-c5f6a828-7e47-41f9-9044-bcf7ad3fd4aa.png">
