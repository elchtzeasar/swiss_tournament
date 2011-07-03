# -*- coding: utf-8 -*-
require 'factory_girl'

Factory.define :tournament do |swiss|
  swiss.id 1
  swiss.created_at Time.mktime(2000)
  swiss.updated_at Time.mktime(2001)
  swiss.rounds_played 0
end

Factory.define :player do |player|
  player.name "Player"
  player.rating 1500
end

Factory.define :participation do |participation|
  participation.wins 0
  participation.losses 0
  participation.draws 0
end

Factory.define :match do |match|
  match.tournament_id 1
  match.player1_id 1
  match.player2_id 2
  match.player1_wins 0
  match.player2_wins 0
end
