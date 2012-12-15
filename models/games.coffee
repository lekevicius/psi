Games = new Meteor.Collection("games");

playerDataNumber = (game) ->
  return 1 if game.player1 is Meteor.userId()
  return 2 if game.player2 is Meteor.userId()

displayName = (user) ->
  return user.username if user.username
  return user.profile.name if user.profile?.name
  return user.emails[0].address

contactEmail = (user) ->
  return user.emails[0].address if user.emails && user.emails.length
  return user.services.facebook.email if user.services?.facebook?.email
  null

Meteor.methods
  createGame: (options = {}) ->
    defaults =
      player1: Meteor.userId()
      player1playedNumbers: []
      player1CurrentTurn: 0
      player1Ready: false
      player1Score: 0
      player1Archived: false
      player2: null
      player2playedNumbers: []
      player2CurrentTurn: 0
      player2Ready: false
      player2Score: 0
      player2Archived: false
      turn: 0
      diceRolls: []
      invited: false
      accepted: false
      forfeited: 0
      lastTurnDate: +(new Date)
    doc = _.defaults(_.pick(options, [ 'player2', 'invited', 'accepted' ]), defaults)
    doc.diceRolls.push _.random(1, 6) + _.random(1, 6)
    # for i in [1..6]
      # doc.diceRolls.push _.random(1, 6) + _.random(1, 6)
    Games.insert doc

  doTurn: (options = {}) ->
    playerNumber = playerDataNumber options.game

    setValues = {}
    setValues["player#{ playerNumber }CurrentTurn"] = options.number
    setValues["player#{ playerNumber }Ready"] = true

    bothReady = false
    bothReady = true if playerNumber is 1 and options.game.player2Ready
    bothReady = true if playerNumber is 2 and options.game.player1Ready

    gameId = options.game._id

    if Meteor.isServer
      game = Games.findOne gameId
      # making sure there can't possibly be a stuck situation because of latency
      bothReady = true if not bothReady and game.player1Ready and game.player2Ready

    if bothReady
      if Meteor.isServer

        player1Number = options.number if playerNumber is 1
        player2Number = options.number if playerNumber is 2
        player1Number = game.player1CurrentTurn if playerNumber is 2
        player2Number = game.player2CurrentTurn if playerNumber is 1

        # console.log "player1 played #{ player1Number } and player2 played #{ player2Number }"

        setValues =
          player1CurrentTurn: 0
          player2CurrentTurn: 0
          player1Ready: false
          player2Ready: false

        if player1Number > player2Number
          setValues.player1Score = game.player1Score + _.last game.diceRolls
        if player2Number > player1Number
          setValues.player2Score = game.player2Score + _.last game.diceRolls

        pushValues =
          diceRolls: _.random(1, 6) + _.random(1, 6)
          player1playedNumbers: player1Number
          player2playedNumbers: player2Number

        delete pushValues.diceRolls if game.turn is 5

        Games.update gameId, { $set: setValues, $inc: { turn: 1 }, $push: pushValues }

    else
      Games.update gameId, { $set: setValues }

  removeGame: (id) ->
    Games.remove { _id: id }

  archiveGame: (id) ->
    game = Games.findOne id
    playerNumber = playerDataNumber game
    setValues = {}
    setValues["player#{ playerNumber }Archived"] = true
    Games.update game._id, { $set: setValues }

  forfeitGame: (id) ->
    game = Games.findOne id
    playerNumber = playerDataNumber game
    Games.update game._id, { $set: { forfeited: playerNumber } }

  acceptInvitation: (id) ->
    Games.update { _id: id }, { $set: { accepted: true } }

  rejectInvitation: (id) ->
    Games.remove { _id: id }

  setUserAvailableForGame: (userId, value) ->
    Meteor.users.update { _id: userId }, { $set: { profile: { availableForGame: value } } }

# Users
