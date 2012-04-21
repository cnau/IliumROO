#Copyright (c) 2009-2012 Christian Nau

#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:

#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Feature: test colorizer mixin
  As a telnet game I can colorize text using ANSI color codes
  So let's test the colorization algorithm

  Scenario: test colorize with a single color token and ANSI enabled
    Given a string to colorize with a single color token and ANSI codes
    When I colorize the string with display type "ANSI"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens and ANSI enabled
    Given a string to colorize with multiple color tokens and ANSI codes
    When I colorize the string with display type "ANSI"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens on the beginning and ending of the string with ANSI enabled
    Given a string to colorize with multiple color tokens on the end of the string and ANSI codes
    When I colorize the string with display type "ANSI"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with a single color token
    Given a string to colorize with a single color token
    When I colorize the string with display type "ASCII"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens
    Given a string to colorize with multiple color tokens
    When I colorize the string with display type "ASCII"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens on the beginning and ending of the string
    Given a string to colorize with multiple color tokens on the end of the string
    When I colorize the string with display type "ASCII"
    Then I should get appropriate color codes for that single token