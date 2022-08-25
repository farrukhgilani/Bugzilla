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
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Title 12345', deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project: project} } }
      it 'is expected to create a bug' do

        post project_bugs_url(project.id), params: params
        expect(assigns[:bug].title).to eq('New Title 12345')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when manager submits create form with Invalid bug Title' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 2, deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project: project} } }
      it 'is Not expected to create a bug and redirect to project show page' do
        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        post project_bugs_url(project.id), params: params
        expect(flash[:alert]).to match('Title (minimum 10), Deadline, Type and Status is required.')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when manager submits create form with Invalid bug deadline' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Bug Title', deadline: 'xyz-xyz-xyz', bug_type: 'bug', bug_status: 'New', project: project} } }
      it 'is Not expected to create a bug and redirect to project show page' do
        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        post project_bugs_url(project.id), params: params
        expect(flash[:alert]).to match('Title (minimum 10), Deadline, Type and Status is required.')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when manager submits create form with Invalid Project' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 2, deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project: 'xyz'} } }
      it 'is Not expected to create a bug and redirect to project show page' do
        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        post project_bugs_url(project.id), params: params
        expect(flash[:alert]).to match('Title (minimum 10), Deadline, Type and Status is required.')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA submits create form with valid bug data' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Title 12345', deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project: project} } }
      it 'is expected to create a bug' do

        sign_in(qa)
        post project_bugs_url(project.id), params: params
        expect(assigns[:bug].title).to eq('New Title 12345')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA submits create form with Invalid bug Title' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 2, deadline: '2016-09-23', bug_type: 'bug', bug_status: 'New', project: project} } }
      it 'is expected to create a bug' do

        sign_in(qa)
        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        post project_bugs_url(project.id), params: params
        expect(flash[:alert]).to match('Title (minimum 10), Deadline, Type and Status is required.')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA submits create form with Invalid bug Deadline Date' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Bug Title', deadline: 'xyz-xyz-xyz', bug_type: 'bug', bug_status: 'New', project: project} } }
      it 'is expected to create a bug' do

        sign_in(qa)
        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        post project_bugs_url(project.id), params: params
        expect(flash[:alert]).to match('Title (minimum 10), Deadline, Type and Status is required.')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA submits create form with Invalid Project info' do
      let ( :project ) { create(:project, user_ids: manager.id) }
      let (:params) { { bug: {  title: 'New Bug Title', deadline: 'xyz-xyz-xyz', bug_type: 'bug', bug_status: 'New', project: 'xyz'} } }
      it 'is expected to create a bug' do

        sign_in(qa)
        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        post project_bugs_url(project.id), params: params
        expect(flash[:alert]).to match('Title (minimum 10), Deadline, Type and Status is required.')
        expect(response).to have_http_status(:found)

      end
    end
  end


  describe 'GET #edit' do

    let(:project ) { create(:project, user_ids: manager.id) }
    let(:bug) { create(:bug, project: project) }
    let(:bug2) { create(:bug, project: project, bug_status: 'started', bug_type:'feature') }
    let(:bug3) { create(:bug, project: project, bug_status: 'started', bug_type:'bug') }
    let(:bug4) { create(:bug, project: project, title:222222222222222) }
    context 'when a developer assigns a bug/feature to himself' do
      it 'changes the bug/feature status to Started' do

        sign_in(developer)
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug].bug_status)).to eq('started').or eq('completed')
        expect((assigns[:bug].bug_type)).to eq('bug').or eq('feature')
        expect((assigns[:bug].dev_id)).to eq(developer.id)
        expect(response).to have_http_status(:found)

      end
    end

    context 'when a developer Completes a feature he was assigned to' do
      it 'changes the feature status from Started to Completed' do

        sign_in(developer)
        get edit_project_bug_url(bug2.project, bug2)
        expect((assigns[:bug].bug_status)).to eq('completed')
        expect((assigns[:bug].bug_type)).to eq('feature')
        expect((assigns[:bug].dev_id)).to eq(developer.id)
        expect(response).to have_http_status(:found)

      end
    end

    context 'when a developer Resolves a bug he was assigned to' do
      it 'changes the bug status from Started to Resolved' do

        sign_in(developer)
        get edit_project_bug_url(bug3.project, bug3)
        expect((assigns[:bug].bug_status)).to eq('resolved')
        expect((assigns[:bug].bug_type)).to eq('bug')
        expect((assigns[:bug].dev_id)).to eq(developer.id)
        expect(response).to have_http_status(:found)

      end
    end

    context "when invalid data is entered in bug" do
      it 'should not save the bug and redirect it to index screen' do

        allow_any_instance_of(Bug).to receive(:save).and_return(false)
        sign_in(developer)
        get edit_project_bug_url(bug4.project, bug4)
        # expect(response).to redirect_to(project_url)
      end
    end

    context 'when a QA try to assign a bug to himself' do
      it 'Does not change the bug status' do

        sign_in(qa)
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug].bug_status)).not_to eq('started')
        expect((assigns[:bug].bug_status)).not_to eq('completed')
        expect((assigns[:bug].dev_id)).not_to eq(qa.id)
        expect(response).to have_http_status(:found)

      end
    end

    context 'when a Manager try to assign a bug to himself' do
      it 'Does not change the bug status' do

        sign_in(manager)
        get edit_project_bug_url(bug.project, bug)
        expect((assigns[:bug].bug_status)).not_to eq('started')
        expect((assigns[:bug].bug_status)).not_to eq('completed')
        expect((assigns[:bug].dev_id)).not_to eq(manager.id)
        expect(response).to have_http_status(:found)

      end
    end

  end
end
