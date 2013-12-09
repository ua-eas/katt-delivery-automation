##
# Public: This class is responsible for performing all steps to prepare
#         to run a build.
#
class ReleaseAutomation::BuildPreparer

  delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

  attr_reader :build_environment, :build_scm, :version

  def initialize
    @logger = ReleaseAutomation::get_logger

    @build_scm 		   = _initialize_build_scm
    @version           = _initialize_version
  end

  # Public: Responsible for orchestrating all tasks required to prepreare
  #         the build source for a build. This are the pre-build steps
  # 		  like checking out source, version bumps, tagging, etc.
  #
  # Examples
  #
  #   build_preparer.prepare
  #
  # Returns nothing.
  def prepare

    build_scm.checkout_source

    version.bump_build_version( build_scm )

    release = _get_release_number
    snaphost = _get_snapshot_number
    build_scm.tag_build( release, snaphost )

  end

  private

  # Private: Initializes the build_scm object used by this preparer.
  #
  # Examples
  #
  #   _initialize_versioner
  #   # => versioner_obj
  #
  # Returns an object that responds to bump_build_version, release, and
  # snapshot method calls.
  def _initialize_build_scm
    ReleaseAutomation::BuildSCM.new
  end

  # Private: Initializes the versioner object used by this preparer.
  #
  # Examples
  #
  #   _initialize_version
  #   # => versioner_obj
  #
  # Returns an object that responds to bump_build_version, release, and
  # snapshot method calls.
  def _initialize_version
    ReleaseAutomation::Versioner.new
  end

  # Private: Determines what the current release number is for the preparer
  #          object.
  #
  # Examples
  #
  #   _get_release_number
  #
  # Returns a string representing the current release version
  def _get_release_number
    version.release
  end

  # Private: Determines what the current snapshot number is for the preparer
  #          object.
  #
  # Examples
  #
  #   _get_snapshot_number
  #
  # Returns a string representing the current snapshot version
  def _get_snapshot_number
    version.snapshot
  end

end
