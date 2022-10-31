# frozen_string_literal: true

describe 'RequestValidator' do
  error_map = {
    'invalid jwt: claim nbf is in the future' => 'Signature nbf has not been reached',
    'invalid jwt: claim exp is in the past' => 'Signature has expired',
    'invalid jwt: signing method none is invalid' => 'Expected a different algorithm',
    'invalid jwt: signature is invalid' => 'Signature verification failed'
  }.freeze

  path = File.join(File.dirname(__FILE__), './data/webhook_signature_test_data.json')
  test_cases = JSON.parse(File.read(path))

  test_cases.each do |t|
    before do
      allow(Time).to receive(:now).and_return Time.parse(t['timestamp'])
    end

    it t['name'] do
      request_validator = MessageBird::RequestValidator.new(t['secret'])

      do_verify = -> { request_validator.validate_signature(t['token'], t['url'], t['payload']) }

      if t['valid']
        expect(do_verify.call).not_to be_empty && include(:iss, :nbf, :exp, :url_hash)
      else
        err = error_map[t['reason']] || t['reason']
        expect { do_verify.call }.to raise_error(MessageBird::ValidationError, err)
      end
    end
  end
end
