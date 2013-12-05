class ReleaseAutomation::Environment::BuildEnvironment < ReleaseAutomation::Environment

  def get_build_directory
  	@config['build_environment']['build_directory']
  end

  def get_rice_repo
    @config['build_environment']['repositories']['rice']['uri']
  end

  def get_foundation_repo
  	@config['build_environment']['repositories']['foundation']['uri']
  end

  def get_ua_repo
  	@config['build_environment']['repositories']['ua']['uri']
  end

  def get_database_update_repo
  	@config['build_environment']['repositories']['database_updates']['uri']
  end

  def get_rice_repo_name
    @config['build_environment']['repositories']['rice']['name']
  end

  def get_foundation_repo_name
  	@config['build_environment']['repositories']['foundation']['name']
  end

  def get_ua_repo_name
  	@config['build_environment']['repositories']['ua']['name']
  end

  def get_database_update_repo_name
  	@config['build_environment']['repositories']['database_updates']['name']
  end

  def get_git_branch
  	@config['build_environment']['git_branch']
  end

  def get_branch
    @config['build_environment']['git_branch']
  end

  def get_rice_working_dir
    return get_build_directory + "/" + get_rice_repo_name + "/"
  end

  def get_foundation_working_dir
    return get_build_directory + "/" + get_foundation_repo_name + "/"
  end

  def get_ua_working_dir
    return get_build_directory + "/" + get_ua_repo_name + "/"
  end

  def get_version_properties_file
    return "#{get_ua_working_dir}/version.properties"
  end

end