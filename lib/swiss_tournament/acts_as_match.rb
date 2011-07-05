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
      errors[:different_players] = 'A player cannot play a match with him-/herself.' if player1 == player2
    end

    def rating_difference
      player1 = Player.find(:first, :conditions => ['id=?', player1_id])
      player2 = Player.find(:first, :conditions => ['id=?', player2_id])

      return (player1.rating - player2.rating).abs
    end

    def point_difference
      return (participation1.points - participation2.points).abs
    end
  
    def is_between(received_player1, received_player2)
      received_player1 = received_player1.id unless received_player1.is_a? Fixnum
      received_player2 = received_player2.id unless received_player2.is_a? Fixnum

      if player1_id == received_player1 and player2_id == received_player2
        return true
      end
      if player2_id == received_player1 and player1_id == received_player2
        return true
      end
      return false
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
end

ActiveRecord::Base.send :include, ActsAsMatch
