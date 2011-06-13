ActiveRecord::Schema.define do
  create_table "tournaments", :force => true do |t|
    t.timestamps
  end

  create_table "players", :force => true do |t|
    t.column 'name', :string
    t.column 'rating', :integer
  end

  create_table "participations", :force => true, :id => false do |t|
    t.references 'players'
    t.references 'tournaments'

    t.column 'wins', :integer, :default => 0
    t.column 'losses', :integer, :default => 0
    t.column 'draws', :integer, :default => 0
  end

  create_table 'duels', :force => true do |t|
    t.references 'tournaments'
    t.column 'player1_id', :integer
    t.column 'player2_id', :integer
    t.column 'player1_wins', :integer
    t.column 'player2_wins', :integer
  end
end
