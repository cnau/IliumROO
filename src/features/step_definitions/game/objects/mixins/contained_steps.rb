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
require 'game/objects/basic_persistent_game_object'
require 'game/objects/mixins/contained'

class ContainedObject < BasicPersistentGameObject
  include Contained
end

Given /^a mocked persistent object with contained mixin$/ do
  klass_hash = {:container=>'container_id', :parent=>'ContainedObject', :game_object_id=>'contained_id'}
  GameObjects.expects(:get).with('contained_id').returns(klass_hash) {|obj_id| obj_id == 'contained_id'}
end

When /^I load the mocked object$/ do
  @contained_obj = GameObjectLoader.load_object('contained_id')
  @contained_obj.should_not be_nil
  @contained_obj.is_a?(Contained).should be_true
end

Then /^I should see the container set properly$/ do
  @contained_obj.container.should_not be_nil
  @contained_obj.container.should eql 'container_id'
end

Given /^a new contained object instance$/ do
  @contained_obj = ContainedObject.new
  @contained_obj.should_not be_nil
end

When /^I set the container$/ do
  new_tag_hash = {'object_id' => @contained_obj.game_object_id, 'container' => 'container_id'}
  GameObjects.expects(:add_tag).once.with('contained', @contained_obj.game_object_id, new_tag_hash) {|tag_name, contained_id, tag_hash| tag_name == 'contained' and contained_id == @contained_obj.game_object_id and tag_hash == new_tag_hash}
  @contained_obj.container = 'container_id'
end

When /^I set the container to nil$/ do
  GameObjects.expects(:remove_tag).once.with('contained', @contained_obj.game_object_id) {|tag_name, contained_id| tag_name == 'contained' and contained_id == @contained_obj.game_object_id}
  @contained_obj.container = nil
end

Then /^I should see a nil container$/ do
  @contained_obj.container.should be_nil
end