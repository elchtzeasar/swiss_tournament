module SwissTournament
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_tournament(optons = {})
      send :include, InstanceMethods

      has_many :participations
      has_many :players, :through => :participations
      has_many :duels
    end
  end
 
  module InstanceMethods
    # any method placed here will apply to instaces
    def add_player(player)
      participations.create(:player => player)
    end

    def generate_matchups
      raise "Cannot generate new matchups since #{current_matchups.size} matchups have not been reported!" if current_matchups.size > 0
      sorted_players = players.sort { |p1, p2| p2.rating <=> p1.rating }
      
      sorted_players.each_slice(2) do |players|
        duels.create(:player1 => players[0],
                     :player2 => players[1])
      end
    end

    def current_matchups
      return duels
    end
  end
end

ActiveRecord::Base.send :include, SwissTournament
