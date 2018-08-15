require 'rspec'
require 'rspec/mocks'
require 'messagebird'

describe 'Message' do

  it 'reads an existing' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:get, 'messages/message-id', {})
        .and_return('{"body": "Hello World","createdDatetime": "2015-01-05T10:02:59+00:00","datacoding": "plain","direction": "mt","gateway": 239,"href": "https://rest.messagebird.com/messages/message-id","id": "message-id","mclass": 1,"originator": "TestName","recipients": {"items": [{"recipient": 31612345678,"status": "sent","statusDatetime": "2015-01-05T10:02:59+00:00"}],"totalCount": 1,"totalDeliveredCount": 0,"totalDeliveryFailedCount": 0,"totalSentCount": 1},"reference": null,"scheduledDatetime": null,"type": "sms","typeDetails": {},"validity": null}')

    message = client.message('message-id')

    expect(message.id).to eq 'message-id'

  end

  it 'creates' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:post, 'messages', {:originator => 'MBTest', :recipients => 31612345678, :body=> 'Hello world', :reference => 'Foo'})
        .and_return('{}')

    client.message_create('MBTest', 31612345678, 'Hello world', { :reference => 'Foo' })

  end

end