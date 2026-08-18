const fs = require('fs');
const content = fs.readFileSync('public/nootturno-experience/assets/js/app.1782836328290.js', 'utf8');

const regex = /this\.([a-zA-Z]+Scene)\s*=\s*this\.initClass\([a-zA-Z]+Scene\s*,\s*AppState\.createLocal\(\{\s*order:\s*(\d+)\s*\}\)\)/g;
let match;
while ((match = regex.exec(content)) !== null) {
  console.log(`${match[1]}: order ${match[2]}`);
}
