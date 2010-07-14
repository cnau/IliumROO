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
require 'game_objects/game_object_loader'

module HumanoidBody
  PROPERTIES = [:left_finger, :right_finger, :neck_1, :neck_2, :body, :head, :legs, :feet, :hands, :arms, :about_body,
                :about_waist, :left_wrist, :right_wrist, :right_hand, :left_hand, :face, :left_ear, :right_ear].freeze

  DESC = {:left_hand  => "left hand", :right_hand   => "right hand",  :head         => "head",          :neck_1       => "around neck",   :neck_2       => "around neck",
          :body       => "on body",   :about_body   => "about body",  :arms         => "on arms",       :left_wrist   => "around wrist",  :right_wrist  => "around wrist",
          :hands      => "on hands",  :left_finger  => "left finger", :right_finger => "right finger",  :about_waist  => "about waist",   :legs         => "on legs",   
          :feet       => "on feet",   :left_ear     => "in left ear", :right_ear    => "in right ear",  :face         => "on face"}.freeze

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