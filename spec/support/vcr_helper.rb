require 'vcr'

class PrettyJsonSerializer
  def file_extension; "json"; end
  # Replace response body string with formatted JSON when dumping request to a cassette, and
  def serialize(hash)
    interactions_hash = hash.dup.tap do |request_hash|
      request_hash['http_interactions'] = request_hash['http_interactions'].map do |interaction|
        response_body_json = JSON.parse(interaction['response']['body']['string'])
        request_body_json = begin
                              JSON.parse(interaction['request']['body']['string'])
                            rescue JSON::ParserError
                              {}
                            end

        response_body = interaction['response']['body'].without('string').merge({ 'json' => response_body_json })
        request_body = interaction['request']['body'].without('string').merge({ 'json' => request_body_json })

        response = interaction['response'].merge({ 'body' => response_body })
        request = interaction['request'].merge({ 'body' => request_body })

        interaction.merge({ 'response' => response, 'request' => request })
      end
    end

    JSON.pretty_generate interactions_hash
  end
  # Return JSON string to the response body when deserializing request from cassette.
  def deserialize(string)
    JSON.parse(string).tap do |request_hash|
      request_hash['http_interactions'] = request_hash['http_interactions'].map do |interaction|
        response_body_string = JSON.generate(interaction['response']['body']['json'])
        request_body_string = JSON.generate(interaction['request']['body']['json'] )

        response_body = { 'string' => response_body_string }.merge(interaction['response']['body'].without('json'))
        request_body = { 'string' => request_body_string }.merge(interaction['request']['body'].without('json'))

        response = interaction['response'].merge({ 'body' => response_body })
        request = interaction['request'].merge({ 'body' => request_body })

        interaction.merge({ 'response' => response, 'request' => request })
      end
    end
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.cassette_serializers[:pretty_json] = PrettyJsonSerializer.new
  config.filter_sensitive_data('<REDCARD_AUTH_TOKEN>') { Redcard::AUTH_TOKEN }
  config.default_cassette_options = {
    serialize_with: :pretty_json,
    match_requests_on: [:method, :uri]
  }
  config.register_request_matcher :body_or_json do |request, cassete_request|
    begin
      # Case when GET or DELETE request it may have return "{}" or ""
      ((request.method == :get && cassete_request.method == :get) || (request.method == :delete && cassete_request.method == :delete)) &&
      ((request.body.empty? || JSON.parse(request.body).empty?) && (cassete_request.body.empty? || JSON.parse(cassete_request.body).empty?)) ||
      (JSON.parse(request.body) == JSON.parse(cassete_request.body))
    rescue JSON::ParserError
      request.body == cassete_request.body
    end
  end
end
