# frozen_string_literal: true

require 'json'
require 'net/https'
require 'uri'

require 'messagebird/balance'
require 'messagebird/contact'
require 'messagebird/conversation'
require 'messagebird/conversation_client'
require 'messagebird/conversation_message'
require 'messagebird/conversation_webhook'
require 'messagebird/error'
require 'messagebird/group'
require 'messagebird/hlr'
require 'messagebird/http_client'
require 'messagebird/list'
require 'messagebird/lookup'
require 'messagebird/message'
require 'messagebird/number'
require 'messagebird/number_client'
require 'messagebird/verify'
require 'messagebird/voice/client'
require 'messagebird/voice/list'
require 'messagebird/voice/webhook'
require 'messagebird/voicemessage'
require 'messagebird/voice_client'
require 'messagebird/voice/call'
require 'messagebird/voice/call_leg'
require 'messagebird/voice/call_leg_recording'
require 'messagebird/voice/transcription'
require 'messagebird/voice/list'

module MessageBird
  class ErrorException < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end
  end

  class InvalidFeatureException < StandardError
  end

  class Client
    attr_reader :access_key, :http_client, :conversation_client, :voice_client

    CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE = 'CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE' # Enables the whatsapp sandbox
    VALID_FEATURES = [CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE].freeze # List of valid features for validation

    def initialize(access_key = nil, http_client = nil, conversation_client = nil, voice_client = nil)
      @access_key = access_key || ENV['MESSAGEBIRD_ACCESS_KEY']
      @http_client = http_client || HttpClient.new(@access_key)
      @conversation_client = conversation_client || ConversationClient.new(@access_key)
      @number_client = http_client || NumberClient.new(@access_key)
      @voice_client = voice_client || VoiceClient.new(@access_key)
    end

    def enable_feature(feature)
      if VALID_FEATURES.include? feature
        @conversation_client.enable_feature(feature)
      else
        raise InvalidFeatureException
      end
    end

    def disable_feature(feature)
      if VALID_FEATURES.include? feature
        @conversation_client.disable_feature(feature)
      else
        raise InvalidFeatureException
      end
    end

    def conversation_request(method, path, params = {})
      response_body = @conversation_client.request(method, path, params)
      return if response_body.nil? || response_body.empty?

      parse_body(response_body)
    end

    def number_request(method, path, params = {})
      response_body = @number_client.request(method, path, params)
      return if response_body.nil? || response_body.empty?

      parse_body(response_body)
    end

    def voice_request(method, path, params = {})
      response_body = @voice_client.request(method, path, params)
      return if response_body.nil? || response_body.empty?

      parse_body(response_body)
    end

    def request(method, path, params = {})
      response_body = @http_client.request(method, path, params)
      return if response_body.empty?

      parse_body(response_body)
    end

    def parse_body(body)
      json = JSON.parse(body)

      # If the request returned errors, create Error objects and raise.
      if json.key?('errors')
        raise(ErrorException, json['errors'].map { |e| Error.new(e) })
      end

      json
    end

    ## Conversations
    # Send a conversation message
    def send_conversation_message(from, to, params = {})
      ConversationMessage.new(conversation_request(
                                :post,
                                'send',
                                params.merge(from: from,
                                             to: to)
      ))
    end

    # Start a conversation
    def start_conversation(to, channel_id, params = {})
      Conversation.new(conversation_request(
                         :post,
                         'conversations/start',
                         params.merge(to: to,
                                      channel_id: channel_id)
      ))
    end

    def conversation_list(limit = 0, offset = 0)
      List.new(Conversation, conversation_request(:get, "conversations?limit=#{limit}&offset=#{offset}"))
    end

    def conversation(id)
      Conversation.new(conversation_request(:get, "conversations/#{id}"))
    end

    def conversation_update(id, status)
      Conversation.new(conversation_request(:patch, "conversations/#{id}", status: status))
    end

    def conversation_reply(id, params = {})
      ConversationMessage.new(conversation_request(:post, "conversations/#{id}/messages", params))
    end

    def conversation_messages_list(id, limit = 0, offset = 0)
      List.new(ConversationMessage, conversation_request(:get, "conversations/#{id}/messages?limit=#{limit}&offset=#{offset}"))
    end

    def conversation_message(id)
      ConversationMessage.new(conversation_request(:get, "messages/#{id}"))
    end

    def conversation_webhook_create(channel_id, url, events = [])
      ConversationWebhook.new(conversation_request(
                                :post,
                                'webhooks',
                                channel_id: channel_id,
                                url: url,
                                events: events
      ))
    end

    def conversation_webhooks_list(limit = 0, offset = 0)
      List.new(ConversationWebhook, conversation_request(:get, "webhooks?limit=#{limit}&offset=#{offset}"))
    end

    def conversation_webhook_update(id, params = {})
      ConversationWebhook.new(conversation_request(:patch, "webhooks/#{id}", params))
    end

    def conversation_webhook(id)
      ConversationWebhook.new(conversation_request(:get, "webhooks/#{id}"))
    end

    def conversation_webhook_delete(id)
      conversation_request(:delete, "webhooks/#{id}")
    end

    # Retrieve your balance.
    def balance
      Balance.new(request(:get, 'balance'))
    end

    # Retrieve the information of specific HLR.
    def hlr(id)
      HLR.new(request(:get, "hlr/#{id}"))
    end

    # Create a new HLR.
    def hlr_create(msisdn, reference)
      HLR.new(request(
                :post,
                'hlr',
                msisdn: msisdn,
                reference: reference
      ))
    end

    # Retrieve the information of specific Verify.
    def verify(id)
      Verify.new(request(:get, "verify/#{id}"))
    end

    # Generate a new One-Time-Password message.
    def verify_create(recipient, params = {})
      Verify.new(request(
                   :post,
                   'verify',
                   params.merge(recipient: recipient)
      ))
    end

    # Verify the One-Time-Password.
    def verify_token(id, token)
      Verify.new(request(:get, "verify/#{id}?token=#{token}"))
    end

    # Delete a Verify
    def verify_delete(id)
      Verify.new(request(:delete, "verify/#{id}"))
    end

    # Retrieve the information of specific message.
    def message(id)
      Message.new(request(:get, "messages/#{id}"))
    end

    # Retrieve messages with optional paging and status filter.
    def message_list(filter = {})
      limit = filter[:limit] || 10
      offset = filter[:offset] || 0
      status = filter[:status] || ''

      params = { limit: limit, offset: offset }
      if status != ''
        params['status'] = status
      end
      query = 'messages?' + URI.encode_www_form(params)
      List.new(Message, request(:get, query))
    end

    # Create a new message.
    def message_create(originator, recipients, body, params = {})
      # Convert an array of recipients to a comma-separated string.
      recipients = recipients.join(',') if recipients.is_a?(Array)

      Message.new(request(
                    :post,
                    'messages',
                    params.merge(originator: originator.to_s,
                                 body: body.to_s,
                                 recipients: recipients)
      ))
    end

    # Retrieve the information of a specific voice message.
    def voice_message(id)
      VoiceMessage.new(request(:get, "voicemessages/#{id}"))
    end

    # Create a new voice message.
    def voice_message_create(recipients, body, params = {})
      # Convert an array of recipients to a comma-separated string.
      recipients = recipients.join(',') if recipients.is_a?(Array)

      VoiceMessage.new(request(
                         :post,
                         'voicemessages',
                         params.merge(recipients: recipients, body: body.to_s)
      ))
    end

    def voice_webhook_create(url, params = {})
      Voice::Webhook.new(voice_request(:post, 'webhooks', params.merge(url: url)))
    end

    def voice_webhooks_list(per_page = VoiceList::PER_PAGE, page = VoiceList::CURRENT_PAGE)
      Voice::List.new(Voice::Webhook, voice_request(:get, "webhooks?perPage=#{per_page}&page=#{page}"))
    end

    def voice_webhook_update(id, params = {})
      Voice::Webhook.new(voice_request(:put, "webhooks/#{id}", params))
    end

    def voice_webhook(id)
      Voice::Webhook.new(voice_request(:get, "webhooks/#{id}"))
    end

    def voice_webhook_delete(id)
      voice_request(:delete, "webhooks/#{id}")
    end

    def call_create(source, destination, call_flow = {}, webhook = {}, params = {})
      params = params.merge(callFlow: call_flow.to_json) unless call_flow.empty?
      params = params.merge(webhook: webhook.to_json) unless webhook.empty?

      Voice::Call.new(voice_request(:post, 'calls', params.merge(source: source, destination: destination)))
    end

    def call_list(per_page = Voice::List::PER_PAGE, page = Voice::List::CURRENT_PAGE)
      Voice::List.new(Voice::Call, voice_request(:get, "calls?perPage=#{per_page}&currentPage=#{page}"))
    end

    def call_view(id)
      Voice::Call.new(voice_request(:get, "calls/#{id}"))
    end

    def call_delete(id)
      voice_request(:delete, "calls/#{id}")
    end

    def call_leg_list(call_id, per_page = Voice::List::PER_PAGE, current_page = Voice::List::CURRENT_PAGE)
      Voice::List.new(Voice::CallLeg, voice_request(:get, "calls/#{call_id}/legs?perPage=#{per_page}&currentPage=#{current_page}"))
    end

    def call_leg_recording_view(call_id, leg_id, recording_id)
      Voice::CallLegRecording.new(voice_request(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}"))
    end

    def call_leg_recording_list(call_id, leg_id)
      Voice::List.new(Voice::CallLegRecording, voice_request(:get, "calls/#{call_id}/legs/#{leg_id}/recordings"))
    end

    def call_leg_recording_delete(call_id, leg_id, recording_id)
      voice_request(:delete, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}")
    end

    def call_leg_recording_download(recording_uri)
      @voice_client.request_block(:get, recording_uri, {}, &Proc.new)
    end

    def voice_transcription_create(call_id, leg_id, recording_id, params = {})
      Voice::Transcription.new(voice_request(:post, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions", params))
    end

    def voice_transcriptions_list(call_id, leg_id, recording_id)
      Voice::List.new(Voice::Transcription, voice_request(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions"))
    end

    def voice_transcription_download(call_id, leg_id, recording_id, transcription_id)
      @voice_client.request_block(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions/#{transcription_id}.txt", {}, &Proc.new)
    end

    def voice_transcription_view(call_id, leg_id, recording_id, transcription_id)
      Voice::Transcription.new(voice_request(:get, "calls/#{call_id}/legs/#{leg_id}/recordings/#{recording_id}/transcriptions/#{transcription_id}"))
    end

    def lookup(phone_number, params = {})
      Lookup.new(request(:get, "lookup/#{phone_number}", params))
    end

    def lookup_hlr_create(phone_number, params = {})
      HLR.new(request(:post, "lookup/#{phone_number}/hlr", params))
    end

    def lookup_hlr(phone_number, params = {})
      HLR.new(request(:get, "lookup/#{phone_number}/hlr", params))
    end

    def contact_create(phone_number, params = {})
      Contact.new(request(
                    :post,
                    'contacts',
                    params.merge(msisdn: phone_number.to_s)
      ))
    end

    def contact(id)
      Contact.new(request(:get, "contacts/#{id}"))
    end

    def contact_delete(id)
      request(:delete, "contacts/#{id}")
    end

    def contact_update(id, params = {})
      request(:patch, "contacts/#{id}", params)
    end

    def contact_list(limit = 0, offset = 0)
      List.new(Contact, request(:get, "contacts?limit=#{limit}&offset=#{offset}"))
    end

    def group(id)
      Group.new(request(:get, "groups/#{id}"))
    end

    def group_create(name)
      Group.new(request(:post, 'groups', name: name))
    end

    def group_delete(id)
      request(:delete, "groups/#{id}")
    end

    def group_list(limit = 0, offset = 0)
      List.new(Group, request(:get, "groups?limit=#{limit}&offset=#{offset}"))
    end

    def group_update(id, name)
      request(:patch, "groups/#{id}", name: name)
    end

    def group_add_contacts(group_id, contact_ids)
      # We expect an array, but we can handle a string ID as well...
      contact_ids = [contact_ids] if contact_ids.is_a? String

      query = add_contacts_query(contact_ids)

      request(:get, "groups/#{group_id}?#{query}")
    end

    def group_delete_contact(group_id, contact_id)
      request(:delete, "groups/#{group_id}/contacts/#{contact_id}")
    end

    ## Numbers API
    # Search for available numbers
    def number_search(country_code, params = {})
      List.new(Number, number_request(:get, add_querystring("available-phone-numbers/#{country_code}", params), params))
    end

    # Purchase an avaiable number
    def number_purchase(number, country_code, billing_interval_months)
      params = {
        number: number,
        countryCode: country_code,
        billingIntervalMonths: billing_interval_months
      }
      Number.new(number_request(:post, 'phone-numbers', params))
    end

    # Fetch all purchaed numbers' details
    def number_fetch_all(params = {})
      List.new(Number, number_request(:get, add_querystring('phone-numbers', params), params))
    end

    # Fetch specific purchased number's details
    def number_fetch(number)
      Number.new(number_request(:get, "phone-numbers/#{number}"))
    end

    # Update a number
    def number_update(number, tags)
      tags = [tags] if tags.is_a? String
      Number.new(number_request(:patch, "phone-numbers/#{number}", tags: tags))
    end

    # Cancel a number
    def number_cancel(number)
      number_request(:delete, "phone-numbers/#{number}")
    end

    def call_flow_create(title, steps, default, record, params = {})
      params = params.merge(
        title: title,
        steps: steps,
        default: default,
        record: record
      )
      CallFlow.new(voice_request(:post, 'call-flows', params))
    end

    def call_flow_view(id)
      CallFlow.new(voice_request(:get, "call-flows/#{id}"))
    end

    def call_flow_list(per_page = CallFlowList::PER_PAGE, page = CallFlowList::CURRENT_PAGE)
      CallFlowList.new(CallFlow, voice_request(:get, "call-flows?perPage=#{per_page}&page=#{page}"))
    end

    def call_flow_delete(id)
      voice_request(:delete, "call-flows/#{id}")
    end

    private # Applies to every method below this line

    # Applies to every method below this line
    def add_contacts_query(contact_ids)
      # add_contacts_query gets a query string to add contacts to a group.
      # We're using the alternative "/foo?_method=PUT&key=value" format to send
      # the contact IDs as GET params. Sending these in the request body would
      # require a painful workaround, as the client sends request bodies as
      # JSON by default. See also:
      # https://developers.messagebird.com/docs/alternatives.

      '_method=PUT&' + contact_ids.map { |id| "ids[]=#{id}" }.join('&')
    end

    def add_querystring(path, params)
      return path if params.empty?

      "#{path}?" + params.collect { |k, v| v.is_a?(Array) ? v.collect { |sv| "#{k}=#{sv}" }.join('&') : "#{k}=#{v}" }.join('&')
    end
  end
end
