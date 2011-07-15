class Match < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :player1, :class_name => 'Player'
  belongs_to :player2, :class_name => 'Player'

  validates_presence_of :tournament
  validate :validate_different_players
  
  def validate_different_players
    errors[:different_players] = 'A player cannot play a match with him-/herself.' if player1 == player2
  end

  def rating_difference
    player1 = Player.find(:first, :conditions => ['id=?', player1_id])
    player2 = Player.find(:first, :conditions => ['id=?', player2_id])

    return 0 if player2.nil?
    return (player1.rating - player2.rating).abs
  end

  def point_difference
    return 0 if participation2.nil?
    return (participation1.points - participation2.points).abs
  end
  
  def is_between(received_player1, received_player2)
    unless received_player1.is_a? Fixnum or received_player1.nil?
      received_player1 = received_player1.id
    end
    unless received_player2.is_a? Fixnum or received_player2.nil?
      received_player2 = received_player2.id
    end

    if player1_id == received_player1 and player2_id == received_player2
      return true
    end
    if player2_id == received_player1 and player1_id == received_player2
      return true
    end
    return false
  end

  def report_result(player1_wins, player2_wins)
    update_attributes(:player1_wins => player1_wins,
                      :player2_wins => player2_wins)

    participation1.report_result(player1_wins, player2_wins)
    participation2.report_result(player2_wins, player1_wins) unless participation2.nil?
  end

  def bye?
    return player2_id.nil?
  end

  def ==(match)
    return false if tournament_id != match.tournament_id
    return true if player1_id == match.player1_id and player2_id == match.player2_id
    return true if player1_id == match.player2_id and player2_id == match.player1_id

    return false
  end

  private
  def participation1
    Participation.find(:first, :conditions => {
                         :player_id => player1_id,
                         :tournament_id => tournament_id })
  end

  def participation2
    Participation.find(:first, :conditions => {
                         :player_id => player2_id,
                         :tournament_id => tournament_id })
  end
end
