Given /^I have started a tournament$/ do
  @tournament = Tournament.create

  Tournament.destroy_all
  Participation.destroy_all
  Player.destroy_all
  Match.destroy_all
end

Given /^I add the following players:$/ do |table|
  table.hashes.each do |attributes|
    player = Player.create(attributes)

    @tournament.add_player(player)
  end
end

Given /^I generate matchups$/ do
  @tournament.generate_matchups
end

Then /^"([^"]*)" should have a match against "([^"]*)"$/ do |player1_name, player2_name|
  player1 = Player.where(:name => player1_name).first
  player2 = Player.where(:name => player2_name).first

  @tournament.current_matchups.should include_match_between_players [player1, player2]
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
