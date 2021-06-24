# frozen_string_literal: true

describe 'Verify' do
  it 'reads an existing' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'verify/verify-id', {})
      .and_return('{"id": "verify-id","href": "https://rest.messagebird.com/verify/verify-id","recipient": 31612345678,"reference": "MyReference","messages": {"href": "https://rest.messagebird.com/messages/message-id"},"status": "verified","createdDatetime": "2017-05-30T12:39:50+00:00","validUntilDatetime": "2017-05-30T12:40:20+00:00"}')

    verify = client.verify('verify-id')

    expect(verify.id).to eq 'verify-id'
    expect(verify.status).to eq 'verified'
  end

  it 'verifies token for existing verify' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'verify/verify-id?token=verify-token', {})
      .and_return('{}')

    client.verify_token('verify-id', 'verify-token')
  end

  it 'creates a verify and sends token' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'verify', recipient: 31_612_345_678, originator: 'MessageBird')
      .and_return('{}')

    client.verify_create(31_612_345_678, originator: 'MessageBird')
  end

  it 'creates a verify and sends token via email' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'verify', type: 'email', recipient: 'verify@example.com', subject: 'Your verification code', originator: 'MessageBird')
      .and_return('{}')

    client.verify_create('verify@example.com', originator: 'MessageBird', type: 'email', subject: 'Your verification code')
  end
end
