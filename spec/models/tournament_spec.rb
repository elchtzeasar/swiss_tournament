require File.dirname(__FILE__) + '/../spec_helper'

require 'match'
require 'tournament'
require 'participation'
require 'player'

describe Tournament do
  before(:each) do
    @tournament = Factory.create(:tournament)

    @players = (0..3).to_a.collect do |index|
      Factory.create(:player, :rating => 1530 - index * 10, :name => "Player #{index}")
    end

    @participations = (0..3).to_a.collect do |index|
      participation = Factory.create(:participation,
                                     :player => @players[index],
                                     :tournament => @tournament)
      participation.stub!(:tie_break).and_return(0)
      participation
    end
  end

  after(:each) do
    Tournament.destroy_all
    Participation.destroy_all
    Player.destroy_all
    Match.destroy_all
  end

  describe 'add_player' do
    it 'should create player on add_player' do
      @tournament.participations.should_receive(:create).
        with(:player => @players[0])

      @tournament.add_player(@players[0])
    end
  end

  describe 'generate_matchups' do
    before(:each) do
    end

    it 'should generate matchups according to rating on initial matchup' do
      @tournament.generate_matchups

      @tournament.current_matchups.size.should == @players.size / 2

      @tournament.current_matchups.should include_match_between_players [@players[0], @players[1]]
      @tournament.current_matchups.should include_match_between_players [@players[2], @players[3]]
    end

    it 'should not generate matchups if current matchups have not been reported yet' do
      @tournament.generate_matchups

      lambda { @tournament.generate_matchups }.should raise_error "Cannot generate new matchups since 2 matchups have not been reported!"

      @tournament.current_matchups.size.should == @players.size / 2
    end

    it 'should generate matchups once the current matchups have been reported' do
      @tournament.stub!(:rounds_played).and_return(1)

      @tournament.participations[0].stub!(:points).and_return(1)
      @tournament.participations[1].stub!(:points).and_return(6)
      @tournament.participations[2].stub!(:points).and_return(3)
      @tournament.participations[3].stub!(:points).and_return(5)

      @tournament.generate_matchups

      @tournament.current_matchups.size.should == @players.size / 2
    end

    it 'should generate matchups the second time between players with similar points' do
      @tournament.stub!(:rounds_played).and_return(1)

      @tournament.participations[0].stub!(:points).and_return(1)
      @tournament.participations[1].stub!(:points).and_return(6)
      @tournament.participations[2].stub!(:points).and_return(3)
      @tournament.participations[3].stub!(:points).and_return(5)

      @tournament.generate_matchups

      @tournament.current_matchups.should include_match_between_players [@players[1], @players[3]]
      @tournament.current_matchups.should include_match_between_players [@players[0], @players[2]]
    end

    it 'should use players tie break if several players have the same points' do
      @tournament.stub!(:rounds_played).and_return(1)

      @tournament.participations[0].stub!(:points).and_return(3)
      @tournament.participations[1].stub!(:points).and_return(3)
      @tournament.participations[2].stub!(:points).and_return(3)
      @tournament.participations[3].stub!(:points).and_return(3)

      @tournament.participations[0].stub!(:tie_break).and_return(+3)
      @tournament.participations[1].stub!(:tie_break).and_return(0)
      @tournament.participations[2].stub!(:tie_break).and_return(0)
      @tournament.participations[3].stub!(:tie_break).and_return(+2)

      @tournament.generate_matchups

      @tournament.current_matchups.should include_match_between_players [@players[0], @players[3]]
      @tournament.current_matchups.should include_match_between_players [@players[1], @players[2]]
    end
  end

  describe 'report_result' do
    before(:each) do
      @tournament.generate_matchups

      @match = mock(Match)
      @tournament.stub!(:current_matchups).and_return([@match])

      @players.each_index do |index|
        @tournament.participations.stub(:find).with(:first, :conditions => 
          ['player_id=?', @players[index]]).
          and_return(@participations[index])
      end
    end

    it 'should add the reported results to the correct match' do
      @tournament.matches.stub!(:find).with(:first, :conditions =>
        ['player1_id=? and player2_id=? or player1_id=? and player2_id=?',
         @players[0], @players[1], @players[1], @players[0]]).and_return(@match)

      @match.should_receive(:update_attributes).with(:player1_wins => 2,
                                                    :player2_wins => 1)

      @tournament.report_result({ :player => @players[0], :wins => 2 },
                                { :player => @players[1], :wins => 1 })
    end

    it 'should increment rounds_played after last result is reported' do
      @tournament.stub!(:current_matchups).and_return([])
      @tournament.stub!(:rounds_played).and_return(1)
      @tournament.should_receive(:rounds_played=).with(2)

      @tournament.report_result({ :player => @players[2], :wins => 2 },
                                { :player => @players[3], :wins => 1 })
    end

    it 'should update participations for player 1' do
      @participations[0].should_receive(:report_result).with(2, 1)

      @tournament.report_result({ :player => @players[0], :wins => 2 },
                                { :player => @players[1], :wins => 1 })
    end

    it 'should update participations for player 2' do
      @participations[1].should_receive(:report_result).with(1, 2)

      @tournament.report_result({ :player => @players[0], :wins => 2 },
                                { :player => @players[1], :wins => 1 })
    end
  end

  describe 'listings' do
    it 'should generate listings ordered after rating if no rounds have been played' do
      @tournament.stub!(:rounds_played).and_return(0)
      @tournament.players[1].stub!(:rating).and_return(1700)
      @tournament.players[3].stub!(:rating).and_return(1600)
      @tournament.players[2].stub!(:rating).and_return(1500)
      @tournament.players[0].stub!(:rating).and_return(1400)

      @tournament.listings.should == @players.values_at(1, 3, 2, 0)
    end

    it 'should generate listings ordered after points if rounds have been played' do
      @tournament.stub!(:rounds_played).and_return(1)
      @tournament.participations[2].stub!(:points).and_return(6)
      @tournament.participations[0].stub!(:points).and_return(4)
      @tournament.participations[1].stub!(:points).and_return(2)
      @tournament.participations[3].stub!(:points).and_return(1)

      @tournament.listings.should == @players.values_at(2, 0, 1, 3)
    end
  end
end
