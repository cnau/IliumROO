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
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "../spec/spec_helper.rb"
require "game_objects/game_object_loader"
require "game_objects/basic_persistent_game_object"

describe "Persistent Game Object" do
  it "should create a new persistent object class" do
    obj_hash = {'game_object_id'=> 'test_class_1',
                'super'         => 'BasicPersistentGameObject',
                'properties'    => 'foo,bar,foo_text'}

    # setup mock game object to prevent database hit
    GameObjects.expects(:get).with('test_class_1').once.returns(obj_hash)

    obj_c = GameObjectLoader.load_object 'test_class_1'

    obj_c.nil?.should == false
    obj_c.superclass.should == BasicPersistentGameObject
    obj_c.properties.sort.eql?([:game_object_id, :foo, :bar, :foo_text, :parent].sort).should == true
  end

  it "should create a new persistent object instance" do
    obj_hash = {'game_object_id'  => 'test_object_1',
                'parent'          => 'test_class_1',
                'foo'             => '1',
                'bar'             => '2',
                'foo_text'        => 'some text'}

    # setup mock game object to prevent database hit
    GameObjects.expects(:get).with('test_object_1').once.returns(obj_hash)

    obj = GameObjectLoader.load_object 'test_object_1'

    obj.nil?.should == false
    obj.is_a?(BasicPersistentGameObject).should == true
    obj.to_hash.eql?({:game_object_id=>"test_object_1", :foo=>"1", :bar=>"2", :foo_text=>"some text", :parent=>"test_class_1"}).should == true
  end

  it "should save a new persistent object instance" do
    obj_hash = {'game_object_id'  => 'test_object_2',
                'parent'          => 'test_class_1',
                'foo'             => '1',
                'bar'             => '2',
                'foo_text'        => 'some text'}

    # setup mock game object to prevent database hit
    GameObjects.expects(:get).with('test_object_2').once.returns(obj_hash)
    GameObjects.expects(:save).with('test_object_2', {:foo => '1', :bar => '2', :foo_text => 'some text', :game_object_id => 'test_object_2', :parent => 'test_class_1'}).once

    obj = GameObjectLoader.load_object 'test_object_2'
    obj.nil?.should == false
    obj.is_a?(BasicPersistentGameObject).should == true
    
    obj.save
  end

  it "should create a new instance of a game object class" do
    obj_hash = {'game_object_id'=> 'test_class_2',
                'super'         => 'BasicPersistentGameObject',
                'properties'    => 'foo,bar,foo_text'}

    GameObjects.expects(:get).with('test_class_2').returns(obj_hash)
    GameObjects.expects(:get).with(regexp_matches(/^[a-z0-9]{6}$/)).at_least_once.returns({})

    obj_c = GameObjectLoader.load_object 'test_class_2'
    obj_c.nil?.should == false
    obj_c.is_a?(Class).should == true

    new_obj = obj_c.new
    new_obj.nil?.should == false
    new_obj.is_a?(obj_c).should == true

    new_obj.foo = 5
    new_obj.bar = 6

    GameObjects.expects(:save).with(new_obj.game_object_id, {:foo => '5', :bar => '6', :foo_text => '', :game_object_id => new_obj.game_object_id, :parent => 'test_class_2'}).once
    new_obj.save
  end
end