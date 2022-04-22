# frozen_string_literal: true

describe 'CallFlow' do
  let(:voice_client) { double(MessageBird::VoiceClient) }
  let(:client) { MessageBird::Client.new('', nil, nil, voice_client) }
  let(:call_flow_id) { '7355a691-381d-42b0-a037-9df5dab19e8e' }
  let(:step_id) { 'dd33982b-2c51-4a38-8975-fb8725e57c5d' }
  let(:title) { '' }
  let(:record) { true }
  let(:default) { false }

  it 'creates a call flow' do
    steps = [
      {
        action: 'transfer',
        options: {
          destination: '31612345678'
        }
      }
    ]

    mock_data = {
      data: [
        {
          id: call_flow_id,
          title: title,
          steps: [
            {
              id: step_id,
              action: 'transfer',
              options: {
                destination: '31612345678'
              }
            }
          ],
          record: true,
          default: false,
          createdAt: '2019-11-07T12:37:59Z',
          updatedAt: '2019-11-07T12:37:59Z'
        }
      ]
    }
    expect(voice_client)
      .to receive(:request)
      .with(:post, 'call-flows', { steps: steps, default: default, record: record })
      .and_return(mock_data.to_json)

    call_flow = client.call_flow_create(steps, default, record)
    expect(call_flow.id).to eq call_flow_id
  end

  it 'lists call flows' do
    voice_client = double(MessageBird::VoiceClient)
    client = MessageBird::Client.new('', nil, nil, voice_client)

    mock_data = {
      data: [
        {
          id: 'cfid-0000',
          title: 'another title',
          steps: [
            {
              id: 'sf001',
              action: 'transfer',
              options: {
                destination: '31612345678'
              }
            }
          ],
          record: true,
          default: false,
          createdAt: '2019-11-07T12:37:59Z',
          updatedAt: '2019-11-07T12:37:59Z'
        },
        {
          id: 'cfid-0001',
          title: 'the title',
          steps: [
            {
              id: 's000000000',
              action: 'transfer',
              options: {
                destination: '31612345678'
              }
            }
          ],
          record: true,
          default: false,
          createdAt: '2019-11-07T12:37:59Z',
          updatedAt: '2019-11-07T12:37:59Z'
        }
      ],
      perPage: 2,
      currentPage: 1,
      totalCount: 111
    }

    expect(voice_client)
      .to receive(:request)
      .with(:get, 'call-flows?perPage=2&page=1', {})
      .and_return(mock_data.to_json)

    list = client.call_flow_list(2, 1)

    expect(list.items.count).to eq 2
    expect(list.items[0].id).to eq 'cfid-0000'
    expect(list.per_page).to eq 2
    expect(list.current_page).to eq 1
    expect(list.total_count).to eq 111
  end

  it 'view a call flow' do
    voice_client = double(MessageBird::VoiceClient)
    client = MessageBird::Client.new('', nil, nil, voice_client)

    mock_data = {
      data: [
        {
          id: 'cfid-1',
          title: 'the title',
          steps: [
            {
              id: 'sfid-1',
              action: 'transfer',
              options: {
                destination: '31612345678'
              }
            }
          ],
          record: true,
          default: false,
          createdAt: '2019-11-07T12:37:59Z',
          updatedAt: '2019-11-07T12:37:59Z'
        }
      ]
    }

    expect(voice_client)
      .to receive(:request)
      .with(:get, 'call-flows/cfid-1', {})
      .and_return(mock_data.to_json)
    call_flow = client.call_flow_view('cfid-1')
    expect(call_flow.id).to eq 'cfid-1'
  end

  it 'delete a call flow' do
    voice_client = double(MessageBird::VoiceClient)
    client = MessageBird::Client.new('', nil, nil, voice_client)

    expect(voice_client)
      .to receive(:request)
      .with(:delete, 'call-flows/cfid-1', {})
      .and_return('')
    client.call_flow_delete('cfid-1')
  end
end
