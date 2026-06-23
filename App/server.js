const express = require('express');
const { greet } = require('../lib/greet');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`<h1>${greet()}</h1>`);
});

app.listen(PORT, () => console.log(`Server listening on ${PORT}`));

module.exports = app;
