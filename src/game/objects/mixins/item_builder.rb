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

module ItemBuilder
  VERBS = {:create => {:prepositions => [:as]}}.freeze

  def create
    # try to get the class for the new item
    new_item_c = GameObjectLoader.load_object @iobjstr
    if new_item_c.nil?
      @player.send_to_client "#{@iobjstr} is not a known Class.\n"

    elsif new_item_c.is_a? Class
      @player.send_to_client "creating #{@dobjstr} as #{new_item_c}\n"
      new_item_o = new_item_c.new

    else
      @player.send_to_client "#{@iobjstr} is an Object, not a Class.\n"
    end
  end
end