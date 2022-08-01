class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: [:manager, :developer, :qa]


  validates :name, :email, :user_type, presence: true
  validates :name, length: {minimum:3, maximum:12}

  has_many :user_projects
  has_many :projects, through: :user_projects


end
