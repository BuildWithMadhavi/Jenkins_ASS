const assert = require('assert');
const { greet } = require('../lib/greet');

try {
  assert.strictEqual(greet(), 'Hello from CI-CD Demo!');
  console.log('Test passed');
  process.exit(0);
} catch (e) {
  console.error('Test failed', e.message);
  process.exit(1);
}
