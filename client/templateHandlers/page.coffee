Template.page.openPanel = -> Session.get('openPanel')

Template.navbar.events
  'click a.panel-link': (e) ->
    Session.set 'openPanel', $(e.currentTarget).data('panel')
    e.preventDefault()

Template.navbar.helpers
  'activeClass': (name) -> if Session.equals('openPanel', name) then 'active' else ''
