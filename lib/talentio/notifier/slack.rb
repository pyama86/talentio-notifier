require 'time'
require 'json'
require 'pp'
require 'slack'
require 'holiday_jp'
module Talentio
  module Notifier
    class Slack
      delegate :chat_postMessage, to: :@client
      def notify?
        ENV['SLACK_APIKEY']
      end

      def nofity
        return unless notify?

      end

      def mention_id_from_evaluations(evaluations)
        members.map do |sm|
          evaluations.select {|e| !e['finished']}.map do |m|
            { id: "@#{sm['id']}", name: sm['name'] } if sm['real_name'] =~ /#{m["employee"]['lastName']}/ && sm['real_name'] =~ /#{m["employee"]['firstName']}/
          end
        end.flatten.compact
      end

      private
      def members
        unless @members
          members = []
          next_cursor = nil
          loop do
            slack_users = client.users_list({limit: 1000, cursor: next_cursor})
            members << slack_users['members']
            next_cursor = slack_users['response_metadata']['next_cursor']
            break if next_cursor.empty?
          end
          @members = members.flatten
        end
        @members
      end

      def client
        unless @client
          ::Slack.configure do |conf|
            conf.token = ENV['SLACK_APIKEY']
          end
          @client = ::Slack::Web::Client.new
              @client.chat_postMessage(
                channel: "U03Q3PPSX",
                as_user: false,
                text: "2020/07/27 15:00からの面接よろしくお願いします！！１",
                attachments: [{
                  fields: [
                    {
                      title: '区分',
                      value: "圧倒的P山採用"
                    },
                    {
                      title: 'url',
                      value: "dummy" 
                    }
                  ],
                  color: 'warning'
                }]
              )

           if ENV['TALENTIO_TEST']
             @client.define_singleton_method(:chat_postMessage) do |m|
               puts m
             end
           end
        end

        @client
      end
    end
  end
end
