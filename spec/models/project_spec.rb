# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'with validation' do

    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
    it {should validate_length_of(:description).is_at_least(30) }
    it {should validate_length_of(:name).is_at_least(5) }
    it {should validate_length_of(:name).is_at_most(40) }
  end

  context 'with association' do
    it {should have_many(:users).through(:user_projects)}
  end
end
