class Campaign < ActiveRecord::Base
  attr_accessible :name, :budget, :platform_ids

  has_and_belongs_to_many :platforms

  validates :name, presence: true
  validates :budget, numericality: { greater_than: 0 }
  validates :platforms, presence: true
  validates :platform_ids, presence: true
  validates_associated :platforms


end
