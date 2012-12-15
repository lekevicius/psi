# Accounts.config { sendVerificationEmail: true }

Meteor.publish "directory", -> Meteor.users.find {}, { fields: { username: yes, profile: yes } }

# The following filters out private data.
# Quite a lot of code if you ask me.
Meteor.publish "activeGames", ->
  find_conditions =
    player2: { $ne: null }
    $or: [ { player1: @userId }, { player2: @userId } ]
  omitValue = (doc) =>
    return 'player1CurrentTurn' if @userId is doc.player2
    return 'player2CurrentTurn' if @userId is doc.player1
  handle = Games.find(find_conditions).observe
    added: (doc, idx) =>
      @set "games", doc._id, _.omit(doc, omitValue(doc))
      @flush()
    changed: (doc, idx, old_doc) =>
      @set "games", doc._id, _.omit(doc, omitValue(doc))
      @flush()
    removed: (doc, idx) =>
      @unset "games", doc._id, _.keys(doc)
      @flush()
  @complete()
  @flush()
  @onStop -> handle.stop()
