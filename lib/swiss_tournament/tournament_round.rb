class TournamentRound
  attr_reader :matches

  def initialize(tournament, matches)
    @tournament = tournament
    @matches = matches
  end

  def point_difference
    eval(@matches.collect { |m| m.point_difference }.join('+'))
  end

  def self.create_rounds(tournament, players, played_matches)
    rounds = Array.new

    # Create an array of the possible matchups. This generates an array
    # of rounds, containing an array of matches which are just arrays of
    # 2 players. The matches are sorted on player id so that we can pick
    # out the unique rounds.
    rounds = []
    players.permutation(players.size).each do |permutation| 
      matches = []

      permutation.each_slice(2) do |player1, player2|
        matches << [player1, player2].sort { |p1, p2| p1.id <=> p2.id }
      end
      rounds << matches.sort { |m1, m2| m1.first.id <=> m2.first.id }
    end
    rounds.uniq!

    # Delete rounds that contain matches that have allready been played:
    rounds = rounds.delete_if do |matches|
      allready_played_match_found = false

      for match in matches do
        matching_played_match = played_matches.find do |played_match|
          played_match.is_between(match[0], match[1])
        end
        
        allready_played_match_found = true unless matching_played_match.nil?
      end

      allready_played_match_found
    end

    # Create TournamentRounds:
    rounds.collect! do |matches|
      matches.collect! do |match|
        Match.new(:tournament_id => tournament.id,
                  :player1_id => match[0].id,
                  :player2_id => match[1].id)
      end

      TournamentRound.new(tournament, matches)
    end

    return rounds
  end
end
