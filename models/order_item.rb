# frozen_string_literal: true

class OrderItem < Sequel::Model
  many_to_one :order
  many_to_one :product, key: :sku, primary_key: :sku
end