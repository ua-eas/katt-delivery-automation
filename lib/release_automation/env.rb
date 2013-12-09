
class ReleaseAutomation::Environment

  delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

  def initialize

    @logger = ReleaseAutomation::get_logger

    debug( "Begin ReleaseAutomation::Environment::initialize" )

    @config = _load_environment_yaml


    debug( "End ReleaseAutomation::Environment::initialize" )
  end

  private

  def _parse_config(text)
    YAML.load text
  end

  def _load_environment_yaml
    # TODO raise if this file doesn't exist
    config_file = ReleaseAutomation::get_build_environment_config_file
    config_text = File.read(config_file)
    _parse_config(config_text)
  end

end

require_relative 'env/build_env'
