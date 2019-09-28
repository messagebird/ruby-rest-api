describe 'Error' do

  it 'raises returned errors' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .and_return('{"errors":[{"code": 2,"description": "Request not allowed (incorrect access_key)","parameter": "access_key"}]}')

    expect{ client.message('some-id') }.to raise_error(MessageBird::ErrorException)
  end

  context 'server responds with an invalid HTTP status code' do
    it 'raises ServerException' do
      stub_request(:any, /#{MessageBird::HttpClient::ENDPOINT}/)
        .to_return(status: 500)

      client = MessageBird::Client.new

      expect { client.message('some-id') }.to raise_error(MessageBird::ServerException)
    end
  end
end
