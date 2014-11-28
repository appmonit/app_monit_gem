module AppMonit
  class Query
    class << self
      %w(count count_unique list_unique minimum maximum average sum funnel).each do |method_name|
        define_method method_name do |collection_name, params|
          query(method_name, collection_name, params)
        end
      end

      def query(method_name, collection_name, params)
        require 'cgi'

        params[:event_collection] = collection_name

        query_string_parts = []

        query_string_parts << "api_key=#{params.delete(:api_key)}" if params[:api_key]
        query_string_parts << "environment=#{params.delete(:environment)}" if params[:environment]
        query_string_parts << "query=#{CGI.escape(params.to_json)}"

        query_string = query_string_parts.join('&')


        version  = params[:version] || Config.version
        path     = "/#{version}/queries/#{method_name}"
        response = Http.get("#{path}?#{query_string}")

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
