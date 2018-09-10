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

    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'groups?limit=0&offset=0', {})
      .and_return('{"offset": 0,"limit": 10,"count": 2,"totalCount": 2,"links": {"first": "https://rest.messagebird.com/groups?offset=0&limit=10","previous": null,"next": null,"last": "https://rest.messagebird.com/groups?offset=0&limit=10"},"items": [{"id": "first-id","href": "https://rest.messagebird.com/groups/first-id","name": "First","contacts": {"totalCount": 3,"href": "https://rest.messagebird.com/groups/first-id/contacts"},"createdDatetime": "2018-07-25T11:47:42+00:00","updatedDatetime": "2018-07-25T14:03:09+00:00"},{"id": "second-id","href": "https://rest.messagebird.com/groups/second-id","name": "Second","contacts": {"totalCount": 4,"href": "https://rest.messagebird.com/groups/second-id/contacts"},"createdDatetime": "2018-07-25T11:47:39+00:00","updatedDatetime": "2018-07-25T14:03:09+00:00"}]}')

    list = client.group_list

    expect(list.count).to eq 2
    expect(list[0].id).to eq 'first-id'

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