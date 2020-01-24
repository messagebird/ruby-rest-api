# frozen_string_literal: true

describe 'Numbers API' do
  it 'performs a number search' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'available-phone-numbers/NL?limit=5', limit: 5)
      .and_return('{"items": [{"number": "3197010260188","country": "NL","region": "","locality": "","features": ["sms","voice"],"type": "mobile"},{"number": "3197010260188","country": "NL","region": "","locality": "","features": ["sms","voice"],"type": "mobile"}],"limit": 5,"count": 2}')

    numbers = client.number_search('NL', limit: 5)

    expect(numbers.count).to eq 2
    expect(numbers.limit).to eq 5
    expect(numbers[0].number).to eq '3197010260188'
    expect(numbers[1].country).to eq 'NL'
  end

  it 'performs a purchase' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'phone-numbers', number: '31971234567', countryCode: 'NL', billingIntervalMonths: 1)
      .and_return('{"number": "31971234567","country": "NL","region": "Haarlem","locality": "Haarlem","features": ["sms","voice"],"tags": [],"type": "landline_or_mobile","status": "active","createdAt": "2019-04-25T14:04:04Z","renewalAt": "2019-05-25T00:00:00Z"}')

    number = client.number_purchase('31971234567', 'NL', 1)

    expect(number.number).to eq '31971234567'
    expect(number.country).to eq 'NL'
    expect(number.region).to eq 'Haarlem'
    expect(number.locality).to eq 'Haarlem'
    expect(number.features).to eq ['sms', 'voice']
    expect(number.tags).to eq []
    expect(number.type).to eq 'landline_or_mobile'
    expect(number.status).to eq 'active'
    expect(number.created_at).to eq Time.parse('2019-04-25T14:04:04Z')
    expect(number.renewal_at).to eq Time.parse('2019-05-25T00:00:00Z')
  end

  it 'performs a fetch all numbers' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'phone-numbers?type=mobile&features=sms&features=voice', type: 'mobile', features: ['sms', 'voice'])
      .and_return('{"offset": 0,"limit": 20,"count": 1,"totalCount": 1,"items": [{"number": "31612345670","country": "NL","region": "Texel","locality": "Texel","features": ["sms","voice"],"tags": [],"type": "mobile","status": "active"}]}')

    numbers = client.number_fetch_all(type: 'mobile', features: ['sms', 'voice'])

    expect(numbers.count).to eq 1
    expect(numbers[0].number).to eq '31612345670'
    expect(numbers[0].country).to eq 'NL'
    expect(numbers[0].region).to eq 'Texel'
    expect(numbers[0].locality).to eq 'Texel'
    expect(numbers[0].features).to eq ['sms', 'voice']
    expect(numbers[0].tags).to eq []
    expect(numbers[0].type).to eq 'mobile'
    expect(numbers[0].status).to eq 'active'
  end

  it 'performs a fetch purchased' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'phone-numbers/31612345670', {})
      .and_return('{"number": "31612345670","country": "NL","region": "Texel","locality": "Texel","features": ["sms","voice"],"tags": [],"type": "mobile","status": "active"}')

    number = client.number_fetch('31612345670')

    expect(number.number).to eq '31612345670'
    expect(number.country).to eq 'NL'
    expect(number.region).to eq 'Texel'
    expect(number.locality).to eq 'Texel'
    expect(number.features).to eq ['sms', 'voice']
    expect(number.tags).to eq []
    expect(number.type).to eq 'mobile'
    expect(number.status).to eq 'active'
  end

  it 'performs a update' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:patch, 'phone-numbers/31612345670', tags: ['tag1'])
      .and_return('{"number": "31612345670","country": "NL","region": "Texel","locality": "Texel","features": ["sms","voice"],"tags": ["tag1"],"type": "mobile","status": "active"}')

    number = client.number_update('31612345670', ['tag1'])

    expect(number.number).to eq '31612345670'
    expect(number.country).to eq 'NL'
    expect(number.region).to eq 'Texel'
    expect(number.locality).to eq 'Texel'
    expect(number.features).to eq ['sms', 'voice']
    expect(number.tags).to eq ['tag1']
    expect(number.type).to eq 'mobile'
    expect(number.status).to eq 'active'
  end

  it 'performs a cancel' do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:delete, 'phone-numbers/31612345670', {})

    client.number_cancel('31612345670')
  end
end
