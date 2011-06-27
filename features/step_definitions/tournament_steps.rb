Given /^I have started a tournament$/ do
  Tournament.destroy_all
  Participation.destroy_all
  Player.destroy_all
  Match.destroy_all

  @tournament = Tournament.create
end

Given /^I add the following players:$/ do |table|
  table.hashes.each do |attributes|
    player = Player.create(attributes)

    @tournament.add_player(player)
  end
end

Given /^I have started a tournament with "([^"]*)" players$/ do |number_of_players|
  Tournament.destroy_all
  Participation.destroy_all
  Player.destroy_all
  Match.destroy_all

  @tournament = Tournament.create

  number_of_players.to_i.times do |number|
    player = Player.create(:name => "Player #{number}")

    @tournament.add_player(player)
  end
end

Given /^the player with the fewest points always wins$/ do
  @config ||= Hash.new

  @config[:win_condition] = :fewest_points
end

Given /^I generate matchups$/ do
  @tournament.generate_matchups
end

Given /^the players play "([^"]*)" rounds$/ do |number_of_rounds|
  number_of_rounds.to_i.times do |round_index|
    @tournament.generate_matchups

    case @config[:win_condition]
      when :fewest_points
        @tournament.current_matchups.each do |match|
          participation1 = match.player1.participations.
            find(:first, :conditions => { :tournament_id => @tournament })
          participation2 = match.player2.participations.
            find(:first, :conditions => { :tournament_id => @tournament })
          
            if participation1.points < participation2.points
              @tournament.report_result({ :player => match.player1, :wins => 2 },
                                        { :player => match.player2, :wins => 0 })
            else
              @tournament.report_result({ :player => match.player1, :wins => 0 },
                                        { :player => match.player2, :wins => 2 })
            end
        end
      else
      raise "Unknown win condition: #{@config[:win_condition]}"
    end
  end
end

Then /^"([^"]*)" should have a match against "([^"]*)"$/ do |player1_name, player2_name|
  player1 = Player.where(:name => player1_name).first
  player2 = Player.where(:name => player2_name).first

  @tournament.current_matchups.should include create_match(player1, player2)
end

Given /^I report the following results:$/ do |table|
  table.hashes.each do |attributes|
    player1 = Player.where(:name => attributes['player 1']).first
    player2 = Player.where(:name => attributes['player 2']).first

    @tournament.report_result({ :player => player1, 
                                :wins => attributes['player 1 wins'].to_i },
                              { :player => player2,
                                :wins => attributes['player 2 wins'].to_i })
  end
end

Then /^the listings should be as follows:$/ do |table|
  expected_listings = table.hashes.collect do |attributes|
    Player.where(:name => attributes['player']).first
  end

  @tournament.listings.should == expected_listings
end

Then /^no players should have met more then once$/ do
  matches = Match.all

  matches.should have_unique_matchups
end

def create_match(player1, player2)
  Factory.build(:match, :player1_id => player1.id, :player2_id => player2.id, :tournament_id => @tournament.id)
end
