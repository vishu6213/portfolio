const fs = require('fs');
const file = 'public/nootturno-experience/assets/js/app.1782836328290.js';
let s = fs.readFileSync(file, 'utf8');

const target1 = '_this.SHOW_AGE_GATE=!Hydra.LOCAL||Hydra.LOCAL&&Utils.query("showAgeGate")';
const replace1 = '_this.SHOW_AGE_GATE=false';

const target2 = 'Hydra.LOCAL&&!Config.SHOW_AGE_GATE&&_this.storyRoot.div.removeAttribute("inert")';
const replace2 = '!Config.SHOW_AGE_GATE&&_this.storyRoot.div.removeAttribute("inert")';

const target3 = 'const skippedAgeGate=Hydra.LOCAL&&!Config.SHOW_AGE_GATE;';
const replace3 = 'const skippedAgeGate=!Config.SHOW_AGE_GATE;';

if (!s.includes(target1)) {
    console.error('Target 1 not found!');
}
if (!s.includes(target2)) {
    console.error('Target 2 not found!');
}
if (!s.includes(target3)) {
    console.error('Target 3 not found!');
}

s = s.replace(target1, replace1);
s = s.replace(target2, replace2);
s = s.replace(target3, replace3);

fs.writeFileSync(file, s, 'utf8');
console.log('Successfully updated app.1782836328290.js to disable AgeGate natively!');
