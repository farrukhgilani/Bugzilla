# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'with validation' do

    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}

    # it 'ensures description has minimum length 30' do
    #   project = build(:project, description: 'sam ldkmaslk mdl')
    #   expect(project).not_to be_valid
    # end
    it {should validate_length_of(:description)}
    it {should validate_length_of(:description).is_at_least(30) }

    # it 'ensures name has minimum length 5' do
    #   project = build(:project, name: 'sam')
    #   expect(project).not_to be_valid
    # end
    it {should validate_length_of(:name)}
    it {should validate_length_of(:name).is_at_least(5) }
    it {should validate_length_of(:name).is_at_most(40) }

    # it 'ensures name has maximum length 40' do
    #   project = build(:project, name: 'sa sa skm dlkamslkmdalkmslk dmaslkm dlkamsa slkmdalkmslk')
    #   expect(project).not_to be_valid
    # end
  end

  context 'with association' do
    # it 'ensures to have many users' do
    #   project = build(:project)
    #   expect(project).to have_many(:users).through(:user_projects)
    # end
    it {should have_many(:users).through(:user_projects)}
  end
end
