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

Feature: test the MapLocation mixin
  As a multi-user game I have map and players
  So I need to test that the players keep track of their own location

  Scenario: test the location setting function with an object
    Given a new object with MapLocation mixin
    When I set the location to an object
    Then the location should be an object

  Scenario: test the location setting function with a string
    Given a new object with MapLocation mixin
    When I set the location to a string representation of an object
    Then the location should be an object

  Scenario: test the map setting function with a string
    Given a new object with MapLocation mixin
    When I set the map property to a string
    Then the map property should be set

  Scenario: test the map setting function with an object
    Given a new object with MapLocation mixin
    When I set the map property to a basic game object
    Then the map property should be set to the object
