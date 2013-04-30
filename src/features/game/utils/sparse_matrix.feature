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

Feature: test sparse matrix class
  As a multi user game, I need a sparse matrix to hold map data
  So let's test sparse matrix

  Scenario: test the sparse matrix overloaded set operator
    Given an instance of SparseMatrix
    When I add an object to a particular set of coordinates in a SparseMatrix
    Then that object should be in that location of the SparseMatrix

  Scenario: test multiple new objects in a sparse matrix
    Given an instance of SparseMatrix
    When I add an object to a first location in SparseMatrix
    And I add another object to a second location in SparseMatrix
    Then those objects should be in the correct locations of SparseMatrix

  Scenario: test enumerable capability of sparse matrix
    Given an instance of SparseMatrix
    When I add an object to a first location in SparseMatrix
    And I add another object to a second location in SparseMatrix
    Then I should be able to enumerate the list