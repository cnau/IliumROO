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
$: << File.expand_path(File.dirname(__FILE__) + '/../../')

require 'features/step_definitions/spec_helper.rb'
require 'game/objects/basic_game_object'
require 'game/objects/mixins/container'

class ContainerTester < BasicGameObject
  include Container

  def contents
    @contents
  end
end

Given /^a new basic game object with container mixin$/ do
  @container_tester = ContainerTester.new
  @container_tester.game_object_id = 'TestContainer'
end

When /^I add the object to itself$/ do
  begin
    @container_tester.add_to_container @container_tester
  rescue Exception => ex
    @got_exception = true
  end
end

Then /^I should have received an exception$/ do
  @got_exception.should be_true
end

When /^I add an object to the container "([^"]*)"$/ do |container|
  @test_object = BasicGameObject.new
  GameObjects.expects(:add_tag).with("#{@container_tester.game_object_id}_#{container.to_s}", @test_object.game_object_id, {'object_id' => @test_object.game_object_id})
  @container_tester.add_to_container @test_object, container
end

Then /^the contents of the "([^"]*)" container should contain the new object$/ do |container|
  @container_tester.contents["#{@container_tester.game_object_id}_#{container}"].should include @test_object.game_object_id
  @container_tester.contents["#{@container_tester.game_object_id}_#{container}"][@test_object.game_object_id].should_not be_nil
  @container_tester.contents["#{@container_tester.game_object_id}_#{container}"][@test_object.game_object_id].should eql @test_object
end

When /^I add an object to the container "([^"]*)" with additional data "([^"]*)"$/ do |container, additional|
  @test_object = BasicGameObject.new
  GameObjects.expects(:add_tag).with("#{@container_tester.game_object_id}_#{container.to_s}", @test_object.game_object_id, is_a(Hash)) { |container, object_id, tag_hash| @tag_hash = tag_hash }
  @container_tester.add_to_container @test_object, container, {'additional' => additional}
end

Then /^the additional data of "([^"]*)" should have been saved$/ do |additional|
  @tag_hash.should_not be_nil
  @tag_hash.should include 'object_id'
  @tag_hash['object_id'].should eql @test_object.game_object_id

  @tag_hash.should include 'additional'
  @tag_hash['additional'].should eql additional
end

Then /^the list_contents function for container "([^"]*)" should contain additional data "([^"]*)"$/ do |container, additional|
  GameObjects.expects(:get_tags).once.with("#{@container_tester.game_object_id}_#{container.to_s}").returns({@test_object.game_object_id => {'object_id' => @test_object.game_object_id, 'additional' => additional}})
  @container_tester.list_container container
  # no need for checks here since the return is mocked and if the call isn't made to GameObjects.get_tags, then mocha will fail the test
end

When /^I remove an object from the container "([^"]*)"$/ do |container|
  GameObjects.expects(:remove_tag).once.with("#{@container_tester.game_object_id}_#{container.to_s}", @test_object.game_object_id)
  @container_tester.remove_from_container @test_object, container
end

Then /^the object should have been removed from the container "([^"]*)"$/ do |container|
  @container_tester.contents["#{@container_tester.game_object_id}_#{container}"].should_not include @test_object.game_object_id
end

When /^I add several persistent objects to the container "([^"]*)"$/ do |container|
  container_name = "#{@container_tester.game_object_id}_#{container.to_s}"
  @persistent_objects = []
  tag_hash = {}
  (0..4).each do |x|
    new_obj = BasicPersistentGameObject.new
    GameObjects.expects(:save).with(new_obj.game_object_id, new_obj.to_h)
    new_obj.save
    @persistent_objects << new_obj

    GameObjects.expects(:add_tag).with(container_name, new_obj.game_object_id, is_a(Hash))
    @container_tester.add_to_container new_obj, container
    GameObjects.expects(:get).with(new_obj.game_object_id).returns(new_obj.to_h)

    tag_hash[new_obj.game_object_id] = {'object_id' => new_obj.game_object_id}
  end
  GameObjects.expects(:get_tags).with(container_name).returns tag_hash
end

When /^I call the load_contents method for container "([^"]*)"$/ do |container|
  @container_tester.load_container container
end

Then /^each of the persistent objects should have been loaded and stored in container "([^"]*)"$/ do |container|
  container_name = "#{@container_tester.game_object_id}_#{container}"
  @container_tester.contents.should_not be_nil
  @container_tester.contents[container_name].should_not be_nil
  @container_tester.contents[container_name].size.should eql @persistent_objects.size
  @persistent_objects.each { |obj|
    game_object_id = obj.is_a?(BasicGameObject) ? obj.game_object_id : obj
    @container_tester.contents[container_name].should have_key game_object_id
    @container_tester.contents[container_name][game_object_id].should_not be_nil
  }
end

When /^I add an object to the container "([^"]*)" with only the game object id$/ do |container|
  @test_object = BasicGameObject.new
  GameObjects.expects(:add_tag).with("#{@container_tester.game_object_id}_#{container.to_s}", @test_object.game_object_id, is_a(Hash)) { |container, object_id, tag_hash| @tag_hash = tag_hash }
  @container_tester.add_to_container @test_object.game_object_id, container
end

Then /^the contents of the "([^"]*)" container should contain the game object id$/ do |container|
  @container_tester.contents.should_not be_nil
  @container_tester.contents["#{@container_tester.game_object_id}_#{container.to_s}"].should_not be_nil
  @container_tester.contents["#{@container_tester.game_object_id}_#{container.to_s}"].should have_key @test_object.game_object_id
  @container_tester.contents["#{@container_tester.game_object_id}_#{container.to_s}"][@test_object.game_object_id].should_not be_nil
  @container_tester.contents["#{@container_tester.game_object_id}_#{container.to_s}"][@test_object.game_object_id].should have_key 'object_id'
  @container_tester.contents["#{@container_tester.game_object_id}_#{container.to_s}"][@test_object.game_object_id]['object_id'].should eql @test_object.game_object_id
end

When /^I add several persistent objects to the container "([^"]*)" via game object ids$/ do |container|
  container_name = "#{@container_tester.game_object_id}_#{container.to_s}"
  @persistent_objects = []
  tag_hash = {}
  (0..4).each do |x|
    new_obj = BasicPersistentGameObject.new
    GameObjects.expects(:save).with(new_obj.game_object_id, new_obj.to_h)
    new_obj.save
    @persistent_objects << new_obj.game_object_id

    GameObjects.expects(:add_tag).with(container_name, new_obj.game_object_id, is_a(Hash))
    @container_tester.add_to_container new_obj, container
    GameObjects.expects(:get).with(new_obj.game_object_id).returns(new_obj.to_h)

    tag_hash[new_obj.game_object_id] = {'object_id' => new_obj.game_object_id}
  end
  GameObjects.expects(:get_tags).with(container_name).returns tag_hash
end

When /^I remove an object from the container "([^"]*)" with only the game object id$/ do |container|
  GameObjects.expects(:remove_tag).once.with("#{@container_tester.game_object_id}_#{container.to_s}", @test_object.game_object_id)
  @container_tester.remove_from_container @test_object.game_object_id, container
end