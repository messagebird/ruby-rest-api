require 'rspec'
require 'rspec/mocks'
require 'messagebird'

describe 'Balance' do

  it 'parses the balance' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
        .to receive(:request)
        .with(:get, 'balance', {})
        .and_return('{"payment":"prepaid","type":"credits","amount":12.34}')

    balance = client.balance

    expect(balance.payment).to eq 'prepaid'

  end

end