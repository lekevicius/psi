Handlebars.registerHelper 'displayName', (player) -> displayName Meteor.users.findOne(player)
Handlebars.registerHelper 'availableForGame', (player) -> !! Meteor.users.findOne(player)?.profile?.availableForGame
