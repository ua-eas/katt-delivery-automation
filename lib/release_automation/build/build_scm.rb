class  ReleaseAutomation::BuildSCM

  delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

  attr_reader :working_directory, :foundation_repo, :foundation_repo_name, :foundation_working_dir,
    :ua_repo, :ua_repo_name, :ua_working_dir, :database_repo, :database_repo_name,
    :database_working_dir, :rice_repo, :rice_repo_name, :rice_working_dir, :branch

  def initialize

    @logger = ReleaseAutomation::get_logger

    build_environment = _initialize_build_environment

    @working_directory    = build_environment.get_build_directory

    @foundation_repo      = build_environment.get_foundation_repo
    @foundation_repo_name = build_environment.get_foundation_repo_name
    @foundation_working_dir = "#{working_directory}/#{foundation_repo_name}/"

    @ua_repo        = build_environment.get_ua_repo
    @ua_repo_name   = build_environment.get_ua_repo_name
    @ua_working_dir = "#{working_directory}/#{ua_repo_name}/"

    @database_repo 		= build_environment.get_database_update_repo
    @database_repo_name = build_environment.get_database_update_repo_name
    @database_working_dir = "#{working_directory}/#{database_repo_name}/"

    @rice_repo 		= build_environment.get_rice_repo
    @rice_repo_name = build_environment.get_rice_repo_name
    @rice_working_dir = "#{working_directory}/#{rice_repo_name}/"

    @branch = build_environment.get_git_branch

  end

  def checkout_source
    _checkout( rice_repo,       rice_repo_name       )
    _checkout( foundation_repo, foundation_repo_name )
    _checkout( ua_repo,         ua_repo_name         )
    _checkout( database_repo,   database_repo_name   )
  end

  def commit_ua_changes ( commit_message )
    _commit_changes( ua_working_dir, commit_message )
  end

  # Public: Builds a list of jiras found in commit messages
  #         found in all projects since we last saw the
  #         passed in commit message.
  #
  # commit_message  - The commit message to stop on
  #
  # Examples
  #
  #   list_jiras_since_commit_message('Bumping snapshot version')
  #   # => 'UAR-12, UAR-6, KSI-123, KSI-456'
  #
  # Returns a string of comma separated jira numbers we found
  # in commit messages since we last saw the passed in commit
  # message.
  def list_jiras_since_commit_message (commit_message)

    fixed_jiras = ''
    fixed_jiras += _list_jiras_since_message_for_repo ua_working_dir, commit_message
    fixed_jiras += _list_jiras_since_message_for_repo rice_working_dir, commit_message
    fixed_jiras += _list_jiras_since_message_for_repo foundation_working_dir, commit_message
    fixed_jiras += _list_jiras_since_message_for_repo database_working_dir, commit_message

  end

  def tag_build ( release, snapshot )

    tag = _get_current_build_tag( release, snapshot )

    _tag_repository rice_working_dir, tag
    _tag_repository foundation_working_dir, tag
    _tag_repository ua_working_dir, tag
    _tag_repository database_working_dir, tag

  end

  private

  def _checkout ( repo_uri, repo_name )

    _cleanup_repo_dir repo_name

    debug "Cloning repository"
    debug "working_directory: #{working_directory}"
    debug "repo_uri: #{repo_uri}"
    debug "branch: #{branch}"
    debug "repo_name: #{repo_name}"

    debug "cloning #{repo_name}"
    git = Git.clone(repo_uri, repo_name, :path => working_directory)
    debug "git clone complete."

    git.checkout(git.branch(branch))
    debug "git checkout branch complete."

    git.pull(git.repo, git.branches.local)
    debug "git pull complete."

  end

  def _cleanup_repo_dir ( repo_name )
    repo_dir = working_directory + '/' + repo_name
    FileUtils.rm_rf(repo_dir)
  end

  def _commit_changes ( repo_working_directory, commit_message )

    git = _open_repository(repo_working_directory)
    git.add
    git.commit_all( commit_message )

  end

  def _get_current_build_tag ( release, snapshot )
    return "release-3.1.1-#{release}.pre#{snapshot}"
  end

  def _initialize_build_environment
    ReleaseAutomation::get_build_environment
  end

  # Private: Builds a list of jiras found in commit messages
  #         found in one repo since we last saw the
  #         passed in commit message.
  #
  # commit_message  - The commit message to stop on
  #
  # Examples
  #
  #   _list_jiras_since_message('Bumping version')
  #   # => 'UAR-12, UAR-6, KSI-123, KSI-456'
  #
  # Returns a string of comma separated jira numbers we found
  # in commit messages since we last saw the passed in commit
  # message.
  def _list_jiras_since_message_for_repo ( repo_working_directory, commit_message)

    fixed_jiras = ''

    messages = _get_commit_messages_for_repository repo_working_directory

    messages.each do | message |

      debug ("Checking the following commit message for jira number: #{message}")

      escaped_match_string = Regexp.escape(commit_message)

      case message
      when /#{escaped_match_string}/; break
      when /(?<match_jira>UAR\-\d+|KCI\-\d+)/;
              jira_num = Regexp.last_match(:match_jira)
              debug "found jira: #{jira_num}"

              fixed_jiras += " #{jira_num},"
        end
      end

    return fixed_jiras.chop
  end

  def _get_commit_messages_for_repository ( repo_working_directory )
    git = _open_repository( repo_working_directory )
    git.log.each do |commit|
      commit.message
    end
  end

  def _open_repository ( repo_working_directory )
    Git.open( repo_working_directory, :log => @logger )
  end

  def _tag_repository ( repo_working_dir, tag )

      git = _open_repository repo_working_directory
      git.add_tag tag

  end

end
