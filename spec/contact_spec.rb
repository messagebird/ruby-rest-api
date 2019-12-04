# frozen_string_literal: true

describe "Contact" do
  it "creates" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, "contacts", { msisdn: "31612345678", firstName: "Foo", lastName: "Bar", custom1: "First", custom4: "Fourth" })
      .and_return("{}")

    client.contact_create(31612345678, { firstName: "Foo", lastName: "Bar", custom1: "First", custom4: "Fourth" })
  end

  it "deletes" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(client)
      .to receive(:request)
      .with(:delete, "contacts/contact-id")
      .and_return("")

    client.contact_delete("contact-id")
  end

  it "lists" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts?limit=0&offset=0", {})
      .and_return('{"offset": 0,"limit": 20,"count": 2,"totalCount": 2,"links": {"first": "https://rest.messagebird.com/contacts?offset=0","previous": null,"next": null,"last": "https://rest.messagebird.com/contacts?offset=0"},"items": [{"id": "first-id","href": "https://rest.messagebird.com/contacts/first-id","msisdn": 31612345678,"firstName": "Foo","lastName": "Bar","customDetails": {"custom1": null,"custom2": null,"custom3": null,"custom4": null},"groups": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/first-id/groups"},"messages": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/first-id/messages"},"createdDatetime": "2018-07-13T10:34:08+00:00","updatedDatetime": "2018-07-13T10:34:08+00:00"},{"id": "second-id","href": "https://rest.messagebird.com/contacts/second-id","msisdn": 49612345678,"firstName": "Hello","lastName": "World","customDetails": {"custom1": null,"custom2": null,"custom3": null,"custom4": null},"groups": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/second-id/groups"},"messages": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/second-id/messages"},"createdDatetime": "2018-07-13T10:33:52+00:00","updatedDatetime": null}]}')

    list = client.contact_list

    expect(list.offset).to eq 0
    expect(list.limit).to eq 20
    expect(list.count).to eq 2
    expect(list.totalCount).to eq 2

    expect(list.items[0].id).to eq "first-id"
  end

  it "lists and allows array access" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts?limit=10&offset=0", {})
      .and_return('{"offset": 0,"limit": 20,"count": 2,"totalCount": 2,"links": {"first": "https://rest.messagebird.com/contacts?offset=0","previous": null,"next": null,"last": "https://rest.messagebird.com/contacts?offset=0"},"items": [{"id": "first-id","href": "https://rest.messagebird.com/contacts/first-id","msisdn": 31612345678,"firstName": "Foo","lastName": "Bar","customDetails": {"custom1": null,"custom2": null,"custom3": null,"custom4": null},"groups": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/first-id/groups"},"messages": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/first-id/messages"},"createdDatetime": "2018-07-13T10:34:08+00:00","updatedDatetime": "2018-07-13T10:34:08+00:00"},{"id": "second-id","href": "https://rest.messagebird.com/contacts/second-id","msisdn": 49612345678,"firstName": "Hello","lastName": "World","customDetails": {"custom1": null,"custom2": null,"custom3": null,"custom4": null},"groups": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/second-id/groups"},"messages": {"totalCount": 0,"href": "https://rest.messagebird.com/contacts/second-id/messages"},"createdDatetime": "2018-07-13T10:33:52+00:00","updatedDatetime": null}]}')

    list = client.contact_list(10)

    expect(list[1].id).to eq "second-id"
  end

  it "lists with pagination" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts?limit=10&offset=20", {})
      .and_return("{}")

    client.contact_list(10, 20)
  end

  it "reads an existing" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts/contact-id", {})
      .and_return('{"id": "contact-id","href": "https://rest.messagebird.com/contacts/contact-id","msisdn": 31612345678,"firstName": "Foo","lastName": "Bar","customDetails": {"custom1": "First","custom2": "Second","custom3": "Third","custom4": "Fourth"},"groups": {"totalCount": 3,"href": "https://rest.messagebird.com/contacts/contact-id/groups"},"messages": {"totalCount": 5,"href": "https://rest.messagebird.com/contacts/contact-id/messages"},"createdDatetime": "2018-07-13T10:34:08+00:00","updatedDatetime": "2018-07-13T10:44:08+00:00"}')

    contact = client.contact("contact-id")

    expect(contact.id).to eq "contact-id"
    expect(contact.msisdn).to eq 31612345678
  end

  it "reads custom details" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts/contact-id", {})
      .and_return('{"id": "contact-id","href": "https://rest.messagebird.com/contacts/contact-id","msisdn": 31612345678,"firstName": "Foo","lastName": "Bar","customDetails": {"custom1": "First","custom2": "Second","custom3": "Third","custom4": "Fourth"},"groups": {"totalCount": 3,"href": "https://rest.messagebird.com/contacts/contact-id/groups"},"messages": {"totalCount": 5,"href": "https://rest.messagebird.com/contacts/contact-id/messages"},"createdDatetime": "2018-07-13T10:34:08+00:00","updatedDatetime": "2018-07-13T10:44:08+00:00"}')

    contact = client.contact("contact-id")

    expect(contact.customDetails).to be_an_instance_of(MessageBird::CustomDetails)

    expect(contact.customDetails.custom1).to eq "First"
    expect(contact.customDetails.custom4).to eq "Fourth"
  end

  it "updates" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:patch, "contacts/contact-id", { msisdn: 31687654321, custom3: "Third" })
      .and_return("")

    client.contact_update("contact-id", { msisdn: 31687654321, custom3: "Third" })
  end

  it "lists groups" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts/contact-id", {})
      .and_return('{"id": "contact-id","href": "https://rest.messagebird.com/contacts/contact-id","msisdn": 31612345678,"firstName": "Foo","lastName": "Bar","customDetails": {"custom1": "First","custom2": "Second","custom3": "Third","custom4": "Fourth"},"groups": {"totalCount": 3,"href": "https://rest.messagebird.com/contacts/contact-id/groups"},"messages": {"totalCount": 5,"href": "https://rest.messagebird.com/contacts/contact-id/messages"},"createdDatetime": "2018-07-13T10:34:08+00:00","updatedDatetime": "2018-07-13T10:44:08+00:00"}')

    contact = client.contact("contact-id")

    expect(contact.groups.href).to eq "https://rest.messagebird.com/contacts/contact-id/groups"
    expect(contact.groups.totalCount).to eq 3
  end

  it "lists messages" do
    http_client = double(MessageBird::HttpClient)
    client = MessageBird::Client.new("", http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, "contacts/contact-id", {})
      .and_return('{"id": "contact-id","href": "https://rest.messagebird.com/contacts/contact-id","msisdn": 31612345678,"firstName": "Foo","lastName": "Bar","customDetails": {"custom1": "First","custom2": "Second","custom3": "Third","custom4": "Fourth"},"groups": {"totalCount": 3,"href": "https://rest.messagebird.com/contacts/contact-id/groups"},"messages": {"totalCount": 5,"href": "https://rest.messagebird.com/contacts/contact-id/messages"},"createdDatetime": "2018-07-13T10:34:08+00:00","updatedDatetime": "2018-07-13T10:44:08+00:00"}')

    contact = client.contact("contact-id")

    expect(contact.messages.href).to eq "https://rest.messagebird.com/contacts/contact-id/messages"
    expect(contact.messages.totalCount).to eq 5
  end
end
