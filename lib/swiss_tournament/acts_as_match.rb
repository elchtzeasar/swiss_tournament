module ActsAsMatch
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_match(optons = {})
      send :include, InstanceMethods

      belongs_to :player1, :class_name => 'Player'
      belongs_to :player2, :class_name => 'Player'

      validate :validate_different_players
    end

  end
 
  module InstanceMethods
    # any method placed here will apply to instaces
    def validate_different_players
      errors[:different_players] = 'A player cannot match with him-/herself.' if player1 == player2
    end
  end
end

ActiveRecord::Base.send :include, ActsAsMatch
