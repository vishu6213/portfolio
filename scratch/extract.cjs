const fs = require('fs');
const content = fs.readFileSync('public/nootturno-experience/assets/js/app.1782836328290.js', 'utf8');
const m = content.match(/this\.fragName=\"([^\"]+)\"/g);
if (m) console.log([...new Set(m)].join('\n'));
