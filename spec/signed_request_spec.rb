# frozen_string_literal: true
SIGNING_KEY = 'PlLrKaqvZNRR5zAjm42ZT6q1SQxgbbGd'

describe 'SignedRequest' do
  it 'verifies a correctly signed request without a body' do
    query = {
      'recipient' => '31612345678',
      'reference' => 'FOO',
      'statusDatetime' => '2019-01-11T09:17:11+00:00',
      'id' => 'eef0ab57a9e049be946f3821568c2b2e',
      'status' => 'delivered',
      'mccmnc' => '20408',
      'ported' => '1'
    }
    signature = 'KVBdcVdz2lYMwcBLZCRITgxUfA/WkwSi+T3Wxl2HL6w='
    request_timestamp = 1_547_198_231
    body = ''

    # Create a MessageBird signed request.
    signed_request = MessageBird::SignedRequest.new(query, signature, request_timestamp, body)

    expect(signed_request.verify(SIGNING_KEY)).to eq true
  end

  it 'verifies a correctly signed request with a body' do
    query = {
      'recipient' => '31612345678',
      'reference' => 'FOO',
      'statusDatetime' => '2019-01-11T09:17:11+00:00',
      'id' => 'eef0ab57a9e049be946f3821568c2b2e',
      'status' => 'delivered',
      'mccmnc' => '20408',
      'ported' => '1'
    }
    signature = '2bl+38H4oHVg03pC3bk2LvCB0IHFgfC4cL5HPQ0LdmI='
    request_timestamp = 1_547_198_231
    body = '{"foo":"bar"}'

    # Create a MessageBird signed request.
    signed_request = MessageBird::SignedRequest.new(query, signature, request_timestamp, body)

    expect(signed_request.verify(SIGNING_KEY)).to eq true
  end

  it 'fails to verify an incorrectly signed request' do
    query = {
      'recipient' => '31612345678',
      'reference' => 'BAR',
      'statusDatetime' => '2019-01-11T09:17:11+00:00',
      'id' => 'eef0ab57a9e049be946f3821568c2b2e',
      'status' => 'delivered',
      'mccmnc' => '20408',
      'ported' => '1'
    }
    signature = 'KVBdcVdz2lYMwcBLZCRITgxUfA/WkwSi+T3Wxl2HL6w='
    request_timestamp = 1_547_198_231
    body = ''

    # Create a MessageBird signed request.
    signed_request = MessageBird::SignedRequest.new(query, signature, request_timestamp, body)

    expect(signed_request.verify(SIGNING_KEY)).to eq false
  end

  it 'correctly identifies a request as recent' do
    query = {}
    signature = 'KVBdcVdz2lYMwcBLZCRITgxUfA/WkwSi+T3Wxl2HL6w='
    request_timestamp = Time.now.getutc.to_i - 1
    body = ''

    # Create a MessageBird signed request.
    signed_request = MessageBird::SignedRequest.new(query, signature, request_timestamp, body)

    expect(signed_request.recent?).to eq true
  end

  it 'correctly identifies a request as not recent' do
    query = {}
    signature = 'KVBdcVdz2lYMwcBLZCRITgxUfA/WkwSi+T3Wxl2HL6w='
    request_timestamp = Time.now.getutc.to_i - 100
    body = ''

    # Create a MessageBird signed request.
    signed_request = MessageBird::SignedRequest.new(query, signature, request_timestamp, body)

    expect(signed_request.recent?).to eq false
  end
end
