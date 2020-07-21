RSpec.describe Talentio::Notifier::Slack::SelectionResult do

  subject {
    described_class.new(client).notify(data)
  }

  let(:client) {
    Talentio::Notifier::Slack.new
  }

  describe '要件を満たしたので通知' do
    let(:data) {
      {
        time: DateTime.parse("1986-04-10 10:00:00 +0900").to_s,
        id: 1,
        step: 1,
        type: "resume",
        evaluations: [
          {
            'employee' => {
              'lastName' => '山田',
              'firstName' => '太郎',
            }
          }
        ],
        scheduled_at: DateTime.parse("1986-04-10 10:00:00 +0900").to_s,
        requisition_name: '書類選考',
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
                value: "書類選考"
              },
              {
                title: "登録日時",
                value: "1986/04/10 10:00:00"
              },
              {
                title: "納期",
                value: "1986-04-14T10:00:00+09:00"
              },
              {
                title: "url",
                value: "https://example.com"
              }
            ]
          }
        ],
        channel: 1,
        text: "書類選考をお願いします。すぐに対応できないときはtalentioの「採用チーム内のコミュニケーション」にいつまでにやるかを書いてください。"
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
                title: "山田 太郎",
                value: "https://example.com"
              },
            ]
          }
        ],
        channel: '#recruiting',
        text: "納期:1986/04/14の書類選考のお願いを通知しました"
      }
    }
    it do
      expect(client).to receive(:mention_id_from_evaluations).and_return([{name: '山田 太郎', id: 1}])
      expect(client).to receive(:chat_postMessage).with(talk_message)
      expect(client).to receive(:chat_postMessage).with(channel_message)
      subject
    end
  end

  describe '日付が未登録' do
    let(:data) {
      {
        time: nil,
        id: 1,
        step: 1,
        type: "resume",
        evaluations: [
          {
            'employee' => {
              'lastName' => '山田',
              'firstName' => '太郎',
            }
          }
        ],
        scheduled_at: DateTime.parse("1986-04-10 10:00:00 +0900").to_s,
        requisition_name: '書類選考',
        candidate_url: "https://example.com",
        slack_mentions: ["@example"]
      }
    }

    it do
      expect(client).to receive(:mention_id_from_evaluations).exactly(0).times
      expect(client).to receive(:chat_postMessage).exactly(0).times
      subject
    end
  end

  describe '日付が今日' do
    let(:data) {
      {
        time: DateTime.now.to_s,
        id: 1,
        step: 1,
        type: "resume",
        evaluations: [
          {
            'employee' => {
              'lastName' => '山田',
              'firstName' => '太郎',
            }
          }
        ],
        scheduled_at: DateTime.parse("1986-04-10 10:00:00 +0900").to_s,
        requisition_name: '書類選考',
        candidate_url: "https://example.com",
        slack_mentions: ["@example"]
      }
    }

    it do
      expect(client).to receive(:mention_id_from_evaluations).exactly(0).times
      expect(client).to receive(:chat_postMessage).exactly(0).times
      subject
    end
  end
end
