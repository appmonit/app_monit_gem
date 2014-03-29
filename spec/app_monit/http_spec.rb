require 'spec_helper'

describe AppMonit::Http do
  subject { AppMonit::Http.new }

  before do
    AppMonit::Config.api_key   = 'MYAPIKEY'
    AppMonit::Config.end_point = 'http://api.appmon.it'
    AppMonit::Config.env       = nil

    stub_request(:post, /.*/)
  end

  it 'POSTs to the configured end_point' do
    AppMonit::Config.end_point = 'http://xyz.appmon.it'
    subject.request(:post, '/', {})
    assert_requested :post, /^\Axyz.appmon.it/
  end

  it 'sets the HTTP header to application/json' do
    subject.request(:post, '/', {})
    assert_requested :post, /.*/, :headers => { 'Content-Type' => 'application/json' }
  end

  it 'sets the HTTP header Appmonit-Env to the configured environment' do
    AppMonit::Config.env = 'staging'
    subject.request(:post, '/', {})
    assert_requested :post, /.*/, :headers => { 'Appmonit-Env' => 'staging' }
  end

  it 'sets the HTTP header Appmonit-Env by default to \'development\' environment' do
    AppMonit::Config.env = nil # make sure it's unset so it defaults to normal
    subject.request(:post, '/', {})
    assert_requested :post, /.*/, :headers => { 'Appmonit-Env' => 'development' }
  end

  it 'sets the HTTP header Appmonit-Api-Key to the configured API Key' do
    AppMonit::Config.api_key = "FUBAR123"
    subject.request(:post, '/', {})
    assert_requested :post, /.*/, :headers => { 'Appmonit-Api-Key' => 'FUBAR123' }
  end

  it 'sets the read timeout to 1 second' do
    assert_equal 1, subject.client.read_timeout
  end

  describe 'when using ssl' do
    before(:each) { AppMonit::Config.end_point = 'https://xyz.appmon.it' }

    it 'sets the use_ssl flag to true' do
      assert_equal true, subject.client.use_ssl?
    end

    it 'sets the verify mode to PEER' do
      assert_equal OpenSSL::SSL::VERIFY_PEER, subject.client.verify_mode
    end
  end
end
