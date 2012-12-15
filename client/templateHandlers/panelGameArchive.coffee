Template.archivedGamesList.games = ->
  Games.find
    $or: [ { player1: Meteor.userId(), player1Archived: true }, { player2: Meteor.userId(), player2Archived: true } ]

Template.archivedGamesListItem.events
  'click .game-info': ->
    console.log @

playerScore = (game) -> game["player#{ playerDataNumber(game) }Score"]
opponentScore = (game) -> game["player#{ 3 - playerDataNumber(game) }Score"]
Template.archivedGamesListItem.gameWon = -> (playerScore(@) > opponentScore(@))
Template.archivedGamesListItem.gameTie = -> (playerScore(@) is opponentScore(@))
Template.archivedGamesListItem.gameLost = -> (playerScore(@) < opponentScore(@))
Template.archivedGamesListItem.diceRollData = -> ( { roll: roll, last: false } for roll in @diceRolls )
Template.archivedGamesListItem.playerNumbers = -> @["player#{ playerDataNumber(@) }playedNumbers"]
Template.archivedGamesListItem.opponentNumbers = -> @["player#{ 3 - playerDataNumber(@) }playedNumbers"]
Template.archivedGamesListItem.opponent = -> Meteor.users.findOne(@["player#{ 3 - playerDataNumber(@) }"])
Template.archivedGamesListItem.playerScore = -> @["player#{ playerDataNumber(@) }Score"]
Template.archivedGamesListItem.opponentScore = -> @["player#{ 3 - playerDataNumber(@) }Score"]
Template.archivedGamesListItem.isForfeited = -> @forfeited > 0
Template.archivedGamesListItem.opponentForfeited = -> @forfeited is (3 - playerDataNumber(@))
