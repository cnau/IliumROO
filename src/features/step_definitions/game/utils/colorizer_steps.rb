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

Given /^a string to colorize with a single color token and ANSI codes$/ do
  @string_to_colorize = '[blue]blue text'
  @expected_string = '' << Colorizer::ESC << Colorizer::COLORS['blue'] << 'blue text'
end

When /^I colorize the string with display type "([^"]*)"$/ do |display_type|
  @colorized_string = Colorizer::colorize(@string_to_colorize, display_type)
  @colorized_string.should_not be_nil
end

Then /^I should get appropriate color codes for that single token$/ do
  @colorized_string.should eql @expected_string
end

Given /^a string to colorize with multiple color tokens and ANSI codes$/ do
  @string_to_colorize = '[blue]blue[white]white[normal]normal[cyan]cyan[back_red]back red'
  @expected_string = '' <<
      Colorizer::ESC << Colorizer::COLORS['blue']     << 'blue' <<
      Colorizer::ESC << Colorizer::COLORS['white']    << 'white' <<
      Colorizer::ESC << Colorizer::COLORS['normal']   << 'normal' <<
      Colorizer::ESC << Colorizer::COLORS['cyan']     << 'cyan' <<
      Colorizer::ESC << Colorizer::COLORS['back_red'] << 'back red'
end

Given /^a string to colorize with multiple color tokens on the end of the string and ANSI codes$/ do
  @string_to_colorize = '[blue][white][red]'
  @expected_string = '' <<
      Colorizer::ESC <<  Colorizer::COLORS['blue'] <<
      Colorizer::ESC << Colorizer::COLORS['white'] <<
      Colorizer::ESC << Colorizer::COLORS['red']
end

Given /^a string to colorize with a single color token$/ do
  @string_to_colorize = '[blue]blue text'
  @expected_string = '' << 'blue text'
end

Given /^a string to colorize with multiple color tokens$/ do
  @string_to_colorize = '[blue]blue[white]white[normal]normal[cyan]cyan[back_red]back red'
  @expected_string = '' << 'blue' << 'white' << 'normal' << 'cyan' << 'back red'
end

Given /^a string to colorize with multiple color tokens on the end of the string$/ do
  @string_to_colorize = '[blue][white][red]'
  @expected_string = ''
end