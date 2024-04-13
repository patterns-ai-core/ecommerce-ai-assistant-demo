require "dotenv/load"
require "openai"
require "langchain"
require "sequel"
require "mail"
require "pry-byebug"

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
require_relative "./tools/inventory_management/inventory_management"
require_relative "./tools/payment_gateway/payment_gateway"
require_relative "./tools/shipping_service/shipping_service"
require_relative "./tools/order_management/order_management"
require_relative "./tools/customer_management/customer_management"
require_relative "./tools/email_service/email_service"

require "irb"
IRB.start(__FILE__)
