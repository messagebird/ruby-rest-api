describe 'Lookup' do

  it 'performs a new international lookup' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:get, 'lookup/31612345678', {})
        .and_return('{"href": "https://rest.messagebird.com/lookup/31612345678","countryCode": "NL","countryPrefix": 31,"phoneNumber": 31612345678,"type": "mobile","formats": {"e164": "+31612345678","international": "+31 6 12345678","national": "06 12345678","rfc3966": "tel:+31-6-12345678"},"hlr": {"id": "hlr-id","network": 20416,"reference": "reference2000","status": "active","createdDatetime": "2015-12-15T08:19:24+00:00","statusDatetime": "2015-12-15T08:19:25+00:00"}}')

    lookup = client.lookup(31612345678)

    expect(lookup.countryCode).to eq 'NL'
    expect(lookup.hlr.id).to eq 'hlr-id'

  end

  it 'performs a new national lookup' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:get, 'lookup/0612345678', { :countryCode => 'NL' })
        .and_return('{"href": "https://rest.messagebird.com/lookup/31612345678","countryCode": "NL","countryPrefix": 31,"phoneNumber": 31612345678,"type": "mobile","formats": {"e164": "+31612345678","international": "+31 6 12345678","national": "06 12345678","rfc3966": "tel:+31-6-12345678"},"hlr": {"id": "hlr-id","network": 20416,"reference": "reference2000","status": "active","createdDatetime": "2015-12-15T08:19:24+00:00","statusDatetime": "2015-12-15T08:19:25+00:00"}}')

    lookup = client.lookup('0612345678', { :countryCode => 'NL' })

    expect(lookup.countryCode).to eq 'NL'
    expect(lookup.hlr.id).to eq 'hlr-id'

  end

end

describe 'Lookup HLR' do

  it 'views an existing' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:get, 'lookup/31612345678/hlr', {})
        .and_return('{"id": "hlr-id","network": 20416,"reference": "reference2000","status": "active","createdDatetime": "2015-12-15T08:19:24+00:00","statusDatetime": "2015-12-15T08:19:25+00:00"}')

    hlr = client.lookup_hlr(31612345678)

    expect(hlr.id).to eq 'hlr-id'

  end

  it 'requests a HLR' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:post, 'lookup/31612345678/hlr', { :reference => 'MyReference' })
        .and_return('{}')

    client.lookup_hlr_create(31612345678, { :reference => 'MyReference' })

  end

end
