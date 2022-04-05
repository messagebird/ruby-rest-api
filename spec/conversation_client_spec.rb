# frozen_string_literal: true

describe MessageBird::ConversationClient do
  before(:all) do
    @client = MessageBird::ConversationClient.new('secret-access-key')
  end

  context 'initialization' do
    it 'uses Conversations API base URL' do
      expect(@client.endpoint).to eq('https://conversations.messagebird.com/v1/')
    end

    it 'uses the provided access key' do
      expect(@client.access_key).to eq('secret-access-key')
    end
  end

  context 'performing a HTTP request' do
    before(:each) do
      stub_request(:get, 'https://conversations.messagebird.com/v1/conversations')
        .with(
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => "AccessKey #{@client.access_key}",
            'User-Agent' => "MessageBird/ApiClient/#{MessageBird::Version::STRING} Ruby/#{RUBY_VERSION}"
          }
        )
        .to_return(status: 200, body: File.new(File.join(File.dirname(__FILE__), './data/conversations/list.json')), headers: {})

      @response = JSON.parse(@client.request(:get, 'conversations'), symbolize_names: true)
    end

    it 'contains an offset in the HTTP response body' do
      expect(@response[:offset]).to be(0)
    end

    it 'contains a limit in the HTTP response body' do
      expect(@response[:limit]).to be(20)
    end

    it 'contains a count in the HTTP response body' do
      expect(@response[:count]).to be(2)
    end

    it 'contains a totalCount in the HTTP response body' do
      expect(@response[:totalCount]).to be(2)
    end

    it 'contains two items' do
      expect(@response[:items].length).to be(2)
    end
  end
end
