# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'with validation' do
    it 'ensures name presence' do
      project = build(:project, name: nil)
      expect(project).not_to be_valid
    end

    it 'ensures description presence' do
      project = build(:project, description: nil)
      expect(project).not_to be_valid
    end

    it 'ensures description has minimum length 30' do
      project = build(:project, description: 'sam ldkmaslk mdl')
      expect(project).not_to be_valid
    end

    it 'ensures name has minimum length 5' do
      project = build(:project, name: 'sam')
      expect(project).not_to be_valid
    end

    it 'ensures name has maximum length 40' do
      project = build(:project, name: 'sa sa skm dlkamslkmdalkmslk dmaslkm dlkamsa slkmdalkmslk')
      expect(project).not_to be_valid
    end
  end

  context 'with association' do
    it 'ensures to have many users' do
      project = build(:project)
      expect(project).to have_many(:users).through(:user_projects)
    end
  end
end
