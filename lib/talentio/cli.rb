require 'json'
require 'thor'

module Talentio
  class CLI < Thor
    desc 'remind-interview', 'remind inteview'
    def remind_interview
      interview = Notifier::Slack::Interview.new(Notifier::Slack.new)
      Talentio.candidates.each do |c|
        interview.notify(c)
      end
    end

    desc 'remind-result', 'remind selection result'
    def remind_result
      result = Notifier::Slack::SelectionResult.new(Notifier::Slack.new)
      Talentio.candidates.each do |c|
        result.notify(c)
      end
    end
  end
end
