require 'rails_helper'

RSpec.describe Bug, type: :model do
  context 'with validation' do

    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:deadline)}
    it {should validate_presence_of(:bug_status)}
    it {should validate_presence_of(:bug_type)}
    # it {should validate_uniqueness_of(:title) }
    it {should validate_length_of(:title).is_at_least(10) }

  end

  context 'with association' do
    it {should belong_to(:project)}
    it {should have_one_attached(:avatar)}
  end
end
