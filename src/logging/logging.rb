=begin
Copyright (c) 2009-2012 Christian Nau

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end
$use_log4r = false

if $use_log4r
  require 'log4r'
  include Log4r
else
  require 'logger'
end

# Logging mixin. Include this module to set up any class with Logging capability
module Logging
  # formats a string to return a class name/object id for log entries
  def who_am_i?
    "#{self.class.name} (\##{self.object_id})"
  end

  # private method to configure the loggers
  def setup_logging
    unless @logger_setup
      @logger_setup = true
      if $use_log4r
        @logger = Logger.new("#{self.who_am_i?}")
        @logger.level = Logger::DEBUG
        @logger.outputters = Outputter.stdout
        @logger.outputters.each { |o| o.formatter = PatternFormatter.new(:pattern => '%-5l %c - %m') }
      else
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::DEBUG
        @logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      end
    end
  end

  def log
    setup_logging
    @logger
  end

  # log a debug message
  # [msg] the message to log
  def log_debug(msg)
    setup_logging
    if @logger.debug?
      if $use_log4r
        @logger.debug msg
      else
        @logger.debug(self.who_am_i?) {msg}
      end
    end
  end

  # log an info message
  # [msg] the message to log
  def log_info(msg)
    setup_logging
    if @logger.info?
      if $use_log4r
        @logger.info msg
      else
        @logger.info(self.who_am_i?) {msg}
      end
    end
  end

  # log a warning message
  # [msg] the message to log
  def log_warn(msg)
    setup_logging
    if @logger.warn?
      if $use_log4r
        @logger.warn msg
      else
        @logger.warn(self.who_am_i?) {msg}
      end
    end
  end

  # log an error message
  # [msg] the message to log
  def log_error(msg)
    setup_logging
    if @logger.error?
      if $use_log4r
        @logger.error msg
      else
        @logger.error(self.who_am_i?) {msg}
      end
    end
  end

  # log a fatal message
  # [msg] the message to log
  def log_fatal(msg)
    setup_logging
    if @logger.fatal?
      if $use_log4r
        @logger.fatal msg
      else
        @logger.fatal(self.who_am_i?) {msg}
      end
    end
  end

  private :setup_logging
end