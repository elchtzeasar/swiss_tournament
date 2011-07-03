require File.dirname(__FILE__) + '/../spec_helper'

require 'match'

describe Match do
  before(:each) do
    @tournament = Factory.build(:tournament)
  end

  describe 'point_difference' do
    it 'should return the difference in points between the players' do
      player1 = Factory.build(:player, :id => 1)
      participation1 = Factory.build(:participation,
                                     :tournament => @tournament,
                                     :player => player1)
      player2 = Factory.build(:player, :id => 2)
      participation2 = Factory.build(:participation,
                                     :tournament => @tournament,
                                     :player => player2)

      Participation.stub!(:find).
        with(:first, :conditions => {
               :player_id => 1,
               :tournament_id => @tournament.id }).and_return(participation1)
      Participation.stub!(:find).
        with(:first, :conditions => {
               :player_id => 2,
               :tournament_id => @tournament.id }).and_return(participation2)

      participation1.stub!(:points).and_return(5)
      participation2.stub!(:points).and_return(2)

      match_between_players(player1, player2).point_difference.should == 3
    end
  end

  describe '==' do
    it 'should return false if matches are in different tournaments' do
      match1 = match_between_players(1,2)
      match2 = match_between_players(1,2)
      match2.tournament_id = @tournament.id + 1

      (match1 == match2).should == false
    end

    it 'should return false if players do not match' do
      (match_between_players(1,2) == match_between_players(3,4)).should == false
    end

    it 'should return true if players match' do
      (match_between_players(1,2) == match_between_players(1,2)).should == true
    end

    it 'should return true if players match, but order is swapped' do
      (match_between_players(1,2) == match_between_players(2,1)).should == true
    end
  end

  describe 'is_between with ids' do
    it 'should return true if the match is between the players supplied' do
      match = match_between_players(1,2)

      match.is_between(1, 2).should == true
    end

    it 'should not return true if the match is between other players then the players supplied' do
      match = match_between_players(1,2)

      match.is_between(3, 4).should == false
    end

    it 'should not return true if the match is between one of the players supplied and a different player' do
      match = match_between_players(1,2)

      match.is_between(1, 3).should == false
    end
  end

  describe 'is_between with players' do
    it 'should return true if the match is between the players supplied' do
      match = match_between_players(1,2)
      player1 = player_with_id(1)
      player2 = player_with_id(2)

      match.is_between(player1, player2).should == true
    end

    it 'should not return true if the match is between other players then the players supplied' do
      match = match_between_players(1,2)
      player1 = player_with_id(3)
      player2 = player_with_id(4)

      match.is_between(player1, player2).should == false
    end

    it 'should not return true if the match is between one of the players supplied and a different player' do
      match = match_between_players(1,2)
      player1 = player_with_id(1)
      player2 = player_with_id(3)

      match.is_between(player1, player2).should == false
    end
  end

  def player_with_id(id)
    Factory.build(:player, :id => id)
  end

  def match_between_players(player1, player2)
    player1 = player_with_id(player1) if player1.is_a? Fixnum
    player2 = player_with_id(player2) if player2.is_a? Fixnum

    Match.new(:tournament_id => @tournament.id,
              :player1_id => player1.id,
              :player2_id => player2.id)
  end
end
