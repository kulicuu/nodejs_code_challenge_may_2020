// Generated by CoffeeScript 2.5.1
(function() {
  var app, c, express;

  c = console.log.bind(console);

  express = require('express');

  app = express();

  app.get('/', function(req, res) {
    return res.send('hallo irving.');
  });

  app.listen(7000, '0.0.0.0');

}).call(this);
