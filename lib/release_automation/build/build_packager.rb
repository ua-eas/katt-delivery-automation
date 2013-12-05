class ReleaseAutomation::BuildRunner
	
	delegate :debug, :info, :warn, :error, :fatal, :log_to_stdout, to: :@logger

	attr_reader :build_environment

	def initialize
		@logger = ReleaseAutomation::get_logger
		@build_environment = _initialize_build_environment
	end

	def _initialize_build_environment
		ReleaseAutomation::get_build_environment
	end

	

end