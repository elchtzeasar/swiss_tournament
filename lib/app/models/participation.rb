class Participation < ActiveRecord::Base
  belongs_to :player
  belongs_to :tournament
  
  def points
    wins * 3 + draws * 1
  end

  def tie_break
    return duels_won - duels_lost
  end

  def report_result(duels_won_this_game, duels_lost_this_game)
    update_attribute(:duels_won, duels_won + duels_won_this_game)
    update_attribute(:duels_lost, duels_lost + duels_lost_this_game)

    if (duels_won_this_game > duels_lost_this_game)
      update_attribute(:wins, wins + 1)
    elsif (duels_won_this_game < duels_lost_this_game)
      update_attribute(:losses, losses + 1)
    else
      update_attribute(:draws, draws + 1)
    end
  end
end
