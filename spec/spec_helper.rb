$LOAD_PATH.push File.dirname(__FILE__) + '/../rails/init'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib/swiss_tournament'
$LOAD_PATH.push File.dirname(__FILE__) + '/include'

require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => 'spec/test.sqlite3'
})

require 'factories'
require 'schema'

RSpec::Matchers.define :include_match_between_players do |players|
  match do |container|
    diffable
    
    included = false
    container.each do |potential_match_match|
      if ( potential_match_match.player1_id == players[0].id and
           potential_match_match.player2_id == players[1].id ) or
         ( potential_match_match.player1_id == players[1].id and
           potential_match_match.player2_id == players[0].id )
        included = true
      end
    end

    included
  end
end

RSpec::Matchers.define :have_unique_matchups do
  match do |container|
    all_matchups_are_unique = true

    for i in 0..(container.size-1)
      for j in 0..(container.size-1)
        unless i == j
          if all_matchups_are_unique and (
             ( container[i].player1 == container[j].player1 and
               container[i].player2 == container[j].player2 ) or
             ( container[i].player1 == container[j].player2 and
               container[i].player2 == container[j].player1 ))
            all_matchups_are_unique = false
require 'pp'
pp 'non-unique matchup:'
pp container[i]
pp container[j]
          end
        end
      end
    end

    all_matchups_are_unique
  end
end
