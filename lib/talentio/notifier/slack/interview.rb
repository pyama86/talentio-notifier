module Talentio
  module Notifier
    class Slack
      class Interview
        attr_reader :client
        def initialize(client)
          @client = client
        end

        def notify(data)
          return if data[:type].to_s != "interview"
          # 面接が行われていないものはスキップする
          return unless data[:scheduled_at]

          base_time = DateTime.parse(data[:scheduled_at])
          diff = base_time.to_i - DateTime.now.to_i

          # 10分毎にcronで実行される想定
          if (diff < (ENV['TALENTIO_REMIND_INTERVAL'] || 600) && diff >= 0)
            slack_mentions = client.mention_id_from_evaluations(data[:evaluations])
            slack_mentions.each do |m|
              client.chat_postMessage(
                channel: m[:id],
                as_user: false,
                text: "#{base_time.strftime("%Y/%m/%d %H:%M")}からの面接よろしくお願いします！！１",
                attachments: [{
                  fields: [
                    {
                      title: '区分',
                      value: data[:requisition_name]
                    },
                    {
                      title: 'url',
                      value: data[:candidate_url]
                    }
                  ],
                  color: 'warning'
                }]
              )
            end

            client.chat_postMessage(
              channel: ENV['TELENTIO_SLACK_CHANNEL'] || '#recruiting',
              as_user: false,
              text: "#{base_time.strftime("%Y/%m/%d %H:%M")}からの面接のリマインドをしました",
              attachments: [{
                fields: [
                  {
                    title: 'インタビュアー',
                    value: slack_mentions.map {|m| "#{m[:name]}"}.join(',')
                  },
                  {
                    title: 'url',
                    value: data[:candidate_url]
                  }
                ],
                color: 'warning'
              }]
            )
          end
        end
      end
    end
  end
end
