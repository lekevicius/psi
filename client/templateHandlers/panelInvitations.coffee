Template.outgoingInvitationsList.invitations = -> Games.find({ player1: Meteor.userId(), invited: true, accepted: false })
Template.outgoingInvitationsListItem.events
  'click .cancel-invitation': ->
    Meteor.call 'removeGame', @_id

Template.incomingInvitationsList.invitations = -> Games.find({ player2: Meteor.userId(), invited: true, accepted: false })
Template.incomingInvitationsListItem.events
  'click .accept-invitation': ->
    Meteor.call 'acceptInvitation', @_id
  'click .reject-invitation': ->
    Meteor.call 'rejectInvitation', @_id
