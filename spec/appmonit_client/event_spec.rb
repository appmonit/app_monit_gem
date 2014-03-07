require 'spec_helper'

describe AppmonitClient::Event do

  subject { AppmonitClient::Event }

  it 'must raise an exception if API key is unset' do
    assert_raises AppmonitClient::ApiKeyNotSetError do
      subject.create({})
    end
  end

  describe '#create' do
    before do
      AppmonitClient::Config.api_key   = 'MYAPIKEY'
      AppmonitClient::Config.end_point = 'http://api.appmon.it'
      AppmonitClient::Config.env = nil
    end

    it 'POSTs to the configured end_point' do
      stub_request(:post, /xyz.appmon.it*/)
      AppmonitClient::Config.end_point = 'http://xyz.appmon.it'
      subject.create({})
      assert_requested :post, /^\Axyz.appmon.it/
    end

    it 'sets the HTTP header to application/json' do
      stub_request(:post, /.*/)
      subject.create({ :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Content-Type' => 'application/json' }
    end

    it 'sets the HTTP header Appmonit-Env to the configured environment' do
      stub_request(:post, /.*/)
      AppmonitClient::Config.env = 'staging'
      subject.create({ :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Appmonit-Env' => 'staging' }
    end

    it 'sets the HTTP header Appmonit-Env by default to \'development\' environment' do
      stub_request(:post, /.*/)
      AppmonitClient::Config.env = nil # make sure it's unset so it defaults to normal
      subject.create({ :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Appmonit-Env' => 'development' }
    end

    it 'sets the HTTP header Appmonit-Api-Key to the configured API Key' do
      stub_request(:post, /.*/)
      AppmonitClient::Config.api_key = "FUBAR123"
      subject.create({ :spec => 'XYZ' })
      assert_requested :post, /.*/, :headers => { 'Appmonit-Api-Key' => 'FUBAR123' }
    end

    # {
    #   :name =>
    #   :created_at =>
    #   :payload => ''
    # }
  end
end
