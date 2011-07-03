require File.dirname(__FILE__) + '/../spec_helper'

require 'tournament_round_creator'

describe TournamentRoundCreator do
  before(:each) do
    @tournament_round_creator = TournamentRoundCreator.new
    @tournament = mock(Tournament)
    @players = mock('Player array')
    @played_games = mock('Played games')
  end

  describe 'generate_round' do
    it 'should generate all rounds' do
      TournamentRound.should_receive(:create_rounds).and_return([stub_round])

      @tournament_round_creator.generate_round(@tournament, @players, @played_games)
    end

    it 'should return the round with the smallest points' do
      rounds = (0..2).to_a.collect do |index|
        stub_round(:point_difference => index)
      end
      TournamentRound.stub!(:create_rounds).and_return(rounds)

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games).should == rounds[0]
    end

    it 'should save all matches in the chosen round' do
      matches = (1..3).collect { mock(Match, :save => nil) }
      round = stub_round(:matches => matches)
      TournamentRound.stub!(:create_rounds).and_return([ round ])

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games)
    end
  end

  def stub_round(stubs = {})
    stubs[:matches] ||= []
    stubs[:point_difference] ||= 0

    stub(TournamentRound, stubs)
  end
end
