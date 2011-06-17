require File.dirname(__FILE__) + '/../spec_helper'

require 'match'
require 'tournament'
require 'participation'
require 'player'

describe Participation do
  before(:each) do
    @player = Factory.build(:player)
    @tournament = Factory.build(:tournament)
    @participation = Participation.new(:player => @player,
                                       :tournament => @tournament)
  end

  after(:each) do
    Participation.destroy_all
    Player.destroy_all
    Tournament.destroy_all
  end

  describe 'points' do
    it 'should calculate 3 points per win' do
      @participation.wins = 2
      @participation.draws = 0
      @participation.losses = 0

      @participation.points.should == 6
    end

    it 'should calculate 1 point per draw' do
      @participation.wins = 0
      @participation.draws = 3
      @participation.losses = 0

      @participation.points.should == 3
    end
  end

  describe 'tie_break' do
    it 'should return difference between duels won and duels lost' do
      @participation.stub!(:duels_won).and_return(3)
      @participation.stub!(:duels_lost).and_return(5)

      @participation.tie_break.should == -2
    end
  end

  describe 'report_result' do
    before(:each) do
      # Stub update_attribute so we dont get errors when we call
      # it several times...
      @participation.stub!(:update_attribute)
    end

    it 'should update duels_won' do
      @participation.stub!(:duels_won).and_return(4)

      @participation.should_receive(:update_attribute).
        with(:duels_won, 6)

      @participation.report_result(2, 1)
    end

    it 'should update duels_lost' do
      @participation.stub!(:duels_lost).and_return(1)

      @participation.should_receive(:update_attribute).
        with(:duels_lost, 2)

      @participation.report_result(2, 1)
    end

    it 'should update wins when the player wins' do
      @participation.stub!(:wins).and_return(2)

      @participation.should_receive(:update_attribute).with(:wins, 3)
      @participation.should_receive(:update_attribute).with(:losses, anything()).never
      @participation.should_receive(:update_attribute).with(:draws, anything()).never

      @participation.report_result(2, 0)
    end

    it 'should update wins and losses when second player wins' do
      @participation.stub!(:losses).and_return(2)

      @participation.should_receive(:update_attribute).with(:wins, anything()).never
      @participation.should_receive(:update_attribute).with(:losses, 3)
      @participation.should_receive(:update_attribute).with(:draws, anything()).never

      @participation.report_result(0, 2)
    end

    it 'should update draws on a draw' do
      @participation.stub!(:draws).and_return(2)

      @participation.should_receive(:update_attribute).with(:wins, anything()).never
      @participation.should_receive(:update_attribute).with(:losses, anything()).never
      @participation.should_receive(:update_attribute).with(:draws, 3)

      @participation.report_result(1, 1)
    end
  end
end
