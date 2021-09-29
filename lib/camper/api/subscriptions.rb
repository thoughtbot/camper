# frozen_string_literal: true

module Camper
  class Client
    # Defines methods related to comments.
    # @see https://github.com/basecamp/bc3-api/blob/master/sections/subscriptions.md
    module SubscriptionsAPI
      # Get a subscription of a resource
      #
      # @example
      #   client.subscription(todo)
      # @example
      #   client.subscription(my_message)
      #
      # @param resource [Resource] resource to get the subscription for
      # @param comment_id [Integer|String] id of comment ot retrieve
      # @return [Resource]
      # @raise [Error::ResourceHasNoSubscriptions] if the resource doesn't support comments
      # @see https://github.com/basecamp/bc3-api/blob/master/sections/subscriptions.md#get-subscription
      def subscription(resource)
        raise Error::ResourceHasNoSubscriptions, resource unless resource.has_subscription?

        bucket_id = resource.bucket.id

        get(resource.subscription_url, override_path: true)
      end
    end
  end
end
