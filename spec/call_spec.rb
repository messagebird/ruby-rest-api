# frozen_string_literal: true

require "messagebird/call"
describe "Call" do
  let(:source) { "31621234567" }
  let(:destination) { "31621234568" }
  let(:call_id) { "21025ed1-cc1d-4554-ac05-043fa6c84e00" }
  let(:http_client) { double(MessageBird::HttpClient) }
  let(:client) { MessageBird::Client.new("", http_client) }
  let(:webhook) { { url: "https://example.com", token: "token_to_sign_the_call_events_with" } }
  let(:call_flow) do
    {
      title: "Say message",
      steps: [
        {
          action: "say",
          options: {
            payload: "This is a journey into sound. Good bye!",
            voice: "male",
            language: "en-US"
          }
        }
      ]
    }
  end

  it "create a call" do
    expect(http_client)
      .to receive(:request)
      .with(:post, "calls", { source: source, destination: destination, callFlow: call_flow.to_json })
      .and_return('{"data":[{"id":"'+call_id+'","status":"queued","source":"'+source+'","destination":"'+destination+'","createdAt":"2019-10-11T13:02:19Z","updatedAt":"2019-10-11T13:02:19Z","endedAt":null}],"_links":{"self":"/calls/'+call_id+'"},"pagination":{"totalCount":0,"pageCount":0,"currentPage":0,"perPage":0}}')
    call = client.call_create(source, destination, call_flow)
    expect(call.id).to eq call_id
  end

  it "create a call with webhook" do
    expect(http_client)
      .to receive(:request)
      .with(:post, "calls", { source: source, destination: destination, callFlow: call_flow.to_json, webhook: webhook.to_json })
      .and_return('{"data":[{"id":"'+call_id+'","status":"queued","source":"'+source+'","destination":"'+destination+'","createdAt":"2019-10-11T13:02:19Z","updatedAt":"2019-10-11T13:02:19Z","endedAt":null, "webhook":'+webhook.to_json+'}],"_links":{"self":"/calls/'+call_id+'"},"pagination":{"totalCount":0,"pageCount":0,"currentPage":0,"perPage":0}}')
    call = client.call_create(source, destination, call_flow, webhook)
    expect(call.id).to eq call_id
    expect(call.webhook.url).to eq webhook[:url]
  end

  it "list all calls" do
    expect(http_client)
      .to receive(:request)
      .with(:get, "calls?perPage=20&page=1", {})
      .and_return('{ "data": [ { "id": "f1aa71c0-8f2a-4fe8-b5ef-9a330454ef58", "status": "ended", "source": "'+source+'", "destination": "31612345678", "createdAt": "2017-02-16T10:52:00Z", "updatedAt": "2017-02-16T10:59:04Z", "endedAt": "2017-02-16T10:59:04Z", "_links": { "self": "/calls/f1aa71c0-8f2a-4fe8-b5ef-9a330454ef58" } }, { "id": "ac07a602-dbc1-11e6-bf26-cec0c932ce01", "status": "ended", "source": "'+source+'", "destination": "31612345678", "createdAt": "2017-01-16T07:51:56Z", "updatedAt": "2017-01-16T07:55:56Z", "endedAt": "2017-01-16T07:55:56Z", "webhook": '+webhook.to_json+',"_links": { "self": "/calls/ac07a602-dbc1-11e6-bf26-cec0c932ce01" } } ], "_links": { "self": "/calls?page=1" }, "pagination": { "totalCount": 2, "pageCount": 1, "currentPage": 1, "perPage": 10 } }
')
    list = client.call_list
    expect(list.items).not_to be_nil
    expect(list.items.first.source).to eq source
    expect(list.items.last.webhook.url).to eq webhook[:url]
  end

  it "view a call" do
    expect(http_client)
      .to receive(:request)
      .with(:get, "calls/#{call_id}", {})
      .and_return('{
  "data": [
    {
      "id": "'+call_id+'",
      "status": "ended",
      "source": "'+source+'",
      "destination": "'+destination+'",
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

  it "delete a call" do
    expect(http_client)
      .to receive(:request)
      .with(:delete, "calls/call-id", {})
      .and_return("")
    client.call_delete("call-id")
  end
end
