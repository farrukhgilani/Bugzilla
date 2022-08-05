# frozen_string_literal: true

module ProjectHelper
  def dev_qa
    arr = []
    User.developer.each do |d|
      arr << d
    end
    User.qa.each do |q|
      arr << q
    end
    arr
  end
end
