# frozen_string_literal: true

module Langchain::Tool
  class OrderManagement < Base
    NAME = "order_management"
    ANNOTATIONS_PATH = Pathname.new("#{__dir__}/order_management.json").to_path

    def initialize
    end

    def create_order(customer_id:, order_items: [])
      Langchain.logger.info("[ 📦 ] Creating Order record for customer ID: #{customer_id}", for: self.class)

      return "Order items cannot be empty" if order_items.empty?

      order = Order.create(customer_id: customer_id, created_at: Time.now)

      order_items.each do |item|
        OrderItem.create(order_id: order.id, product_sku: item[:product_sku], quantity: item[:quantity])
      end

      { success: true, order_id: order.id }
    end

    def mark_as_refunded(order_id:)
      Langchain.logger.info("[ 📦 ] Refunding order ID: #{order_id}", for: self.class)

      order = Order.find(id: order_id)

      return "Order not found" if order.nil?

      { success: !!order.destroy }
    end

    def find_order(order_id:)
      Langchain.logger.info("[ 📦 ] Looking up Order record for ID: #{order_id}", for: self.class)

      order = Order.find(id: order_id)

      return "Order not found" if order.nil?

      order.to_hash
    end
  end
end