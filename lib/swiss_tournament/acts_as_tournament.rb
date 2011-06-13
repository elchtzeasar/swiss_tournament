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
    end

  end
 
  module InstanceMethods
    # any method placed here will apply to instaces
    def generate_matchups
    end

    def current_matchups
      []
    end
  end
end

ActiveRecord::Base.send :include, SwissTournament
