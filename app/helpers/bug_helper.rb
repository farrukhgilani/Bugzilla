module BugHelper

  def find_assigned_bug_user(bug)
    User.find(bug.dev_id).name
  end
end
