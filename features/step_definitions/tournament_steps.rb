Given /^I have started a tournament$/ do
  @tournament = Tournament.create
end

Given /^I add the following players:$/ do |table|
  table.hashes.each do |attributes|
    player = Player.create(attributes)
    Participation.create(:tournament => @tournament, :player => @player)
  end
end

Given /^I generate matchups$/ do
  @tournament.generate_matchups
end

Then /^"([^"]*)" should have a match against "([^"]*)"$/ do |player1_name, player2_name|
  player1 = Player.where(:name => player1_name).first
  player2 = Player.where(:name => player2_name).first
  @tournament.current_matchups.should include [player1, player2]
end

Given /^I report the following results:$/ do |table|
  table.hashes.each do |attributes|
    player1 = Player.where(:name => attributes['player 1']).first
    player2 = Player.where(:name => attributes['player 2']).first

    @tournament.report_result({ :player => player1, 
                                :wins => attributes['player 1 wins'] },
                              { :player => player2,
                                :wins => attributes['player 2 wins'] })
  end
end

Then /^the listings should be as follows:$/ do |table|
  expected_listings = table.hashes.each do |attributes|
    player = Player.where(:name => attributes['player']).first
    { :player => player, :place => attributes['place'] }
  end

  @tournament.listings.should == expected_listings
end
