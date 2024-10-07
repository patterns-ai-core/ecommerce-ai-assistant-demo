# frozen_string_literal: true

require "bundler/setup"
Bundler.require
require "dotenv/load"

Langchain.logger.level = Logger::DEBUG

Mail.defaults do
  delivery_method :sendmail
end

Sequel::Model.db = Sequel.sqlite(ENV["DATABASE_NAME"])

# Require all the models
require_relative "./models/product"
require_relative "./models/order"
require_relative "./models/order_item"
require_relative "./models/customer"

# Require all the tools
require_relative "./tools/inventory_management"
require_relative "./tools/payment_gateway"
require_relative "./tools/shipping_service"
require_relative "./tools/order_management"
require_relative "./tools/customer_management"
require_relative "./tools/email_service"

require_relative "./controllers/main_controller"
