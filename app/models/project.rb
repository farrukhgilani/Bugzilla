class Project < ApplicationRecord

  validates :name, :description, presence: true
  validates :name, length: {minimum:5, maximum:40}
  validates :description, length: {minimum:30}

  has_many :bugs, dependent: :destroy

  has_many :user_projects
  has_many :users, through: :user_projects
end
