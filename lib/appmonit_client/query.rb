module AppmonitClient
  class Query
    class << self
      %w(count count_unique minimum maximum average sum funnel).each do |method_name|
        define_method method_name do |collection_name, params|
          path = "/v1/queries/#{method_name}"

          params[:event_collection] = collection_name

          Http.get(path, params)
        end
      end
    end
  end
end
