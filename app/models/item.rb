# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.find_by_name(name)
    Item.where('name ILIKE ?', "%#{name}%").order(Arel.sql('lower(name) DESC')).limit(1).first
  end

  # def self.find_by_price(min_price, max_price)
  #   max_price = default_max_price if max_price == nil
  #   min_price = 0 if min_price == nil
  #   Item.where('unit_price >= ?', min_price).where('unit_price <= ?', max_price).limit(1).first
  # end

  def self.find_all_by_name(name)
    Item.where('name ILIKE ?', "%#{name}%")
        # .or(Item.where('description ILIKE ?', "%#{name}%"))
        .order(Arel.sql('lower(name) DESC'))
  end

  def self.default_max_price
    Item.maximum(:unit_price)
  end

  def self.find_all_by_price(min_price, max_price)
    max_price = default_max_price if max_price.nil?
    min_price = 0 if min_price.nil?
    Item.where('unit_price >= ?', min_price).where('unit_price <= ?', max_price)
  end
end
