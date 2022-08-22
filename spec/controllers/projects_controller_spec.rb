require 'rails_helper'

RSpec.describe ProjectsController, type: :request do

  let (:manager) {create(:user, user_type: :manager)}
  let (:developer) {create(:user, user_type: :developer)}
  let (:qa) {create(:user, user_type: :qa)}


  before do
    sign_in(manager)
  end

  describe 'GET #index' do
    let ( :projects ) { FactoryBot.create_list(:project, user_ids: manager.id) }
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


  describe 'GET #show' do
    context "when Manager visits project show" do
      # let(:filter_by) { 'New' }
      it 'return a success response with bugs_status = New' do
      project = create(:project, user_ids: manager.id)
      bug = create(:bug, project_id: project.id, bug_status: 'New')
      get project_url(project.id), params: {filter_by: "New"}
      expect(assigns[:project])
      expect(bug.bug_status).to eq('New')
      expect(response.status).to eq(200)
      end

      it 'return a success response with bugs_status = Started' do
      project = create(:project, user_ids: manager.id)
      bug = create(:bug, project_id: project.id, bug_status: 'started')
      get project_url(project.id), params: {filter_by: "started"}
      expect(assigns[:project])
      expect(bug.bug_status).to eq('started')
      expect(response.status).to eq(200)
      end

      it 'return a success response with bugs_status = Completed' do
      project = create(:project, user_ids: manager.id)
      bug = create(:bug, project_id: project.id, bug_status: 'completed')
      get project_url(project.id), params: {filter_by: "completed"}
      expect(assigns[:project])
      expect(bug.bug_status).to eq('completed')
      expect(response.status).to eq(200)
      end

      it 'return a success response with bugs_status = Resolved' do
      project = create(:project, user_ids: manager.id)
      bug = create(:bug, project_id: project.id, bug_status: 'resolved')
      get project_url(project.id), params: {filter_by: "resolved"}
      expect(assigns[:project])
      expect(bug.bug_status).to eq('resolved')
      expect(response.status).to eq(200)
      end
    end

    context "when Developer visits project show" do
      let ( :project ) { FactoryBot.create(:project, user_ids: manager.id) }
        it 'return a success response' do
        sign_in(developer)
        get project_url(project.id)
        expect(assigns[:project])
        expect(response.status).to eq(302)
      end
    end

    context "when QA visits project show" do
      let ( :project ) { FactoryBot.create(:project, user_ids: manager.id) }
        it 'return a success response' do
        sign_in(qa)
        get project_url(project.id)
        expect(assigns[:project])
        expect(response.status).to eq(200)
      end
    end

  end

   describe 'GET #new' do
    context 'when Manager visits new project page' do
      it 'assign project to an instance variable and return a success response' do
        get new_project_url
        expect((assigns[:project])).to be_instance_of(Project)
        expect(response).to be_successful
        is_expected.to render_template(:new)
      end
    end

    context 'when Developer visits new project page' do
      it 'return to index page showing not Authorized' do
        sign_in(developer)
        get new_project_url
        expect((assigns[:project])).to be_instance_of(Project)
        expect(response.status).to eq(302)
      end
    end

    context 'when QA visits new project page' do
      it 'return to index page showing not Authorized' do
        sign_in(qa)
        get new_project_url
        expect((assigns[:project])).to be_instance_of(Project)
        expect(response.status).to eq(302)
      end
    end

  end

   describe 'GET #edit' do
    let(:edit_project) { FactoryBot.create(:project) }
    context 'when Manager visits Edit project page' do
      it 'find project using param id and render edit form' do
        get edit_project_url(edit_project)
        expect((assigns[:project])).to be_instance_of(Project)
        expect((assigns[:project].id)).to eq(edit_project.id)
        expect(response.status).to eq(302)
      end
    end

    context 'when Developer visits Edit project page' do
      it 'return to index page showing not Authorized' do
        sign_in(developer)
        get edit_project_url(edit_project)
        expect((assigns[:project])).to be_instance_of(Project)
        expect((assigns[:project].id)).to eq(edit_project.id)
        expect(response.status).to eq(302)
      end
    end

    context 'when QA visits Edit project page' do
      it 'return to index page showing not Authorized' do
        sign_in(qa)
        get edit_project_url(edit_project)
        expect((assigns[:project])).to be_instance_of(Project)
        expect((assigns[:project].id)).to eq(edit_project.id)
        expect(response.status).to eq(302)
      end
    end
  end


  describe 'DELETE #delete' do
  let!( :new_project ) { FactoryBot.create(:project, user_ids: manager.id) }
    context 'when Manager deletes one of his project' do
      it 'is expected to destroy the project' do
        delete project_url(new_project)
        expect(Project.find_by(id: new_project.id)).to be_nil
        expect(response.status).to be(302)
      end
    end

    context 'when Manager deletes one of his project' do
      before do
        allow(new_project).to receive(:destroy).and_return(false)
        allow(Project).to receive(:find).and_return(new_project)
      end
      it 'is not expected to destroy the project' do
        delete project_url(new_project)
        expect(response.status).to be(302)
      end
    end

    context 'when Developer try to delete one of his project' do
      it 'return to index page showing not Authorized While not deleting project' do
        sign_in(developer)
        delete project_url(new_project)
        expect(Project.find_by(id: new_project.id)).not_to be_nil
        expect(response.status).to be(302)
      end
    end

    context 'when QA try to delete one of his project' do
      it 'return to index page showing not Authorized While not deleting project' do
        sign_in(qa)
        delete project_url(new_project)
        expect(Project.find_by(id: new_project.id)).not_to be_nil
        expect(response.status).to be(302)
      end
    end
  end

  describe 'PUT #update' do
    let(:edit_project) { FactoryBot.create(:project, user_ids: manager.id) }
    context 'when Manager submits edit form with valid project data' do
      let(:params) { { project: { name: 'Edited Title', description: 'Edited Description kl maskldm klas salk md' } } }
      it 'is expected to update project' do
        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(Project.find_by(id: edit_project.id))
        expect((assigns[:project])).to be_instance_of(Project)
        expect(assigns[:project].name).to eq('Edited Title')
        assert(assigns[:project].id, edit_project.id)
        expect(response.status).to be(302)
      end
    end

    context 'when Manager submits edit form with Invalid project data' do
      let(:params) { { project: { name: nil, description: 'Edited Description kl maskldm klas salk md' } } }
      it 'is not expected to update the project' do
        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(Project.find_by(id: edit_project.id))
        expect((assigns[:project])).to be_instance_of(Project)
        expect(assigns[:project].name).not_to eq('New Project')
        assert(assigns[:project].id, edit_project.id)
        expect(response.status).to be(302)
        # response.should render_template("edit")
      end
    end

    context 'when Developer submits edit form with valid project data' do
      let(:params) { { project: { name: 'Edited Title', description: 'Edited Description kl maskldm klas salk md' } } }
      it 'return to index page showing not Authorized While not updating project' do
        sign_in(developer)
        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(Project.find_by(id: edit_project.id))
        expect((assigns[:project])).to be_instance_of(Project)
        expect(assigns[:project].name).not_to eq('Edited Title')
        assert(assigns[:project].id, edit_project.id)
        expect(response.status).to be(302)
      end
    end

    context 'when QA submits edit form with valid project data' do
      let(:params) { { project: { name: 'Edited Title', description: 'Edited Description kl maskldm klas salk md' } } }
      it 'return to index page showing not Authorized While not updating project' do
        sign_in(qa)
        put project_url(edit_project.id), params: params
        expect(assigns[:project]).to eq(Project.find_by(id: edit_project.id))
        expect((assigns[:project])).to be_instance_of(Project)
        expect(assigns[:project].name).not_to eq('Edited Title')
        assert(assigns[:project].id, edit_project.id)
        expect(response.status).to be(302)
      end
    end
  end


  describe 'POST #create' do
    context 'when manager submits create form with valid project data' do
      let(:params) { { project: {  name: 'New Title', description: 'mkm dlkmalksmlkds s kmaslk mdlkamsl sk', user_ids: manager.id } } }
      it 'is expected to create a project' do
        post projects_url, params: params
        expect((assigns[:project])).to be_instance_of(Project)
        expect(assigns[:project].name).to eq('New Title')
        expect(response.status).to be(302)
      end
    end

    context 'when manager submits create form with Invalid project data' do
      let(:params) { { project: {  name: 2, description: 'mkm dlkmalksmlkds s kmaslk mdlkamsl sk', user_ids: manager.id } } }
      it 'is expected not to create the project' do
        post projects_url, params: params
        expect((assigns[:project])).to be_instance_of(Project)
        expect(assigns[:project]).not_to be_valid
        expect(response.status).to be(200)
      end
    end
  end
end
