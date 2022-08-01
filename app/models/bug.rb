class Bug < ApplicationRecord

  validates :title, :deadline, :bug_status, :bug_type, presence: true
  validates :title, presence: true, uniqueness: true
  validates :title, length: {minimum:10}

  enum bug_type: [:feature, :bug]
  enum bug_status: [:New, :started, :completed, :resolved]

  belongs_to :project
  has_one_attached :avatar
end
