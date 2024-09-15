# frozen_string_literal: true

class Customer < Sequel::Model
  one_to_many :orders

  def validate
    super
    errors.add(:name, "can't be empty") if name.empty?
    errors.add(:email, "can't be empty") if email.empty?
  end
end