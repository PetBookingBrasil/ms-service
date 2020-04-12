class ServiceCategory < ApplicationRecord
  validates :uuid, :name, :slug, :system_code, presence: true
  validates :uuid, :slug, :system_code, uniqueness: true
  has_closure_tree

  def to_s
    "{id: '#{id}'}"#", uuid: uuid}
  end
end
