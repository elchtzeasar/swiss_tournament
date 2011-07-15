Feature: Swiss tournaments
In order to be able to run swiss tournaments
  We need to be able to add players, generate matchups, report results and see listings

Scenario: Generate initial matchups
  Given I have started a tournament with the following players:
      | name            | rating |
      | Bugs Bunny      |   1500 |
      | Roger Rabbit    |   1501 |
      | Speedrunner     |   1502 |
      | Winnie the Pooh |   1503 |
    And I generate matchups
   Then "Bugs Bunny" should have a match against "Roger Rabbit"
    And "Speedrunner" should have a match against "Winnie the Pooh"

Scenario: Report results and see listings
  Given I have started a tournament with the following players:
      | name            | rating |
      | Bugs Bunny      |   1503 |
      | Roger Rabbit    |   1502 |
      | Speedrunner     |   1501 |
      | Winnie the Pooh |   1500 |
    And the player with the most points always wins
    And the players play 1 round
   Then the listings should be as follows:
      | player          |
      | Bugs Bunny      |
      | Speedrunner     |
      | Roger Rabbit    |
      | Winnie the Pooh |
      
  
Scenario: Report results and generate new matchups
  Given I have started a tournament with the following players:
      | name            | rating |
      | Bugs Bunny      |    1500 |
      | Roger Rabbit    |    1501 |
      | Speedrunner     |    1502 |
      | Winnie the Pooh |    1503 |
    And the player with the most points always wins
    And the players play 1 round
    And I generate matchups
   Then "Bugs Bunny" should have a match against "Speedrunner"
    And "Roger Rabbit" should have a match against "Winnie the Pooh"

Scenario: Matchup with number of players
  Given I have started a tournament with the following players:
      | name            | rating |
      | Bugs Bunny      |    1500 |
      | Roger Rabbit    |    1501 |
      | Speedrunner     |    1502 |
      | Winnie the Pooh |    1503 |
      | Cartman         |    1504 |
    And I generate matchups
   Then there should be 2 matchups
    And there should be 1 bye

Scenario: No more then 1 bye per player
  Given I have started a tournament with the following players:
      | name            |  rating |
      | Bugs Bunny      |    1500 |
      | Roger Rabbit    |    1501 |
      | Speedrunner     |    1502 |
      | Winnie the Pooh |    1503 |
      | Cartman         |    1504 |
    And the players always draw
    And the players play 2 rounds
   Then no player should have byed more then once

Scenario: Dont generate the same matchup twice
  Given I have started a tournament with 8 players
    And the players always draw
    And the players play 3 rounds
   Then no players should have met more then once