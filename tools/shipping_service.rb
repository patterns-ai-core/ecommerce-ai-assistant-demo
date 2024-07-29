# frozen_string_literal: true

class ShippingService
  extend Langchain::ToolDefinition

  define_function :create_shipping_label, description: "Shipping Service: Create a shipping label for a given customer name, address and shipping provider" do
    property :customer_id, type: "string", description: "Customer ID", required: true
    property :address, type: "string", description: "Full inline address string", required: true
    property :provider, type: "string", enum: ["usps", "ups", "fedex", "dhl"], required: true
  end

  define_function :create_return_label, description: "Shipping Service: Create a return label from a given customer name, address and shipping provider" do
    property :customer_id, type: "string", description: "Customer ID", required: true
    property :address, type: "string", description: "Full inline address string", required: true
    property :provider, type: "string", enum: ["usps", "ups", "fedex", "dhl"], required: true
  end

  def create_shipping_label(customer_id:, address:, provider:)
    Langchain.logger.info("[ 🚚 ] Creating shipping label for customer ID: #{customer_id}", for: self.class)

    return "Invalid provider" unless ["ups", "fedex", "usps", "dhl"].include?(provider)

    {success: true, tracking_number: SecureRandom.uuid, provider: provider}
  end

  def create_return_label(customer_id:, address:, provider:)
    Langchain.logger.info("[ 🚚 ] Creating return shipping label for customer ID: #{customer_id}", for: self.class)

    return "Invalid provider" unless ["ups", "fedex", "usps", "dhl"].include?(provider)

    {success: true, tracking_number: SecureRandom.uuid, provider: provider}
  end
end
