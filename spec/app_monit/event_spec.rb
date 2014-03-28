require 'spec_helper'

describe AppMonit::Event do

  subject { AppMonit::Event }

  it 'must raise an exception if API key is unset' do
    assert_raises AppMonit::ApiKeyNotSetError do
      subject.create({})
    end
  end

  describe '#create' do
    before do
      AppMonit::Config.api_key   = 'MYAPIKEY'
      AppMonit::Config.end_point = 'http://api.appmon.it'
      AppMonit::Config.env = nil
    end

    it 'POSTs to the configured end_point' do
      stub_request(:post, /xyz.appmon.it*/)
      AppMonit::Config.end_point = 'http://xyz.appmon.it'
      subject.create('event', {})
      assert_requested :post, /^\Axyz.appmon.it/
    end

    it 'sets the HTTP header to application/json' do
      stub_request(:post, /.*/)
      subject.create('event', { :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Content-Type' => 'application/json' }
    end

    it 'sets the HTTP header Appmonit-Env to the configured environment' do
      stub_request(:post, /.*/)
      AppMonit::Config.env = 'staging'
      subject.create('test', { :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Appmonit-Env' => 'staging' }
    end

    it 'sets the HTTP header Appmonit-Env by default to \'development\' environment' do
      stub_request(:post, /.*/)
      AppMonit::Config.env = nil # make sure it's unset so it defaults to normal
      subject.create('test', { :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Appmonit-Env' => 'development' }
    end

    it 'sets the HTTP header Appmonit-Api-Key to the configured API Key' do
      stub_request(:post, /.*/)
      AppMonit::Config.api_key = "FUBAR123"
      subject.create('test', { :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Appmonit-Api-Key' => 'FUBAR123' }
    end
  end

  describe '#failed_events' do
    let(:event1) { { spec: 'ABC', created_at: '1' } }
    let(:event2) { { spec: 'XYZ', created_at: '1' } }
    before :each do
      stub_request(:post, /.*/).to_return(status: 500)
    end

    it 'writes the event to a log' do
      subject.create('test', event1)
      subject.create('test', event2)
      assert_includes File.read('tmp/failed_events.log'), event1.to_json
      assert_includes File.read('tmp/failed_events.log'), event2.to_json
    end
  end
end
