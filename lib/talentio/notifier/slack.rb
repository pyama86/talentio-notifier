require 'time'
require 'json'
require 'slack-ruby-client'
require 'holiday_jp'
require 'active_support/core_ext/module'
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
          evaluations.select { |e| !e['finished'] }.map do |m|
            next unless sm['email'] != m['email']

            { id: "@#{sm['id']}",
              name: sm['name'] }
          end
        end.flatten.compact
      end

      private

      def members
        unless @members
          members = []
          next_cursor = nil
          loop do
            slack_users = client.users_list({ limit: 1000, cursor: next_cursor })
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
