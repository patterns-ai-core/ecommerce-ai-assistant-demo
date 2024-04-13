# frozen_string_literal: true

module Langchain::Tool
  class PaymentGateway < Base
    NAME = "payment_gateway"
    ANNOTATIONS_PATH = Pathname.new("#{__dir__}/payment_gateway.json").to_path

    def charge_customer(customer_id:, amount:)
      Langchain.logger.info("[ 💰 ] Charging customer ID: #{customer_id} for #{amount} USD", for: self.class) 

      {success: true, transaction_id: SecureRandom.uuid, amount: amount, customer_id: customer_id, transaction_type: "charge", transaction_date: Time.now}
    end

    def refund_customer(customer_id:, amount:)
      Langchain.logger.info("[ 💰 ] Refunding customer ID: #{customer_id} for #{amount} USD", for: self.class)

      {success: true, transaction_id: SecureRandom.uuid, amount: amount, customer_id: customer_id, transaction_type: "refund", transaction_date: Time.now}
    end

    def issue_store_credit(customer_id:, amount:)
      Langchain.logger.info("[ 💰 ] Issuing store credit to customer ID: #{customer_id} for #{amount} USD", for: self.class)

      {success: true, transaction_id: SecureRandom.uuid, amount: amount, customer_id: customer_id, transaction_type: "store_credit", transaction_date: Time.now}
    end
  end
end
