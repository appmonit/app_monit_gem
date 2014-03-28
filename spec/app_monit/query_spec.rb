require 'spec_helper'

describe AppMonit::Query do
  subject { AppMonit::Query }

  before do
    AppMonit::Config.api_key   = 'MYAPIKEY'
    AppMonit::Config.end_point = 'http://api.appmon.it'
    AppMonit::Config.env       = nil
  end

  %w(count count_unique minimum maximum average sum funnel).each do |method_name|
    describe method_name do
      it 'gets the results with the given params' do
        stub_request(:get, /api.appmon.it\/v1\/queries\/#{method_name}/).to_return(code: '200', body: {result: '0'}.to_json)

        params = { valid: 'params' }
        subject.send(method_name, 'collection_name', params)

        params[:event_collection] = 'collection_name'

        assert_requested(:get, /api.appmon.it\/v1\/queries\/#{method_name}\?query=#{params.to_json}/)
      end
    end
  end
end
