# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with Validation' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:password)}
    it {should validate_presence_of(:user_type)}

    # it 'ensures name length max 20' do
    #   user = build(:user, name: 'nilnbbbbbjssjchshfhsduhfksdhfhsdfhsdgfjgsdjfgjsdgfjsgjfgsdjfgjsdgfjdsg')
    #   expect(user).not_to be_valid
    # end

    # it 'ensures name length min 3' do
    #   user = build(:user, name: 'ni')
    #   expect(user).not_to be_valid
    # end

    # it 'ensures name length is between 3-20' do
    #   user = build(:user, name: 'Shaheer')
    #   expect(user).to be_valid
    # end
    it {should validate_length_of(:name).is_at_least(3) }
    it {should validate_length_of(:name).is_at_most(20) }
  end

  context 'with associations' do
    # it 'ensures to have many projects' do
    #   user = build(:user)
    #   expect(user).to have_many(:projects).through(:user_projects)
    # end
    it {should have_many(:projects).through(:user_projects)}
  end
end
