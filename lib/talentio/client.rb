require 'faraday'
require 'uri'
module Talentio
  class Client
    def candidates(id = nil)
      res = client.get do |req|
        if id
          req.url "candidates/#{id}"
        else
          req.url 'candidates', { status: 'ongoing' }
        end
      end
      JSON.parse res.body
    end

    private

    def client
      @_client ||= ::Faraday.new(
        url: URI.join(::Talentio.url, '/api/v1/').to_s,
        headers: {
          Authorization: "Bearer #{ENV['TALENTIO_APIKEY']}"
        }
      )
    end
  end
end
