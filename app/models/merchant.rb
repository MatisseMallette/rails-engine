class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.find_by_name(name)
    Merchant.where('name ILIKE ?', "%#{name}%").order(Arel.sql('lower(name) DESC')).limit(1).first
  end

  def self.find_all_by_name(name)
    Merchant.where('name ILIKE ?', "%#{name}%")
        # .or(Item.where('description ILIKE ?', "%#{name}%"))
        .order(Arel.sql('lower(name) DESC'))
  end
end
