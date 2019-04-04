describe 'Conversation' do

  it 'sends a message' do

    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:post, 'send', {:from => 'MBTest', :to => 31612345678, :type => 'text',  :content => {:text => 'Hi there!'}})
      .and_return('{}')

    client.send_conversation_message('MBTest', 31612345678,  :type => 'text', :content => {:text => 'Hi there!'})
  end

  it 'starts a conversation' do

    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:post, 'conversations/start', {:channelId => 'c0dae31e440145e094c4708b7d000000', :to => 31612345678, :type => 'text',  :content => {:text => 'Hi there!'}})
      .and_return('{}')

    client.start_conversation(31612345678, 'c0dae31e440145e094c4708b7d000000', :type => 'text', :content => {:text => 'Hi there!'})
  end

  it 'lists' do

    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'conversations?limit=2&offset=0', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_list(2, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'

  end

  it 'reads an existing' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'conversations/conversation-id', {})
      .and_return('{"id": "conversation-id","href": "https://conversations.messagebird.com/v1/conversations/conversation-id"}')

    conversation = client.conversation('conversation-id')

    expect(conversation.id).to eq 'conversation-id'
 
  end

  it 'updates a conversation' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:patch, 'conversations/conversation-id', { :status => MessageBird::CONVERSATION_STATUS_ARCHIVED })
      .and_return('{"id":"conversation-id", "contactId": "contact-id"}')
    conversation = client.conversation_update('conversation-id', MessageBird::CONVERSATION_STATUS_ARCHIVED)

    expect(conversation.id).to eq 'conversation-id'
    expect(conversation.contactId).to eq 'contact-id'

  end

  it 'replies to a conversation' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'conversations/conversation-id/messages', { :type => 'text', :content => { :text => 'Hi there' }})
      .and_return('{"id":"message-id", "channelId": "channel-id", "conversationId": "conversation-id"}')

    msg = client.conversation_reply('conversation-id', :type => 'text', :content => { :text => 'Hi there' })

    expect(msg.id).to eq 'message-id'
    expect(msg.channelId).to eq 'channel-id'
    expect(msg.conversationId).to eq 'conversation-id'

  end

  it 'reads messages in a conversation' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'conversations/conversation-id/messages?limit=2&offset=0', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_messages_list('conversation-id', 2, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'

  end


  it 'reads a message' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'messages/message-id', {})
      .and_return('{"id":"00000000000000000000000000000000"}')

    msg = client.conversation_message('message-id')

    expect(msg.id).to eq '00000000000000000000000000000000'

  end

  it 'creates a webhook' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:post, 'webhooks', :channelId => 'channel-id', :events => [MessageBird::WEBHOOK_EVENT_MESSAGE_CREATED, MessageBird::WEBHOOK_EVENT_MESSAGE_UPDATED], :url => 'url')
      .and_return('{"id":"00000000000000000000000000000000", "events": ["message.created", "message.updated"]}')

    webhook = client.conversation_webhook_create('channel-id', 'url', [MessageBird::WEBHOOK_EVENT_MESSAGE_CREATED, MessageBird::WEBHOOK_EVENT_MESSAGE_UPDATED])

    expect(webhook.id).to eq '00000000000000000000000000000000'
    expect(webhook.events.count).to eq 2
  end

  it 'reads a list of webhooks' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'webhooks?limit=10&offset=0', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_webhooks_list(10, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'reads a webhook' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:get, 'webhooks/webhook-id', {})
      .and_return('{"id":"00000000000000000000000000000000"}')

    webhook = client.conversation_webhook('webhook-id')

    expect(webhook.id).to eq '00000000000000000000000000000000'
  end

  it 'updates a webhook' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:patch, 'webhooks/webhook-id', :events => [MessageBird::WEBHOOK_EVENT_MESSAGE_CREATED], :url => 'url')
      .and_return('{"id":"00000000000000000000000000000000", "events": ["message.created"]}')

    webhook = client.conversation_webhook_update('webhook-id', :events => [MessageBird::WEBHOOK_EVENT_MESSAGE_CREATED], :url => 'url')

    expect(webhook.id).to eq '00000000000000000000000000000000'
    expect(webhook.events.count).to eq 1
  end

  it 'deletes a webhook' do
    http_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', http_client)

    expect(http_client)
      .to receive(:request)
      .with(:delete, 'webhooks/webhook-id', {})
      .and_return('')

    client.conversation_webhook_delete('webhook-id')
  end

end
