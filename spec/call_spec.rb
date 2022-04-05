# frozen_string_literal: true

require 'messagebird/voice/call'
describe 'Call' do
  let(:source) { '31621234567' }
  let(:destination) { '31621234568' }
  let(:call_id) { '21025ed1-cc1d-4554-ac05-043fa6c84e00' }
  let(:leg_id) { '30c42b27-dce6-4f72-b9c1-01f78ebc1008' }
  let(:recording_id) { '3f7b2a0b-3f42-4b6c-a492-22cf35df98f6' }
  let(:transcription_id) { '87c377ce-1629-48b6-ad01-4b4fd069c53c' }
  let(:transcription_language) { 'en-UK' }

  let(:http_client) { double(MessageBird::HttpClient) }
  let(:voice_client) { double(MessageBird::VoiceClient) }
  let(:client) { MessageBird::Client.new('', http_client, nil, voice_client) }
  let(:webhook) { { url: 'https://example.com', token: 'token_to_sign_the_call_events_with' } }
  let(:call_flow) do
    {
      title: 'Say message',
      steps: [
        {
          action: 'say',
          options: {
            payload: 'This is a journey into sound. Good bye!',
            voice: 'male',
            language: 'en-US'
          }
        }
      ]
    }
  end
  let(:language) do
    {
      language: 'en-UK'
    }
  end

  it 'create a call' do
    expect(voice_client)
      .to receive(:request)
      .with(:post, 'calls', { source: source, destination: destination, callFlow: call_flow.to_json })
      .and_return('{"data":[{"id":"' + call_id + '","status":"queued","source":"' + source + '","destination":"' + destination + '","createdAt":"2019-10-11T13:02:19Z","updatedAt":"2019-10-11T13:02:19Z","endedAt":null}],"_links":{"self":"/calls/' + call_id + '"},"pagination":{"total_count":0,"pageCount":0,"currentPage":0,"perPage":0}}')
    call = client.call_create(source, destination, call_flow)
    expect(call.id).to eq call_id
  end

  it 'create a call with webhook' do
    expect(voice_client)
      .to receive(:request)
      .with(:post, 'calls', { source: source, destination: destination, callFlow: call_flow.to_json, webhook: webhook.to_json })
      .and_return('{"data":[{"id":"' + call_id + '","status":"queued","source":"' + source + '","destination":"' + destination + '","createdAt":"2019-10-11T13:02:19Z","updatedAt":"2019-10-11T13:02:19Z","endedAt":null, "webhook":' + webhook.to_json + '}],"_links":{"self":"/calls/' + call_id + '"},"pagination":{"total_count":0,"pageCount":0,"currentPage":0,"perPage":0}}')
    call = client.call_create(source, destination, call_flow, webhook)
    expect(call.id).to eq call_id
    expect(call.webhook.url).to eq webhook[:url]
  end

  it 'list all calls' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, 'calls?perPage=20&currentPage=1', {})
      .and_return('{ "data": [ { "id": "f1aa71c0-8f2a-4fe8-b5ef-9a330454ef58", "status": "ended", "source": "' + source + '", "destination": "31612345678", "createdAt": "2017-02-16T10:52:00Z", "updatedAt": "2017-02-16T10:59:04Z", "endedAt": "2017-02-16T10:59:04Z", "_links": { "self": "/calls/f1aa71c0-8f2a-4fe8-b5ef-9a330454ef58" } }, { "id": "ac07a602-dbc1-11e6-bf26-cec0c932ce01", "status": "ended", "source": "' + source + '", "destination": "31612345678", "createdAt": "2017-01-16T07:51:56Z", "updatedAt": "2017-01-16T07:55:56Z", "endedAt": "2017-01-16T07:55:56Z", "webhook": ' + webhook.to_json + ',"_links": { "self": "/calls/ac07a602-dbc1-11e6-bf26-cec0c932ce01" } } ], "_links": { "self": "/calls?page=1" }, "pagination": { "total_count": 2, "pageCount": 1, "currentPage": 1, "perPage": 10 } }')

    list = client.call_list
    expect(list.items).not_to be_nil
    expect(list.items.first.source).to eq source
    expect(list.items.last.webhook.url).to eq webhook[:url]
  end

  it 'view a call' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}", {})
      .and_return('{
  "data": [
    {
      "id": "' + call_id + '",
      "status": "ended",
      "source": "' + source + '",
      "destination": "' + destination + '",
      "createdAt": "2017-02-16T10:52:00Z",
      "updatedAt": "2017-02-16T10:59:04Z",
      "endedAt": "2017-02-16T10:59:04Z"
    }
  ],
  "_links": {
    "self": "/calls/f1aa71c0-8f2a-4fe8-b5ef-9a330454ef58"
  }
}')
    call = client.call_view(call_id)
    expect(call.id).to eq(call_id)
  end

  it 'delete a call' do
    expect(voice_client)
      .to receive(:request)
      .with(:delete, 'calls/call-id', {})
      .and_return('')
    client.call_delete('call-id')
  end

  it 'list call legs' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}/legs?perPage=#{MessageBird::Voice::List::PER_PAGE}&currentPage=#{MessageBird::Voice::List::CURRENT_PAGE}", {})
      .and_return('
        {
          "data": [
              {
                  "id": "' + leg_id + '",
                  "callId": "' + call_id + '",
                  "source": "' + source + '",
                  "destination": "' + destination + '",
                  "service": 1,
                  "status": "hangup",
                  "direction": "outgoing",
                  "cost": 0.0021670,
                  "currency": "EUR",
                  "duration": 10,
                  "createdAt": "2019-12-03T14:50:47Z",
                  "updatedAt": "2019-12-03T14:51:00Z",
                  "answeredAt": "2019-12-03T14:50:50Z",
                  "endedAt": "2019-12-03T14:51:00Z",
                  "_links": {
                      "self": "/calls/' + call_id + '/legs/' + leg_id + '"
                  }
              }
          ],
          "_links": {
              "self": "/calls/' + call_id + '/legs?page=1"
          },
          "pagination": {
              "totalCount": 1,
              "pageCount": 1,
              "currentPage": 1,
              "perPage": 10
          }
      }')

    legs = client.call_leg_list(call_id)
    expect(legs[0].id).to eq leg_id
  end

  it 'list call leg recordings' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}/legs/#{leg_id}/recordings", {})
      .and_return('
        {
          "data": [
              {
                  "id": "' + recording_id + '",
                  "format": "wav",
                  "legId": "' + leg_id + '",
                  "status": "done",
                  "duration": 5,
                  "type": "ivr",
                  "createdAt": "2019-12-03T14:50:53Z",
                  "updatedAt": "2019-12-03T14:51:00Z",
                  "deletedAt": null,
                  "_links": {
                      "file": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '.wav",
                      "self": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '"
                  }
              }
          ],
          "_links": {
              "self": "/calls/' + call_id + '/legs/' + leg_id + '/recordings?page=1"
          },
          "pagination": {
              "totalCount": 1,
              "pageCount": 1,
              "currentPage": 1,
              "perPage": 10
          }
      }')

    records = client.call_leg_recording_list(call_id, leg_id)
    expect(records[0].uri).to eq '/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '.wav'
  end

  it 'view a call recording' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}", {})
      .and_return('
        {
          "data": [
              {
                  "id": "' + recording_id + '",
                  "format": "wav",
                  "legId": "' + leg_id + '",
                  "status": "done",
                  "duration": 12,
                  "type": "call",
                  "createdAt": "2019-12-03T14:50:47Z",
                  "updatedAt": "2019-12-03T14:51:01Z",
                  "deletedAt": null
              }
          ],
          "_links": {
              "file": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '.wav",
              "self": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '"
          },
          "pagination": {
              "totalCount": 0,
              "pageCount": 0,
              "currentPage": 0,
              "perPage": 0
          }
      }')

    recording = client.call_leg_recording_view(call_id, leg_id, recording_id)
    expect(recording.uri).to eq '/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '.wav'
  end

  it 'download a call recording' do
    mock_response  = double(Net::HTTPResponse)
    recording_uri  = '/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '.wav'

    expect(voice_client)
      .to receive(:request_block)
      .with(:get, recording_uri, {})
      .and_yield(mock_response)

    expect(mock_response)
      .to receive(:read_body)
      .once
      .and_return('bytes go here')

    client.call_leg_recording_download(recording_uri) do |response|
      expect(response.read_body)
        .to eq 'bytes go here'
    end
  end

  it 'delete a recording' do
    expect(voice_client)
      .to receive(:request)
      .with(:delete, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}", {})
      .and_return('')
    client.call_leg_recording_delete(call_id, leg_id, recording_id)
  end

  it 'create a transcription' do
    expect(voice_client)
      .to receive(:request)
      .with(:post, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions", language.to_json)
      .and_return('
        {
          "data": [
            {
              "id":"' + transcription_id + '",
              "recordingId":"' + recording_id + '",
              "error": null,"destination":"' + destination + '",
              "createdAt":"2017-06-20T10:03:14Z",
              "updatedAt": "2017-06-20T10:03:14Z"
            }
          ],
          "_links": {
            "file": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '.txt",
            "self": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '"
          },
          "pagination":{"total_count":0,"pageCount":0,"currentPage":0,"perPage":0}
        }')
    transcription = client.voice_transcription_create(call_id, leg_id, recording_id, language.to_json)
    expect(transcription.id).to eq transcription_id
  end

  it 'view a transcription' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions/#{transcription_id}", {})
      .and_return('
      {
        "data": [
          {
            "id": "' + transcription_id + '",
            "recordingId": "' + recording_id + '",
            "error": null,
            "createdAt": "2017-06-20T10:03:14Z",
            "updatedAt": "2017-06-20T10:03:14Z"
          }
        ],
        "_links": {
          "file": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '.txt",
          "self": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '"
        },
        "pagination": {
          "totalCount": 1,
          "pageCount": 1,
          "currentPage": 1,
          "perPage": 10
        }
      }')

    transcription = client.voice_transcription_view(call_id, leg_id, recording_id, transcription_id)
    expect(transcription.uri).to eq '/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '.txt'
  end

  it 'list transcriptions' do
    expect(voice_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions", {})
      .and_return('
      {
        "data": [
          {
            "id":"' + transcription_id + '",
            "recordingId": "' + recording_id + '",
            "status":"done",
            "createdAt":"2019-12-04T16:52:51Z",
            "updatedAt":"2019-12-04T16:53:02Z",
            "legId":"00000000-0000-0000-0000-000000000000",
            "_links": {
              "file":"/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '.txt",
              "self":"/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '"
            }
          }
        ],
        "_links": {
          "self": "/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '"
        },
        "pagination": {
          "totalCount": 1,
          "pageCount": 1,
          "currentPage": 1,
          "perPage": 10
        }
      }')

    records = client.voice_transcriptions_list(call_id, leg_id, recording_id)
    expect(records[0].uri).to eq '/calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '.txt'
  end

  it 'download a transcription' do
    mock_response = double(Net::HTTPResponse)
    transcription_uri = 'calls/' + call_id + '/legs/' + leg_id + '/recordings/' + recording_id + '/transcriptions/' + transcription_id + '.txt'

    expect(voice_client)
      .to receive(:request_block)
      .with(:get, transcription_uri, {})
      .and_yield(mock_response)

    expect(mock_response)
      .to receive(:read_body)
      .once
      .and_return('Hello Test! This a call transcript! Bye, bye!')

    client.voice_transcription_download(call_id, leg_id, recording_id, transcription_id) do |response|
      expect(response.read_body)
        .to eq 'Hello Test! This a call transcript! Bye, bye!'
    end
  end
end
