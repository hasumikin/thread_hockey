thread_hockey
=============

# 初期設定

1. リポジトリをクローンします

2. $ cp thread_hokcey/client/config.yml.base thread_hokcey/client/config.yml

3. thread_hokcey/client/config.yml の中身を「localhost」にします

# 起動方法

1. ターミナルを３つ起動し、3つとも $ cd thread_hokcey します

2. 1番目のターミナルで $ ruby server/start.rb

3. 2番目と3番目のターミナルで $ ruby client/start.rb

# ネットワーク設定

thread_hokcey/client/config.yml をネットワーク上の（TCP12345ポートが通じる）IPアドレスに変更すれば、ネットワーク越しにサーバに接続して、対戦できます。

ひとつのサーバに対し、3組の対戦を受け入れます。4組目の接続はウェイトがかかり、1組のゲームが終了すると、ウェイトしていた対戦が開始します。
