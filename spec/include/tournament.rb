require 'swiss_tournament'

class Tournament < ActiveRecord::Base
  acts_as_tournament
end
