module SwissTournament
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
  end
end

ActiveRecord::Base.send :include, SwissTournament
