Template.panelActiveGames.events
  'click .find-new-game': ->
    availableOpponents = Meteor.users.find({ _id: { $ne: Meteor.userId() }, 'profile.availableForGame': true }).fetch()
    randomOpponentIndex = _.random(0, availableOpponents.length - 1)
    randomOpponent = availableOpponents[randomOpponentIndex]
    options = { player2: randomOpponent._id, invited: false, accepted: true }
    Meteor.call 'createGame', options

Template.activeGamesList.games = ->
  Games.find
    accepted: true
    $or: [ { player1: Meteor.userId(), player1Archived: false }, { player2: Meteor.userId(), player2Archived: false } ]

Template.activeGamesListItem.opponent = -> Meteor.users.findOne(@["player#{ 3 - playerDataNumber(@) }"])
Template.activeGamesListItem.opponentIsReady = -> @["player#{ 3 - playerDataNumber(@) }Ready"]
Template.activeGamesListItem.playerScore = -> @["player#{ playerDataNumber(@) }Score"]
Template.activeGamesListItem.opponentScore = -> @["player#{ 3 - playerDataNumber(@) }Score"]
Template.activeGamesListItem.isForfeited = -> @forfeited > 0
Template.activeGamesListItem.opponentForfeited = -> @forfeited is (3 - playerDataNumber(@))

Template.activeGamesListItem.events
  'click .player-numbers button': (e, self) ->
    Meteor.call 'doTurn', { game: self.data, number: @number }
  'click .game-info': ->
    console.log @
  'click .archive-game': ->
    Meteor.call 'archiveGame', @
  'click .forfeit-game': ->
    Meteor.call 'forfeitGame', @
    # TODO: Real forfeiting, with tracking and archiving

Template.activeGamesListItem.diceRollData = ->
  rolls = ( { roll: roll, last: false } for roll in @diceRolls )
  _.last(rolls).last = true unless @forfeited > 0 or @turn is 6
  rolls

Template.activeGamesListItem.playerNumbers = ->
  selection = 0
  selection = @player1CurrentTurn if @player1 is Meteor.userId() and @player1Ready
  selection = @player2CurrentTurn if @player2 is Meteor.userId() and @player2Ready
  playedNumbers = @["player#{ playerDataNumber(@) }playedNumbers"]
  ( { number: number, selected: (selection is number), disabled: ((selection isnt 0 and selection isnt number) or (_.contains(playedNumbers, number)) or (@forfeited > 0)) } for number in [1..6] )

Template.activeGamesListItem.opponentNumbers = ->
  playedNumbers = @player1playedNumbers if @player2 is Meteor.userId()
  playedNumbers = @player2playedNumbers if @player1 is Meteor.userId()
  ( { number: number, played: _.contains(playedNumbers, number) } for number in [1..6] )

Template.activeGamesListItem.gameOver = -> @turn is 6

playerScore = (game) -> game["player#{ playerDataNumber(game) }Score"]
opponentScore = (game) -> game["player#{ 3 - playerDataNumber(game) }Score"]
Template.activeGamesListItem.gameWon = -> (playerScore(@) > opponentScore(@))
Template.activeGamesListItem.gameTie = -> (playerScore(@) is opponentScore(@))
Template.activeGamesListItem.gameLost = -> (playerScore(@) < opponentScore(@))
