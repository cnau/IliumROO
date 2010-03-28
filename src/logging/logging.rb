=begin
  This file is part of Ilium MUD.

  Ilium MUD is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Ilium MUD is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.
=end
$use_log4r = false

if $use_log4r
  require 'log4r'
  include Log4r
else
  require 'logger'
end

module Logging
  def who_am_i?
    "#{self.class.name} (\##{self.object_id})"
  end

  def setup_logging()
    if !@logger_setup
      @logger_setup = true
      if $use_log4r
        @logger = Logger.new("#{self.who_am_i?}")
        @logger.level = Logger::DEBUG
        @logger.outputters = Outputter.stdout
        @logger.outputters.each {|o| o.formatter = PatternFormatter.new(:pattern => "%-5l %c - %m")}
      else
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::DEBUG
        @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      end
    end
  end

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
end