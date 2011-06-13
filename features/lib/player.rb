require 'swiss_tournament'

class Player < ActiveRecord::Base
  acts_as_player
end
