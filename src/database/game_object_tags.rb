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

# class to interact with "object_tags" column families
class GameObjectTags
  include Logging

  COLUMNFAMILY_NAME = 'game_object_tags'

  def valid?
    @valid
  end

  def initialize(cql_dao = nil)
    @cql_dao = cql_dao
    if !validate_database
      build_database
    end
  end

  def build_database
    log.debug { "creating columnfamily #{COLUMNFAMILY_NAME}" }
    # no columnfamily, so create one
    @cql_dao.execute "CREATE TABLE #{COLUMNFAMILY_NAME} (name varchar PRIMARY KEY, objects set<text>)"
    @valid = true
  end

  def validate_database
    @valid = false
    result = @cql_dao.execute "SELECT columnfamily_name FROM system.schema_columnfamilies WHERE keyspace_name = '#{@cql_dao.keyspace}' AND columnfamily_name = '#{COLUMNFAMILY_NAME}'"
    @valid = !(result.nil? or result.empty?)
    @valid
  end
end