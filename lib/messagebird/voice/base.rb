module MessageBird
    module Voice
      class Base < MessageBird::Base
        def initialize(json)
          self._links=(json['_links'])
          
          params = json.include?("data") ? json["data"].first : json
          super(params)
        end

        # intentional empty method, objects may not want to deal with _links
        def _links=(json)
        end
      end
    end
  end
    