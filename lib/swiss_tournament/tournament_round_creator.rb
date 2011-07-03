class TournamentRoundCreator
  def generate_round(tournament, players, played_games)
    rounds = TournamentRound.create_rounds(tournament, players, played_games)

    round = rounds.sort do |round1, round2|
      round1.point_difference <=> round2.point_difference
    end.first
    round.matches.each { |match| match.save }

    return round
  end
end
