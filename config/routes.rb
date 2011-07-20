Rails.application.routes.draw do |map|
   resources :swiss_tournaments, :controller => 'swiss_tournaments/swiss_tournaments', :only => [:new, :create]
 end
