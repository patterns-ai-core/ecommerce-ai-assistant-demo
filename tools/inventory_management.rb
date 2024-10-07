# frozen_string_literal: true

class InventoryManagement
  extend Langchain::ToolDefinition

  define_function :update_inventory, description: "Inventory Management Service: Update inventory with new quantity for specific product" do
    property :sku, type: "string", description: "Product SKU number", required: true
    property :quantity, type: "number", description: "New quantity to set", required: true
  end

  define_function :find_product, description: "Inventory Management Service: Look up a product by SKU" do
    property :sku, type: "string", description: "Product SKU number", required: true
  end

  def initialize
  end

  def update_inventory(sku:, quantity:)
    Langchain.logger.info("[ 📋 ] Updating Inventory for #{sku} with #{quantity} unit(s)")

    product = Product.find(sku: sku)
    product.quantity = quantity
    product.save
  end

  def find_product(sku:)
    Langchain.logger.info("[ 📋 ] Looking up Product SKU: #{sku}")

    product = Product.find(sku: sku)

    return "Product not found" if product.nil?

    product.to_hash
  end
end