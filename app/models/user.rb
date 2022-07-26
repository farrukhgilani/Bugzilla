class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum type: {Manager: 1,Developer: 2, QA: 3}

  scope :developers, -> { where("user_type = 2") }


  has_many :user_projects
  has_many :projects, through: :user_projects


  def manager?
    user_type == 1
  end

  def developer?
    user_type == 2
  end

  def qa?
    user_type == 3
  end
end
