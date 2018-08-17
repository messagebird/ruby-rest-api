describe 'Voice message' do

  it 'reads an existing' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'voicemessages/voicemessage-id', {})
      .and_return('{"body": "Hello World","createdDatetime": "2015-01-05T16:11:24+00:00","href": "https://rest.messagebird.com/voicemessages/voicemessage-id","id": "voicemessage-id","ifMachine": "continue","language": "en-gb","originator": "MessageBird","recipients": {"items": [{"recipient": 31612345678,"status": "calling","statusDatetime": "2015-01-05T16:11:24+00:00"}],"totalCount": 1,"totalDeliveredCount": 0,"totalDeliveryFailedCount": 0,"totalSentCount": 1},"reference": null,"repeat": 1,"scheduledDatetime": null,"voice": "female"}')

    voice_message = client.voice_message('voicemessage-id')

    expect(voice_message.id).to eq 'voicemessage-id'

  end

  it 'creates with a single recipient' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'voicemessages', { :recipients => 31612345678, :body => 'Body', :repeat => 3 })
      .and_return('{}')

    client.voice_message_create(31612345678, 'Body', { :repeat => 3 })

  end

  it 'creates with multiple recipients' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'voicemessages', { :recipients => '31612345678,31687654321', :body => 'Body', :repeat => 3 })
      .and_return('{}')

    client.voice_message_create([31612345678,31687654321], 'Body', { :repeat => 3 })

  end

end
