# frozen_string_literal: true

class Product < Sequel::Model
  unrestrict_primary_key

  one_to_many :order_items, key: :product_sku

  def validate
    super
    errors.add(:price, "can't be empty") if price.nil?
    errors.add(:quantity, "can't be empty") if quantity.nil?
  end
end