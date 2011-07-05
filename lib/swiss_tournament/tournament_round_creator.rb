class TournamentRoundCreator
  def generate_round(tournament, players, played_games)
    rounds = TournamentRound.create_rounds(tournament, players, played_games)

    round = rounds.sort do |round1, round2|
      if tournament.rounds_played > 0
        round1.point_difference <=> round2.point_difference
      else
        round1.rating_difference <=> round2.rating_difference
      end
    end.first
    round.matches.each { |match| match.save }

    return round
  end
end
