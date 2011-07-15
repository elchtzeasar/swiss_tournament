require File.dirname(__FILE__) + '/../spec_helper'

describe TournamentRoundCreator do
  before(:each) do
    @tournament_round_creator = TournamentRoundCreator.new
    @tournament = mock(Tournament, :rounds_played => 0)
    @players = mock('Player array')
    @played_games = mock('Played games')
  end

  describe 'generate_round' do
    it 'should generate all rounds' do
      TournamentRound.should_receive(:create_rounds).and_return([stub_round])

      @tournament_round_creator.generate_round(@tournament, @players, @played_games)
    end

    it 'should return the round with the smallest rating difference if rounds have not been played' do
      @tournament.stub!(:rounds_played).and_return(0)
      rounds = stub_rounds(3, :rating_differences => [3,1,5])
      TournamentRound.stub!(:create_rounds).and_return(rounds.dup)

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games).should == rounds[1]
    end

    it 'should return the round with the smallest point difference if rounds have been played' do
      @tournament.stub!(:rounds_played).and_return(3)
      rounds = stub_rounds(3, :point_differences => [3, 1, 5])
      TournamentRound.stub!(:create_rounds).and_return(rounds.dup)

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games).should == rounds[1]
    end

    it 'should return a random round if there are many rounds with the same rating difference' do
      rounds = stub_rounds(3)

      TournamentRound.stub!(:create_rounds).and_return(rounds)
      Kernel.stub!(:rand).with(3).and_return(1)

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games).should == rounds[1]
    end

    it 'should return a random round if there are many rounds with the same point difference' do
      rounds = stub_rounds(3)

      @tournament.stub!(:rounds_played).and_return(1)
      TournamentRound.stub!(:create_rounds).and_return(rounds)
      Kernel.stub!(:rand).with(3).and_return(1)

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games).should == rounds[1]
    end

    it 'should report win for all byed players' do
      bye_match = mock_match('BYE', { :bye? => true})
      matches = mock_matches(2)
      matches << bye_match
      round = stub_round(:matches => matches)
      TournamentRound.stub!(:create_rounds).and_return( [round] )

      bye_match.should_receive(:report_result).with(2, 0)

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games)
    end

    it 'should save all matches in the chosen round' do
      matches = mock_matches(3)
      round = stub_round(:matches => matches)
      TournamentRound.stub!(:create_rounds).and_return([ round ])

      for match in matches do
        match.should_receive(:save)
      end

      @tournament_round_creator.generate_round(
        @tournament, @players, @played_games)
    end
  end

  def mock_match(description, stubs = {})
    stubs[:save] ||= nil
    stubs[:bye?] ||= false

    return mock("Match [#{description}]", stubs)
  end

  def mock_matches(number_of_matches)
    matches = (1..number_of_matches).collect { |index| mock_match(index) }
  end

  def default_stubs(stubs)
    stubs[:matches] ||= []
    stubs[:point_difference] ||= 5
    stubs[:rating_difference] ||= 5

    return stubs
  end

  def stub_round(stubs = {})
    stub(TournamentRound, default_stubs(stubs))
  end

  def stub_rounds(number_of_rounds, args = {})
    return (0..(number_of_rounds-1)).to_a.collect do |index|
      stubs = {}
      unless args[:rating_differences].nil?
        stubs[:rating_difference] = args[:rating_differences][index]
      end
      unless args[:point_differences].nil?
        stubs[:point_difference] = args[:point_differences][index]
      end

      stub("TournamentRound #{index}", default_stubs(stubs))
    end
  end
end
