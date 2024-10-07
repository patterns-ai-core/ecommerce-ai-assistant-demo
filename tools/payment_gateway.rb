# frozen_string_literal: true

class PaymentGateway
  extend Langchain::ToolDefinition

  define_function :charge_customer, description: "Payment Gateway Service: Charge customer for a specific amount" do
    property :customer_id, type: "string", description: "Customer ID", required: true
    property :amount, type: "number", description: "Amount (USD) to charge, e.g.: 156.24", required: true
  end

  define_function :refund_customer, description: "Payment Gateway Service: Refund customer for a specific amount" do
    property :customer_id, type: "string", description: "Customer ID", required: true
    property :amount, type: "number", description: "Amount (USD) to refund, e.g.: 156.24", required: true
  end

  define_function :issue_store_credit, description: "Payment Gateway Service: Issue store credit" do
    property :customer_id, type: "string", description: "Customer ID", required: true
    property :amount, type: "number", description: "Amount (USD) to issue as store credit for", required: true
  end

  def charge_customer(customer_id:, amount:)
    Langchain.logger.info("[ 💰 ] Charging customer ID: #{customer_id} for #{amount} USD") 

    {success: true, transaction_id: SecureRandom.uuid, amount: amount, customer_id: customer_id, transaction_type: "charge", transaction_date: Time.now}
  end

  def refund_customer(customer_id:, amount:)
    Langchain.logger.info("[ 💰 ] Refunding customer ID: #{customer_id} for #{amount} USD")

    {success: true, transaction_id: SecureRandom.uuid, amount: amount, customer_id: customer_id, transaction_type: "refund", transaction_date: Time.now}
  end

  def issue_store_credit(customer_id:, amount:)
    Langchain.logger.info("[ 💰 ] Issuing store credit to customer ID: #{customer_id} for #{amount} USD")

    {success: true, transaction_id: SecureRandom.uuid, amount: amount, customer_id: customer_id, transaction_type: "store_credit", transaction_date: Time.now}
  end
end