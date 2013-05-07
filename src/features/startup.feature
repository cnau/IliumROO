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

Feature: startup tester
  As a game I need to startup
  So I will test my startup code

  Scenario: test startup with no game or map created yet and no config properties set
    Given a mocked game config object with startup map of "" and room of ""
    And a mocked object tag indicating no previous game object created
    And a mocked game object
    When I start the game
    Then I should get map of type "BasicContinuousMap" and room of "[0,0,0]" created
    And I should get game of type "Game" and port list of "6666" created

  Scenario: test startup with no game or map created yet and config properties set
    Given a mocked game config object with startup map of "BasicContinuousMap" and room of "[0,1,0]"
    And a mocked object tag indicating no previous game object created
    And a mocked game object
    When I start the game
    Then I should get map of type "BasicContinuousMap" and room of "[0,1,0]" created
    And I should get game of type "Game" and port list of "6666" created
