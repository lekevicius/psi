# Meteor.publish "userGames", ->
# 	Games.find , { fields: { player1CurrentTurn: 0, player2CurrentTurn: 0 } }

# _.extend Meteor._LivedataSubscription.prototype,
#   publishModifiedCursor: (cursor, name, map_callback) ->
#     self = this
#     collection = name || cursor.collection_name

#     observe_handle = cursor.observe
#       added: (obj) ->
#           obj = map_callback.call self, obj
#           self.set collection, obj._id, obj
#           self.flush()
#       changed: (obj, old_idx, old_obj) ->
#           set = {}
#           obj = map_callback.call self, obj

#           _.each obj, (v, k) -> set[k] = v if !_.isEqual v, old_obj[k]
#           self.set collection, obj._id, set

#           dead_keys = _.difference _.keys(old_obj), _.keys(obj)
#           self.unset collection, obj._id, dead_keys
#           self.flush()
#       removed: (old_obj, old_idx) ->
#           old_obj = map_callback.call self, old_obj
#           self.unset collection, old_obj._id, _.keys(old_obj)
#           self.flush()

#     self.complete()
#     self.flush()
#     self.onStop(_.bind(observe_handle.stop, observe_handle))



    # unless typeof options.title is "string" &&
    #   options.title.length &&
    #   typeof options.description is "string" &&
    #   options.description.length &&
    #   typeof options.x is "number" &&
    #   options.x >= 0 &&
    #   options.x <= 1 &&
    #   typeof options.y is "number" &&
    #   options.y >= 0 &&
    #   options.y <= 1
    #     throw new Meteor.Error(400, "Required parameter missing");
    # throw new Meteor.Error 413, "Title too long" if options.title.length > 100
    # throw new Meteor.Error 413, "Description too long" if options.description.length > 1000
    # throw new Meteor.Error 403, "You must be logged in" unless this.userId

  # claimGame: (options = {}) ->
  #   Games.update options.id, { $set: { player1: this.userId, player2: this.userId } }

# var attending = function (party) {
#   return (_.groupBy(party.rsvps, 'rsvp').yes || []).length;
# };
#   invite: function (partyId, userId) {
#     var party = Parties.findOne(partyId);
#     if (! party || party.owner !== this.userId)
#       throw new Meteor.Error(404, "No such party");
#     if (party.public)
#       throw new Meteor.Error(400,
#                              "That party is public. No need to invite people.");
#     if (userId !== party.owner && ! _.contains(party.invited, userId)) {
#       Parties.update(partyId, { $addToSet: { invited: userId } });

#       var from = contactEmail(Meteor.users.findOne(this.userId));
#       var to = contactEmail(Meteor.users.findOne(userId));
#       if (Meteor.isServer && to) {
#         // This code only runs on the server. If you didn't want clients
#         // to be able to see it, you could move it to a separate file.
#         Email.send({
#           from: "noreply@example.com",
#           to: to,
#           replyTo: from || undefined,
#           subject: "PARTY: " + party.title,
#           text:
# "Hey, I just invited you to '" + party.title + "' on All Tomorrow's Parties." +
# "\n\nCome check it out: " + Meteor.absoluteUrl() + "\n"
#         });
#       }
#     }
#   },

  # rsvp: function (partyId, rsvp) {
  #   if (! this.userId)
  #     throw new Meteor.Error(403, "You must be logged in to RSVP");
  #   if (! _.contains(['yes', 'no', 'maybe'], rsvp))
  #     throw new Meteor.Error(400, "Invalid RSVP");
  #   var party = Parties.findOne(partyId);
  #   if (! party)
  #     throw new Meteor.Error(404, "No such party");
  #   if (! party.public && party.owner !== this.userId &&
  #       !_.contains(party.invited, this.userId))
  #     // private, but let's not tell this to the user
  #     throw new Meteor.Error(403, "No such party");

  #   var rsvpIndex = _.indexOf(_.pluck(party.rsvps, 'user'), this.userId);
  #   if (rsvpIndex !== -1) {
  #     // update existing rsvp entry

  #     if (Meteor.isServer) {
  #       // update the appropriate rsvp entry with $
  #       Parties.update(
  #         {_id: partyId, "rsvps.user": this.userId},
  #         {$set: {"rsvps.$.rsvp": rsvp}});
  #     } else {
  #       // minimongo doesn't yet support $ in modifier. as a temporary
  #       // workaround, make a modifier that uses an index. this is
  #       // safe on the client since there's only one thread.
  #       var modifier = {$set: {}};
  #       modifier.$set["rsvps." + rsvpIndex + ".rsvp"] = rsvp;
  #       Parties.update(partyId, modifier);
  #     }

  #     // Possible improvement: send email to the other people that are
  #     // coming to the party.
  #   } else {
  #     // add new rsvp entry
  #     Parties.update(partyId,
  #                    {$push: {rsvps: {user: this.userId, rsvp: rsvp}}});
  #   }
  # }
