describe 'Voice' do
  
    it 'creates a webhook' do
      voice_client = double(MessageBird::VoiceClient)
      client = MessageBird::Client.new('', nil, nil, voice_client)
  
      expect(voice_client)
        .to receive(:request)
        .with(:post, 'webhooks', :url => 'https://test.com', :token => 'sometoken')
        .and_return('{"data":[{"id":"00000000000000000000000000000000", "url": "https://test.com", "token": "sometoken"}]}')
  
      webhook = client.voice_webhook_create('https://test.com', {:token => 'sometoken'})
  
      expect(webhook.id).to eq '00000000000000000000000000000000'
      expect(webhook.url).to eq 'https://test.com'
      expect(webhook.token).to eq 'sometoken'
    end
  
    it 'reads a list of webhooks' do
      voice_client = double(MessageBird::VoiceClient)
      client = MessageBird::Client.new('', nil, nil, voice_client)
  
      expect(voice_client)
        .to receive(:request)
        .with(:get, 'webhooks?perPage=10&page=1', {})
        .and_return('{"pagination":{"perPage":10, "currentPage":1, "pageCount":1, "totalCount":2}, "data":[{"id":"1111111111", "url": "url_1", "token": "token_1"},{"id":"2222222222", "url": "url_2", "token": "token_2"}]}')
  
      list = client.voice_webhooks_list(10, 1)
  
      expect(list.items.count).to eq 2
      expect(list[0].id).to eq '1111111111'
      expect(list[1].id).to eq '2222222222'
    end
  
    it 'reads a webhook' do
      voice_client = double(MessageBird::VoiceClient)
      client = MessageBird::Client.new('', nil, nil, voice_client)
  
      expect(voice_client)
        .to receive(:request)
        .with(:get, 'webhooks/webhook-id', {})
        .and_return('{"data":[{"id":"00000000000000000000000000000000"}]}')
  
      webhook = client.voice_webhook('webhook-id')
  
      expect(webhook.id).to eq '00000000000000000000000000000000'
    end
  
    it 'updates a webhook' do
      voice_client = double(MessageBird::VoiceClient)
      client = MessageBird::Client.new('', nil, nil, voice_client)
  
      expect(voice_client)
        .to receive(:request)
        .with(:put, 'webhooks/webhook-id', :url => 'https://test.com', :token => 'sometoken')
        .and_return('{"data":[{"id":"00000000000000000000000000000000", "url": "https://test.com", "token": "sometoken"}]}')
  
      webhook = client.voice_webhook_update('webhook-id', :url => 'https://test.com', :token => 'sometoken')
  
      expect(webhook.id).to eq '00000000000000000000000000000000'
      expect(webhook.url).to eq 'https://test.com'
      expect(webhook.token).to eq 'sometoken'
    end
  
    it 'deletes a webhook' do
      voice_client = double(MessageBird::VoiceClient)
      client = MessageBird::Client.new('', nil, nil, voice_client)
  
      expect(voice_client)
        .to receive(:request)
        .with(:delete, 'webhooks/webhook-id', {})
        .and_return('')
  
      client.voice_webhook_delete('webhook-id')
    end
  
  end
  