require 'active_support/core_ext'
require 'log4r'
require 'git'


module ReleaseAutomation

end

class Build

  delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

  def initialize
  	@logger = ReleaseAutomation::Logger.new 'Build'
  end

  def checkout_foundation_source
    build_dir = '/tmp'
    repo_uri = 'git@github.com:joshuofa/simple-rails-app.git'
    git_branch = 'feature-1234'
    repo_name = 'ruby-testing-git-repo'

    _checkout_branch( build_dir, repo_uri, git_branch, repo_name )

  end

  private

  def _checkout_branch ( working_directory, repo_uri, branch, repo_name )

    #remove the repository if it exists. This seems cleaner.
    repo_dir = working_directory + '/' + repo_name
    FileUtils.rm_rf(repo_dir)

    g = Git.clone(repo_uri, repo_name, :log => @logger, :path => working_directory)
  	info( "repo does not exist, checking out new repository" )

  	g.checkout(g.branch(branch))
  	g.pull(g.repo, g.branches.local)

  end
end

require_relative 'lib/release_automation/logger'
build_inst = Build.new

build_inst.checkout_foundation_source