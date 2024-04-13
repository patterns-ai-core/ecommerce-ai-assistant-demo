# frozen_string_literal: true

module Langchain::Tool
  class CustomerManagement < Base
    NAME = "customer_management"
    ANNOTATIONS_PATH = Pathname.new("#{__dir__}/customer_management.json").to_path

    def initialize
    end

    def create_customer(name:, email:)
      Langchain.logger.info("[ 👤 ] Creating Customer record for #{email}", for: self.class)

      customer = Customer.create(name: name, email: email)

      { success: true, customer_id: customer.id }
    end

    def find_customer(email:)
      Langchain.logger.info("[ 👤 ] Looking up Customer record for #{email}", for: self.class)

      customer = Customer.find(email: email)

      return "Customer not found" if customer.nil?

      customer.to_hash
    end
  end
end
