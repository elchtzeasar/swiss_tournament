$LOAD_PATH.push File.dirname(__FILE__) + '/../rails/init'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
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
    
    @included = false
    container.each do |potential_match_match|
      if ( potential_match_match.player1_id == players[0].id and
           potential_match_match.player2_id == players[1].id ) or
         ( potential_match_match.player1_id == players[1].id and
           potential_match_match.player2_id == players[0].id )
        @included = true
      end
    end

    @included
  end
end
