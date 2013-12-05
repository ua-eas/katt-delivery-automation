class ReleaseAutomation::Logger
  include Log4r

  attr_accessor :job_stream_file, :log4r_logger

  delegate :debug, :info, :warn, :error, :fatal, to: :@log4r_logger

  # Create a new Logger that will initially log to STDOUT. We may want to change this later.
  def initialize(logger_name)
    
    @log4r_logger = Logger.new logger_name
    outputter = Outputter.stdout
    @time_formatter  = PatternFormatter.new(:pattern => "%d (%l) %m", :date_pattern => "%H:%M:%S")
    outputter.formatter = @time_formatter
    @log4r_logger.add(outputter)
  end

  def log_to_stdout
    job_stream_stdout_outputter = StdoutOutputter.new('console')
    job_stream_stdout_outputter.formatter = @short_formatter
    @log4r_logger.add(job_stream_stdout_outputter)
  end
end
