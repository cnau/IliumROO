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

require_relative '../../spec_helper'

Given /^a persistent game object instance$/ do
  @persistent_obj_0 = BasicPersistentGameObject.new
  @persistent_obj_0.should_not be_nil
end

Then /^parent should be BasicPersistentGameObject$/ do
  @persistent_obj_0.parent.should eql 'BasicPersistentGameObject'
end

Given /^a mocked persistent class$/ do
  obj_hash = {:game_object_id   => 'persistent_class_1',
              :super            => 'BasicPersistentGameObject',
              :properties       => 'foo,bar,foo_text'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_class_1').returns(obj_hash)
end

When /^I request the persistent class$/ do
  @persistent_obj_c_1 = GameObjectLoader.load_object 'persistent_class_1'
  @persistent_obj_c_1.should_not be_nil
end

Then /^I get the correct class object$/ do
  @persistent_obj_c_1.superclass.should be BasicPersistentGameObject
  @persistent_obj_c_1.properties.should include :foo
  @persistent_obj_c_1.properties.should include :bar
  @persistent_obj_c_1.properties.should include :foo_text
end

Given /^a mocked persistent object$/ do
  obj_hash = {:game_object_id   => 'persistent_object_1',
              :parent           => 'persistent_class_1',
              :foo              => '1',
              :bar              => '2',
              :foo_text         => 'some text'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_object_1').once.returns(obj_hash)
end

When /^I request a new persistent object$/ do
  @persistent_obj_1 = GameObjectLoader.load_object 'persistent_object_1'
  @persistent_obj_1.should_not be_nil
end

Then /^I get the correct persistent object$/ do
  @persistent_obj_1.should be_a_kind_of BasicPersistentGameObject
  @persistent_obj_1.parent.should eql 'persistent_class_1'
  
  obj_hash = @persistent_obj_1.to_h

  obj_hash.should have_key :game_object_id
  obj_hash[:game_object_id].should eql 'persistent_object_1'

  obj_hash.should have_key :foo
  obj_hash[:foo].should eql '1'

  obj_hash.should have_key :bar
  obj_hash[:bar].should eql '2'

  obj_hash.should have_key :foo_text
  obj_hash[:foo_text].should eql 'some text'

  obj_hash.should have_key :parent
  obj_hash[:parent].should eql 'persistent_class_1'
end

Given /^a mocked persistent object to save$/ do
  obj_hash = {:game_object_id   => 'persistent_object_2',
              :parent           => 'persistent_class_1',
              :foo              => '1',
              :bar              => '2',
              :foo_text         => 'some text'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_object_2').once.returns(obj_hash)
end

Given /^a mocked save database function$/ do
  GameObjects.expects(:save).with('persistent_object_2', is_a(Hash)) {|object_id, obj_hash| @object_hash_2 = obj_hash}
end

When /^I load a persistent object instance$/ do
  @persistent_obj_2 = GameObjectLoader.load_object 'persistent_object_2'
  @persistent_obj_2.should_not be_nil
  @persistent_obj_2.should be_a_kind_of BasicPersistentGameObject
end

When /^I save a persistent object instance$/ do
  @persistent_obj_2.save
end

Then /^the object should save$/ do
  @object_hash_2.should include :game_object_id
  @object_hash_2[:game_object_id].should eql 'persistent_object_2'
end

Given /^a mocked persistent class 2$/ do
  obj_hash = {:game_object_id   => 'persistent_class_2',
              :super            => 'BasicPersistentGameObject',
              :properties       => 'foo,bar,foo_text'}

  GameObjects.expects(:get).with('persistent_class_2').returns(obj_hash)
end

Given /^a mocked save function 2$/ do
  GameObjects.expects(:save).with(@persistent_obj_3.game_object_id, {:foo => '5', :bar => '6', :foo_text => '', :parent => 'persistent_class_2', :game_object_id => @persistent_obj_3.game_object_id}).once
end

When /^I load a persistent class 2$/ do
  @persistent_obj_c_2 = GameObjectLoader.load_object 'persistent_class_2'
  @persistent_obj_c_2.should_not be_nil
  @persistent_obj_c_2.should be_a Class
end

When /^I create an object instance from persistent class 2$/ do
  @persistent_obj_3 = @persistent_obj_c_2.new
  @persistent_obj_3.should_not be_nil
  @persistent_obj_3.should be_an_instance_of @persistent_obj_c_2
end

When /^I change some properties in persistent object$/ do
  @persistent_obj_3.foo = 5
  @persistent_obj_3.bar = 6
end

When /^I save the persistent object 2$/ do
  @persistent_obj_3.save
end

Then /^the object should save 2$/ do
  #NOOP mocha will complain if the properties aren't set properly
end

Given /^a mocked persistent object 3$/ do
  obj_hash = {:game_object_id  => 'persistent_object_3',
              :parent          => 'BasicPersistentGameObject'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_object_3').once.returns(obj_hash)
end

Given /^a mocked recycle database function 3$/ do
  GameObjects.expects(:add_tag).with('recycled', 'persistent_object_3', {'object_id' => 'persistent_object_3'}).once
end

When /^I load a persistent object instance 3$/ do
  @persistent_obj_3 = GameObjectLoader.load_object 'persistent_object_3'
  @persistent_obj_3.should_not be_nil
  @persistent_obj_3.should be_a_kind_of BasicPersistentGameObject
end

When /^I recycle a persistent object instance 3$/ do
  @persistent_obj_3.recycle
end

Then /^the object should recycle$/ do
  #NOOP mocha complains if database function isn't hit
end