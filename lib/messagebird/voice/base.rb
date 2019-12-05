module MessageBird
  module Voice
    class Base < MessageBird::Base
      def initialize(json)
        params = json.include?('data') ? json['data'].first : json
        super(params)
        handle_links(json['_links'])
      end

      # intentional empty method, objects may not want to deal with _links
      def handle_links(json) end
    end
  end
end
