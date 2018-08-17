describe 'Group' do

  it 'creates' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'groups', { :name => 'friends'})
      .and_return('{}')

    client.group_create('friends')

  end

  it 'deletes' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:delete, 'groups/group-id', {})
      .and_return('')

    client.group_delete('group-id')

  end

  it 'lists' do
    # todo
  end

  it 'reads an existing' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'groups/group-id', {})
      .and_return('{"id": "group-id","href": "https://rest.messagebird.com/groups/group-id","name": "Friends","contacts": {"totalCount": 3,"href": "https://rest.messagebird.com/groups/group-id"},"createdDatetime": "2018-07-25T12:16:10+00:00","updatedDatetime": "2018-07-25T12:16:23+00:00"}')

    group = client.group('group-id')

    expect(group.id).to eq 'group-id'
    expect(group.name).to eq 'Friends'

  end

  it 'reads the contact reference' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'groups/group-id', {})
      .and_return('{"id": "group-id","href": "https://rest.messagebird.com/groups/group-id","name": "Friends","contacts": {"totalCount": 3,"href": "https://rest.messagebird.com/groups/group-id/contacts"},"createdDatetime": "2018-07-25T12:16:10+00:00","updatedDatetime": "2018-07-25T12:16:23+00:00"}')

    group = client.group('group-id')

    expect(group.contacts.href).to eq 'https://rest.messagebird.com/groups/group-id/contacts'
    expect(group.contacts.totalCount).to eq 3

  end

  it 'updates' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:patch, 'groups/group-id', { :name => 'family' })
      .and_return('{}')

    client.group_update('group-id', 'family')

  end

  it 'adds contacts' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'groups/group-id?_method=PUT&ids[]=first-contact-id&ids[]=second-contact-id', { })
      .and_return('{}')

    client.group_add_contacts('group-id', ['first-contact-id', 'second-contact-id'])

  end

  it 'adds single contact' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'groups/group-id?_method=PUT&ids[]=contact-id', { })
      .and_return('{}')

    client.group_add_contacts('group-id', 'contact-id')

  end

  it 'removes contact' do

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:delete, 'groups/group-id/contacts/contact-id', {})
      .and_return('{}')

    client.group_delete_contact('group-id', 'contact-id')

  end

end