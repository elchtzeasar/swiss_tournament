module ActsAsPlayer
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    # any method placed here will apply to classes
    def acts_as_player(optons = {})
      send :include, InstanceMethods

      has_many :participations
      has_many :tournaments, :through => 'participations'
      has_many :matches, :through => 'tournaments'
      validates_uniqueness_of :name
    end
  end
 
  module InstanceMethods
    # any method placed here will apply to instaces
  end
end

ActiveRecord::Base.send :include, ActsAsPlayer
