# frozen_string_literal: true

describe 'HttpClient' do
  context 'build_request' do
    let(:url) { URI::HTTP.build(path: '/foo/bar', query: 'test=true') }
    it 'check not not_allowed_method' do
      http_client = MessageBird::HttpClient.new('some_key')
      expect { http_client.build_request(:not_allowed_method, url, {}) }.to raise_error(MessageBird::MethodNotAllowedException)
    end

    [:get, :post, :delete, :get, :patch].each do |method|
      http_client = MessageBird::HttpClient.new('some_key')
      it "check allowed method #{method}" do
        expect(http_client.build_request(method, url, {})).to be_an_instance_of Class.const_get("Net::HTTP::#{method.to_s.capitalize}")
      end
    end
  end
end
