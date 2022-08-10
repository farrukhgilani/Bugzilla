# frozen_string_literal: true

class Bug < ApplicationRecord
  validates :title, :deadline, :bug_status, :bug_type, presence: true
  validates :title, presence: true, uniqueness: true
  validates :title, length: { minimum: 10 }

  enum bug_type: { feature: 0, bug: 1 }
  enum bug_status: { New: 0, started: 1, completed: 2, resolved: 3 }

  belongs_to :project
  has_one_attached :avatar
end
