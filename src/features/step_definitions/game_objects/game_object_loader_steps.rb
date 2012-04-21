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
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require 'features/step_definitions/spec_helper.rb'
require 'database/game_objects'
require 'game_objects/game_object_loader'
require 'game/objects/basic_game_object'
require 'mocha'

Given /^a mock class setup$/ do
  obj_hash = {:game_object_id => 'test_class_1',
              :super          => 'BasicGameObject',
              :mixins         => 'Logging',
              :properties     => 'game_object_id,foo,bar,foo_text,foo_obj',
              :foo_bar        => 'self.foo + self.bar',
              :foo_log        => 'log.info "some info"'}#,
              #:foo_m(param)   => 'log.info param'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('test_class_1').returns(obj_hash)
end

When /^I load test class object$/ do
  @obj_c = GameObjectLoader.load_object 'test_class_1'
  @obj_c.should_not be_nil
end

Then /^I verify class structure$/ do
  @obj_c.superclass.name.should eql 'BasicGameObject'
  @obj_c.public_instance_methods.should include :foo
  @obj_c.public_instance_methods.should include :bar
  @obj_c.public_instance_methods.should include :game_object_id
  @obj_c.public_instance_methods.should include :foo_bar
  @obj_c.public_instance_methods.should include :foo_log
  @obj_c.public_instance_methods.should include :foo_obj
  @obj_c.included_modules.should include Logging
end

And /^a mock object setup$/ do
  obj_hash = {:game_object_id   => 'test_object_1',
              :parent           => 'test_class_1',
              :foo              => '1',
              :bar              => '2',
              :foo_text         => 'some text',
              :foo_obj          => '$${BasicGameObject}.new'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('test_object_1').returns(obj_hash)
end

And /^I load test object$/ do
  @obj = GameObjectLoader.load_object 'test_object_1'
  @obj.should_not be_nil
end

Then /^I verify object structure$/ do
  @obj.game_object_id.should eql 'test_object_1'
  @obj.should be_an_instance_of @obj_c
  @obj.foo.should eql 1
  @obj.bar.should eql 2
  @obj.foo_bar.should eql 3
  @obj.foo_text.should eql 'some text'
  @obj.foo_obj.should be_an_instance_of BasicGameObject
end