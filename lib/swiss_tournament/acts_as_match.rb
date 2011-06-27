module ActsAsMatch
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_match(optons = {})
      send :include, InstanceMethods

      belongs_to :tournament
      belongs_to :player1, :class_name => 'Player'
      belongs_to :player2, :class_name => 'Player'

      validates_presence_of :tournament
      validate :validate_different_players
    end

  end
 
  module InstanceMethods
    # any method placed here will apply to instaces
    def validate_different_players
      errors[:different_players] = 'A player cannot match with him-/herself.' if player1 == player2
    end

    def ==(match)
      return false if tournament_id != match.tournament_id
      return true if player1_id == match.player1_id and player2_id == match.player2_id
      return true if player1_id = match.player2_id and player2_id == match.player1_id

      return false
    end
  end
end

ActiveRecord::Base.send :include, ActsAsMatch
