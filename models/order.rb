class Order < Sequel::Model
  many_to_one :customer
  one_to_many :order_items
end