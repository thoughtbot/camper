module Camper
  class Resource

    Dir[File.expand_path('resources/*.rb', __dir__)].each { |f| require f }

    # Creates a new Resource object.
    def initialize(hash)
      @hash = hash
      @data = resourcify_data
    end

    # @return [Hash] The original hash.
    def to_hash
      hash
    end
    alias to_h to_hash

    # @return [String] Formatted string with the class name, object id and original hash.
    def inspect
      "#<#{self.class}:#{object_id} {hash: #{hash.inspect}}"
    end

    def [](key)
      data[key]
    end

    # Check whether a resource can be commented on or not
    # given the presences of `comments_count` and `comments_url` keys
    #
    # @return [Boolean]
    def can_be_commented?
      hash.key?('comments_url') && hash.key?('comments_count')
    end

    # Check whether a resource can be subscribed to or not
    # given the presence of `subscription_url` keys
    #
    # @return [Boolean]
    def has_subscription?
      hash.key?('subscription_url')
    end


    def self.create(hash)
      klass = detect_type(hash["url"])

      return klass.new(hash)
    end

    private

    attr_reader :hash, :data

    def resourcify_data
      @hash.each_with_object({}) do |(key, value), data|
        value = resourcify_value(value)

        data[key.to_s] = value
      end
    end

    def resourcify_value(input)
      return Resource.new(input) if input.is_a? Hash

      return input unless input.is_a? Array

      input.map { |curr| resourcify_value(curr) }
    end

    # Respond to messages for which `self.data` has a key
    def method_missing(method_name, *args, &block)
      @data.key?(method_name.to_s) ? @data[method_name.to_s] : super
    end

    def respond_to_missing?(method_name, include_private = false)
      @hash.keys.map(&:to_sym).include?(method_name.to_sym) || super
    end

    def self.detect_type(url)
      case url
      when /#{Configuration.base_api_endpoint}\/\d+\/projects\/\d+\.json/
        return Project
      else
        return Resource
      end
    end

    private_class_method :detect_type
  end
end
