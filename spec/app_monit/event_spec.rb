require 'spec_helper'

describe AppMonit::Event do

  subject { AppMonit::Event }

  before :each do
    AppMonit::Config.api_key   = 'MYAPIKEY'
    AppMonit::Config.end_point = 'http://api.appmon.it'
    AppMonit::Config.env       = nil

    stub_request(:post, /.*/)
  end

  it 'must raise an exception if API key is unset' do
    AppMonit::Config.api_key = nil
    assert_raises AppMonit::ApiKeyNotSetError do
      subject.create({})
    end
  end

  describe '#create' do
    it 'returns a response if successful' do
      subject.stub(:create!, 'response') do
        assert_equal 'response', subject.create
      end
    end

    it 'returns false if an Http::Error is raised' do
      subject.stub(:create!, -> { raise AppMonit::Http::Error }) do
        assert_equal false, subject.create
      end
    end

    describe 'when the AppMonit::Config.fail_silent is set' do
      it 'returns false if any Http related error is raised' do
        AppMonit::Config.fail_silent = true

        subject.stub(:create!, -> { raise Timeout::Error }) do
          assert_equal false, subject.create
        end
      end
    end

    describe 'when the AppMonit::Config.fail_silent is NOT set' do
      it 'raises the rescued Http related error again' do
        AppMonit::Config.fail_silent = false

        subject.stub(:create!, -> { raise Timeout::Error }) do
          assert_raises(Timeout::Error) { subject.create }
        end
      end
    end
  end

  describe '#create!' do
    it 'sets a created at if not given' do
      @mock = MiniTest::Mock.new
      @mock.expect(:post, true, ['/v1/events', { created_at: Time.at(0).utc, name: 'test', payload: {} }])

      Time.stub(:now, Time.at(0)) do
        subject.stub(:client, @mock) do
          subject.create!('test', {})
          @mock.verify
        end
      end
    end

    it 'sets calls post on http with the correct params' do
      time = Time.now
      @mock = MiniTest::Mock.new
      @mock.expect(:post, true, ['/v1/events', { created_at: time.utc, name: 'test', payload: {test: 'test'} }])

      subject.stub(:client, @mock) do
        subject.create!('test', {created_at: time, test: 'test'})
        @mock.verify
      end
    end
  end
end
