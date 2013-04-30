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
require 'singleton'
require 'database/cassandra_dao'
require 'logging/logging'
require 'facets/hash/rekey'

# class to interact with "objects" and "object_tags" column families
class GameObjects
  include Singleton
  include Logging


  # gets a record from the 'objects' column family
  # [object_id] id of the object to retrieve
  def get(object_id)
    log.debug {"getting object #{object_id}"}
    obj = CassandraDao.get(:objects, object_id).to_h
    
    # convert hash to symbolic keys
    ret = obj.rekey {|k| k.to_sym}
    
    log.debug {"retrieved object #{ret}"}
    ret
  end

  # gets a record from the 'objects' column family
  # [object_id] id of the object to retrieve
  def self.get(object_id)
    GameObjects.instance.get object_id
  end

  # saves an object to the 'objects' column family
  # [object_id] object id to save
  # [object_hash] object data
  def save(object_id, object_hash)
    log.debug {"saving #{object_id} : #{object_hash}"}
    #convert hash to string keys
    to_insert = object_hash.rekey {|k| k.to_s}
    CassandraDao.insert :objects, object_id, to_insert
  end

  # saves an object to the 'objects' column family
  # [object_id] object id to save
  # [object_hash] object data
  def self.save(object_id, object_hash)
    GameObjects.instance.save object_id, object_hash
  end

  # removes an object from the database
  # [object_id] object id to remove
  def remove(object_id)
    log.debug {"removing #{object_id}"}
    CassandraDao.remove :objects, object_id
  end

  # removes an object from the database
  # [object_id] object id to remove
  def self.remove(object_id)
    GameObjects.instance.remove object_id
  end

  # retrieves an object tag for a given tag name and value
  # [tag_name] object tag name to retrieve
  # [val] specific tag to get
  def get_tag(tag_name, val)
    log.debug {"getting object tag #{tag_name} for #{val}"}
    tag = CassandraDao.get :object_tags, tag_name, val
    log.debug {"retrieved #{tag}"}
    tag
  end

  # retrieves an object tag for a given tag name and value
  # [tag_name] object tag name to retrieve
  # [val] specific tag to get
  def self.get_tag(tag_name, val)
    GameObjects.instance.get_tag tag_name, val
  end

  # retrieves all object tags for a given tag name
  # [tag_name] object tag name to retrieve
  def self.get_tags(tag_name)
    GameObjects.instance.get_tags tag_name
  end

  # retrieves all object tags for a given tag name
  # [tag_name] object tag name to retrieve
  def get_tags(tag_name)
    log.debug {"getting tags for #{tag_name}"}
    tags = CassandraDao.get :object_tags, tag_name
    log.debug {"retrieved #{tags}"}
    tags
  end

  # removes an object tag for a given tag name and value
  # [tag_name] object tag name to remove
  # [val] specific tag to remove
  def remove_tag(tag_name, val)
    log.debug {"removing object tag for #{tag_name} for #{val}"}
    CassandraDao.remove :object_tags, tag_name, val
  end

  # removes an object tag for a given tag name and value
  # [tag_name] object tag name to remove
  # [val] specific tag to remove
  def self.remove_tag(tag_name, val)
    GameObjects.instance.remove_tag tag_name, val
  end

  # adds an object tag for a given tag name and value
  # [tag_name] object tag name to add
  # [val] specific tag to add
  # [row_hash] row hash to add to tag
  def add_tag(tag_name, val, row_hash)
    log.debug {"adding object tag for #{tag_name} for #{val} : #{row_hash}"}
    CassandraDao.insert :object_tags, tag_name, {val => row_hash}
  end

  # adds an object tag for a given tag name and value
  # [tag_name] object tag name to add
  # [val] specific tag to add
  # [row_hash] row hash to add to tag
  def self.add_tag(tag_name, val, row_hash)
    GameObjects.instance.add_tag tag_name, val, row_hash
  end
end