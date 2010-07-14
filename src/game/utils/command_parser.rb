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
module CommandParser
    def process_command(sentence)
      # parse the command string
      @command = parse_to_words sentence
      @verb = @command['verb']
      @verbsym = @verb.to_sym
      @dobjstr = @command['direct_object']
      @iobjstr = @command['indirect_object']
      @prepstr = @command['preposition']
      @prepsym = @prepstr.to_sym unless @prepstr.nil?
      @player = self
      @caller = self

      # locate objects
      @dobj = locate_object(@player, @player.room, @command['direct_object'])
      @iobj = locate_object(@player, @player.room, @command['indirect_object'])

      # locate verb
      @this = nil
      if test_verb(@player)
        @this = @player
      elsif test_verb(@room)
        @this = @room
      elsif test_verb(@dobj)
        @this = @dobj
      elsif test_verb(@iobj)
        @this = @iobj
      end

      @this.send @verb unless @this.nil?
      huh if @this.nil?
    end

    def huh
      @player.send_to_client "huh?\n"
    end

    def test_verb(obj_to_test)
      return false if obj_to_test.nil?
      verbs = obj_to_test.class.verbs
      if verbs.has_key? @verbsym
        if verbs[@verbsym].nil?
          return true
        else
          if verbs[@verbsym].has_key? :prepositions
            if verbs[@verbsym][:prepositions].nil?
              return true
            else
              if verbs[@verbsym][:prepositions].has_key? @prepsym
                return true
              end
            end
          else
            return true
          end
        end
      end

      return false
    end

    def locate_object(player, room, object_name)
      if object_name =="me"
        return player

      elsif object_name == "here"
        return room
        
      end
    end
    
	def parse_to_words(sentence)
      # make common replacements
      sentence.gsub! /^"/, "say"
      sentence.gsub! /^:/, "emote"
      sentence.gsub! /^;/, "eval"

      # break up sentence
      matches = sentence.match(/\A([a-z][a-z_?]*)(?: ([a-z ]+))?(?: (with|using|at|to|in front of|in|inside|into|on top of|on|onto|upon|out of|from inside|from|over|through|under|underneath|beneath|behind|beside|for|about|is|as|off|off of) ([a-z ]+))\Z|\A([a-z][a-z_?]*) ([a-z ]+)\Z|\A([a-z][a-z_?]*)\Z/i)
      matches = matches.to_a
      matches.delete_at 0

      # assign each sentence part to return hash
      ctr = -1
      sentence_parts = ['verb', 'direct_object', 'preposition', 'indirect_object']
      parts = {}
      matches.each do |item|
        unless item.nil? and ctr == -1
          ctr += 1
        end
        if ctr != -1
          parts[sentence_parts[ctr]] = item unless item.nil?
        end
    end

    # remove common words
    ret = {}
    parts.each do |key,value|
      vals = value.split(" ")
      vals.delete_if {|item|
        item == "the" or item == "a" or item == "an"
      }
      ret[key] = vals.join(" ")
    end

    return ret
  end
end