require 'rails_helper'

RSpec.describe ProjectsController, type: :request do

  let (:manager) {create(:user, user_type: :manager)}
  let (:developer) {create(:user, user_type: :developer)}
  let (:qa) {create(:user, user_type: :qa)}


  	before do
    	sign_in(manager)
  	end

  describe 'GET #show' do
    let ( :project ) { create(:project, user_ids: manager.id) }

    context "when User visits project show" do
        it 'return a success response' do

          get project_url(project.id)
          expect(assigns[:project])
          expect(response).to have_http_status(:ok)

      end
    end

    context "when User visits Non existing project's show page" do
      it 'is expected to show Project not found page.' do
         get project_url(123)
         expect(flash[:alert]).to match('Record Not Found')
         expect(response).to have_http_status(:found)

      end
    end

    context "when user visits project show" do
      let ( :bug ) { create(:bug, project_id: project.id, bug_status: 'New') }

      it 'return a success response with bugs_status = New' do

        get project_url(project.id), params: {filter_by: "New"}
        expect(assigns[:project])
        expect(bug.bug_status).to eq('New')
        expect(response).to have_http_status(:ok)

      end

      context "when user visits project show and filters result by Status = Started" do

      let ( :bug ) { create(:bug, project_id: project.id, bug_status: 'started') }
        it 'return a success response with bugs_status = Started' do

          get project_url(project.id), params: {filter_by: "started"}
          expect(assigns[:project])
          expect(bug.bug_status).to eq('started')
          expect(response).to have_http_status(:ok)

      end
    end

    context "when user visits project show and filters result by Status = Completed" do
      let ( :bug ) { create(:bug, project_id: project.id, bug_status: 'completed') }
      it 'return a success response with bugs_status = Completed' do

        get project_url(project.id), params: {filter_by: "completed"}
        expect(assigns[:project])
        expect(bug.bug_status).to eq('completed')
        expect(response).to have_http_status(:ok)

      end
    end

      context "when user visits project show and filters result by Status = Resolved" do
        let ( :bug ) { create(:bug, project_id: project.id, bug_status: 'resolved') }
        it 'return a success response with bugs_status = Resolved' do

          get project_url(project.id), params: {filter_by: "resolved"}
          expect(assigns[:project])
          expect(bug.bug_status).to eq('resolved')
          expect(response).to have_http_status(:ok)

        end
      end
    end

    context "when Developer visits project show" do
      let ( :project ) { create(:project, user_ids: manager.id) }
        it 'return a success response' do

          sign_in(developer)
          get project_url(project.id)
          expect(assigns[:project])
          expect(response).to have_http_status(:found)

      end
    end

    context "when QA visits project show" do
      let ( :project ) {create(:project, user_ids: manager.id) }
        it 'return a success response' do

          sign_in(qa)
          get project_url(project.id)
          expect(assigns[:project])
          expect(response).to have_http_status(:ok)

      end
    end

  end


  describe 'GET #index' do

    let ( :projects ) { create(:project, user_ids: manager.id) }
    context "when Manager visits project index" do
        it 'return a success response' do

          get projects_url
          expect(assigns[:projects])
          expect(response).to be_successful

      end
    end

    context "when Developer visits project index" do
        it 'return a success response' do

          sign_in(developer)
          get projects_url
          expect(assigns[:projects])
          expect(response).to be_successful

      end
    end

    context "when QA visits project index" do
        it 'return a success response' do

        sign_in(qa)
        get projects_url
        expect(assigns[:projects])
        expect(response).to be_successful

      end
    end
  end

   describe 'GET #new' do

      context 'when Manager visits new project page' do
      it 'assign project to an instance variable and return a success response' do

        get new_project_url
        expect(response).to be_successful
        is_expected.to render_template(:new)

      end
    end

    context 'when Developer visits new project page' do
      it 'return to index page showing not Authorized' do

        sign_in(developer)
        get new_project_url
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA visits new project page' do
      it 'return to index page showing not Authorized' do

        sign_in(qa)
        get new_project_url
        expect(response).to have_http_status(:found)

      end
    end

  end

   describe 'GET #edit' do

    let(:edit_project) { create(:project, user_ids: manager.id ) }
    context 'when Manager visits Edit project page' do
      it 'find project using param id and render edit form' do

        get edit_project_url(edit_project)
        expect((assigns[:project].id)).to eq(edit_project.id)
        expect(response).to have_http_status(:ok)
        is_expected.to render_template(:edit)

      end
    end

    context 'when Manager visits Edit project page for Invalid Project' do
      it 'should not render edit form' do

        get edit_project_url(123)
        expect(flash[:alert]).to match('Record Not Found')
        expect(response).to have_http_status(:found)
        is_expected.not_to render_template(:edit)

      end
    end

    context 'when Developer visits Edit project page' do
      it 'return to index page showing not Authorized' do

        sign_in(developer)
        get edit_project_url(edit_project)
        expect((assigns[:project].id)).to eq(edit_project.id)
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA visits Edit project page' do
      it 'return to index page showing not Authorized' do

        sign_in(qa)
        get edit_project_url(edit_project)
        expect((assigns[:project].id)).to eq(edit_project.id)
        expect(response).to have_http_status(:found)

      end
    end
  end


  describe 'DELETE #delete' do
    let( :new_project ) { create(:project, user_ids: manager.id) }

    context 'when Manager deletes one of his project' do
      it 'is expected to destroy the project' do

        delete project_url(new_project)
        expect(Project.find_by(id: new_project.id)).to be_nil
        expect(flash[:notice]).to match('Project Deleted Successfully')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when Manager deletes an Invalid project' do
      before do
        allow(new_project).to receive(:destroy).and_return(false)
        allow(Project).to receive(:find).and_return(new_project)
      end
      it 'is not expected to destroy the project' do
        delete project_url(new_project)
        expect(flash[:alert]).to match('Something went wrong')
        expect(response).to have_http_status(:found)
      end
    end

    context 'when Developer try to delete one of his project' do
      it 'return to index page showing not Authorized While not deleting project' do

        sign_in(developer)
        delete project_url(new_project)
        expect(Project.find_by(id: new_project.id)).not_to be_nil
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA try to delete one of his project' do
      it 'return to index page showing not Authorized While not deleting project' do

        sign_in(qa)
        delete project_url(new_project)
        expect(Project.find_by(id: new_project.id)).not_to be_nil
        expect(response).to have_http_status(:found)

      end
    end
  end

  describe 'PUT #update' do
   let(:edit_project) { create(:project, user_ids: manager.id) }

    context 'when Manager submits edit form with valid project data' do
      let(:params) { { project: { name: 'Edited Title', description: 'Edited Description kl maskldm klas salk md' } } }
      it 'is expected to update project' do

        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(edit_project)
        expect(assigns[:project].name).to eq('Edited Title')
        expect(flash[:notice]).to match('Project Updated Successfully')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when Manager submits edit form with Invalid project data' do
      let(:params) { { project: { name: nil, description: 'Edited Description kl maskldm klas salk md' } } }

      it 'is not expected to update the project' do

        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(edit_project)
        expect(assigns[:project].name).not_to eq('New Project')
        expect(flash[:alert]).to match('Something Went Wrong!')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when Developer submits edit form with valid project data' do
      let(:params) { { project: { name: 'Edited Title', description: 'Edited Description kl maskldm klas salk md' } } }

      it 'return to index page showing not Authorized While not updating project' do

        sign_in(developer)
        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(edit_project)
        expect(assigns[:project].name).not_to eq('Edited Title')
        expect(response).to have_http_status(:found)

      end
    end

    context 'when QA submits edit form with valid project data' do
      let(:params) { { project: { name: 'Edited Title', description: 'Edited Description kl maskldm klas salk md' } } }

      it 'return to index page showing not Authorized While not updating project' do

        sign_in(qa)
        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(edit_project)
        expect(assigns[:project].name).not_to eq('Edited Title')
        expect(response).to have_http_status(:found)

      end
    end
  end


  describe 'POST #create' do

    context 'when manager submits create form with valid project name and description' do
      let(:params) { { project: {  name: 'New Title', description: 'mkm dlkmalksmlkds s kmaslk mdlkamsl sk', user_ids: manager.id } } }

      it 'is expected to create a project' do
        post projects_url, params: params
        expect(assigns[:project].name).to eq('New Title')
        expect(flash[:notice]).to match('Project Created Successfully')
        expect {post projects_url, params: params}.to change(Project, :count).by(1)
        expect(response).to have_http_status(:found)

      end
    end

    context 'when manager submits create form with Invalid project name' do
      let(:params) { { project: {  name: 2, description: 'mkm dlkmalksmlkds s kmaslk mdlkamsl sk', user_ids: manager.id } } }

      it 'is expected not to create the project' do

        post projects_url, params: params
        expect(assigns[:project]).not_to be_valid
        expect(response).to have_http_status(:ok)

      end
    end

    context 'when manager submits create form with Invalid project Description' do
      let(:params) { { project: {  name: 'New Project', description: 22222222222222222222, user_ids: manager.id } } }

      it 'is expected not to create the project' do

        post projects_url, params: params
        expect(assigns[:project]).not_to be_valid
        expect(response).to have_http_status(:ok)

      end
    end

    context 'when manager submits create form with Nil project Description' do
      let(:params) { { project: {  name: 'New Project', description: nil, user_ids: manager.id } } }

      it 'is expected not to create the project' do

        post projects_url, params: params
        expect(assigns[:project]).not_to be_valid
        expect(response).to have_http_status(:ok)

      end
    end

  end
end
