# frozen_string_literal: true

require "mainstreet"

module Langchain::Tool
  class ShippingService < Base
    NAME = "shipping_service"
    ANNOTATIONS_PATH = Pathname.new("#{__dir__}/shipping_service.json").to_path

    def validate_address(address:)
      Langchain.logger.info("[ 🚚 ] Validating address: #{address}", for: self.class)

      verifier = MainStreet::AddressVerifier.new(address)
      verifier.success? ? true : verifier.failure_message
    end

    def create_shipping_label(customer_id:, address:, provider:)
      Langchain.logger.info("[ 🚚 ] Creating shipping label for customer ID: #{customer_id}", for: self.class)

      validate_address(address: address)

      return "Invalid provider" unless ["ups", "fedex", "usps", "dhl"].include?(provider)

      {success: true, tracking_number: SecureRandom.uuid, provider: provider}
    end

    def create_return_label(customer_id:, address:, provider:)
      Langchain.logger.info("[ 🚚 ] Creating return shipping label for customer ID: #{customer_id}", for: self.class)

      validate_address(address)

      return "Invalid provider" unless ["ups", "fedex", "usps", "dhl"].include?(provider)

      {success: true, tracking_number: SecureRandom.uuid, provider: provider}
    end
  end
end
