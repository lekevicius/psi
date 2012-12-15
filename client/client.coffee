Accounts.ui.config
  passwordSignupFields: 'USERNAME_AND_EMAIL'

Meteor.subscribe "directory"
Meteor.subscribe "activeGames"

Meteor.startup () ->
  Meteor.autorun () ->
    Session.set 'openPanel', 'active-games' unless Session.get("openPanel")
