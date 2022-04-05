# frozen_string_literal: true

describe '#map_hash_elements_to_self' do
  context 'hash is nil' do
    it 'doesnt raise errors' do
      expect { @contact = MessageBird::Contact.new(nil) }.not_to raise_error
    end
  end

  context 'hash is a contact' do
    before(:all) do
      @contact = MessageBird::Contact.new(
        'id' => '03dfc27855c3475b953d6200a1b7eaf7',
        'msisdn' => '+31600000000',
        'firstName' => 'John',
        'lastName' => 'Doe'
      )
    end

    it 'contains an id' do
      expect(@contact.id).to be('03dfc27855c3475b953d6200a1b7eaf7')
    end

    it 'contains a msisdn' do
      expect(@contact.msisdn).to be('+31600000000')
    end

    it 'contains a first name' do
      expect(@contact.first_name).to be('John')
    end

    it 'contains a last name' do
      expect(@contact.last_name).to be('Doe')
    end
  end
end
