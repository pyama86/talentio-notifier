require 'faraday'
module Talentio
  class Client
    def candidates(id=nil)
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
      @_client ||= ::Faraday.new(:url => ENV['TALENTIO_API_ENDPOINT'] || "https://talentio.com/api/v1/") do |b|
        b.headers['Authorization'] = "Bearer #{ENV['TALENTIO_APIKEY']}"
        b.adapter Faraday.default_adapter
      end
    end
  end
end
