const fs = require('fs');
const file = 'public/nootturno-experience/assets/js/app.1782836328290.js';
let s = fs.readFileSync(file, 'utf8');

const target1 = '_this.SHOW_AGE_GATE=!Hydra.LOCAL||Hydra.LOCAL&&Utils.query("showAgeGate")';
const replace1 = '_this.SHOW_AGE_GATE=false';

const target2 = 'Hydra.LOCAL&&!Config.SHOW_AGE_GATE&&_this.storyRoot.div.removeAttribute("inert")';
const replace2 = '!Config.SHOW_AGE_GATE&&_this.storyRoot.div.removeAttribute("inert")';

const target3 = 'const skippedAgeGate=Hydra.LOCAL&&!Config.SHOW_AGE_GATE;';
const replace3 = 'const skippedAgeGate=!Config.SHOW_AGE_GATE;';

console.log('Target 1 found:', s.includes(target1));
console.log('Target 2 found:', s.includes(target2));
console.log('Target 3 found:', s.includes(target3));

s = s.replace(target1, replace1);
s = s.replace(target2, replace2);
s = s.replace(target3, replace3);

fs.writeFileSync(file, s, 'utf8');
console.log('Successfully updated app.1782836328290.js to disable AgeGate natively!');
