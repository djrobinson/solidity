const routes = require('next-routes')();

routes
  .add('/loans/new', '/loans/new')
  .add('/loans/:address', '/loans/show')

module.exports = routes;