# frozen_string_literal: true

module Langchain::Tool
  class InventoryManagement < Base
    NAME = "inventory_management"
    ANNOTATIONS_PATH = Pathname.new("#{__dir__}/inventory_management.json").to_path

    def initialize
    end

    def update_inventory(sku:, quantity:)
      Langchain.logger.info("[ 📋 ] Updating Inventory for #{sku} with #{quantity} unit(s)", for: self.class)

      product = Product.find(sku: sku)
      product.quantity = quantity
      product.save
    end

    def find_product(sku:)
      Langchain.logger.info("[ 📋 ] Looking up Product SKU: #{sku}", for: self.class)

      product = Product.find(sku: sku)

      return "Product not found" if product.nil?

      product.to_hash
    end
  end
end
