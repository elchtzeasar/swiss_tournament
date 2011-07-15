class Tournament < ActiveRecord::Base
  has_many :participations
  has_many :players, :through => :participations
  has_many :matches

  def add_player(player)
    participations.create(:player => player)
  end

  def generate_matchups
    raise "Cannot generate new matchups since #{current_matchups.size} matchups have not been reported!" if current_matchups.size > 0

    return TournamentRoundCreator.new.
      generate_round(self, players, matches.to_a)
  end

  def current_matchups
    matchups = matches.reload.find(:all, :conditions => {:player1_wins => nil, :player2_wins => nil})
    return [] if matchups.nil?
    return matchups
  end

  def report_result(player1_hash, player2_hash)
    player1 = player1_hash[:player]
    player2 = player2_hash[:player]
    match = matches.
      find(:first,
           :conditions => [ '(player1_id=? and player2_id=? or' +
                            ' player1_id=? and player2_id=?) and ' +
                            'player1_wins is null and player2_wins is null',
                            player1, player2,
                            player2, player1])

    raise "Cannot find match between #{player1.name} and #{player2.name} on report_result" if match.nil?
    if match.player1_id == player1.id
      match.report_result(player1_hash[:wins], player2_hash[:wins])
    else
      match.report_result(player2_hash[:wins], player1_hash[:wins])
    end

    if current_matchups.size == 0
      update_attribute(:rounds_played, rounds_played + 1)
    end
  end

  def listings
    if rounds_played == 0
      return players.sort { |p1, p2| p2.rating <=> p1.rating }
    else
      sorted_participations = participations.sort do |p1, p2|
        point_difference = p2.points <=> p1.points
        if point_difference == 0
          p2.tie_break <=> p1.tie_break
        else
          point_difference
        end
      end

      return sorted_participations.collect do |participation|
        participation.player
      end
    end
  end
end
