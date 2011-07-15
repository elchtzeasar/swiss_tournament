class TournamentRoundCreator
  def generate_round(tournament, players, played_games)
    rounds = TournamentRound.create_rounds(tournament, players, played_games)

    rounds.sort! do |round1, round2|
      if tournament.rounds_played > 0
        round1.point_difference <=> round2.point_difference
      else
        round1.rating_difference <=> round2.rating_difference
      end
    end

    rounds.delete_if do |round|
      if tournament.rounds_played > 0
        round.point_difference > rounds.first.point_difference
      else
        round.rating_difference > rounds.first.rating_difference
      end
    end

    round = rounds[Kernel.rand(rounds.size)]

    round.matches.each do |match|
      match.report_result(2, 0) if match.bye?
      match.save
    end

    return round
  end
end
