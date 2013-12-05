class ReleaseAutomation::Build

  delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

  attr_reader :build_environment, :build_preparer, :build_runner, :build_packager

  def initialize

    @logger = ReleaseAutomation::get_logger

    debug( "Begin ReleaseAutomation::initialize" )

    @build_preparer    = _initialize_build_preparer
    @build_runner      = _initialize_build_runner
    @build_packager    = _initialize_build_packager

    debug( "End ReleaseAutomation::initialize" )

  end

  def create_build 

    build_preparer.prepare
    build_runner.build
    build_packager.package

  end

  private

  def _initialize_build_preparer
    ReleaseAutomation::BuildPreparer.new
  end

  def _initialize_build_runner
    ReleaseAutomation::BuildRunner.new
  end

  def _initialize_build_packager
    ReleaseAutomation::BuildPackager.new
  end

end

require_relative 'build/build_preparer'
require_relative 'build/build_scm'
require_relative 'build/build_runner'
require_relative 'build/build_packager'