class Bug < ApplicationRecord

  validates :title, :deadline, :bug_status, :bug_type, presence: true
  validates :title, presence: true, uniqueness: true

  validates :title, length: {minimum:10}

  enum bug: {Feature: 0, Bug: 1}
  enum status: {New: 0, Started: 1, Completed: 2}

  belongs_to :project
  has_one_attached :avatar
end
