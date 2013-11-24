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
require 'cql'

class CQLDao
  include Singleton
  include Logging

  def initialize
    if (!GameConfig.instance.config.nil?) && (!GameConfig.instance.config.empty?) && (!GameConfig.instance.config['cassandra'].nil?) && (!GameConfig.instance.config['cassandra'].empty?)
      keyspace = GameConfig.instance['cassandra']['keyspace']
      server = GameConfig.instance['cassandra']['server']
      port = GameConfig.instance['cassandra']['cql_port']
    else
      keyspace = 'IliumROO'
      server = 'localhost'
      port = '9042'
    end
    log.info { "attaching to cassandra server: #{keyspace}@#{server}:#{port}" }
    @dao = Cql::Client.connect({:host => server, :port => port})
  end

  def connected?
    @dao.connected?
  end

  def self.connected?
    CQLDao.instance.connected?
  end

  def execute(cql, options)
    @dao.execute cql, options
  end

  def self.execute(cql, options)
    CQLDao.instance.execute cql, options
  end
end