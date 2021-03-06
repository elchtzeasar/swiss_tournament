require File.dirname(__FILE__) + '/../spec_helper'

require 'match'

describe Match do
  before(:each) do
    @tournament_id = 1
  end

  describe 'rating_difference' do
    it 'should return the difference in ratings between the players' do
      player1 = player_with_id(1, :rating => 5)
      player2 = player_with_id(2, :rating => 2)

      Player.stub!(:find).with(:first, :conditions => ['id=?', 1]).
        and_return(player1)
      Player.stub!(:find).with(:first, :conditions => ['id=?', 2]).
        and_return(player2)

      match_between_players(player1, player2).rating_difference.should == 3
    end
  end

  describe 'point_difference' do
    it 'should return the difference in points between the players' do
      player1 = player_with_id(1)
      player2 = player_with_id(2)

      participation1 = stub_participation(1, :points => 5)
      participation2 = stub_participation(2, :points => 2)

      match_between_players(player1, player2).point_difference.should == 3
    end
  end

  describe 'report_result' do
    before(:each) do
      @participation1 = stub_participation(1, :points => 5, :report_result => nil)
      @participation2 = stub_participation(2, :points => 2, :report_result => nil)

      @match = match_between_players(1,2)
    end

    it 'should add the reported results to the correct match' do
      @match.should_receive(:update_attributes).with(:player1_wins => 2,
                                                     :player2_wins => 1)

      @match.report_result(2, 1)
    end

    it 'should update participations for player 1' do
      @participation1.should_receive(:report_result).with(2, 1)

      @match.report_result(2, 1)
    end

    it 'should update participations for player 2' do
      @participation2.should_receive(:report_result).with(1, 2)

      @match.report_result(2, 1)
    end
  end

  describe '==' do
    it 'should return false if matches are in different tournaments' do
      match1 = match_between_players(1,2)
      match2 = match_between_players(1,2)
      match2.tournament_id = @tournament_id + 1

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
      player1 = player_with_id(1)
      player2 = player_with_id(2)
      match = match_between_players(player1, player2)

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

  def player_with_id(id, stubs = {})
    stubs[:id] = id
    stubs[:name] = "Player #{id}"
    Factory.build(:player, stubs)
  end

  def match_between_players(player1, player2)
    player1 = player_with_id(player1) if player1.is_a? Fixnum
    player2 = player_with_id(player2) if player2.is_a? Fixnum

    Match.new(:tournament_id => @tournament_id,
              :player1_id => player1.id,
              :player2_id => player2.id)
  end

  def stub_participation(player_id, stubs = {})
    participation = mock(Participation, stubs)

    Participation.stub!(:find).
      with(:first, :conditions => {
             :player_id => player_id,
             :tournament_id => @tournament_id }).and_return(participation)

    return participation
  end
end
