Template.panelAllUsers.events
  'change .available-for-game': (e) ->
    Meteor.call 'setUserAvailableForGame', Meteor.userId(), $(e.target).prop('checked')

Template.userList.users = -> Meteor.users.find({ _id: { $ne: Meteor.userId() } })
Template.userListItem.helpers
  alreadyInvited: (player) ->
    Games.find({ player1: Meteor.userId(), player2: player, accepted: false }).count() > 0
Template.userListItem.events
  'click .invite-user': ->
    options = { player2: @_id, invited: true }
    Meteor.call 'createGame', options
  'click .start-new-game': ->
    options = { player2: @_id, invited: false, accepted: true }
    console.log options
    Meteor.call 'createGame', options
