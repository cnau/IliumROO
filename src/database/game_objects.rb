#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.
require 'singleton'
require 'database/cassandra_dao'
require 'logging/logging'

# class to interact with "objects" and "object_tags" column families
class GameObjects
  include Singleton
  include Logging

  # gets a record from the 'objects' column family
  # [object_id] id of the object to retrieve
  def get(object_id)
    log_debug "getting object #{object_id}"
    obj = CassandraDao.get :objects, object_id
    log_debug "retrieved object #{obj}"
    obj
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
    log_debug "saving #{object_id} : #{object_hash}"
    CassandraDao.insert :objects, object_id, object_hash
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
    log_debug "removing #{object_id}"
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
    log_debug "getting object tag #{tag_name} for #{val}"
    tag = CassandraDao.get :object_tags, tag_name, val
    log_debug "retrieved #{tag}"
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
    log_debug "getting tags for #{tag_name}"
    tags = CassandraDao.get :object_tags, tag_name
    log_debug "retrieved #{tags}"
    tags
  end

  # removes an object tag for a given tag name and value
  # [tag_name] object tag name to remove
  # [val] specific tag to remove
  def remove_tag(tag_name, val)
    log_debug "removing object tag for #{tag_name} for #{val}"
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
    log_debug "adding object tag for #{tag_name} for #{val} : #{row_hash}"
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