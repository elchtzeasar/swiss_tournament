require File.dirname(__FILE__) + '/../spec_helper'

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

    it 'should not generate matchups if current matchups have not been reported yet' do
      @tournament.generate_matchups

      lambda { @tournament.generate_matchups }.should raise_error "Cannot generate new matchups since 2 matchups have not been reported!"

      @tournament.current_matchups.size.should == @players.size / 2
    end

    it 'should generate matchups through TournamentRoundCreator' do
      TournamentRoundCreator.any_instance.should_receive(:generate_round).
        with(@tournament, @players, [])

      @tournament.generate_matchups
    end
  end

  describe 'report_result' do
    before(:each) do
      @match = stub(Match,
                    :update_attributes => nil,
                    :report_result => nil,
                    :player1_id => @players[0].id)
      @tournament.stub!(:current_matchups).and_return([@match])

      @players.each_index do |index|
        @tournament.participations.stub(:find).with(:first, :conditions => 
          ['player_id=?', @players[index]]).
          and_return(@participations[index])
      end

      @tournament.matches.stub!(:find).with(:first, :conditions =>
        ['(player1_id=? and player2_id=? or player1_id=? and player2_id=?) and ' +
         'player1_wins is null and player2_wins is null',
         @players[0], @players[1], @players[1], @players[0]]).and_return(@match)
      @tournament.matches.stub!(:find).with(:first, :conditions =>
        ['(player1_id=? and player2_id=? or player1_id=? and player2_id=?) and ' +
         'player1_wins is null and player2_wins is null',
         @players[2], @players[3], @players[3], @players[2]]).and_return(@match)
    end

    it 'should report result in match' do
      @tournament.stub!(:current_matchups).and_return([])
      @tournament.stub!(:rounds_played).and_return(1)
      @match.should_receive(:report_result).with(2, 1)

      @tournament.report_result({ :player => @players[0], :wins => 2 },
                                { :player => @players[1], :wins => 1 })
    end

    it 'should increment rounds_played after last result is reported' do
      @tournament.stub!(:current_matchups).and_return([])
      @tournament.stub!(:rounds_played).and_return(1)
      @tournament.should_receive(:rounds_played=).with(2)

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

  def create_match(player1_index, player2_index)
    player1 = @players[player1_index]
    player2 = @players[player2_index]

    Factory.build(:match,
                  :player1_id => player1.id,
                  :player2_id => player2.id,
                  :tournament_id => @tournament.id)
  end
end
