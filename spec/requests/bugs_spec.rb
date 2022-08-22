require 'rails_helper'

RSpec.describe "Bugs", type: :request do

let (:manager) {create(:user, user_type: :manager)}
let (:developer) {create(:user, user_type: :developer)}
let (:qa) {create(:user, user_type: :qa)}

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

    context 'when manager submits create form with Invalid bug data' do
      let ( :project ) { FactoryBot.create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 2, deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project_id: project.id} } }
      it 'is Not expected to create a bug' do
        post project_bugs_url(project.id), params: params
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect(assigns[:bug].title).not_to eq('New Project')
        expect(response.status).to be(302)
      end
    end
  end

  describe 'POST #create' do
    context 'when QA submits create form with valid bug data' do
      let ( :project ) { FactoryBot.create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Title 12345', deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project_id: project.id} } }
      it 'is expected to create a bug' do
        sign_in(qa)
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
    let(:bug2) { FactoryBot.create(:bug, project_id: project.id, bug_status: 'started', bug_type:'feature') }
    let(:bug3) { FactoryBot.create(:bug, project_id: project.id, bug_status: 'started', bug_type:'bug') }
    let(:bug4) { FactoryBot.create(:bug, project_id: project.id, title:222222222222222) }
    context 'when a developer assigns a bug to himself' do
      it 'changes the bug status' do
        sign_in(developer)
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect((assigns[:bug].id)).to eq(bug.id)
        expect((assigns[:bug].bug_status)).to eq('started').or eq('completed')
        expect((assigns[:bug].bug_type)).to eq('bug').or eq('feature')
        expect((assigns[:bug].dev_id)).to eq(developer.id)
        expect(response.status).to eq(302)
      end
    end

    context 'when a developer assigns a bug to himself' do
      it 'changes the bug status' do
        sign_in(developer)
        get edit_project_bug_url(bug2.project, bug2)
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect((assigns[:bug].id)).to eq(bug2.id)
        expect((assigns[:bug].bug_status)).to eq('completed')
        expect((assigns[:bug].bug_type)).to eq('feature')
        expect((assigns[:bug].dev_id)).to eq(developer.id)
        expect(response.status).to eq(302)
      end
    end

    context 'when a developer assigns a bug to himself' do
      it 'changes the bug status' do
        sign_in(developer)
        get edit_project_bug_url(bug3.project, bug3)
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect((assigns[:bug].id)).to eq(bug3.id)
        expect((assigns[:bug].bug_status)).to eq('resolved')
        expect((assigns[:bug].bug_type)).to eq('bug')
        expect((assigns[:bug].dev_id)).to eq(developer.id)
        expect(response.status).to eq(302)
      end
    end

    context "when invalid data is entered in bug" do
      it 'should not save the bug and redirect it to index screen' do
      allow_any_instance_of(Bug).to receive(:save).and_return(false)
      sign_in(developer)
      get edit_project_bug_url(bug4.project, bug4)
      # allow_any_instance_of(Bug).to receive(:save).and_return(false)

      end
    end
  end

  describe 'GET #edit' do
    let(:project ) { FactoryBot.create(:project, user_ids: manager.id) }
    let(:bug) { FactoryBot.create(:bug, project_id: project.id) }
    context 'when a QA try to assign a bug to himself' do
      it 'Does not change the change the bug status' do
        sign_in(qa)
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect((assigns[:bug].id)).to eq(bug.id)
        expect((assigns[:bug].bug_status)).not_to eq('started')
        expect((assigns[:bug].bug_status)).not_to eq('completed')
        expect((assigns[:bug].dev_id)).not_to eq(developer.id)
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'GET #edit' do
    let(:project ) { FactoryBot.create(:project, user_ids: manager.id) }
    let(:bug) { FactoryBot.create(:bug, project_id: project.id) }
    context 'when a Manager try to assign a bug to himself' do
      it 'Does not change the change the bug status' do
        sign_in(manager)
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug])).to be_instance_of(Bug)
        expect((assigns[:bug].id)).to eq(bug.id)
        expect((assigns[:bug].bug_status)).not_to eq('started')
        expect((assigns[:bug].bug_status)).not_to eq('completed')
        expect((assigns[:bug].dev_id)).not_to eq(developer.id)
        expect(response.status).to eq(302)
      end
    end
  end


end
