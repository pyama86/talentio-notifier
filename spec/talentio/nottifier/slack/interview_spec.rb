RSpec.describe Talentio::Notifier::Slack::Interview do

  subject {
    described_class.new(client).notify(data)
  }

  let(:client) {
    Talentio::Notifier::Slack.new
  }

  describe '要件を満たしたので通知' do
    let(:base_time) {
        Time.now + Rational(9, 24 * 60)
    }

    let(:data) {
      {
        time: Time.now,
        id: 1,
        step: 1,
        type: "interview",
        evaluations: [
          {
            'employee' => {
              'lastName' => '山田',
              'firstName' => '太郎',
            }
          }
        ],
        scheduled_at: base_time.to_s,
        requisition_name: '面接',
        candidate_url: "https://example.com",
        slack_mentions: ["@example"]
      }
    }

    let(:talk_message) {
      {
        as_user: false,
        attachments: [
          {
            color: "warning",
            fields: [
              {
                title: "区分",
                value: "面接"
              },
              {
                title: "url",
                value: "https://example.com"
              }
            ]
          }
        ],
        channel: 1,
        text: "#{base_time.strftime("%Y/%m/%d %H:%M")}からの面接よろしくお願いします！！１",
      }
    }

    let(:channel_message) {
      {
        as_user: false,
        attachments: [
          {
            color: "warning",
            fields: [
              {
                title: "インタビュアー",
                value: "山田 太郎",
              },
              {
                title: "url",
                value: "https://example.com"
              }
            ]
          }
        ],
        channel: '#recruiting',
        text: "#{base_time.strftime("%Y/%m/%d %H:%M")}からの面接のリマインドをしました",
      }
    }
    it do
      expect(client).to receive(:mention_id_from_evaluations).and_return([{name: '山田 太郎', id: 1}])
      expect(client).to receive(:chat_postMessage).with(talk_message)
      expect(client).to receive(:chat_postMessage).with(channel_message)
      subject
    end
  end

  describe '過去日付なので通知しない' do
    let(:base_time) {
        Time.now - 1
    }

    let(:data) {
      {
        time: Time.now,
        id: 1,
        step: 1,
        type: "interview",
        evaluations: [
          {
            'employee' => {
              'lastName' => '山田',
              'firstName' => '太郎',
            }
          }
        ],
        scheduled_at: base_time.to_s,
        requisition_name: '面接',
        candidate_url: "https://example.com",
        slack_mentions: ["@example"]
      }
    }

    let(:talk_message) {
      {
        as_user: false,
        attachments: [
          {
            color: "warning",
            fields: [
              {
                title: "区分",
                value: "面接"
              },
              {
                title: "url",
                value: "https://example.com"
              }
            ]
          }
        ],
        channel: 1,
        text: "#{base_time.strftime("%Y/%m/%d %H:%M")}からの面接よろしくお願いします！！１",
      }
    }

    let(:channel_message) {
      {
        as_user: false,
        attachments: [
          {
            color: "warning",
            fields: [
              {
                title: "インタビュアー",
                value: "山田 太郎",
              },
              {
                title: "url",
                value: "https://example.com"
              }
            ]
          }
        ],
        channel: '#recruiting',
        text: "#{base_time.strftime("%Y/%m/%d %H:%M")}からの面接のリマインドをしました",
      }
    }
    it do
      expect(client).to receive(:mention_id_from_evaluations).exactly(0).times
      expect(client).to receive(:chat_postMessage).exactly(0).times
      subject
    end
  end
end
