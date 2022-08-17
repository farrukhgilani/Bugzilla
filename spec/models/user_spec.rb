# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with Validation' do
    it 'ensures name presence' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it 'ensures email presence' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'ensures password presence' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'ensures user_type presence' do
      user = build(:user, user_type: nil)
      expect(user).not_to be_valid
    end

    it 'ensures name length max 20' do
      user = build(:user, name: 'nilnbbbbbjssjchshfhsduhfksdhfhsdfhsdgfjgsdjfgjsdgfjsgjfgsdjfgjsdgfjdsg')
      expect(user).not_to be_valid
    end

    it 'ensures name length min 3' do
      user = build(:user, name: 'ni')
      expect(user).not_to be_valid
    end

    it 'ensures name length is between 3-20' do
      user = build(:user, name: 'Shaheer')
      expect(user).to be_valid
    end
  end

  context 'with associations' do
    it 'ensures to have many projects' do
      user = build(:user)
      expect(user).to have_many(:projects).through(:user_projects)
    end
  end
end
