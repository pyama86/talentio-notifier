require 'time'
module Talentio
  module Notifier
    class Slack
      class SelectionResult
        attr_reader :client

        def initialize(client)
          @client = client
        end

        def notify(data)
          channel_message = []
          param = selection_types[data[:type].to_sym]

          return unless param
          # 納期の計算対象となる日付が登録されていないものはスキップする
          return unless data[param[:limit_key]]

          # 登録当日はスキップする
          base_time = Time.parse(data[param[:limit_key]])
          return if base_time >= Date.today.to_time

          slack_mentions = client.mention_id_from_evaluations(data[:evaluations])
          slack_mentions.each do |m|
            limit_day = base_time + param[:limit_day] * (60 * 60 * 24)
            # 納期を設定する
            loop do
              break if ![0, 6].include?(limit_day.wday) && !HolidayJp.holiday?(limit_day)

              limit_day += (60 * 60 * 24)
            end

            # 個別の通知はトークで実行するので、共有チャンネルに動いたことを通知する
            channel_message << {
              name: m[:name],
              limit: limit_day,
              url: data[:candidate_url]
            }

            client.chat_postMessage(
              channel: m[:id],
              as_user: false,
              text: "#{param[:label]}をお願いします。すぐに対応できないときはtalentioの「採用チーム内のコミュニケーション」にいつまでにやるかを書いてください。\n#{Talentio::Notifier::AI.ai_message}",
              attachments: [{
                fields: [
                  {
                    title: '区分',
                    value: data[:requisition_name]
                  },
                  {
                    title: '登録日時',
                    value: base_time.strftime('%Y/%m/%d %H:%M:%S')
                  },
                  {
                    title: '納期',
                    value: limit_day.to_s
                  },
                  {
                    title: 'url',
                    value: data[:candidate_url]
                  }
                ],
                color: 'warning'
              }]
            )

            channel_message.sort_by! { |a| a[:limit] }.each_with_object({}) do |m, r|
              r[m[:limit].strftime('%Y/%m/%d')] ||= []
              r[m[:limit].strftime('%Y/%m/%d')] << {
                name: m[:name],
                url: m[:url]
              }
            end.map do |k, v|
              f = v.map do |vv|
                [
                  {
                    title: vv[:name],
                    value: vv[:url]
                  }
                ]
              end

              client.chat_postMessage(
                channel: ENV['TELENTIO_SLACK_CHANNEL'] || '#recruiting',
                as_user: false,
                text: "納期:#{k}の#{param[:label]}のお願いを通知しました",
                attachments: [{
                  fields: f.flatten,
                  color: 'warning'
                }]
              )
            end
          end
        end

        private

        def selection_types
          {
            resume: {
              label: '書類選考',
              limit_day: 4,
              limit_key: :time
            },
            interview: {
              label: '面接評定',
              limit_day: 5,
              limit_key: :scheduled_at
            }
          }
        end
      end
    end
  end
end
