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

# class to interact with "objects" column families
class GameObjects
  include Logging

  COLUMNFAMILY_NAME = 'game_objects'

  def convert_rowproperties_to_hash(row)
    ret = {}
    row['properties'].each {|k,v|
      ret[k.to_sym] = v.to_s
    }
    ret
  end

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
    @cql_dao.execute "CREATE TABLE #{COLUMNFAMILY_NAME} (id varchar PRIMARY KEY, properties map<text,text>, contents set<text>)"
    @valid = true
  end

  def validate_database
    @valid = false
    result = @cql_dao.execute "SELECT columnfamily_name FROM system.schema_columnfamilies WHERE keyspace_name = '#{@cql_dao.keyspace}' AND columnfamily_name = '#{COLUMNFAMILY_NAME}'"
    @valid = !(result.nil? or result.empty?)
    @valid
  end

  # gets a record from the 'objects' column family
  # [object_id] id of the object to retrieve
  def get(object_id)
    log.debug { "getting object #{object_id}" }
    rows = @cql_dao.execute "SELECT * FROM #{COLUMNFAMILY_NAME} WHERE id = '#{object_id}'"
    ret = convert_rowproperties_to_hash rows.first

    log.debug { "retrieved object #{ret}" }
    ret
  end

  # saves an object to the 'objects' column family
  # [object_id] object id to save
  # [object_hash] object data
  def save(object_id, object_hash)
    log.debug { "saving #{object_id} : #{object_hash}" }
    #convert hash to string keys
    sql = "INSERT INTO #{COLUMNFAMILY_NAME} (id, properties) VALUES ('#{object_id}', {"
    props = ''
    object_hash.each {|k,v|
      props += ',' unless props.empty?
      props += "'#{k.to_s}' : '#{v}'"
    }
    sql = sql + props + '})'
    puts sql
    @cql_dao.execute sql
  end

  # removes an object from the database
  # [object_id] object id to remove
  def remove(object_id)
    log.debug { "removing #{object_id}" }
    @cql_dao.execute "DELETE FROM #{COLUMNFAMILY_NAME} WHERE id = '#{object_id}'"
  end

  # retrieves an object tag for a given tag name and value
  # [tag_name] object tag name to retrieve
  # [val] specific tag to get
  def get_tag(tag_name, val)
    log.debug { "getting object tag #{tag_name} for #{val}" }
    tag = CassandraDao.get :object_tags, tag_name, val
    log.debug { "retrieved #{tag}" }
    tag
  end

  # retrieves all object tags for a given tag name
  # [tag_name] object tag name to retrieve
  def get_tags(tag_name)
    log.debug { "getting tags for #{tag_name}" }
    tags = CassandraDao.get :object_tags, tag_name
    log.debug { "retrieved #{tags}" }
    tags
  end

  # removes an object tag for a given tag name and value
  # [tag_name] object tag name to remove
  # [val] specific tag to remove
  def remove_tag(tag_name, val)
    log.debug { "removing object tag for #{tag_name} for #{val}" }
    CassandraDao.remove :object_tags, tag_name, val
  end

  # adds an object tag for a given tag name and value
  # [tag_name] object tag name to add
  # [val] specific tag to add
  # [row_hash] row hash to add to tag
  def add_tag(tag_name, val, row_hash)
    log.debug { "adding object tag for #{tag_name} for #{val} : #{row_hash}" }
    CassandraDao.insert :object_tags, tag_name, {val => row_hash}
  end
end