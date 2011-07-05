require File.dirname(__FILE__) + '/../spec_helper'

require 'player'
require 'tournament_round'

describe TournamentRound do
  before(:each) do
    @tournament = Factory.build(:tournament)
  end

  describe 'point_difference' do
    it 'should return the sum of all the point differences of matches' do
      matches = [ create_match(1,2), create_match(3,4) ]
      
      matches.first.stub!(:point_difference).and_return(4)
      matches.last.stub!(:point_difference).and_return(2)
      
      tournament_round = TournamentRound.new(@tournament, matches)

      tournament_round.point_difference.should == 6
    end
  end

  describe 'rating_difference' do
    it 'should return the sum of all the rating differences of matches' do
      matches = [ create_match(1,2), create_match(3,4) ]
      
      matches.first.stub!(:rating_difference).and_return(4)
      matches.last.stub!(:rating_difference).and_return(2)
      
      tournament_round = TournamentRound.new(@tournament, matches)
  
      tournament_round.rating_difference.should == 6
    end
  end

  describe 'create_rounds' do
    players = Factory.build(:player), Factory.build(:player), Factory.build(:player), Factory.build(:player)

    it 'should create all rounds possible when given a list of 4 players' do
      tournament_rounds =
        TournamentRound.create_rounds(@tournament, create_players(4), [])

      possible_matches = [
                          [ create_match(1,2), create_match(3,4)],
                          [ create_match(1,3), create_match(2,4)],
                          [ create_match(1,4), create_match(2,3)]
                         ]
      for matches in possible_matches do
        tournament_rounds.should include_tournament_round_with matches
      end
    end


    it 'should create all rounds possible when given a list of 6 players' do
      tournament_rounds =
        TournamentRound.create_rounds(@tournament, create_players(6), [])

      # This could be expanded to all possible matches instead:
      possible_matches = [
        [ create_match(1,2), create_match(3,4), create_match(5,6) ],
        [ create_match(1,6), create_match(2,4), create_match(3,5) ],
        [ create_match(1,2), create_match(3,6), create_match(4,5) ],
      ]
      for matches in possible_matches do
        tournament_rounds.should include_tournament_round_with matches
      end
    end

    it 'should not generate rounds with matches between players that have allready met' do
      played_matches = [ create_match(1,2), create_match(2,3) ]
      tournament_rounds =
        TournamentRound.create_rounds(@tournament, create_players(4),
                                      played_matches)

      impossible_matches = [
        [ create_match(1,2), create_match(3,4) ],
        [ create_match(2,3), create_match(1,4) ],
      ]
      for matches in impossible_matches do
        tournament_rounds.should_not include_tournament_round_with matches
      end
    end
  end

  def create_players(number_of_players)
    (1..number_of_players).collect { |index| create_player(index) }
  end
  
  def create_player(index)
    @players ||= Hash.new

    @players[index] ||= Factory.build(:player, :id => index, :name => "Player #{index}")
  end

  def create_match(player1_index, player2_index)
    @matches ||= Hash.new
    @matches[player1_index] ||= Hash.new
    @matches[player2_index] ||= Hash.new

    match = Factory.build(:match,
                          :tournament_id => @tournament.id,
                          :player1_id => player1_index,
                          :player2_id => player2_index)

    @matches[player1_index][player2_index] ||= match
    @matches[player2_index][player1_index] ||= match
  end
end
