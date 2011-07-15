$LOAD_PATH.push File.dirname(__FILE__) + '/../rails/init'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib/swiss_tournament'
$LOAD_PATH.push File.dirname(__FILE__) + '/include'

require 'swiss_tournament'

require 'rubygems'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => 'spec/test.sqlite3'
})

require 'factories'
require 'schema'

RSpec::Matchers.define :include_tournament_round_with do |matches|
  match do |tournament_rounds|
    diffable
    
    included = false
    tournament_rounds.each do |tournament_round|
      #included = true if tournament_round.matches.sort == matches.sort
      included = true if tournament_round.matches == matches
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
