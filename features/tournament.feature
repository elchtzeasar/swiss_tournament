Feature: Swiss tournaments
In order to be able to run swiss tournaments
  We need to be able to add players, generate matchups, report results and see listings

Scenario: Generate initial matchups
  Given I have started a tournament
    And I add the following players:
      | name            | rating |
      | Bugs Bunny      |   1500 |
      | Roger Rabbit    |   1501 |
      | Speedrunner     |   1502 |
      | Winnie the Pooh |   1503 |
    And I generate matchups
   Then "Bugs Bunny" should have a match against "Roger Rabbit"
    And "Speedrunner" should have a match against "Winnie the Pooh"

Scenario: Report results and see listings
  Given I have started a tournament
    And I add the following players:
      | name            | rating |
      | Bugs Bunny      |   1500 |
      | Roger Rabbit    |   1501 |
      | Speedrunner     |   1502 |
      | Winnie the Pooh |   1503 |
    And I generate matchups
    And I report the following results:
      | player 1    | player 2        | player 1 wins | player 2 wins |
      | Bugs Bunny  | Roger Rabbit    |             2 |             0 |
      | Speedrunner | Winnie the Pooh |             2 |             1 |
   Then the listings should be as follows:
      | player          |
      | Bugs Bunny      |
      | Speedrunner     |
      | Winnie the Pooh |
      | Roger Rabbit    |
      
  
Scenario: Report results and generate new matchups
  Given I have started a tournament
    And I add the following players:
      | name            | rating |
      | Bugs Bunny      |    1500 |
      | Roger Rabbit    |    1501 |
      | Speedrunner     |    1502 |
      | Winnie the Pooh |    1503 |
    And I generate matchups
    And I report the following results:
      | player 1    | player 2        | player 1 wins | player 2 wins |
      | Bugs Bunny  | Roger Rabbit    |             2 |             0 |
      | Speedrunner | Winnie the Pooh |             2 |             1 |
    And I generate matchups
   Then "Bugs Bunny" should have a match against "Speedrunner"
    And "Roger Rabbit" should have a match against "Winnie the Pooh"

@wip
Scenario: Dont generate the same matchup twice
  Given I have started a tournament with "8" players
    And the player with the fewest points always wins
    And the players play "3" rounds
   Then no players should have met more then once