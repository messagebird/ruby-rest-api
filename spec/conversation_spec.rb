# frozen_string_literal: true

describe 'Conversation' do
  it 'sends a message' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:post, 'send', from: 'MBTest', to: 31_612_345_678, type: 'text', content: { text: 'Hi there!' })
      .and_return('{}')

    client.send_conversation_message('MBTest', 31_612_345_678, type: 'text', content: { text: 'Hi there!' })
  end

  it 'starts a conversation' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:post, 'conversations/start', channel_id: 'c0dae31e440145e094c4708b7d000000', to: 31_612_345_678, type: 'text', content: { text: 'Hi there!' })
      .and_return('{}')

    client.start_conversation(31_612_345_678, 'c0dae31e440145e094c4708b7d000000', type: 'text', content: { text: 'Hi there!' })
  end

  it 'lists' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'conversations?limit=2&offset=0', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_list(2, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'list without args'  do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'conversations?', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_list

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'list messages' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    conversation_id = '5f3437fdb8444583aea093a047ac014b'

    expect(conversation_client)
      .to receive(:request)
      .with(:get, "conversations/#{conversation_id}/messages?limit=2&offset=0", {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_messages_list(conversation_id, 2, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'list messages without args' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    conversation_id = '5f3437fdb8444583aea093a047ac014b'

    expect(conversation_client)
      .to receive(:request)
      .with(:get, "conversations/#{conversation_id}/messages?", {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_messages_list(conversation_id)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'reads an existing' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'conversations/conversation-id', {})
      .and_return('{"id": "conversation-id","href": "https://conversations.messagebird.com/v1/conversations/conversation-id"}')

    conversation = client.conversation('conversation-id')

    expect(conversation.id).to eq 'conversation-id'
  end

  it 'updates a conversation' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:patch, 'conversations/conversation-id', status: MessageBird::Conversation::CONVERSATION_STATUS_ARCHIVED)
      .and_return('{"id":"conversation-id", "contactId": "contact-id"}')
    conversation = client.conversation_update('conversation-id', MessageBird::Conversation::CONVERSATION_STATUS_ARCHIVED)

    expect(conversation.id).to eq 'conversation-id'
    expect(conversation.contact_id).to eq 'contact-id'
  end

  it 'replies to a conversation' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:post, 'conversations/conversation-id/messages', type: 'text', content: { text: 'Hi there' })
      .and_return({ id: 'message-id', channel_id: 'channel-id', conversationId: 'conversation-id' }.to_json)

    msg = client.conversation_reply('conversation-id', type: 'text', content: { text: 'Hi there' })

    expect(msg.id).to eq 'message-id'
    expect(msg.channel_id).to eq 'channel-id'
    expect(msg.conversation_id).to eq 'conversation-id'
  end

  it 'reads messages in a conversation' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'conversations/conversation-id/messages?limit=2&offset=0', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_messages_list('conversation-id', 2, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'reads a message' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'messages/message-id', {})
      .and_return('{"id":"00000000000000000000000000000000"}')

    msg = client.conversation_message('message-id')

    expect(msg.id).to eq '00000000000000000000000000000000'
  end

  it 'creates a webhook' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:post, 'webhooks', channel_id: 'channel-id', events: [MessageBird::Conversation::WEBHOOK_EVENT_MESSAGE_CREATED, MessageBird::Conversation::WEBHOOK_EVENT_MESSAGE_UPDATED], url: 'url')
      .and_return('{"id":"00000000000000000000000000000000", "events": ["message.created", "message.updated"]}')

    webhook = client.conversation_webhook_create('channel-id', 'url', [MessageBird::Conversation::WEBHOOK_EVENT_MESSAGE_CREATED, MessageBird::Conversation::WEBHOOK_EVENT_MESSAGE_UPDATED])

    expect(webhook.id).to eq '00000000000000000000000000000000'
    expect(webhook.events.count).to eq 2
  end

  it 'reads a list of webhooks' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'webhooks?limit=10&offset=0', {})
      .and_return('{"offset":0,"limit":10,"count":2,"totalCount":2,"items":[{"id":"00000000000000000000000000000000"},{"id":"11111111111111111111111111111111"}]}')

    list = client.conversation_webhooks_list(10, 0)

    expect(list.count).to eq 2
    expect(list[0].id).to eq '00000000000000000000000000000000'
  end

  it 'reads a webhook' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:get, 'webhooks/webhook-id', {})
      .and_return('{"id":"00000000000000000000000000000000"}')

    webhook = client.conversation_webhook('webhook-id')

    expect(webhook.id).to eq '00000000000000000000000000000000'
  end

  it 'updates a webhook' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:patch, 'webhooks/webhook-id', events: [MessageBird::Conversation::WEBHOOK_EVENT_MESSAGE_CREATED], url: 'url')
      .and_return('{"id":"00000000000000000000000000000000", "events": ["message.created"]}')

    webhook = client.conversation_webhook_update('webhook-id', events: [MessageBird::Conversation::WEBHOOK_EVENT_MESSAGE_CREATED], url: 'url')

    expect(webhook.id).to eq '00000000000000000000000000000000'
    expect(webhook.events.count).to eq 1
  end

  it 'deletes a webhook' do
    conversation_client = double(MessageBird::ConversationClient)
    client = MessageBird::Client.new('', nil, conversation_client)

    expect(conversation_client)
      .to receive(:request)
      .with(:delete, 'webhooks/webhook-id', {})
      .and_return('')

    client.conversation_webhook_delete('webhook-id')
  end
end
