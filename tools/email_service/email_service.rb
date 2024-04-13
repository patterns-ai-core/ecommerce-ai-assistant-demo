module Langchain::Tool
  class EmailService < Base
    NAME = "email_service"
    ANNOTATIONS_PATH = Pathname.new("#{__dir__}/email_service.json").to_path

    def initialize
    end

    def send_email(
      customer_id:,
      order_id:
    )
      Langchain.logger.info("[ 📧 ] Sending an email notification to Customer ID: #{customer_id}", for: self.class)

      customer = Customer.find(id: customer_id)
      return "Customer not found" if customer.nil?

      order = Order.find(id: order_id)
      return "Order not found" if order.nil?

      Mail.deliver do
        from     "do-not-reply@nerds-and-threads.com"
        to       customer.email
        subject  "Order Confirmation: #{order.id}"
        body     <<-BODY
          Dear #{customer.name},

          Your order has been confirmed. Order ID: #{order.id}

          Order details:
          #{order.order_items.map { |item| "#{item.product.sku} x#{item.quantity}" }.join("\n")}

          Thank you for shopping with us!
          — Nerds & Threads
        BODY
        self.charset = "UTF-8"
      end
    end
  end
end