# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with Validation' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:password)}
    it {should validate_presence_of(:user_type)}
    it {should validate_length_of(:name).is_at_least(3) }
    it {should validate_length_of(:name).is_at_most(20) }
    it {should validate_length_of(:password).is_at_least(6) }
  end

  context 'with associations' do
    it {should have_many(:projects).through(:user_projects)}
  end
end
