# Talentio::Notifier

TalentioのAPIを利用して、Slack通知を行うことができます。これにより採用選考をいい感じに進めていきましょう。

## 利用方法

### 書類選考や面接結果のリマインド

選考結果の記入が終わっていないユーザーに通知します。

```
$ talentio-notifier remind-result
```

### 面接時間のリマインド

面接の10分前にリマインドします。

```
$ talentio-notifier remind-interview
```


## 実行環境

開発者の所属する企業ではk8sを利用して運用しています。manifestsについても `manifests` 配下のものを利用可能です。

## 環境変数

APIキーなどは環境変数で指定してください。

- SLACK_APIKEY
slackのAPIキーを指定してください。
- TALENTIO_APIKEY
talentioのAPIキーを指定してください。
- TALENTIO_SKIP_STAGE
役員面接などはリマインドしたくないときに指定してください。デフォルト値は3で、開発者の所属する企業の場合は、4段階の先行があり、最終工程はリマインドしたくないため、3をデフォルトにしています。
- TALENTIO_REMIND_INTERVAL
インタビュー通知のcron間隔に合わせて秒で指定してください。デフォルトで600(10分)です。
- TELENTIO_SLACK_CHANNEL
トークで通知したことを通知するチャンネル指定です。デフォルトは `#recruiting` です。

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/talentio-notifier.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
