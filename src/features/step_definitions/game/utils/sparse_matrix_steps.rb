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

$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require 'game/utils/sparse_matrix'

Given /^an instance of SparseMatrix$/ do
  @sparse_matrix = SparseMatrix.new
end

When /^I add an object to a particular set of coordinates in a SparseMatrix$/ do
  @sparse_matrix[0,0,0] = "NEW STRING"
end

Then /^that object should be in that location of the SparseMatrix$/ do
  @sparse_matrix[0,0,0].should_not be_nil
  @sparse_matrix[0,0,0].should eql "NEW STRING"
end

When /^I add an object to a first location in SparseMatrix$/ do
  @sparse_matrix[1,2,3] = "NEW STRING 1"
end

When /^I add another object to a second location in SparseMatrix$/ do
  @sparse_matrix[3,2,1] = "NEW STRING 2"
end

Then /^those objects should be in the correct locations of SparseMatrix$/ do
  @sparse_matrix[1,2,3].should_not be_nil
  @sparse_matrix[1,2,3].should eql "NEW STRING 1"
  @sparse_matrix[3,2,1].should_not be_nil
  @sparse_matrix[3,2,1].should eql "NEW STRING 2"
end