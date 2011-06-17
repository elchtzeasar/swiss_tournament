module ActsAsParticipation
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_participation(optons = {})
      send :include, InstanceMethods

      belongs_to :player
      belongs_to :tournament
    end
  end
 
  module InstanceMethods
    # any method placed here will apply to instaces
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
end

ActiveRecord::Base.send :include, ActsAsParticipation
