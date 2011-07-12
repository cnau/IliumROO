#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.

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