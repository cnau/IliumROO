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
require 'game/utils/sparse_matrix'

Given /^an instance of SparseMatrix$/ do
  @sparse_matrix = SparseMatrix.new
end

When /^I add an object to a particular set of coordinates in a SparseMatrix$/ do
  @sparse_matrix[0,0,0] = 'NEW STRING'
end

Then /^that object should be in that location of the SparseMatrix$/ do
  @sparse_matrix[0,0,0].should_not be_nil
  @sparse_matrix[0,0,0].should eql 'NEW STRING'
end

When /^I add an object to a first location in SparseMatrix$/ do
  @sparse_matrix[1,2,3] = 'NEW STRING 1'
end

When /^I add another object to a second location in SparseMatrix$/ do
  @sparse_matrix[3,2,1] = 'NEW STRING 2'
end

Then /^those objects should be in the correct locations of SparseMatrix$/ do
  @sparse_matrix[1,2,3].should_not be_nil
  @sparse_matrix[1,2,3].should eql 'NEW STRING 1'
  @sparse_matrix[3,2,1].should_not be_nil
  @sparse_matrix[3,2,1].should eql 'NEW STRING 2'
end

Then /^I should be able to enumerate the list$/ do
  @sparse_matrix.each {|k,v|
    @sparse_matrix[*k].should eql v
  }
end