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
module HumanoidBody
  PROPERTIES = [:left_finger, :right_finger, :neck_1, :neck_2, :body, :head, :legs, :feet, :hands, :arms, :about_body,
                :about_waist, :left_wrist, :right_wrist, :right_hand, :left_hand, :face, :left_ear, :right_ear].freeze

  DESC = {:left_hand  => 'left hand', :right_hand   => 'right hand',  :head         => 'head',          :neck_1       => 'around neck',   :neck_2       => 'around neck',
          :body       => 'on body',   :about_body   => 'about body',  :arms         => 'on arms',       :left_wrist   => 'around wrist',  :right_wrist  => 'around wrist',
          :hands      => 'on hands',  :left_finger  => 'left finger', :right_finger => 'right finger',  :about_waist  => 'about waist',   :legs         => 'on legs',
          :feet       => 'on feet',   :left_ear     => 'in left ear', :right_ear    => 'in right ear',  :face         => 'on face'}.freeze

  VERBS = {:eq => nil}

  def eq
    ret = "You are using:\n"
    ret << "<    worn     > Item Description\n\n"
    @slots.each do |key,value|
      ret << "<#{slot_desc(key)}>".ljust(15) << "\n"
    end
    @player.send_to_client ret
  end
  
  def setup_slots
    if @slots.nil?
      @slots ||= {}
      PROPERTIES.each do |prop|
        item = self.instance_variable_get("@#{prop}")
        if item.nil?
          @slots[prop] = nil
        else
          @slots[prop] = GameObjectLoader.load_object item.to_s
        end
      end
    end
  end

  def slot_available?(slot)
    @slots.has_key? slot
  end

  def slot_desc(slot)
    DESC[slot]
  end
end