class Project < ApplicationRecord

  validates :name, :description, presence: true

  has_many :bugs, dependent: :destroy

  has_many :user_projects
  has_many :users, through: :user_projects
end
