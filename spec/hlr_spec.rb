# frozen_string_literal: true

describe 'HLR' do
  it 'views an existing' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'hlr/hlr-id', {})
      .and_return('{"id":"hlr-id","href":"https://rest.messagebird.com/hlr/hlr-id","msisdn":31612345678,"network":20406,"reference":"MyReference","status": "sent","createdDatetime": "2015-01-04T13:14:08+00:00","statusDatetime": "2015-01-04T13:14:09+00:00"}')

    hlr = client.hlr('hlr-id')

    expect(hlr.id).to eq 'hlr-id'
  end

  it 'requests a HLR' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'hlr', { msisdn: 31_612_345_678, reference: 'MyReference' })
      .and_return('{}')

    client.hlr_create(31_612_345_678, 'MyReference')
  end
end
