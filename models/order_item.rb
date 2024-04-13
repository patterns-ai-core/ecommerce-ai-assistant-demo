class OrderItem < Sequel::Model
  many_to_one :order
  many_to_one :product, key: :product_sku, primary_key: :sku
end