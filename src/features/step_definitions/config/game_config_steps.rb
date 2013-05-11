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

require_relative '../spec_helper'

Given /^a new instance of game config$/ do
  @game_config = GameConfig.instance
end

When /^I check for the config hash$/ do
  @game_config.config.should_not be_nil
end

Then /^I should see the correct game hash$/ do
  conf_name = File.join(File.dirname(__FILE__), '../../../../game_properties.yaml')
  if File.exists? conf_name
    config = File.open(conf_name) { |yf| YAML::load(yf) }
  end

  @game_config.config.should eql config
end

Then /^I should see the correct entries in the index operator$/ do
  @game_config.config.each {|k,v|
    @game_config[k].should eql v
  }
end