# tiny_ndl

国立国会図書館(NDL)がAPIを公開していて、書籍の検索ができるというのは皆さんご存知と思います。NDL APIに対してISBNで問い合わせるRubyスクリプトです。(NDL APIはもっと多機能ですが、ISBNでしか問い合わせないので、tiny、と。)


## 使い方

tiny_ndl-test.rbを見てください。

## バグ等

[Qiita](https://qiita.com/)に[Rubyで国立国会図書館APIに問い合わせ](https://qiita.com/hiranoi/items/8f5bbffaacc61ced5407)なんて記事があったり、[GitHub](https://github.com/)には[ndlという名のgem](https://github.com/himkt/ndl)があったりしますので、車輪の再発明です。いや、そんなことを言ったら車輪に失礼ですね。ごめんなさい、車輪未満です。

## 履歴

以前は取得データをDC-NDL（Simple）フォーマットとして処理していました。ですが、DC-NDL（Simple）フォーマットは2024年1月でデータ提供終了となりましたので、（Simpleでない）DC-NDLフォーマットを受信して動作するよう変更しました。とりあえず私の使う範囲では期待したように動作しているみたいですけど、おかしなところがあればお知らせください。対応するかもしれません。
