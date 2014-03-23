module AppmonitClient
  class Query
    class << self
      %w(count count_unique minimum maximum average sum funnel).each do |method_name|
        define_method method_name do |collection_name, params|
          query(method_name, collection_name, params)
        end
      end

      def query(method_name, collection_name, params)
        require 'cgi'
        path = "/v1/queries/#{method_name}"

        params[:event_collection] = collection_name

        response = Http.get("#{path}?query=#{CGI.escape(params.to_json)}")

        case response.code.to_i
          when 200
            JSON.parse(response.body)
          else
            nil
        end
      end
    end
  end
end
