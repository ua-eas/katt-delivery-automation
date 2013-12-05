require 'active_support/core_ext'
require 'log4r'
require 'git'
require 'java_properties'
require 'yaml'

module ReleaseAutomation

	def self.get_build_environment
    	@@build_environment ||= ReleaseAutomation::Environment::BuildEnvironment.new 
  	end

  	def self.get_build_environment_config_file
  		@@environment_config_file ||= 'config/environemnt.yaml'
  	end

  	def self.get_logger
    	@@logger ||= ReleaseAutomation::Logger.new 'ReleaseAutomation'
  	end

  	def self.set_build_environment_config_file(config_file_full_path)
  		@@environment_config_file = config_file_full_path
  	end

end

require_relative 'release_automation/logger'
require_relative 'release_automation/build'
require_relative 'release_automation/env'
require_relative 'release_automation/versioner'