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


end
