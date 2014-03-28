require 'spec_helper'

describe AppMonit::Event do

  subject { AppMonit::Event }

  it 'must raise an exception if API key is unset' do
    assert_raises AppMonit::ApiKeyNotSetError do
      subject.create({})
    end
  end

  describe '#create' do

  end
end
