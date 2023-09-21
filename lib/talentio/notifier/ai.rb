module Talentio
  module Notifier
    class AI
      class << self
        def ai_message
          return unless ai?

          unless @ai_message
            response = openai.chat(
              parameters: {
                model: 'gpt-4',
                messages: [{ role: 'user', content: <<~EOS
                  面接の結果を促す文章を考えてください。
                  あなたに作成していただいたメッセージはSlackで送信するので返信に件名は不要です。
                  文章は下記を要点とします。

                  1. 採用活動において応募者への早い応答は成否に影響します。
                  2. 人事チームはあなたがいつ結果を書いてくれるかを知りません
                  3. 今日は#{Date.today}です。面接官に対して、日付にちなんだ面白い興味を引く文章にしてください。
                EOS
                }] # Required.
              }
            )
            @ai_message = response.dig('choices', 0, 'message', 'content')
          end
          @ai_message
        end

        def ai?
          openai
        end

        def openai
          return unless ENV['OPENAI_API_KEY']

          @openai ||= ::OpenAI::Client.new(
            access_token: ENV['OPENAI_API_KEY']
          )
        end
      end
    end
  end
end
