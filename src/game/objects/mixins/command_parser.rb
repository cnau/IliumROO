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
    def process_command(player)
      # parse the command string
      command   = parse_to_words player.last_client_data
      verb      = command['verb']
      verbsym   = verb.to_sym unless verb.nil?
      verbalias = verb
      aliassym  = verbsym
      dobjstr   = command['direct_object']
      iobjstr   = command['indirect_object']
      prepstr   = command['preposition']
      prepsym   = prepstr.to_sym unless prepstr.nil?
      caller    = player
      #TODO: reimplement once room becomes something
      #room = player.room
      room = nil

      # locate objects
      dobj = locate_object(player, room, dobjstr)
      iobj = locate_object(player, room, iobjstr)

      if dobj.nil? then
        verb_args = dobjstr
        dobjstr = nil
      end

      # locate verb
      this = nil
      if test_verb(player, verbsym, prepsym)
        this = player
      elsif test_verb(room, verbsym, prepsym)
        this = room
      elsif test_verb(dobj, verbsym, prepsym)
        this = dobj
      elsif test_verb(iobj, verbsym, prepsym)
        this = iobj
      end

      # find alias
      aliassym = find_alias(this, verbsym)

      if this.nil? or verb.nil?
        huh player
      else
        ret = {}
        ret[:verb]     = verb
        ret[:verbsym]  = verbsym
        ret[:alias]    = aliassym.to_s
        ret[:aliassym] = aliassym
        ret[:dobjstr]  = dobjstr
        ret[:iobjstr]  = iobjstr
        ret[:prepstr]  = prepstr
        ret[:prepsym]  = prepsym
        ret[:player]   = player
        ret[:caller]   = caller
        ret[:dobj]     = dobj
        ret[:iobj]     = iobj
        ret[:args]     = verb_args

        this.set_command_args ret
        this.send ret[:alias]
      end
    end

    def huh(player)
      player.send_to_client "huh?\n"
    end

    def find_alias(obj_to_test, verbsym)
      return verbsym if obj_to_test.nil?
      verbs = obj_to_test.class.verbs
      return verbsym if verbs[verbsym].nil?
      if verbs.has_key? verbsym
        if verbs[verbsym].has_key? :alias
          return verbs[verbsym][:alias]
        end
      end
      verbsym
    end

    def test_verb(obj_to_test, verbsym, prepsym)
      return false if obj_to_test.nil?
      verbs = obj_to_test.class.verbs
      if verbs.has_key? verbsym
        if verbs[verbsym].nil?
          return true
        else
          if verbs[verbsym].has_key? :prepositions
            if verbs[verbsym][:prepositions].nil?
              return true
            else
              if verbs[verbsym][:prepositions].include? prepsym
                return true
              end
            end
          else
            return true
          end
        end
      end
      false
    end

    def locate_object(player, room, object_name)
      if object_name =="me"
        player

      elsif object_name == "here"
        room
        
      end
    end
    
	def parse_to_words(sentence)
      # make common replacements
      sentence.gsub! /^"/, "say"
      sentence.gsub! /^:/, "emote"
      # TODO reimplement eval
      #sentence.gsub! /^;/, "eval"

      # break up sentence
      matches = sentence.match(/\A([a-z][a-z_?!"]*)(?: ([a-z 0-9]+))?(?: (with|using|at|to|in front of|in|inside|into|on top of|on|onto|upon|out of|from inside|from|over|through|under|underneath|beneath|behind|beside|for|about|is|as|off|off of) ([a-z 0-9!?"]+))\Z|\A([a-z][a-z_?!]*) ([a-z 0-9?!"]+)\Z|\A([a-z][a-z_?!]*)\Z/)
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

    ret
  end

  module_function :process_command, :huh, :test_verb, :locate_object, :parse_to_words, :find_alias
  private :huh, :test_verb, :locate_object, :parse_to_words, :find_alias
end