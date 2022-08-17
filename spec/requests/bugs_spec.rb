require 'rails_helper'

RSpec.describe "Bugs", type: :request do

let (:manager) {create(:user, user_type: :manager)}

before do
  sign_in(manager)
end

  describe 'POST #create' do
    context 'when manager submits create form with valid bug data' do
      let ( :project ) { FactoryBot.create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Title 12345', deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project_id: project.id} } }
      it 'is expected to create a bug' do
        post project_bugs_url(project.id), params: params
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect(assigns[:bug].title).to eq('New Title 12345')
        expect(response.status).to be(302)
      end
    end
  end

  describe 'GET #edit' do
    let(:project ) { FactoryBot.create(:project, user_ids: manager.id) }
    let(:bug) { FactoryBot.create(:bug, project_id: project.id) }
    context 'when a developer assigns a bug to himself' do
      it 'changes the bug status' do
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect((assigns[:bug].id)).to eq(bug.id)
        expect(response.status).to eq(302)
      end
    end
  end


end
