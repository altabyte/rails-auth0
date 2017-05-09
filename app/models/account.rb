# Account model.
#
class Account < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def name=(name)
    name = sanitize(name).squish
    name = nil if name.blank?
    self[:name] = name
  end
end
