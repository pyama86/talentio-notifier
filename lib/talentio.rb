require 'talentio'
require 'talentio/client'
require 'talentio/notifier/ai'
require 'talentio/notifier/slack'
require 'talentio/notifier/slack/interview'
require 'talentio/notifier/slack/selection_result'
require 'uri'
require 'openai'
require 'date'
module Talentio
  class << self
    def candidates
      result = client.candidates.map do |c|
        # まだステージが割り当てられていない
        next if c['stages'].empty?
        # 役員面接とかスキップしたい場合
        next if ENV['TALENTIO_SKIP_STAGE'] && c['stages'].size > ENV['TALENTIO_SKIP_STAGE'].to_i

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
          candidate_url: URI.join(url, "ats/candidate/#{c['id']}").to_s
        }
      end.flatten.compact
    end

    def url
      ENV['TALENTIO_URL'] || 'https://talentio.com'
    end

    private

    def client
      @client ||= Client.new
    end
  end
end
