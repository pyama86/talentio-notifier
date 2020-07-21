require 'talentio'
require 'talentio/client'
require 'talentio/notifier/slack'
require 'talentio/notifier/slack/interview'
require 'talentio/notifier/slack/selection_result'

module Talentio
  class << self
    def candidates
      result = client.candidates.map do |c|
        # まだステージが割り当てられていない
        next if c['stages'].empty?
        # 役員面接とかスキップしたい場合
        next if ENV['TALENTIO_SKIP_STAGE'] && c['stages'].size > ENV['TALENTIO_SKIP_STAGE']

        candidate = client.candidates(c['id'])

        s = candidate['stages'].last

        {
          time: c['registeredAt'],
          id: c['id'],
          step: s['step'],
          type: s['type'],
          evaluations: s['evaluations'],
          scheduled_at: s['scheduledAt'],
          requisition_name: c['requisition']['name'],
          candidate_url: "https://talentio.com/ats/candidate/#{c['id']}"
        }
      end.flatten.compact
    end

    private
    def client
      @client ||= Client.new
    end
  end
end
