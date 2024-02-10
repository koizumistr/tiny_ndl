# tiny_ndl

> [!CAUTION]
> サーバ側が色々変わってしまっていますので、ここにあるプログラムはそのままでは動作しません。
> URLが変わっているだけでなく、取得データをDC-NDL（Simple）フォーマットとして処理しているためです。（DC-NDL（Simple）フォーマットは2024年1月でデータ提供終了となっています(T_T)）
> 急ぎの場合には[バグ等](https://github.com/koizumistr/tiny_ndl?tab=readme-ov-file#%E3%83%90%E3%82%B0%E7%AD%89)で引用している先のものをURLを修正した上で使うのが良いのではないかと思います。（確かめてはいませんが）

国立国会図書館(NDL)がAPIを公開していて、書籍の検索ができるというのは皆さんご存知と思います。NDL APIに対してISBNで問い合わせるRubyスクリプトです。(NDL APIはもっと多機能ですが、ISBNでしか問い合わせないので、tiny、と。)


## 使い方

tiny_ndl-test.rbを見てください。

## バグ等

[Qiita](https://qiita.com/)に[Rubyで国立国会図書館APIに問い合わせ](https://qiita.com/hiranoi/items/8f5bbffaacc61ced5407)なんて記事があったり、[GitHub](https://github.com/)には[ndlという名のgem](https://github.com/himkt/ndl)があったりしますので、車輪の再発明です。いや、そんなことを言ったら車輪に失礼ですね。ごめんなさい、車輪未満です。
