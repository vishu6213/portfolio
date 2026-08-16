{@}aastep.glsl{@}float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float aastep(float threshold, float value, float padding) {
    return smoothstep(threshold - padding, threshold + padding, value);
}

vec2 aastep(vec2 threshold, vec2 value) {
    return vec2(
        aastep(threshold.x, value.x),
        aastep(threshold.y, value.y)
    );
}{@}AntimatterCopy.fs{@}uniform sampler2D tDiffuse;

varying vec2 vUv;

void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
}{@}AntimatterCopy.vs{@}varying vec2 vUv;
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}AntimatterPass.vs{@}varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}AntimatterPosition.vs{@}uniform sampler2D tPos;
uniform float uDPR;

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.02 * uDPR) * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}{@}AntimatterBasicFrag.fs{@}void main() {
    gl_FragColor = vec4(1.0);
}{@}antimatter.glsl{@}vec3 getData(sampler2D tex, vec2 uv) {
    return texture2D(tex, uv).xyz;
}

vec4 getData4(sampler2D tex, vec2 uv) {
    return texture2D(tex, uv);
}

{@}blendmodes.glsl{@}float blendColorDodge(float base, float blend) {
    return (blend == 1.0)?blend:min(base/(1.0-blend), 1.0);
}
vec3 blendColorDodge(vec3 base, vec3 blend) {
    return vec3(blendColorDodge(base.r, blend.r), blendColorDodge(base.g, blend.g), blendColorDodge(base.b, blend.b));
}
vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
    return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}
float blendColorBurn(float base, float blend) {
    return (blend == 0.0)?blend:max((1.0-((1.0-base)/blend)), 0.0);
}
vec3 blendColorBurn(vec3 base, vec3 blend) {
    return vec3(blendColorBurn(base.r, blend.r), blendColorBurn(base.g, blend.g), blendColorBurn(base.b, blend.b));
}
vec3 blendColorBurn(vec3 base, vec3 blend, float opacity) {
    return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
}
float blendVividLight(float base, float blend) {
    return (blend<0.5)?blendColorBurn(base, (2.0*blend)):blendColorDodge(base, (2.0*(blend-0.5)));
}
vec3 blendVividLight(vec3 base, vec3 blend) {
    return vec3(blendVividLight(base.r, blend.r), blendVividLight(base.g, blend.g), blendVividLight(base.b, blend.b));
}
vec3 blendVividLight(vec3 base, vec3 blend, float opacity) {
    return (blendVividLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendHardMix(float base, float blend) {
    return (blendVividLight(base, blend)<0.5)?0.0:1.0;
}
vec3 blendHardMix(vec3 base, vec3 blend) {
    return vec3(blendHardMix(base.r, blend.r), blendHardMix(base.g, blend.g), blendHardMix(base.b, blend.b));
}
vec3 blendHardMix(vec3 base, vec3 blend, float opacity) {
    return (blendHardMix(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearDodge(float base, float blend) {
    return min(base+blend, 1.0);
}
vec3 blendLinearDodge(vec3 base, vec3 blend) {
    return min(base+blend, vec3(1.0));
}
vec3 blendLinearDodge(vec3 base, vec3 blend, float opacity) {
    return (blendLinearDodge(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearBurn(float base, float blend) {
    return max(base+blend-1.0, 0.0);
}
vec3 blendLinearBurn(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0), vec3(0.0));
}
vec3 blendLinearBurn(vec3 base, vec3 blend, float opacity) {
    return (blendLinearBurn(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearLight(float base, float blend) {
    return blend<0.5?blendLinearBurn(base, (2.0*blend)):blendLinearDodge(base, (2.0*(blend-0.5)));
}
vec3 blendLinearLight(vec3 base, vec3 blend) {
    return vec3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
}
vec3 blendLinearLight(vec3 base, vec3 blend, float opacity) {
    return (blendLinearLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLighten(float base, float blend) {
    return max(blend, base);
}
vec3 blendLighten(vec3 base, vec3 blend) {
    return vec3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
}
vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
    return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
}
float blendDarken(float base, float blend) {
    return min(blend, base);
}
vec3 blendDarken(vec3 base, vec3 blend) {
    return vec3(blendDarken(base.r, blend.r), blendDarken(base.g, blend.g), blendDarken(base.b, blend.b));
}
vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
    return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
}
float blendPinLight(float base, float blend) {
    return (blend<0.5)?blendDarken(base, (2.0*blend)):blendLighten(base, (2.0*(blend-0.5)));
}
vec3 blendPinLight(vec3 base, vec3 blend) {
    return vec3(blendPinLight(base.r, blend.r), blendPinLight(base.g, blend.g), blendPinLight(base.b, blend.b));
}
vec3 blendPinLight(vec3 base, vec3 blend, float opacity) {
    return (blendPinLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendReflect(float base, float blend) {
    return (blend == 1.0)?blend:min(base*base/(1.0-blend), 1.0);
}
vec3 blendReflect(vec3 base, vec3 blend) {
    return vec3(blendReflect(base.r, blend.r), blendReflect(base.g, blend.g), blendReflect(base.b, blend.b));
}
vec3 blendReflect(vec3 base, vec3 blend, float opacity) {
    return (blendReflect(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendGlow(vec3 base, vec3 blend) {
    return blendReflect(blend, base);
}
vec3 blendGlow(vec3 base, vec3 blend, float opacity) {
    return (blendGlow(base, blend) * opacity + base * (1.0 - opacity));
}
float blendOverlay(float base, float blend) {
    return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}
vec3 blendOverlay(vec3 base, vec3 blend) {
    return vec3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
}
vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
    return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendHardLight(vec3 base, vec3 blend) {
    return blendOverlay(blend, base);
}
vec3 blendHardLight(vec3 base, vec3 blend, float opacity) {
    return (blendHardLight(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendPhoenix(vec3 base, vec3 blend) {
    return min(base, blend)-max(base, blend)+vec3(1.0);
}
vec3 blendPhoenix(vec3 base, vec3 blend, float opacity) {
    return (blendPhoenix(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendNormal(vec3 base, vec3 blend) {
    return blend;
}
vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
    return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendNegation(vec3 base, vec3 blend) {
    return vec3(1.0)-abs(vec3(1.0)-base-blend);
}
vec3 blendNegation(vec3 base, vec3 blend, float opacity) {
    return (blendNegation(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendMultiply(vec3 base, vec3 blend) {
    return base*blend;
}
vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
    return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendAverage(vec3 base, vec3 blend) {
    return (base+blend)/2.0;
}
vec3 blendAverage(vec3 base, vec3 blend, float opacity) {
    return (blendAverage(base, blend) * opacity + base * (1.0 - opacity));
}
float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}
vec3 blendScreen(vec3 base, vec3 blend) {
    return vec3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
}
vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
    return (blendScreen(base, blend) * opacity + base * (1.0 - opacity));
}
float blendSoftLight(float base, float blend) {
    return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}
vec3 blendSoftLight(vec3 base, vec3 blend) {
    return vec3(blendSoftLight(base.r, blend.r), blendSoftLight(base.g, blend.g), blendSoftLight(base.b, blend.b));
}
vec3 blendSoftLight(vec3 base, vec3 blend, float opacity) {
    return (blendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendSubtract(float base, float blend) {
    return max(base+blend-1.0, 0.0);
}
vec3 blendSubtract(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0), vec3(0.0));
}
vec3 blendSubtract(vec3 base, vec3 blend, float opacity) {
    return (blendSubtract(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendExclusion(vec3 base, vec3 blend) {
    return base+blend-2.0*base*blend;
}
vec3 blendExclusion(vec3 base, vec3 blend, float opacity) {
    return (blendExclusion(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendDifference(vec3 base, vec3 blend) {
    return abs(base-blend);
}
vec3 blendDifference(vec3 base, vec3 blend, float opacity) {
    return (blendDifference(base, blend) * opacity + base * (1.0 - opacity));
}
float blendAdd(float base, float blend) {
    return min(base+blend, 1.0);
}
vec3 blendAdd(vec3 base, vec3 blend) {
    return min(base+blend, vec3(1.0));
}
vec3 blendAdd(vec3 base, vec3 blend, float opacity) {
    return (blendAdd(base, blend) * opacity + base * (1.0 - opacity));
}{@}conditionals.glsl{@}vec4 when_eq(vec4 x, vec4 y) {
  return 1.0 - abs(sign(x - y));
}

vec4 when_neq(vec4 x, vec4 y) {
  return abs(sign(x - y));
}

vec4 when_gt(vec4 x, vec4 y) {
  return max(sign(x - y), 0.0);
}

vec4 when_lt(vec4 x, vec4 y) {
  return max(sign(y - x), 0.0);
}

vec4 when_ge(vec4 x, vec4 y) {
  return 1.0 - when_lt(x, y);
}

vec4 when_le(vec4 x, vec4 y) {
  return 1.0 - when_gt(x, y);
}

vec3 when_eq(vec3 x, vec3 y) {
  return 1.0 - abs(sign(x - y));
}

vec3 when_neq(vec3 x, vec3 y) {
  return abs(sign(x - y));
}

vec3 when_gt(vec3 x, vec3 y) {
  return max(sign(x - y), 0.0);
}

vec3 when_lt(vec3 x, vec3 y) {
  return max(sign(y - x), 0.0);
}

vec3 when_ge(vec3 x, vec3 y) {
  return 1.0 - when_lt(x, y);
}

vec3 when_le(vec3 x, vec3 y) {
  return 1.0 - when_gt(x, y);
}

vec2 when_eq(vec2 x, vec2 y) {
  return 1.0 - abs(sign(x - y));
}

vec2 when_neq(vec2 x, vec2 y) {
  return abs(sign(x - y));
}

vec2 when_gt(vec2 x, vec2 y) {
  return max(sign(x - y), 0.0);
}

vec2 when_lt(vec2 x, vec2 y) {
  return max(sign(y - x), 0.0);
}

vec2 when_ge(vec2 x, vec2 y) {
  return 1.0 - when_lt(x, y);
}

vec2 when_le(vec2 x, vec2 y) {
  return 1.0 - when_gt(x, y);
}

float when_eq(float x, float y) {
  return 1.0 - abs(sign(x - y));
}

float when_neq(float x, float y) {
  return abs(sign(x - y));
}

float when_gt(float x, float y) {
  return max(sign(x - y), 0.0);
}

float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

float when_ge(float x, float y) {
  return 1.0 - when_lt(x, y);
}

float when_le(float x, float y) {
  return 1.0 - when_gt(x, y);
}

vec4 and(vec4 a, vec4 b) {
  return a * b;
}

vec4 or(vec4 a, vec4 b) {
  return min(a + b, 1.0);
}

vec4 Not(vec4 a) {
  return 1.0 - a;
}

vec3 and(vec3 a, vec3 b) {
  return a * b;
}

vec3 or(vec3 a, vec3 b) {
  return min(a + b, 1.0);
}

vec3 Not(vec3 a) {
  return 1.0 - a;
}

vec2 and(vec2 a, vec2 b) {
  return a * b;
}

vec2 or(vec2 a, vec2 b) {
  return min(a + b, 1.0);
}


vec2 Not(vec2 a) {
  return 1.0 - a;
}

float and(float a, float b) {
  return a * b;
}

float or(float a, float b) {
  return min(a + b, 1.0);
}

float Not(float a) {
  return 1.0 - a;
}{@}curl.glsl{@}#test Device.mobile
float sinf2(float x) {
    x*=0.159155;
    x-=floor(x);
    float xx=x*x;
    float y=-6.87897;
    y=y*xx+33.7755;
    y=y*xx-72.5257;
    y=y*xx+80.5874;
    y=y*xx-41.2408;
    y=y*xx+6.28077;
    return x*y;
}

float cosf2(float x) {
    return sinf2(x+1.5708);
}
#endtest

#test !Device.mobile
    #define sinf2 sin
    #define cosf2 cos
#endtest

float potential1(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.x * 1.8 + v.z * 3.) + sinf2(v.x * 4.8 + v.z * 4.5) + sinf2(v.x * -7.0 + v.z * 1.2) + sinf2(v.x * -5.0 + v.z * 2.13);
    noise += sinf2(v.y * -0.48 + v.z * 5.4) + sinf2(v.y * 2.56 + v.z * 5.4) + sinf2(v.y * 4.16 + v.z * 2.4) + sinf2(v.y * -4.16 + v.z * 1.35);
    return noise;
}

float potential2(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.y * 1.8 + v.x * 3. - 2.82) + sinf2(v.y * 4.8 + v.x * 4.5 + 74.37) + sinf2(v.y * -7.0 + v.x * 1.2 - 256.72) + sinf2(v.y * -5.0 + v.x * 2.13 - 207.683);
    noise += sinf2(v.z * -0.48 + v.x * 5.4 -125.796) + sinf2(v.z * 2.56 + v.x * 5.4 + 17.692) + sinf2(v.z * 4.16 + v.x * 2.4 + 150.512) + sinf2(v.z * -4.16 + v.x * 1.35 - 222.137);
    return noise;
}

float potential3(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.z * 1.8 + v.y * 3. - 194.58) + sinf2(v.z * 4.8 + v.y * 4.5 - 83.13) + sinf2(v.z * -7.0 + v.y * 1.2 -845.2) + sinf2(v.z * -5.0 + v.y * 2.13 - 762.185);
    noise += sinf2(v.x * -0.48 + v.y * 5.4 - 707.916) + sinf2(v.x * 2.56 + v.y * 5.4 + -482.348) + sinf2(v.x * 4.16 + v.y * 2.4 + 9.872) + sinf2(v.x * -4.16 + v.y * 1.35 - 476.747);
    return noise;
}

vec3 snoiseVec3( vec3 x ) {
    float s  = potential1(x);
    float s1 = potential2(x);
    float s2 = potential3(x);
    return vec3( s , s1 , s2 );
}

//Analitic derivatives of the potentials for the curl noise, based on: http://weber.itn.liu.se/~stegu/TNM084-2019/bridson-siggraph2007-curlnoise.pdf

float dP3dY(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.z * 1.8 + v.y * 3. - 194.58) + 4.5 * cosf2(v.z * 4.8 + v.y * 4.5 - 83.13) + 1.2 * cosf2(v.z * -7.0 + v.y * 1.2 -845.2) + 2.13 * cosf2(v.z * -5.0 + v.y * 2.13 - 762.185);
    noise += 5.4 * cosf2(v.x * -0.48 + v.y * 5.4 - 707.916) + 5.4 * cosf2(v.x * 2.56 + v.y * 5.4 + -482.348) + 2.4 * cosf2(v.x * 4.16 + v.y * 2.4 + 9.872) + 1.35 * cosf2(v.x * -4.16 + v.y * 1.35 - 476.747);
    return noise;
}

float dP2dZ(vec3 v) {
    return -0.48 * cosf2(v.z * -0.48 + v.x * 5.4 -125.796) + 2.56 * cosf2(v.z * 2.56 + v.x * 5.4 + 17.692) + 4.16 * cosf2(v.z * 4.16 + v.x * 2.4 + 150.512) -4.16 * cosf2(v.z * -4.16 + v.x * 1.35 - 222.137);
}

float dP1dZ(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.x * 1.8 + v.z * 3.) + 4.5 * cosf2(v.x * 4.8 + v.z * 4.5) + 1.2 * cosf2(v.x * -7.0 + v.z * 1.2) + 2.13 * cosf2(v.x * -5.0 + v.z * 2.13);
    noise += 5.4 * cosf2(v.y * -0.48 + v.z * 5.4) + 5.4 * cosf2(v.y * 2.56 + v.z * 5.4) + 2.4 * cosf2(v.y * 4.16 + v.z * 2.4) + 1.35 * cosf2(v.y * -4.16 + v.z * 1.35);
    return noise;
}

float dP3dX(vec3 v) {
    return -0.48 * cosf2(v.x * -0.48 + v.y * 5.4 - 707.916) + 2.56 * cosf2(v.x * 2.56 + v.y * 5.4 + -482.348) + 4.16 * cosf2(v.x * 4.16 + v.y * 2.4 + 9.872) -4.16 * cosf2(v.x * -4.16 + v.y * 1.35 - 476.747);
}

float dP2dX(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.y * 1.8 + v.x * 3. - 2.82) + 4.5 * cosf2(v.y * 4.8 + v.x * 4.5 + 74.37) + 1.2 * cosf2(v.y * -7.0 + v.x * 1.2 - 256.72) + 2.13 * cosf2(v.y * -5.0 + v.x * 2.13 - 207.683);
    noise += 5.4 * cosf2(v.z * -0.48 + v.x * 5.4 -125.796) + 5.4 * cosf2(v.z * 2.56 + v.x * 5.4 + 17.692) + 2.4 * cosf2(v.z * 4.16 + v.x * 2.4 + 150.512) + 1.35 * cosf2(v.z * -4.16 + v.x * 1.35 - 222.137);
    return noise;
}

float dP1dY(vec3 v) {
    return -0.48 * cosf2(v.y * -0.48 + v.z * 5.4) + 2.56 * cosf2(v.y * 2.56 + v.z * 5.4) +  4.16 * cosf2(v.y * 4.16 + v.z * 2.4) -4.16 * cosf2(v.y * -4.16 + v.z * 1.35);
}


vec3 curlNoise( vec3 p ) {

    //A sinf2 or cosf2 call is a trigonometric function, these functions are expensive in the GPU
    //the partial derivatives with approximations require to calculate the snoiseVec3 function 4 times.
    //The previous function evaluate the potentials that include 8 trigonometric functions each.
    //
    //This means that the potentials are evaluated 12 times (4 calls to snoiseVec3 that make 3 potential calls).
    //The whole process call 12 * 8 trigonometric functions, a total of 96 times.


    /*
    const float e = 1e-1;
    vec3 dx = vec3( e   , 0.0 , 0.0 );
    vec3 dy = vec3( 0.0 , e   , 0.0 );
    vec3 dz = vec3( 0.0 , 0.0 , e   );
    vec3 p0 = snoiseVec3(p);
    vec3 p_x1 = snoiseVec3( p + dx );
    vec3 p_y1 = snoiseVec3( p + dy );
    vec3 p_z1 = snoiseVec3( p + dz );
    float x = p_y1.z - p0.z - p_z1.y + p0.y;
    float y = p_z1.x - p0.x - p_x1.z + p0.z;
    float z = p_x1.y - p0.y - p_y1.x + p0.x;
    return normalize( vec3( x , y , z ));
    */


    //The noise that is used to define the potentials is based on analitic functions that are easy to derivate,
    //meaning that the analitic solution would provide a much faster approach with the same visual results.
    //
    //Usinf2g the analitic derivatives the algorithm does not require to evaluate snoiseVec3, instead it uses the
    //analitic partial derivatives from each potential on the corresponding axis, providing a total of
    //36 calls to trigonometric functions, making the analytic evaluation almost 3 times faster than the aproximation method.


    float x = dP3dY(p) - dP2dZ(p);
    float y = dP1dZ(p) - dP3dX(p);
    float z = dP2dX(p) - dP1dY(p);


    return normalize( vec3( x , y , z ));



}{@}eases.glsl{@}#ifndef PI
#define PI 3.141592653589793
#endif

#ifndef HALF_PI
#define HALF_PI 1.5707963267948966
#endif

float backInOut(float t) {
  float f = t < 0.5
    ? 2.0 * t
    : 1.0 - (2.0 * t - 1.0);

  float g = pow(f, 3.0) - f * sin(f * PI);

  return t < 0.5
    ? 0.5 * g
    : 0.5 * (1.0 - g) + 0.5;
}

float backIn(float t) {
  return pow(t, 3.0) - t * sin(t * PI);
}

float backOut(float t) {
  float f = 1.0 - t;
  return 1.0 - (pow(f, 3.0) - f * sin(f * PI));
}

float bounceOut(float t) {
  const float a = 4.0 / 11.0;
  const float b = 8.0 / 11.0;
  const float c = 9.0 / 10.0;

  const float ca = 4356.0 / 361.0;
  const float cb = 35442.0 / 1805.0;
  const float cc = 16061.0 / 1805.0;

  float t2 = t * t;

  return t < a
    ? 7.5625 * t2
    : t < b
      ? 9.075 * t2 - 9.9 * t + 3.4
      : t < c
        ? ca * t2 - cb * t + cc
        : 10.8 * t * t - 20.52 * t + 10.72;
}

float bounceIn(float t) {
  return 1.0 - bounceOut(1.0 - t);
}

float bounceInOut(float t) {
  return t < 0.5
    ? 0.5 * (1.0 - bounceOut(1.0 - t * 2.0))
    : 0.5 * bounceOut(t * 2.0 - 1.0) + 0.5;
}

float circularInOut(float t) {
  return t < 0.5
    ? 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
    : 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
}

float circularIn(float t) {
  return 1.0 - sqrt(1.0 - t * t);
}

float circularOut(float t) {
  return sqrt((2.0 - t) * t);
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * -pow(2.0 - 2.0 * t, 3.0) + 1.0;
}

float cubicIn(float t) {
  return t * t * t;
}

float cubicOut(float t) {
  float f = t - 1.0;
  return f * f * f + 1.0;
}

float elasticInOut(float t) {
  return t < 0.5
    ? 0.5 * sin(+13.0 * HALF_PI * 2.0 * t) * pow(2.0, 10.0 * (2.0 * t - 1.0))
    : 0.5 * sin(-13.0 * HALF_PI * ((2.0 * t - 1.0) + 1.0)) * pow(2.0, -10.0 * (2.0 * t - 1.0)) + 1.0;
}

float elasticIn(float t) {
  return sin(13.0 * t * HALF_PI) * pow(2.0, 10.0 * (t - 1.0));
}

float elasticOut(float t) {
  return sin(-13.0 * (t + 1.0) * HALF_PI) * pow(2.0, -10.0 * t) + 1.0;
}

float expoInOut(float t) {
  return t == 0.0 || t == 1.0
    ? t
    : t < 0.5
      ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
      : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float expoIn(float t) {
  return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
}

float expoOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

float linear(float t) {
  return t;
}

float quadraticInOut(float t) {
  float p = 2.0 * t * t;
  return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float quadraticIn(float t) {
  return t * t;
}

float quadraticOut(float t) {
  return -t * (t - 2.0);
}

float quarticInOut(float t) {
  return t < 0.5
    ? +8.0 * pow(t, 4.0)
    : -8.0 * pow(1.0 - t, 4.0) + 1.0;
}

float quarticIn(float t) {
  return pow(t, 4.0);
}

float quarticOut(float t) {
  return pow(1.0 - t, 3.0) * (t - 1.0) + 1.0;
}

float qinticInOut(float t) {
  return t < 0.5
    ? +16.0 * pow(t, 5.0)
    : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float qinticIn(float t) {
  return pow(t, 5.0);
}

float qinticOut(float t) {
  return 1.0 - (pow(1.0 - t, 5.0));
}

float sineInOut(float t) {
  return -0.5 * (cos(PI * t) - 1.0);
}

float sineIn(float t) {
  return sin((t - 1.0) * HALF_PI) + 1.0;
}

float sineOut(float t) {
  return sin(t * HALF_PI);
}
{@}ColorMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 color;
uniform float alpha;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;
#!VARYINGS

#!SHADER: ColorMaterial.vs
void main() {
    vec3 localPos = position;
    if (uFixed > 0.5) {
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(localPos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(localPos, 1.0);
    }
}

#!SHADER: ColorMaterial.fs
void main() {
    gl_FragColor = vec4(color, alpha);
    //gl_FragColor.rgb /= gl_FragColor.a;
}{@}DebugCamera.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;

#!VARYINGS
varying vec3 vColor;

#!SHADER: DebugCamera.vs
void main() {
    vColor = mix(uColor, vec3(1.0, 0.0, 0.0), step(position.z, -0.1));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: DebugCamera.fs
void main() {
    gl_FragColor = vec4(vColor, 1.0);
}{@}OcclusionMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 bbMin;
uniform vec3 bbMax;

#!VARYINGS

#!SHADER: Vertex.vs
void main() {
    vec3 pos = position;
    pos *= bbMax - bbMin;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment.fs
void main() {
    gl_FragColor = vec4(1.0);
}{@}ScreenQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS

#!SHADER: ScreenQuad.vs
void main() {
    gl_Position = vec4(position, 1.0);
}

#!SHADER: ScreenQuad.fs
void main() {
    gl_FragColor = texture2D(tMap, gl_FragCoord.xy / resolution);
    gl_FragColor.a = 1.0;
}{@}ScreenQuadVR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uEye;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex

vec2 scaleUV(vec2 uv, vec2 scale, vec2 origin) {
    vec2 st = uv - origin;
    st /= scale;
    return st + origin;
}

void main() {
    vUv = scaleUV(uv, vec2(2.0, 1.0), vec2(0.0)) - vec2(uEye, 0.0);
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = texture2D(tMap, vUv);
}{@}TestMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float alpha;

#!VARYINGS
varying vec3 vNormal;

#!SHADER: TestMaterial.vs
void main() {
    vec3 pos = position;
    vNormal = normalMatrix * normal;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: TestMaterial.fs
void main() {
    gl_FragColor = vec4(1.0);
}{@}TextureMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;

#!VARYINGS
varying vec2 vUv;

#!SHADER: TextureMaterial.vs
void main() {
    vUv = uv;
    vec3 localPos = position;
    if (uFixed > 0.5) {
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(localPos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
}

#!SHADER: TextureMaterial.fs
void main() {
    gl_FragColor = texture2D(tMap, vUv);
    gl_FragColor.a *= uAlpha;
    gl_FragColor.rgb /= gl_FragColor.a;
}{@}BlitPass.fs{@}void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
}
{@}NukePass.vs{@}varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}ShadowDepth.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: ShadowDepth.vs
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: ShadowDepth.fs
void main() {
    gl_FragColor = vec4(vec3(gl_FragCoord.x), 1.0);
}{@}instance.vs{@}vec3 transformNormal(vec3 n, vec4 orientation) {
    vec3 nn = n + 2.0 * cross(orientation.xyz, cross(orientation.xyz, n) + orientation.w * n);
    return nn;
}

vec3 transformPosition(vec3 position, vec3 offset, vec3 scale, vec4 orientation) {
    vec3 _pos = position;
    _pos *= scale;

    _pos = _pos + 2.0 * cross(orientation.xyz, cross(orientation.xyz, _pos) + orientation.w * _pos);
    _pos += offset;
    return _pos;
}

vec3 transformPosition(vec3 position, vec3 offset, vec4 orientation) {
    vec3 _pos = position;

    _pos = _pos + 2.0 * cross(orientation.xyz, cross(orientation.xyz, _pos) + orientation.w * _pos);
    _pos += offset;
    return _pos;
}

vec3 transformPosition(vec3 position, vec3 offset, float scale, vec4 orientation) {
    return transformPosition(position, offset, vec3(scale), orientation);
}

vec3 transformPosition(vec3 position, vec3 offset) {
    return position + offset;
}

vec3 transformPosition(vec3 position, vec3 offset, float scale) {
    vec3 pos = position * scale;
    return pos + offset;
}

vec3 transformPosition(vec3 position, vec3 offset, vec3 scale) {
    vec3 pos = position * scale;
    return pos + offset;
}{@}lights.fs{@}vec3 worldLight(vec3 pos, vec3 vpos) {
    vec4 mvPos = modelViewMatrix * vec4(vpos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}{@}lights.vs{@}vec3 worldLight(vec3 pos) {
    vec4 mvPos = modelViewMatrix * vec4(position, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}

vec3 worldLight(vec3 lightPos, vec3 localPos) {
    vec4 mvPos = modelViewMatrix * vec4(localPos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(lightPos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}{@}shadows.fs{@}#define PI2 6.2831853072
#define PI 3.141592653589793

#define MAX_PCSS_SAMPLES 17
vec2 poissonDisk[MAX_PCSS_SAMPLES];

struct PCSShadowConfig {
    int sampleCount;
    int ringCount;
    float lightWorldSize;
    float lightFrustumWidth;
    float nearPlane;
};

PCSShadowConfig defaultPCSSShadowConfig() {
    PCSShadowConfig config;
    config.sampleCount = 10;
    config.ringCount = 11;
    config.lightWorldSize = 0.3;
    config.lightFrustumWidth = 6.75;
    config.nearPlane = 6.5;
    return config;
}

bool frustumTest(vec3 coords) {
    return coords.x >= 0.0 && coords.x <= 1.0 && coords.y >= 0.0 && coords.y <= 1.0 && coords.z <= 1.0;
}

float rand(float n){return fract(sin(n) * 43758.5453123);}
highp float rand( const in vec2 uv ) {
    const highp float a = 12.9898, b = 78.233, c = 43758.5453;
    highp float dt = dot( uv.xy, vec2( a, b ) ), sn = mod( dt, PI );
    return fract( sin( sn ) * c );
}

void initPoissonSamples(const in vec2 randomSeed, PCSShadowConfig config) {
    float angleStep = PI2 * float(config.ringCount) / float(config.sampleCount);
    float invSampleCount = 1.0 / float(config.sampleCount);
    float angle = rand(randomSeed) * PI2;
    float radius = invSampleCount;
    float radiusStep = radius;
    
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > config.sampleCount ) {
            break;
        }
        poissonDisk[i] = vec2(cos(angle), sin(angle)) * pow(radius, 0.75);
        radius += radiusStep;
        angle += angleStep;
    }
}

float penumbraSize(const in float zReceiver, const in float zBlocker) {
    return (zReceiver - zBlocker) / zBlocker;
}

float findBlocker(sampler2D shadowMap, const in vec2 uv, const in float zReceiver, PCSShadowConfig config) {
    // This uses similar triangles to compute what
    // area of the shadow map we should search
    float lightSizeUV = config.lightWorldSize / config.lightFrustumWidth;
    float searchRadius = lightSizeUV * (zReceiver - config.nearPlane) / zReceiver;
    float blockerDepthSum = 0.0;
    int numBlockers = 0;
    
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > config.sampleCount ) {
            break;
        }
        float shadowMapDepth = texture2D(shadowMap, uv + poissonDisk[i] * searchRadius).r;
        if (shadowMapDepth < zReceiver) {
            blockerDepthSum += shadowMapDepth;
            numBlockers ++ ;
        }
    }
    
    if (numBlockers == 0)return -1.0;
    
    return blockerDepthSum / float(numBlockers);
}

float pcfFilter(sampler2D shadowMap, vec2 uv, float zReceiver, float filterRadius, PCSShadowConfig config) {
    float sum = 0.0;
    float depth;
    int numSamples = config.sampleCount;
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > numSamples ) {
            break;
        }
        depth = texture2D(shadowMap, uv + poissonDisk[i] * filterRadius).r;
        if (zReceiver <= depth) sum += 1.0;
    }
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > numSamples ) {
            break;
        }
        depth = texture2D(shadowMap, uv + -poissonDisk[i].yx * filterRadius).r;
        if (zReceiver <= depth) sum += 1.0;
    }
    return sum / (2.0 * float(numSamples));
}

float PCSS(sampler2D shadowMap, vec3 coords, PCSShadowConfig config) {
    vec2 uv = coords.xy;
    float zReceiver = coords.z; // Assumed to be eye-space z in this code
    
    initPoissonSamples(uv, config);
    
    float avgBlockerDepth = findBlocker(shadowMap, uv, zReceiver, config);
    if (avgBlockerDepth == -1.0)return 1.0; 

    float penumbraRatio = penumbraSize(zReceiver, avgBlockerDepth);
    float lightSizeUV = config.lightWorldSize / config.lightFrustumWidth;
    float filterRadius = penumbraRatio * lightSizeUV * config.nearPlane / zReceiver;    

    return pcfFilter(shadowMap, uv, zReceiver, filterRadius, config);
}

float shadowLookupPCSS(sampler2D map, vec3 coords, float size, float compare, vec3 wpos, PCSShadowConfig config) {
    float shadow = 1.0;
    bool frustumTest = frustumTest(coords);
    if (frustumTest) {
        shadow = PCSS(map, coords, config);
    }
    return clamp(shadow, 0.0, 1.0);
}

float shadowCompare(sampler2D map, vec2 coords, float compare) {
    return step(compare, texture2D(map, coords).r);
}

float shadowLerp(sampler2D map, vec2 coords, float compare, float size) {
    const vec2 offset = vec2(0.0, 1.0);

    vec2 texelSize = vec2(1.0) / size;
    vec2 centroidUV = floor(coords * size + 0.5) / size;

    float lb = shadowCompare(map, centroidUV + texelSize * offset.xx, compare);
    float lt = shadowCompare(map, centroidUV + texelSize * offset.xy, compare);
    float rb = shadowCompare(map, centroidUV + texelSize * offset.yx, compare);
    float rt = shadowCompare(map, centroidUV + texelSize * offset.yy, compare);

    vec2 f = fract( coords * size + 0.5 );

    float a = mix( lb, lt, f.y );
    float b = mix( rb, rt, f.y );
    float c = mix( a, b, f.x );

    return c;
}

float srange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    float oldRange = oldMax - oldMin;
    float newRange = newMax - newMin;
    return (((oldValue - oldMin) * newRange) / oldRange) + newMin;
}

float shadowrandom(vec3 vin) {
    vec3 v = vin * 0.1;
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += srange(sin(v.x * 0.9 / s + t * 10.0) + sin(v.x * 2.4 / s + t * 15.0) + sin(v.x * -3.5 / s + t * 4.0) + sin(v.x * -2.5 / s + t * 7.1), -1.0, 1.0, -0.3, 0.3);
    noise += srange(sin(v.y * -0.3 / s + t * 18.0) + sin(v.y * 1.6 / s + t * 18.0) + sin(v.y * 2.6 / s + t * 8.0) + sin(v.y * -2.6 / s + t * 4.5), -1.0, 1.0, -0.3, 0.3);
    return noise;
}

float shadowLookup(sampler2D map, vec3 coords, float size, float compare, vec3 wpos) {
    float shadow = 1.0;

    #if defined(SHADOW_MAPS)
    bool frustumTest = coords.x >= 0.0 && coords.x <= 1.0 && coords.y >= 0.0 && coords.y <= 1.0 && coords.z <= 1.0;
    if (frustumTest) {
        
        vec2 texelSize = vec2(1.0) / size;

        float dx0 = -texelSize.x;
        float dy0 = -texelSize.y;
        float dx1 = +texelSize.x;
        float dy1 = +texelSize.y;

        float rnoise = shadowrandom(wpos) * 0.00015;
        dx0 += rnoise;
        dy0 -= rnoise;
        dx1 += rnoise;
        dy1 -= rnoise;

        #if defined(SHADOWS_MED)
        shadow += shadowCompare(map, coords.xy + vec2(0.0, dy0), compare);
        //        shadow += shadowCompare(map, coords.xy + vec2(dx1, dy0), compare);
        shadow += shadowCompare(map, coords.xy + vec2(dx0, 0.0), compare);
        shadow += shadowCompare(map, coords.xy, compare);
        shadow += shadowCompare(map, coords.xy + vec2(dx1, 0.0), compare);
        //        shadow += shadowCompare(map, coords.xy + vec2(dx0, dy1), compare);
        shadow += shadowCompare(map, coords.xy + vec2(0.0, dy1), compare);
        shadow /= 5.0;

        #elif defined(SHADOWS_HIGH)
        shadow = shadowLerp(map, coords.xy + vec2(dx0, dy0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(0.0, dy0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx1, dy0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx0, 0.0), compare, size);
        shadow += shadowLerp(map, coords.xy, compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx1, 0.0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx0, dy1), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(0.0, dy1), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx1, dy1), compare, size);
        shadow /= 9.0;

        #else
        shadow = shadowCompare(map, coords.xy, compare);
        #endif
    }

        #endif

    return clamp(shadow, 0.0, 1.0);
}

#test !!window.Metal
vec3 transformShadowLight(vec3 pos, vec3 vpos, mat4 mvMatrix, mat4 viewMatrix) {
    vec4 mvPos = mvMatrix * vec4(vpos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return normalize(worldPosition.xyz - mvPos.xyz);
}

float getShadow(vec3 pos, vec3 normal, float bias, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = uniforms.shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookup(shadowMap, coords, uniforms.shadowSize[i], coords.z - bias, pos);
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(uniforms.shadowLightPos[i], pos, uniforms.modelViewMatrix, globalUniforms.viewMatrix), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }

    #endif
    return shadow;
}

float getShadow(vec3 pos, vec3 normal, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    return getShadow(pos, normal, 0.0, uniforms, globalUniforms, shadowMap);
}

float getShadow(vec3 pos, float bias, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    return getShadow(pos, vec3(99999.0), bias, uniforms, globalUniforms, shadowMap);
}

float getShadow(vec3 pos, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    return getShadow(pos, vec3(99999.0), 0.0, uniforms, globalUniforms, shadowMap);
}

float getShadow(vec3 pos, vec3 normal) {
    return 1.0;
}

float getShadow(vec3 pos, float bias) {
    return 1.0;
}

float getShadow(vec3 pos) {
    return 1.0;
}

float getShadowPCSS(vec3 pos, vec3 normal, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap, PCSShadowConfig config) {
    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = uniforms.shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookupPCSS(shadowMap, coords, uniforms.shadowSize[i], coords.z - bias, pos);
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(uniforms.shadowLightPos[i], pos, uniforms.modelViewMatrix, globalUniforms.viewMatrix), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }

    #endif
    return shadow;
}

float getShadowPCSS(vec3 pos, vec3 normal, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    PCSShadowConfig config = defaultPCSSShadowConfig();
    return getShadowPCSS(pos, normal, bias, config);
}

#endtest

#test !window.Metal
vec3 transformShadowLight(vec3 pos, vec3 vpos) {
    vec4 mvPos = modelViewMatrix * vec4(vpos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return normalize(worldPosition.xyz - mvPos.xyz);
}

float getShadow(vec3 pos, vec3 normal, float bias) {

    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    #pragma unroll_loop
    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookup(shadowMap[i], coords, shadowSize[i], coords.z - bias, pos);        
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(shadowLightPos[i], pos), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }
    #endif
    return shadow;
}

float getShadow(vec3 pos, vec3 normal) {
    return getShadow(pos, normal, 0.0);
}

float getShadow(vec3 pos, float bias) {
    return getShadow(pos, vec3(99999.0), bias);
}

float getShadow(vec3 pos) {
    return getShadow(pos, vec3(99999.0), 0.0);
}

float getShadowPCSS(vec3 pos, vec3 normal, float bias, PCSShadowConfig config) {    
    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    #pragma unroll_loop
    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookupPCSS(shadowMap[i], coords, shadowSize[i], coords.z - bias, pos, config);
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(shadowLightPos[i], pos), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }
    #endif
    
    return shadow;
}

float getShadowPCSS(vec3 pos, vec3 normal, float bias) {
    PCSShadowConfig config = defaultPCSSShadowConfig();
    return getShadowPCSS(pos, normal, bias, config);
}
#endtest{@}FXAA.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMask;

#!VARYINGS
varying vec2 v_rgbNW;
varying vec2 v_rgbNE;
varying vec2 v_rgbSW;
varying vec2 v_rgbSE;
varying vec2 v_rgbM;

#!SHADER: FXAA.vs

varying vec2 vUv;

void main() {
    vUv = uv;

    vec2 fragCoord = uv * resolution;
    vec2 inverseVP = 1.0 / resolution.xy;
    v_rgbNW = (fragCoord + vec2(-1.0, -1.0)) * inverseVP;
    v_rgbNE = (fragCoord + vec2(1.0, -1.0)) * inverseVP;
    v_rgbSW = (fragCoord + vec2(-1.0, 1.0)) * inverseVP;
    v_rgbSE = (fragCoord + vec2(1.0, 1.0)) * inverseVP;
    v_rgbM = vec2(fragCoord * inverseVP);

    gl_Position = vec4(position, 1.0);
}

#!SHADER: FXAA.fs

#require(conditionals.glsl)

#ifndef FXAA_REDUCE_MIN
    #define FXAA_REDUCE_MIN   (1.0/ 128.0)
#endif
#ifndef FXAA_REDUCE_MUL
    #define FXAA_REDUCE_MUL   (1.0 / 8.0)
#endif
#ifndef FXAA_SPAN_MAX
    #define FXAA_SPAN_MAX     8.0
#endif

vec4 fxaa(sampler2D tex, vec2 fragCoord, vec2 resolution,
            vec2 v_rgbNW, vec2 v_rgbNE,
            vec2 v_rgbSW, vec2 v_rgbSE,
            vec2 v_rgbM) {
    vec4 color;
    mediump vec2 inverseVP = vec2(1.0 / resolution.x, 1.0 / resolution.y);
    vec3 rgbNW = texture2D(tex, v_rgbNW).xyz;
    vec3 rgbNE = texture2D(tex, v_rgbNE).xyz;
    vec3 rgbSW = texture2D(tex, v_rgbSW).xyz;
    vec3 rgbSE = texture2D(tex, v_rgbSE).xyz;
    vec4 texColor = texture2D(tex, v_rgbM);
    vec3 rgbM  = texColor.xyz;
    vec3 luma = vec3(0.299, 0.587, 0.114);
    float lumaNW = dot(rgbNW, luma);
    float lumaNE = dot(rgbNE, luma);
    float lumaSW = dot(rgbSW, luma);
    float lumaSE = dot(rgbSE, luma);
    float lumaM  = dot(rgbM,  luma);
    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));

    mediump vec2 dir;
    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
    dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));

    float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *
                          (0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);

    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
    dir = min(vec2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),
              max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),
              dir * rcpDirMin)) * inverseVP;

    vec3 rgbA = 0.5 * (
        texture2D(tex, fragCoord * inverseVP + dir * (1.0 / 3.0 - 0.5)).xyz +
        texture2D(tex, fragCoord * inverseVP + dir * (2.0 / 3.0 - 0.5)).xyz);
    vec3 rgbB = rgbA * 0.5 + 0.25 * (
        texture2D(tex, fragCoord * inverseVP + dir * -0.5).xyz +
        texture2D(tex, fragCoord * inverseVP + dir * 0.5).xyz);

    float lumaB = dot(rgbB, luma);

    color = vec4(rgbB, texColor.a);
    color = mix(color, vec4(rgbA, texColor.a), when_lt(lumaB, lumaMin));
    color = mix(color, vec4(rgbA, texColor.a), when_gt(lumaB, lumaMax));

    return color;
}

void main() {
    vec2 fragCoord = vUv * resolution;
    float mask = texture2D(tMask, vUv).r;
    if (mask < 0.5) {
        gl_FragColor = fxaa(tDiffuse, fragCoord, resolution, v_rgbNW, v_rgbNE, v_rgbSW, v_rgbSE, v_rgbM);
    } else {
        gl_FragColor = texture2D(tDiffuse, vUv);
    }
    gl_FragColor.a = 1.0;
}
{@}gaussianblur.fs{@}vec4 blur13(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.411764705882353) * direction;
  vec2 off2 = vec2(3.2941176470588234) * direction;
  vec2 off3 = vec2(5.176470588235294) * direction;
  color += texture2D(image, uv) * 0.1964825501511404;
  color += texture2D(image, uv + (off1 / resolution)) * 0.2969069646728344;
  color += texture2D(image, uv - (off1 / resolution)) * 0.2969069646728344;
  color += texture2D(image, uv + (off2 / resolution)) * 0.09447039785044732;
  color += texture2D(image, uv - (off2 / resolution)) * 0.09447039785044732;
  color += texture2D(image, uv + (off3 / resolution)) * 0.010381362401148057;
  color += texture2D(image, uv - (off3 / resolution)) * 0.010381362401148057;
  return color;
}

vec4 blur5(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.3333333333333333) * direction;
  color += texture2D(image, uv) * 0.29411764705882354;
  color += texture2D(image, uv + (off1 / resolution)) * 0.35294117647058826;
  color += texture2D(image, uv - (off1 / resolution)) * 0.35294117647058826;
  return color;
}

vec4 blur9(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.3846153846) * direction;
  vec2 off2 = vec2(3.2307692308) * direction;
  color += texture2D(image, uv) * 0.2270270270;
  color += texture2D(image, uv + (off1 / resolution)) * 0.3162162162;
  color += texture2D(image, uv - (off1 / resolution)) * 0.3162162162;
  color += texture2D(image, uv + (off2 / resolution)) * 0.0702702703;
  color += texture2D(image, uv - (off2 / resolution)) * 0.0702702703;
  return color;
}

vec4 gaussianblur(sampler2D image, vec2 uv, float steps, vec2 resolution, vec2 direction) {

  vec4 blend = vec4(0.);
  float sum = 1.;
  float m = 1.;
  float n = steps;

  for (float i = 0.; i < 100.; i += 1.) {
      if(i >= 2. * steps) break;
      float k = i;
      float j = i - 0.5 * steps;
      blend += m * texture2D(image, uv + j * direction / resolution);
      m *= (n - k) / (k + 1.);
      sum += m;
  }

  return blend / sum;

}{@}glscreenprojection.glsl{@}vec2 frag_coord(vec4 glPos) {
    vec2 ndc = (glPos.xyz / glPos.w).xy;
    return ndc * 0.5 + 0.5;
}

vec2 getProjection(vec3 pos, mat4 projMatrix) {
    vec4 mvpPos = projMatrix * vec4(pos, 1.0);
    return frag_coord(mvpPos);
}

void applyNormal(inout vec3 pos, mat4 projNormalMatrix, mat4 modelMatrix) {
    vec4 viewSpace = inverse(projNormalMatrix) * vec4(pos.x, pos.y, 0.0, 0.0);
    vec4 worldSpace = inverse(modelMatrix) * vec4(viewSpace.xyz, 0.0);
    pos = worldSpace.xyz;
}{@}DefaultText.glsl{@}#!ATTRIBUTES

#!UNIFORMS

uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS

varying vec2 vUv;

#!SHADER: DefaultText.vs

void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: DefaultText.fs

#require(msdf.glsl)

void main() {
    float alpha = msdf(tMap, vUv);

    gl_FragColor.rgb = uColor;
    gl_FragColor.a = alpha * uAlpha;
}
{@}msdf.glsl{@}float msdf(vec3 tex, vec2 uv, bool discards) {
    // TODO: fallback for fwidth for webgl1 (need to enable ext)
    float signedDist = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float d = fwidth(signedDist);
    float alpha = smoothstep(-d, d, signedDist);
    if (alpha < 0.01 && discards) discard;
    return alpha;
}

float msdf(sampler2D tMap, vec2 uv, bool discards) {
    vec3 tex = texture2D(tMap, uv).rgb;
    return msdf( tex, uv, discards );
}

float msdf(vec3 tex, vec2 uv) {
    return msdf( tex, uv, true );
}

float msdf(sampler2D tMap, vec2 uv) {
    vec3 tex = texture2D(tMap, uv).rgb;
    return msdf( tex, uv );
}

float strokemsdf(sampler2D tMap, vec2 uv, float stroke, float padding) {
    vec3 tex = texture2D(tMap, uv).rgb;
    float signedDist = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float t = stroke;
    float alpha = smoothstep(-t, -t + padding, signedDist) * smoothstep(t, t - padding, signedDist);
    return alpha;
}
{@}GLUIBatch.glsl{@}#!ATTRIBUTES
attribute vec3 offset;
attribute vec2 scale;
attribute float rotation;
//attributes

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
//varyings

#!SHADER: Vertex

mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
    0.0,                                0.0,                                0.0,                                1.0);
}

void main() {
    vUv = uv;
    //vdefines

    vec3 pos = vec3(rotationMatrix(vec3(0.0, 0.0, 1.0), rotation) * vec4(position, 1.0));
    pos.xy *= scale;
    pos.xyz += offset;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(1.0);
}{@}GLUIBatchText.glsl{@}#!ATTRIBUTES
attribute vec3 offset;
attribute vec2 scale;
attribute float rotation;
//attributes

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
//varyings

#!SHADER: Vertex

mat4 lrotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
    0.0,                                0.0,                                0.0,                                1.0);
}

void main() {
    vUv = uv;
    //vdefines

    vec3 pos = vec3(lrotationMatrix(vec3(0.0, 0.0, 1.0), rotation) * vec4(position, 1.0));

    //custommain

    pos.xy *= scale;
    pos += offset;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(msdf.glsl)

void main() {
    float alpha = msdf(tMap, vUv);

    gl_FragColor.rgb = v_uColor;
    gl_FragColor.a = alpha * v_uAlpha;
}
{@}GLUIColor.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: GLUIColor.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: GLUIColor.fs
void main() {
    vec2 uv = vUv;
    vec3 uvColor = vec3(uv, 1.0);
    gl_FragColor = vec4(mix(uColor, uvColor, 0.0), uAlpha);
}{@}GLUIObject.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: GLUIObject.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: GLUIObject.fs
void main() {
    gl_FragColor = texture2D(tMap, vUv);
    gl_FragColor.a *= uAlpha;
}{@}gluimask.fs{@}uniform vec4 uMaskValues;

#require(range.glsl)

vec2 getMaskUV() {
    vec2 ores = gl_FragCoord.xy / resolution;
    vec2 uv;
    uv.x = range(ores.x, uMaskValues.x, uMaskValues.z, 0.0, 1.0);
    uv.y = 1.0 - range(1.0 - ores.y, uMaskValues.y, uMaskValues.w, 0.0, 1.0);
    return uv;
}{@}luma.fs{@}float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

float luma(vec4 color) {
  return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}{@}PBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex

#require(pbr.vs)

void main() {
    vec3 pos = position;
    setupPBR(pos);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(pbr.fs)

void main() {
    gl_FragColor = getPBR();
}
{@}pbr.fs{@}uniform sampler2D tBaseColor;
uniform sampler2D tMRO;
uniform sampler2D tNormal;
uniform sampler2D tLUT;

uniform sampler2D tEnvDiffuse;
uniform sampler2D tEnvSpecular;
uniform vec2 uEnvOffset;

uniform sampler2D tLightmap;
uniform float uUseLightmap;
uniform float uLightmapIntensity;
uniform float uUseLinearOutput;

uniform vec3 uTint;
uniform vec2 uTiling;
uniform vec2 uOffset;
uniform vec4 uMRON;
uniform vec3 uEnv;

uniform float uHDR;

varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vV;
varying vec3 vWorldNormal;

vec3 unpackNormalPBR( vec3 eye_pos, vec3 surf_norm, sampler2D normal_map, float intensity, float scale, vec2 uv ) {
    vec3 q0 = dFdx( eye_pos.xyz );
    vec3 q1 = dFdy( eye_pos.xyz );
    vec2 st0 = dFdx( uv.st );
    vec2 st1 = dFdy( uv.st );

    vec3 N = normalize(surf_norm);

    vec3 q1perp = cross( q1, N );
    vec3 q0perp = cross( N, q0 );

    vec3 T = q1perp * st0.x + q0perp * st1.x;
    vec3 B = q1perp * st0.y + q0perp * st1.y;

    float det = max( dot( T, T ), dot( B, B ) );
    float scalefactor = ( det == 0.0 ) ? 0.0 : inversesqrt( det );

    vec3 mapN = texture2D( normal_map, uv * scale ).xyz * 2.0 - 1.0;
    mapN.xy *= intensity;

    return normalize( T * ( mapN.x * scalefactor ) + B * ( mapN.y * scalefactor ) + N * mapN.z );
}

const vec2 INV_ATAN = vec2(0.1591, 0.3183);
const float LN2 = 0.6931472;
const float ENV_LODS = 6.0;
const float PI = 3.14159;

struct PBRConfig {
    float reflection;
    float clearcoat;
    vec3 color;
    vec3 lightColor;
    vec3 envReflection;
    bool overrideMRO;
    bool overrideENV;
    vec3 mro;
    vec3 env;
};

vec3 fresnelSphericalGaussianRoughness(float cosTheta, vec3 F0, float roughness) {
    return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(2.0, (-5.55473 * cosTheta - 6.98316) * cosTheta);
}

vec2 SampleSphericalMap(vec3 v)
{
    vec2 uv = vec2(atan(v.z, v.x), asin(v.y));
    uv *= INV_ATAN;
    uv += 0.5;
    return uv;
}

vec4 SRGBtoLinear(vec4 srgb) {
    vec3 linOut = pow(srgb.xyz, vec3(2.2));
    return vec4(linOut, srgb.w);
}

vec3 linearToSRGB(vec3 color) {
    return pow(color, vec3(0.4545454545454545));
}

vec4 linearToSRGB(vec4 color) {
    return vec4(pow(color.rgb, vec3(0.4545454545454545)), 1.0);
}

vec4 RGBMToLinear(vec4 value) {
    float maxRange = 6.0;
    return vec4(value.xyz * value.w * maxRange, 1.0);
}

vec4 autoToLinear(vec4 texel, float uHDR) {
    vec4 color = RGBMToLinear(texel);
    if (uHDR < 0.001) { color = SRGBtoLinear(texel); }
    return color;
}

vec3 uncharted2Tonemap(vec3 x) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 uncharted2(vec3 color) {
    const float W = 11.2;
    float exposureBias = 2.0;
    vec3 curr = uncharted2Tonemap(exposureBias * color);
    vec3 whiteScale = 1.0 / uncharted2Tonemap(vec3(W));
    return curr * whiteScale;
}

vec3 filmicTonemap(vec3 x) {
    float A = 0.22;
    float B = 0.30;
    float C = 0.10;
    float D = 0.20;
    float E = 0.01;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 filmic(vec3 color) {
    float exposureBias = 2.0;
    return filmicTonemap(exposureBias * color);
}

vec3 acesFilm(vec3 x) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec4 getIBLContribution(float NdV, vec4 baseColor, vec4 MRO, vec3 R, vec3 V, vec3 N, sampler2D tLUT, sampler2D tEnvDiffuse, sampler2D tEnvSpecular, PBRConfig config) {
    float metallic = clamp(MRO.x + uMRON.x - 1.0, 0.0, 1.0);
    float roughness = clamp(MRO.y + uMRON.y - 1.0, 0.0, 1.0);
    float ao = mix(1.0, MRO.z, uMRON.z);
    vec3 env = uEnv;

    if (config.overrideMRO) {
        metallic = config.mro.x;
        roughness = config.mro.y;
        ao = config.mro.z;
    }

    if (config.overrideENV) {
        env = config.env;
    }

    vec2 lutUV = vec2(NdV, roughness);
    vec2 diffuseUV = SampleSphericalMap(N);

    vec3 brdf = SRGBtoLinear(texture2D(tLUT, lutUV)).rgb;
    vec4 diffuse = texture2D(tEnvDiffuse, diffuseUV);
    diffuse.rgb = autoToLinear(diffuse, uHDR).rgb;
    

    vec3 lightmap = vec3(1.0);

    if (uUseLightmap > 0.0) {
        lightmap = texture2D(tLightmap, vUv2).rgb;
        lightmap.rgb = pow(lightmap.rgb, vec3(2.2)) * uLightmapIntensity;
        diffuse.rgb *= lightmap.rgb;
    }

    diffuse.rgb *= baseColor.rgb;

    float blend = roughness * ENV_LODS;
    float level0 = floor(blend);
    float level1 = min(ENV_LODS, level0 + 1.0);
    blend -= level0;

    vec2 specUV = SampleSphericalMap(R);

    vec2 specUV1 = specUV;
    vec2 specUV2 = specUV;

    specUV1.y /= 2.0;
    specUV1 /= pow(2.0, level0);
    specUV1.y += 1.0 - exp(-LN2 * level0);

    specUV2.y /= 2.0;
    specUV2 /= pow(2.0, level1);
    specUV2.y += 1.0 - exp(-LN2 * level1);

    
    vec4 specular = mix(
        texture2D(tEnvSpecular, specUV1),
        texture2D(tEnvSpecular, specUV2),
        blend
    );

    specular.rgb = autoToLinear(specular, uHDR).rgb;
    specular.rgb = linearToSRGB(specular).rgb;

    // fake stronger specular highlight
    specular.rgb += pow(specular.rgb, vec3(2.2)) * env.y;

    if (uUseLightmap > 0.0) {
        specular.rgb *= lightmap;
    }

    vec3 F0 = vec3(0.04);
    F0 = mix(F0, baseColor.rgb, metallic);

    vec3 F = fresnelSphericalGaussianRoughness(NdV, F0, roughness);

    vec3 diffuseContrib = 1.0 - F;
    specular.rgb = specular.rgb * (F * brdf.x + brdf.y);

    diffuseContrib *= 1.0 - metallic;

    float alpha = baseColor.a;

    return vec4((diffuseContrib * diffuse.rgb + specular.rgb + (config.envReflection*0.01)) * ao * env.x, alpha);

}

vec3 getNormal() {
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    return unpackNormalPBR(V, N, tNormal, uMRON.w, 1.0, vUv).xyz;
}

vec4 getPBR(vec3 baseColor, PBRConfig config) {
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    vec3 worldNormal = getNormal();
    vec3 R = reflect(V, worldNormal);
    float NdV = abs(dot(worldNormal, V));
    vec4 baseColor4 = SRGBtoLinear(vec4(baseColor, 1.0));

    vec4 MRO = texture2D(tMRO, vUv);
    vec4 color = getIBLContribution(NdV, baseColor4, MRO, R, V, worldNormal, tLUT, tEnvDiffuse, tEnvSpecular, config);

    if (uUseLinearOutput < 0.5) {
        color.rgb = uncharted2(color.rgb);
        color = linearToSRGB(color);
    }

    return color;
}

vec4 getPBR(vec3 baseColor) {
    PBRConfig config;
    return getPBR(baseColor, config);
}

vec4 getPBR() {
    vec4 baseColor = texture2D(tBaseColor, vUv);
    vec4 color = getPBR(baseColor.rgb * uTint);
    color.a *= baseColor.a;
    return color;
}
{@}pbr.vs{@}attribute vec2 uv2;

uniform sampler2D tBaseColor;
uniform vec2 uTiling;
uniform vec2 uOffset;

varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vV;

void setupPBR(vec3 p0) { //inlinemain
    vUv = uv * uTiling + uOffset;
    vUv2 = uv2;
    vec4 worldPos = modelMatrix * vec4(p0, 1.0);
    vV = worldPos.xyz - cameraPosition;
    vNormal = normalMatrix * normal;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * normal;
}

void setupPBR(vec3 p0, vec3 n) {
    vUv = uv * uTiling + uOffset;
    vUv2 = uv2;
    vec4 worldPos = modelMatrix * vec4(p0, 1.0);
    vV = worldPos.xyz - cameraPosition;
    vNormal = normalMatrix * n;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * n;
}
{@}quaternion.glsl{@}vec4 quatFromAxisAngle(vec3 axis, float angle)
{ 
  vec4 qr;
  float half_angle = (angle * 0.5) * 3.14159 / 180.0;
  qr.x = axis.x * sin(half_angle);
  qr.y = axis.y * sin(half_angle);
  qr.z = axis.z * sin(half_angle);
  qr.w = cos(half_angle);
  return qr;
}

vec4 quatConj(vec4 q)
{ 
  return vec4(-q.x, -q.y, -q.z, q.w); 
}
  
vec4 quatMult(vec4 q1, vec4 q2)
{ 
  vec4 qr;
  qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
  qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
  qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
  qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
  return qr;
}

vec3 rotateVertexPosition(vec3 position, vec3 axis, float angle)
{ 
  vec4 q = quatFromAxisAngle(axis, angle);
  vec3 v = position.xyz;
  return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}

{@}radialblur.fs{@}vec3 radialBlur( sampler2D map, vec2 uv, float size, vec2 resolution, float quality ) {
    vec3 color = vec3(0.);

    const float pi2 = 3.141596 * 2.0;
    const float direction = 8.0;

    vec2 radius = size / resolution;
    float test = 1.0;

    for ( float d = 0.0; d < pi2 ; d += pi2 / direction ) {
        vec2 t = radius * vec2( cos(d), sin(d));
        for ( float i = 1.0; i <= 100.0; i += 1.0 ) {
            if (i >= quality) break;
            color += texture2D( map, uv + t * i / quality ).rgb ;
        }
    }

    return color / ( quality * direction);
}

vec3 radialBlur( sampler2D map, vec2 uv, float size, float quality ) {
    vec3 color = vec3(0.);

    const float pi2 = 3.141596 * 2.0;
    const float direction = 8.0;

    vec2 radius = size / vec2(1024.0);
    float test = 1.0;
    float samples = 0.0;

    for ( float d = 0.0; d < pi2 ; d += pi2 / direction ) {
        vec2 t = radius * vec2( cos(d), sin(d));
        for ( float i = 1.0; i <= 100.0; i += 1.0 ) {
            if (i >= quality) break;
            color += texture2D( map, uv + t * i / quality ).rgb ;
            samples += 1.0;
        }
    }

    return color / samples;
}
{@}range.glsl{@}

float range(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    vec3 sub = vec3(oldValue, newMax, oldMax) - vec3(oldMin, newMin, oldMin);
    return sub.x * sub.y / sub.z + newMin;
}

vec2 range(vec2 oldValue, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    vec2 oldRange = oldMax - oldMin;
    vec2 newRange = newMax - newMin;
    vec2 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

vec3 range(vec3 oldValue, vec3 oldMin, vec3 oldMax, vec3 newMin, vec3 newMax) {
    vec3 oldRange = oldMax - oldMin;
    vec3 newRange = newMax - newMin;
    vec3 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

vec4 range(vec4 oldValue, vec4 oldMin, vec4 oldMax, vec4 newMin, vec4 newMax) {
    vec4 oldRange = oldMax - oldMin;
    vec4 newRange = newMax - newMin;
    vec4 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

float crange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec2 crange(vec2 oldValue, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec3 crange(vec3 oldValue, vec3 oldMin, vec3 oldMax, vec3 newMin, vec3 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec4 crange(vec4 oldValue, vec4 oldMin, vec4 oldMax, vec4 newMin, vec4 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

float rangeTransition(float t, float x, float padding) {
    float transition = crange(t, 0.0, 1.0, -padding, 1.0 + padding);
    return crange(x, transition - padding, transition + padding, 1.0, 0.0);
}
{@}rgb2hsv.fs{@}vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}{@}rgbshift.fs{@}vec4 getRGB(sampler2D tDiffuse, vec2 uv, float angle, float amount) {
    vec2 offset = vec2(cos(angle), sin(angle)) * amount;
    vec4 r = texture2D(tDiffuse, uv + offset);
    vec4 g = texture2D(tDiffuse, uv);
    vec4 b = texture2D(tDiffuse, uv - offset);
    return vec4(r.r, g.g, b.b, g.a);
}{@}rotation.glsl{@}mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}


mat2 rotationMatrix(float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return mat2(c, -s, s, c);
}{@}simplenoise.glsl{@}float getNoise(vec2 uv, float time) {
    float x = uv.x * uv.y * time * 1000.0;
    x = mod(x, 13.0) * mod(x, 123.0);
    float dx = mod(x, 0.01);
    float amount = clamp(0.1 + dx * 100.0, 0.0, 1.0);
    return amount;
}

#test Device.mobile
float sinf(float x) {
    x*=0.159155;
    x-=floor(x);
    float xx=x*x;
    float y=-6.87897;
    y=y*xx+33.7755;
    y=y*xx-72.5257;
    y=y*xx+80.5874;
    y=y*xx-41.2408;
    y=y*xx+6.28077;
    return x*y;
}
#endtest

#test !Device.mobile
    #define sinf sin
#endtest

highp float getRandom(vec2 co) {
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt = dot(co.xy, vec2(a, b));
    highp float sn = mod(dt, 3.14);
    return fract(sin(sn) * c);
}

float cnoise(vec3 v) {
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += (sinf(v.x * 0.9 / s + t * 10.0) + sinf(v.x * 2.4 / s + t * 15.0) + sinf(v.x * -3.5 / s + t * 4.0) + sinf(v.x * -2.5 / s + t * 7.1)) * 0.3;
    noise += (sinf(v.y * -0.3 / s + t * 18.0) + sinf(v.y * 1.6 / s + t * 18.0) + sinf(v.y * 2.6 / s + t * 8.0) + sinf(v.y * -2.6 / s + t * 4.5)) * 0.3;
    return noise;
}

float cnoise(vec2 v) {
    float t = v.x * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += (sinf(v.x * 0.9 / s + t * 10.0) + sinf(v.x * 2.4 / s + t * 15.0) + sinf(v.x * -3.5 / s + t * 4.0) + sinf(v.x * -2.5 / s + t * 7.1)) * 0.3;
    noise += (sinf(v.y * -0.3 / s + t * 18.0) + sinf(v.y * 1.6 / s + t * 18.0) + sinf(v.y * 2.6 / s + t * 8.0) + sinf(v.y * -2.6 / s + t * 4.5)) * 0.3;
    return noise;
}

float fbm(vec3 x, int octaves) {
    float v = 0.0;
    float a = 0.5;
    vec3 shift = vec3(100);

    for (int i = 0; i < 10; ++i) {
        if (i >= octaves){ break; }

        v += a * cnoise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }

    return v;
}

float fbm(vec2 x, int octaves) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100);
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));

    for (int i = 0; i < 10; ++i) {
        if (i >= octaves){ break; }

        v += a * cnoise(x);
        x = rot * x * 2.0 + shift;
        a *= 0.5;
    }

    return v;
}
{@}skinning.glsl{@}attribute vec4 skinIndex;
attribute vec4 skinWeight;

uniform sampler2D boneTexture;
uniform float boneTextureSize;

mat4 getBoneMatrix(const in float i) {
    float j = i * 4.0;
    float x = mod(j, boneTextureSize);
    float y = floor(j / boneTextureSize);

    float dx = 1.0 / boneTextureSize;
    float dy = 1.0 / boneTextureSize;

    y = dy * (y + 0.5);

    vec4 v1 = texture2D(boneTexture, vec2(dx * (x + 0.5), y));
    vec4 v2 = texture2D(boneTexture, vec2(dx * (x + 1.5), y));
    vec4 v3 = texture2D(boneTexture, vec2(dx * (x + 2.5), y));
    vec4 v4 = texture2D(boneTexture, vec2(dx * (x + 3.5), y));

    return mat4(v1, v2, v3, v4);
}

void applySkin(inout vec3 pos, inout vec3 normal) {
    mat4 boneMatX = getBoneMatrix(skinIndex.x);
    mat4 boneMatY = getBoneMatrix(skinIndex.y);
    mat4 boneMatZ = getBoneMatrix(skinIndex.z);
    mat4 boneMatW = getBoneMatrix(skinIndex.w);

    mat4 skinMatrix = mat4(0.0);
    skinMatrix += skinWeight.x * boneMatX;
    skinMatrix += skinWeight.y * boneMatY;
    skinMatrix += skinWeight.z * boneMatZ;
    skinMatrix += skinWeight.w * boneMatW;
    normal = vec4(skinMatrix * vec4(normal, 0.0)).xyz;

    vec4 bindPos = vec4(pos, 1.0);
    vec4 transformed = vec4(0.0);
    
    transformed += boneMatX * bindPos * skinWeight.x;
    transformed += boneMatY * bindPos * skinWeight.y;
    transformed += boneMatZ * bindPos * skinWeight.z;
    transformed += boneMatW * bindPos * skinWeight.w;

    pos = transformed.xyz;
}

void applySkin(inout vec3 pos) {
    vec3 normal = vec3(0.0, 1.0, 0.0);
    applySkin(pos, normal);
}{@}transformUV.glsl{@}vec2 translateUV(vec2 uv, vec2 translate) {
    return uv - translate;
}

vec2 rotateUV(vec2 uv, float r, vec2 origin) {
    float c = cos(r);
    float s = sin(r);
    mat2 m = mat2(c, -s,
                  s, c);
    vec2 st = uv - origin;
    st = m * st;
    return st + origin;
}

vec2 scaleUV(vec2 uv, vec2 scale, vec2 origin) {
    vec2 st = uv - origin;
    st /= scale;
    return st + origin;
}

vec2 rotateUV(vec2 uv, float r) {
    return rotateUV(uv, r, vec2(0.5));
}

vec2 scaleUV(vec2 uv, vec2 scale) {
    return scaleUV(uv, scale, vec2(0.5));
}

vec2 skewUV(vec2 st, vec2 skew) {
    return st + st.gr * skew;
}

vec2 transformUV(vec2 uv, float a[9]) {

    // Array consists of the following
    // 0 translate.x
    // 1 translate.y
    // 2 skew.x
    // 3 skew.y
    // 4 rotate
    // 5 scale.x
    // 6 scale.y
    // 7 origin.x
    // 8 origin.y

    vec2 st = uv;

    //Translate
    st -= vec2(a[0], a[1]);

    //Skew
    st = st + st.gr * vec2(a[2], a[3]);

    //Rotate
    st = rotateUV(st, a[4], vec2(a[7], a[8]));

    //Scale
    st = scaleUV(st, vec2(a[5], a[6]), vec2(a[7], a[8]));

    return st;
}{@}FooterShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform sampler2D tNoise;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
#require(mousefluid.fs)

void main() {

  vec3 color = uColor;

  vec2 screenUv = gl_FragCoord.xy / resolution.xy;
  float fluidMask = smoothstep(0.4, 0.7, texture2D(tFluidMask, screenUv).r);
  vec3 fluid = vec3(texture2D(tFluid, screenUv).xy * fluidMask, fluidMask);

  // color = mix(color, vec3(0.2), mask)

  color += fluid * 0.0001;
  float steppedTime = floor(time * 8.0) / 8.0;
  float n1 = texture2D(tNoise, screenUv * 1.3 + vec2(-steppedTime * 0.05, steppedTime * 0.02)).r;
  fluid.z *= 0.1 + sin(steppedTime + n1 * 4.0) * 0.5 + 0.5;
  color = mix(color, color + 0.02, step(0.9, sin(fluid.z * 4.0)));

  gl_FragColor = vec4(color, 1.0);
}{@}BorderBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform vec3 uBorder;
uniform float alpha;
uniform float uAspectRatio;
uniform vec2 uDimensions;
uniform sampler2D tNoise;

#!VARYINGS
varying vec2 vUv;

#!SHADER: BorderBGShader.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: BorderBGShader.fs

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}


void main() {
    vec2 uv = vUv;
    // vec3 color = uColor;

    float steppedTime = floor(time * 8.0) / 8.0;
    float noise = texture2D(tNoise, vUv.xy * (vec2(0.5)) + vec2(0.0, -steppedTime)).r;
    // float lines = texture2D(tLines, vUv.xy * (vec2(5.5)) + vec2(0.0, -steppedTime)).r;

    float baseCut = 0.005;
    float baseWidth = 1.4;
    baseCut *= (baseWidth / uDimensions.x);

    float border = 3.0;
    float cut = baseCut + (noise * 0.006);
    border *= aastep(cut, vUv.x);
    border *= 1.0 - aastep(1.0 - cut, vUv.x);
    border *= aastep(cut * uAspectRatio, vUv.y);
    border *= 1.0 - aastep(1.0 - cut * uAspectRatio, vUv.y);

    vec3 color = mix(uColor, uBorder, 1.0 - border);
    // vec3 color = uBorder;


    float alphaBorder = 3.0;
    float cutOut = 0.001 + (noise * 0.002);
    alphaBorder *= aastep(cutOut, vUv.x);
    alphaBorder *= 1.0 - aastep(1.0 - cutOut, vUv.x);
    alphaBorder *= aastep(cutOut * uAspectRatio, vUv.y);
    alphaBorder *= 1.0 - aastep(1.0 - cutOut * uAspectRatio, vUv.y);


    float opacity = alpha * alphaBorder;
    opacity = aastep(0.5, opacity);
    // opacity = mix(1.0, (1.0 - border) * noise, 1.0 - border);


    gl_FragColor = vec4(color, opacity);
}{@}TextBoxTextShader.glsl{@}#!ATTRIBUTES
attribute vec3 animation;
attribute vec3 karaoke;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform vec3 uColorHighlight;
uniform float uScale;
uniform float uAlpha;
uniform vec3 uCount;
uniform sampler2D uTranslate;
uniform sampler2D uOpacity;
uniform vec4 uParentBounds;
uniform float uKaraokeTime;
uniform float uKaraokeInfluence;

#!VARYINGS
varying vec2 vUv;
varying float vAlpha;
varying vec3 vPos;
varying float vOpacity;
varying float vGlyphIndex;
varying float vIndex;
varying float vTranslate;
varying vec4 vWorldPos;
varying vec3 vKaraoke;

#!SHADER: Vertex
#require(range.glsl)

void main() {
    vUv = uv;
    vGlyphIndex = animation.z;
    vKaraoke = karaoke;

    float index01 = vGlyphIndex / uCount.z;

    float wordIndex = animation.y;

    vWorldPos = modelMatrix * vec4(position, 1.0);

    vec3 pos = position;
    float translate = texture2D(uTranslate, vec2(index01, 0.0)).r;
    pos.x -= translate * 0.4;

    vOpacity = texture2D(uOpacity, vec2(index01, 0.0)).r;

    vTranslate = translate;

    vIndex = index01;
    vPos = pos;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
#require(msdf.glsl)
#require(range.glsl)


void main() {
    if (vPos.x < -0.1) discard; // might need to update this value for mobile

    float alpha = msdf(tMap, vUv);

    float highlight = 0.0;
    float padding = 0.4;

    if (uKaraokeTime < 0.01) {
        padding = 0.0;
    }

    highlight = smoothstep(vKaraoke.x - padding, vKaraoke.x, uKaraokeTime);
    highlight *= 1.0 - smoothstep(vKaraoke.y, vKaraoke.y + padding, uKaraokeTime);
    highlight *= uKaraokeInfluence;

    gl_FragColor.rgb = mix(uColor, uColorHighlight, highlight);
    gl_FragColor.a = alpha * uAlpha;
    gl_FragColor.a *= 1.0 - vOpacity;
}
{@}BGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS

#!SHADER: BGShader.vs
void main() {
    gl_Position = vec4(position, 1.0);
}

#!SHADER: BGShader.fs
void main() {
    gl_FragColor.rgb = vec3(0.2);
    gl_FragColor.a = 1.0;
}{@}BottleShader.glsl{@}#!ATTRIBUTES
attribute float ao;
attribute float thickness;

#!UNIFORMS
uniform sampler2D tText;
uniform sampler2D tEnvDiffuse;
uniform sampler2D tEnvSpecular;

#!VARYINGS
varying vec2 vUv;
varying float vThickness;
varying float vAo;
varying vec3 viewDir;
varying vec3 vNormal;
varying vec3 vPosition;
varying vec3 vWorldPosition;

#!SHADER: Vertex
void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

  vWorldPosition = vec3(modelMatrix * vec4(position, 1.0));
  viewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
  vNormal = normal;
  vUv = uv;
  vThickness = thickness;
  vAo = ao;
  vPosition = position;
}

#!SHADER: Fragment
float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

vec4 getRGB(sampler2D tDiffuse, vec2 uv, float angle, float amount) {
    vec2 offset = vec2(cos(angle), sin(angle)) * amount;
    vec4 r = texture2D(tDiffuse, uv + offset);
    vec4 g = texture2D(tDiffuse, uv);
    vec4 b = texture2D(tDiffuse, uv - offset);
    return vec4(r.r, g.g, b.b, g.a);
}

// vec4 blur(sampler2D tDiffuse, vec2 uv, float sampleDist, float strength) {
//     float samples[6];
//     samples[0] = -0.08;
//     samples[1] = -0.03;
//     samples[2] = -0.01;
//     samples[3] =  0.01;
//     samples[4] =  0.03;
//     samples[5] =  0.08;

//     vec2 dir = normalize(0.5 - uv);
//     vec4 texel = texture2D(tDiffuse, uv);
//     vec4 sum = texel;

//     for (int i = 0; i < 6; i++) {
//         sum += texture2D(tDiffuse, uv + (dir * samples[i] * sampleDist * strength));
//     }

//     sum /= 6.0;
//     return sum;
// }

float lodweight(float t, float log2radius, float gamma) {
	return exp(-gamma*pow(log2radius-t,2.));
}


vec4 lodBlur(sampler2D tMap, vec2 uv, float radius, float gamma) {
	vec4 pix = vec4(0.);
	float norm = 0.;
	//weighted integration over mipmap levels
	for(float i = 0.; i < 10.; i += 0.5)
	{
		float k = lodweight(i, log2(radius), gamma);
		pix += k*textureLod(tMap, uv, i);
		norm += k;
	}
	//nomalize, and a bit of brigtness hacking
	return pix*pow(norm,-0.99);
}


const vec2 INV_ATAN = vec2(0.1591, 0.3183);
const float LN2 = 0.6931472;
const float ENV_LODS = 7.0;

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 fresnelSphericalGaussianRoughness(float cosTheta, vec3 F0, float roughness) {
	return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(2.0, (-5.55473 * cosTheta - 6.98316) * cosTheta);
}

vec2 sampleSphericalMap(vec3 v)
{
    vec2 uv = vec2(atan(v.z, v.x), asin(v.y));
    uv *= INV_ATAN;
    uv += 0.5;

    // match default C4D baked HDRI
    uv.x = fract(uv.x + 0.25 + 0.0 + 0.8 - 0.1);

    return uv;
}

vec4 SRGBtoLinear(vec4 srgb) {
    vec3 linOut = pow(srgb.xyz, vec3(2.2));
    return vec4(linOut, srgb.w);
}

vec3 linearToSRGB(vec3 color) {
    return pow(color, vec3(0.4545454545454545));
}

vec4 RGBMToLinear(vec4 value) {
    float maxRange = 6.0;
    return vec4(value.xyz * value.w * maxRange, 1.0);
}

vec4 autoToLinear(vec4 texel, float uHDR) {
    vec4 color = RGBMToLinear(texel);
    if (uHDR == 0.0) { color = SRGBtoLinear(texel); }
    return color;
}

void main() {
  float fresnel = getFresnel(vNormal, viewDir, 0.7);
  float thickness = vThickness * 2.0;
  float ao = vAo * 0.8;


  vec2 screenUv = (gl_FragCoord.xy / resolution.xy);
  screenUv += vNormal.xy * 0.05;
  // screenUv.xy += vWorldPosition.z * 0.03;

  // screenUv += sampleSphericalMap(vNormal) * 0.02;

  // vec4 textColor = getRGB(tText, screenUv, sin(time * 0.2), 0.0003);
//   vec4 textColor = blur(tText, screenUv, 0.8, 0.2);
  vec4 textColor = lodBlur(tText, screenUv, 5.0 + fresnel * 120.0, 3.0);
  vec3 baseColor = vec3(0.5, 0.75, 0.78);

  float alpha = 1.1;
  alpha -= (fresnel * 0.3);

  vec3 finalColor = mix(baseColor, textColor.rgb, 0.13);

  // finalColor += fresnel * 0.3;
  // finalColor += fresnel * 0.3;
  // finalColor -= ao * 0.3;
  // finalColor += thickness * 0.3;


  vec3 lightDir = normalize(vec3(1.0, 1.0, 0.1));
  vec3 diffuse = max(0.0, dot(vNormal, lightDir)) * vec3(1.0);
  finalColor += diffuse * 0.2;

  alpha -= vWorldPosition.z * 0.15;
  // finalColor += thickness * 0.2;

  vec2 diffuseUV = sampleSphericalMap(vNormal);
  vec3 envSpecular = texture2D(tEnvSpecular, diffuseUV).rgb;
  finalColor += (1.0 - thickness) * envSpecular * 10.0;
  finalColor -= ao * 0.4;
  finalColor += fresnel * 0.5;

  finalColor += thickness * 0.6;


  gl_FragColor = vec4(finalColor, alpha);
}{@}LiquidShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
varying vec3 vPosition;

#!VARYINGS
#!SHADER: Vertex
void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  vPosition = position;
}

#!SHADER: Fragment
void main() {
  // if (vPosition.x > 0.5) {
  //   gl_FragColor = vec4(0.0, 1.0, 0.0, 0.0);
  //   return;
  // }

  gl_FragColor = vec4(0.3, 0.0, 0.0, 0.0);
}{@}BottlePBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uLightColor;
uniform sampler2D tRefraction;
uniform sampler2D tText;
uniform vec3 uBGColor;
uniform float uOpacity;

#!VARYINGS
varying vec3 vWorldPosition;
varying vec3 vPosition;
#!SHADER: Vertex
#require(glasspbr.vs)

void main() {
    vec3 pos = position;
    setupPBR(position);

    vWorldPosition = (modelMatrix * vec4(position, 1.0)).xyz;
    vPosition = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(glasspbr.fs)

void main() {
    // PBR Config
		// this is the default config that can be tweaked
    PBRConfig baseConfig;
    baseConfig.overrideMRO = true;
    baseConfig.reflection = 1.0;
    baseConfig.mro = vec3(0.6, 0.0, 1.0);
    baseConfig.color = vec3(1.0, 1.0, 1.0);
    
    vec2 screenUv = (gl_FragCoord.xy / resolution.xy);
    vec3 refractedDir = refract(-normalize(vV), normalize(vWorldNormal), 1.0 / 1.9);

    float vDotN = dot(-normalize(vV), normalize(vWorldNormal));
    float fresnel = clamp(SchlickFresnel(vDotN), 0.5, 1.0);

    vec3 pbr = getPBR(vec3(1.0, 1.0, 1.0), baseConfig).rgb;

    float alpha = mix(fresnel, 1.0, 0.3);

    float mask = clamp(smoothstep(0.0, 1.0, vPosition.y), 0.1, 1.0);

    screenUv += refractedDir.xy * 0.1;
    float refraction = 1.0 - texture(tRefraction, screenUv).r;
    vec3 refractionColor = refraction * vec3(0.715, 0.75, 1.0);


    vec3 lightPos = vec3(-10, 0., -12.0);
    vec3 lightDir = normalize(lightPos - vWorldPosition);
    float spec = dot(-vWorldNormal, lightDir);
    spec = max(0.0, spec);
    spec = pow(spec, 32.0);
    vec3 specular = spec * vec3(6.0);
    
    gl_FragColor = vec4(specular + pbr + 0.3 + (refractionColor * 0.35), pow(alpha, mask) * (0.15 + smoothstep(0.7, 0.8, vPosition.y) * 0.3));;


    if(!gl_FrontFacing) {
      vec3 refractedDirBack = refract(-normalize(vV), normalize(vWorldNormal), 1.0 / 1.8);
      vec2 screen2Uv = (gl_FragCoord.xy / resolution.xy);
      screen2Uv += refractedDirBack.xy * 0.3;
      vec3 textCol = texture(tText, screen2Uv).rgb;
      gl_FragColor.rgb = mix(uBGColor.rgb, vec3(1.0), textCol.r) * 0.8;
      gl_FragColor.rgb += (pbr * 0.5 * pow(alpha, mask) * 0.3);
      gl_FragColor.a = 1.0;
    }

    gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb, clamp(spec, 0.0, 1.0));

    //gl_FragColor.rgb = vec3(vPosition.y);

    gl_FragColor.a *= uOpacity;
}{@}GlassPBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uLightColor;
uniform sampler2D tRefraction;
uniform sampler2D tLiquid;
uniform float uOpacity;
uniform sampler2D tBlueNoise;

#!VARYINGS
varying vec3 vWorldPosition;
varying vec3 vPosition;
#!SHADER: Vertex
#require(glasspbr.vs)

void main() {
    vec3 pos = position;
    setupPBR(position);

    vWorldPosition = (modelMatrix * vec4(position, 1.0)).xyz;
    vPosition = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
#require(glasspbr.fs)
#require(rgbshift.fs)

vec2 pinch(vec2 uv, float strength) {
    vec2 st = uv - 0.5;
    float t = atan(st.x, st.y);
    float r = sqrt(dot(st, st));
    r *= 1.0 + strength * (r * r);

    return 0.5 + r * vec2(sin(t), cos(t));
}


void main() {
    // PBR Config
		// this is the default config that can be tweaked
    PBRConfig baseConfig;
    baseConfig.overrideMRO = true;
    baseConfig.mro = vec3(0.0, 0.0, 1.0);
    baseConfig.color = vec3(1.0, 1.0, 1.0);
    
    vec2 screenUvRefraction = (gl_FragCoord.xy / resolution.xy);
    vec2 screenUvLiquid = (gl_FragCoord.xy / resolution.xy);

    // screenUvRefraction = pinch(screenUvRefraction, -1.1);

    vec3 noise = texture2D(tBlueNoise, vPosition.xy * 1.6).rgb;

    baseConfig.mro.r += noise.b * 0.01;
    baseConfig.mro.g += noise.r * .1;
    // baseConfig.mro.b += noise.g * 1.0;

    vec3 refractedDir = refract(-normalize(vV), normalize(vWorldNormal), 1.0 / 1.2);
    // screenUvRefraction += refractedDir.xy * 0.01;
    // vec3 refraction = texture2D(tRefraction, screenUvRefraction).rgb;

    float split = 0.0003;
    // split += smoothstep(1.4, 1.8, vPosition.y) * 0.001;
    // split += smoothstep(1.4, 1.8, vPosition.y) * 0.0003;

    screenUvRefraction += 0.5;
    float up = 1.0 - smoothstep(1.4, 1.9, vPosition.y);
    screenUvRefraction += (refractedDir.xy * 0.01) * up;
    // screenUvRefraction *= 1.0 - (length(vPosition.xz + vec2(0.5)) * 0.01) * up;
    // screenUvRefraction *= 1.0 - noise.g * 0.002;
    screenUvRefraction -= 0.5;

    vec3 refraction = 1.0 - getRGB(tRefraction, screenUvRefraction, sin(time * 0.2), split).rgb;

    // baseConfig.color = refraction;

    float vDotN = dot(-normalize(vV), normalize(vWorldNormal));
    float fresnel = clamp(SchlickFresnel(vDotN), 0.0, 1.0);

    vec3 pbr = getPBR(vec3(1.0, 1.0, 1.0) * 5.0 * refraction, baseConfig).rgb;

    // vec3 pbrNoRefraction = getPBR(vec3(1.0, 1.0, 1.0) * 5.0, baseConfig).rgb;

   
    vec3 liquid = texture2D(tLiquid, screenUvLiquid).rgb;

    vec3 compLiquidAndRefraction = mix(pbr, liquid, step(0.5, length(liquid)));
    // compLiquidAndRefraction = pbr;

    float alpha = 1.0;

    if (gl_FrontFacing) {
        float fade = smoothstep(1.6, 2.3, vPosition.y);
        fade *= 1.0 - smoothstep(0.0, 1.0, vPosition.z);
        alpha *= 1.0 - (fade * 0.9);
        // compLiquidAndRefraction = vec3(fade);
    }

    // alpha -= noise.g * 0.2;
    // compLiquidAndRefraction -= smoothstep(-0.0, 0.8, vPosition.z) * 0.4;

    // compLiquidAndRefraction += vec3(noise) * 0.1;

    gl_FragColor = vec4(compLiquidAndRefraction, alpha);

}{@}LabelPBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uTransition;
uniform sampler2D tBaseColor2;
uniform float uUVOffset1;
uniform float uUVOffset2;

#!VARYINGS
varying vec2 vUv1;
varying vec2 vUv2;

#!SHADER: Vertex
#require(pbr.vs)
#require(quaternion.glsl)

void main() {

  vec3 pos = position;
  setupPBR(pos);

  vUv1 = vec2(vUv.x, (vUv.y - uUVOffset1));
  vUv2 = vec2(vUv.x, (vUv.y - uUVOffset2));

  vWorldNormal = rotateVertexPosition(vWorldNormal, vec3(0.0, 1.0, 0.0), 26.0);
  vWorldNormal = rotateVertexPosition(vWorldNormal, vec3(0.0, 0.0, 1.0), 10.0);

  gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(pbr.fs)

void main() {
  vec4 baseColor = texture2D(tBaseColor, vUv1);
  vec4 baseColor2 = texture2D(tBaseColor, vUv2);
  vec4 color = mix(baseColor, baseColor2, uTransition);
  gl_FragColor = getPBR(color.rgb);
}
{@}glasspbr.fs{@}uniform sampler2D tBaseColor;
uniform sampler2D tMRO;
uniform sampler2D tNormal;
uniform sampler2D tLUT;

uniform sampler2D tEnvDiffuse;
uniform sampler2D tEnvSpecular;
uniform vec2 uEnvOffset;

uniform sampler2D tLightmap;
uniform float uUseLightmap;
uniform float uLightmapIntensity;
uniform float uUseLinearOutput;

uniform vec3 uTint;
uniform vec2 uTiling;
uniform vec2 uOffset;
uniform vec4 uMRON;
uniform vec3 uEnv;

uniform float uHDR;

varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vV;
varying vec3 vWorldNormal;
varying vec3 vNormal;

vec3 unpackNormalPBR( vec3 eye_pos, vec3 surf_norm, sampler2D normal_map, float intensity, float scale, vec2 uv ) {
    vec3 q0 = dFdx( eye_pos.xyz );
    vec3 q1 = dFdy( eye_pos.xyz );
    vec2 st0 = dFdx( uv.st );
    vec2 st1 = dFdy( uv.st );

    vec3 N = normalize(surf_norm);

    vec3 q1perp = cross( q1, N );
    vec3 q0perp = cross( N, q0 );

    vec3 T = q1perp * st0.x + q0perp * st1.x;
    vec3 B = q1perp * st0.y + q0perp * st1.y;

    float det = max( dot( T, T ), dot( B, B ) );
    float scalefactor = ( det == 0.0 ) ? 0.0 : inversesqrt( det );

    vec3 mapN = texture2D( normal_map, uv * scale ).xyz * 2.0 - 1.0;
    mapN.xy *= intensity;

    return normalize( T * ( mapN.x * scalefactor ) + B * ( mapN.y * scalefactor ) + N * mapN.z );
}

const vec2 INV_ATAN = vec2(0.1591, 0.3183);
const float LN2 = 0.6931472;
const float ENV_LODS = 6.0;
const float PI = 3.14159;

struct PBRConfig {
    float reflection;
    float clearcoat;
    vec3 color;
    vec3 lightColor;
    vec3 envReflection;
    bool overrideMRO;
    bool overrideENV;
    vec3 mro;
    vec3 env;
};

vec3 fresnelSphericalGaussianRoughness(float cosTheta, vec3 F0, float roughness) {
    return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(2.0, (-5.55473 * cosTheta - 6.98316) * cosTheta);
}

vec2 SampleSphericalMap(vec3 v)
{
    vec2 uv = vec2(atan(v.z, v.x), asin(v.y));
    uv *= INV_ATAN;
    uv += 0.5;
    return uv;
}

vec4 SRGBtoLinear(vec4 srgb) {
    vec3 linOut = pow(srgb.xyz, vec3(2.2));
    return vec4(linOut, srgb.w);
}

vec3 linearToSRGB(vec3 color) {
    return pow(color, vec3(0.4545454545454545));
}

vec4 linearToSRGB(vec4 color) {
    return vec4(pow(color.rgb, vec3(0.4545454545454545)), 1.0);
}

vec4 RGBMToLinear(vec4 value) {
    float maxRange = 6.0;
    return vec4(value.xyz * value.w * maxRange, 1.0);
}

vec4 autoToLinear(vec4 texel, float uHDR) {
    vec4 color = RGBMToLinear(texel);
    if (uHDR < 0.001) { color = SRGBtoLinear(texel); }
    return color;
}

vec3 uncharted2Tonemap(vec3 x) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 uncharted2(vec3 color) {
    const float W = 11.2;
    float exposureBias = 2.0;
    vec3 curr = uncharted2Tonemap(exposureBias * color);
    vec3 whiteScale = 1.0 / uncharted2Tonemap(vec3(W));
    return curr * whiteScale;
}

vec3 filmicTonemap(vec3 x) {
    float A = 0.22;
    float B = 0.30;
    float C = 0.10;
    float D = 0.20;
    float E = 0.01;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 filmic(vec3 color) {
    float exposureBias = 2.0;
    return filmicTonemap(exposureBias * color);
}

vec3 acesFilm(vec3 x) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

float SchlickFresnel(float u) {
	float m = 1.0 - u;
	float m2 = m * m;
	return m2 * m2 * m;
}

vec3 rotateVector(vec3 vector, vec3 axis, float angle) {
    mat3 rotateR = mat3(1.0);
    rotateR[0][0] = cos(angle);
    rotateR[0][1] = -sin(angle);
    rotateR[1][0] = sin(angle);
    rotateR[1][1] = cos(angle);
    rotateR[2][2] = 1.0;
    return rotateR * vector;
}

vec4 getIBLContribution(float NdV, vec4 baseColor, vec4 MRO, vec3 R, vec3 V, vec3 N, sampler2D tLUT, sampler2D tEnvDiffuse, sampler2D tEnvSpecular, PBRConfig config) {
    float metallic = clamp(MRO.x + uMRON.x - 1.0, 0.0, 1.0);
    float roughness = clamp(MRO.y + uMRON.y - 1.0, 0.0, 1.0);
    float ao = mix(1.0, MRO.z, uMRON.z);
    vec3 env = uEnv;

    if (config.overrideMRO) {
        metallic = config.mro.x;
        roughness = config.mro.y;
        ao = config.mro.z;
    }

    if (config.overrideENV) {
        env = config.env;
    }

    vec2 lutUV = vec2(NdV, roughness);
    vec2 diffuseUV = SampleSphericalMap(N);

    vec3 brdf = SRGBtoLinear(texture2D(tLUT, lutUV)).rgb;
    vec4 diffuse = texture2D(tEnvDiffuse, diffuseUV);
    diffuse.rgb = autoToLinear(diffuse, uHDR).rgb;
    

    vec3 lightmap = vec3(1.0);

    if (uUseLightmap > 0.0) {
        lightmap = texture2D(tLightmap, vUv2).rgb;
        lightmap.rgb = pow(lightmap.rgb, vec3(2.2)) * uLightmapIntensity;
        diffuse.rgb *= lightmap.rgb;
    }

    diffuse.rgb *= baseColor.rgb;

    float blend = roughness * ENV_LODS;
    float level0 = floor(blend);
    float level1 = min(ENV_LODS, level0 + 1.0);
    blend -= level0;

    R = rotateVector(R, vec3(1.0, 0.0, 0.0), 1.75);

    vec2 specUV = SampleSphericalMap(R);

    vec2 specUV1 = specUV;
    vec2 specUV2 = specUV;

    specUV1.y /= 2.0;
    specUV1 /= pow(2.0, level0);
    specUV1.y += 1.0 - exp(-LN2 * level0);

    specUV2.y /= 2.0;
    specUV2 /= pow(2.0, level1);
    specUV2.y += 1.0 - exp(-LN2 * level1);

    
    vec4 specular = mix(
        texture2D(tEnvSpecular, specUV1),
        texture2D(tEnvSpecular, specUV2),
        blend
    );

    specular.rgb = autoToLinear(specular, uHDR).rgb;
    specular.rgb = linearToSRGB(specular).rgb;

    // fake stronger specular highlight
    specular.rgb += pow(specular.rgb, vec3(1.2)) * env.y;

    if (uUseLightmap > 0.0) {
        specular.rgb *= lightmap;
    }

    vec3 F0 = vec3(0.04);
    F0 = mix(F0, baseColor.rgb, metallic);

    vec3 F = fresnelSphericalGaussianRoughness(NdV, F0, roughness);

    vec3 diffuseContrib = 1.0 - F;
    specular.rgb = specular.rgb * (F * brdf.x + brdf.y);

    diffuseContrib *= 1.0 - metallic;

    float vDotN = dot(-normalize(vV), normalize(vWorldNormal));
    float fresnel = clamp(SchlickFresnel(vDotN), 0.0, 1.0);

    float alpha = baseColor.a;

    return vec4((diffuseContrib * diffuse.rgb + (specular.rgb * 10. * fresnel) + (config.envReflection*0.01)) * ao * env.x, alpha);

}

vec3 getNormal() {
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    return unpackNormalPBR(V, N, tNormal, uMRON.w, 1.0, vUv).xyz;
}

vec4 getPBR(vec3 baseColor, PBRConfig config) {
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    vec3 worldNormal = getNormal();
    vec3 R = reflect(V, worldNormal);
    float NdV = abs(dot(worldNormal, V));
    vec4 baseColor4 = SRGBtoLinear(vec4(baseColor, 1.0));

    vec4 MRO = texture2D(tMRO, vUv);
    vec4 color = getIBLContribution(NdV, baseColor4, MRO, R, V, worldNormal, tLUT, tEnvDiffuse, tEnvSpecular, config);

    if (uUseLinearOutput < 0.5) {
        color.rgb = uncharted2(color.rgb);
        color = linearToSRGB(color);
    }

    return color;
}

vec4 getPBR(vec3 baseColor) {
    PBRConfig config;
    return getPBR(baseColor, config);
}

vec4 getPBR() {
    vec4 baseColor = texture2D(tBaseColor, vUv);
    float fresnel = clamp(SchlickFresnel(dot(normalize(vV), normalize(vWorldNormal))), 0.0, 1.0);
    float alpha = mix(fresnel * 1.0, 1.0, 0.0);
    baseColor.rgb - mix(vec3(1.0), baseColor.rgb, alpha);
    vec4 color = getPBR(baseColor.rgb * uTint);
    color.a *= baseColor.a;
    return color;
}
{@}glasspbr.vs{@}attribute vec2 uv2;

uniform sampler2D tBaseColor;
uniform vec2 uTiling;
uniform vec2 uOffset;

varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vWorldPosition;
varying vec3 vV;

void setupPBR(vec3 p0) { //inlinemain
    vUv = uv * uTiling + uOffset;
    vUv2 = uv2;
    vec4 worldPos = modelMatrix * vec4(p0, 1.0);
    vWorldPosition = worldPos.xyz;
    vV = worldPos.xyz - cameraPosition;
    vNormal = normalMatrix * normal;
    vWorldNormal = (modelMatrix * vec4(normal, 0.0)).xyz;
}

void setupPBR(vec3 p0, vec3 n) {
    vUv = uv * uTiling + uOffset;
    vUv2 = uv2;
    vec4 worldPos = modelMatrix * vec4(p0, 1.0);
    vWorldPosition = worldPos.xyz;
    vV = worldPos.xyz - cameraPosition;
    vNormal = normalMatrix * n;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * n;
}
{@}AudioToggleShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tNoise;
uniform sampler2D tScene;

uniform float uHover;
uniform float uShow;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;

#!SHADER: Vertex
void main() {
  vUv = uv;
  vPos = position;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(vPos, 1.0);
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
  float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
  return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float parabola( float x, float k ){
  return pow( 4.0*x*(1.0-x), k );
}

float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

void main() {
  vec2 screenUv = gl_FragCoord.xy / resolution.xy;

  // is scene dark
  vec3 scene = texture2D(tScene, screenUv).rgb;
  float sceneLuma = luma(scene);
  float isDark = step(0.3, sceneLuma);

  // if yes, blend to red
  vec3 baseColor = vec3(0.0);
  // vec3 outColor = mix(vec3(0.784,0.161,0.141), vec3(0.071,0.071,0.071), isDark);
  vec3 outColor = mix(vec3(1.0), vec3(0.071,0.071,0.071), isDark);

  float steppedTime = floor(time * 8.0) / 8.0;
  float noiseTiling = 0.6;
  float noiseInfluence = 0.8;
  float noise = texture2D(tNoise, vPos.xy * noiseTiling + vec2(0.0, steppedTime)).r;

  float value = 1.0;
  value *= parabola(vUv.x, 1.0);
  value *= parabola(vUv.y, 0.3);
  value -= noise * noiseInfluence;

  float outline = aastep(0.4, value);
  vec3 color = max(outColor, outline * baseColor);

  float alpha = aastep(0.01, value) * uShow;
  gl_FragColor = vec4(color, alpha);
}
{@}BaseShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;

uniform float uLinesTile;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;

#!SHADER: Vertex

#require(skinning.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalize(normalMatrix * normal);

    vec3 pos = position;

    vLineUv = (rotation3d(normalize(vec3(1.0, 0.0, 2.5)), 0.5) * position).xy;
    vAo = uv2.x;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    vec3 normal = normalize(vNormal);
    
    float steppedTime = floor(time * 8.0);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.y += steppedTime * 0.15;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // trim pattern
    float trim = texture2D(tTrim, vUv).r;
    trim = aastep(0.55, trim);

    // lighting
    vec3 lightDir = normalize(vec3(-0.8, 0.1, 0.0));
    float lighting = dot(normal, lightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.1, lighting + lines * 0.3 - vAo);
    float terminatorhigh = aastep(0.9, lighting + lines * 0.075 - vAo);
    float terminatorbounce = 1.0 - aastep(-0.91, lighting + vAo * 0.2 - lines * 0.2);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    vec3 brown = vec3(176.0, 156.0, 118.0) / 255.0;
    color = mix(vec3(0.0), brown, terminatormid);
    color = mix(color, vec3(1.0), terminatorhigh);
    color *= maskedLines;
    color = mix(color, brown, terminatorbounce);
    color *= trim;

    if (!gl_FrontFacing) {
        color = vec3(0.0);
    }

    gl_FragColor = vec4(color, 1.0);
}{@}BorderShader.glsl{@}#!ATTRIBUTES
attribute float inner;
attribute float outer;

#!UNIFORMS
uniform sampler2D tMap;

uniform vec3 uColor;
uniform float uPadX;
uniform float uPadY;
uniform float uPadTop;
uniform float uSceneHeightWorld;
uniform float uScreenHeightWorld;
uniform float uFixedWidth;
uniform float uDepthSkew;
uniform float uDepthOffset;
uniform float uFragDepth;
uniform float uSkewCorrection;
uniform float uMaxWidth;
uniform float uDPR;
uniform float uTransition;

uniform vec4 uFluidEdge;
uniform float uFadeTop;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vInner;
varying float vDepth;
varying float vOuter;
varying float vFadeTop;

#!SHADER: Vertex
void main() {
    vUv = uv;
    vInner = inner;

    vec3 pos = position;
    float aspect = resolution.x / resolution.y;
    float maxAspect = 2.0;
    float clampedAspect = min(maxAspect, aspect);

    float mask = 1.0 - outer;

    float halfWidth = uScreenHeightWorld * aspect * 0.5;
    float halfHeight = uSceneHeightWorld * 0.5;

    // clamp width to max pixel width
    float resx = resolution.x / uDPR;
    float halfWidthClamped = uScreenHeightWorld * (uMaxWidth / resx) * 0.5 * aspect;
    float blend = resx < uMaxWidth ? 1.0 : outer;
    halfWidth = mix(halfWidthClamped, halfWidth, blend);

    float padx = mix(halfWidth, halfWidth * uPadX, uTransition);
    float pady = mix(halfHeight, halfHeight * uPadY, uTransition);
    float padyTop = mix(0.0, halfHeight * uPadTop, uTransition);

    // if (abs(uPadTop) > 0.1) {
    //     padyTop = mix(0.0, halfHeight * uPadTop, uTransition);
    // }

    vFadeTop = 0.0;
    if (vUv.y > 0.5 && uFadeTop > 0.5) {
        vFadeTop = 1.0;
    }

    float outlineThickness = 0.1;

    // fit border to world space screen size, with padding
    // if (uFixedWidth > 0.5) {
    //     padx = halfWidth - halfWidth * uPadX;
    // }

    if (pos.x < 0.0) {
        pos.x = -halfWidth;
        pos.x += mask * padx;
    }

    if (pos.x > 0.0) {
        pos.x = halfWidth;
        pos.x -= mask * padx;
    }

    if (pos.y > 0.0) {
        pos.y = halfHeight;
        pos.y -= mask * (pady + padyTop);
    }

    if (pos.y < 0.0) {
        pos.y = -halfHeight;
        pos.y += mask * pady;
    }

    // extend outer edges
    if (abs(position.x) > 0.9) {
        pos.x += outer * pos.x;
    }

    // skew along depth when objects need to pop out
    float ygrad = sign(position.y);
    ygrad = ygrad + 1.0;
    float depthGrad = ygrad * uDepthSkew;
    float depthMask = (1.0 - outer);
    pos.z -= depthGrad * depthMask;
    pos.z += uDepthOffset * depthMask;

    // vDepth = (1.0 - (position.y * 0.5 + 0.5)) * uFragDepth * depthMask;

    // skew along x axis to correct for perspective distortion
    pos.x += ygrad * uSkewCorrection * sign(position.x);

    // pass transformed pos to fragment shader
    vPos = position;

    // extrude outline in screen space
    vec4 projPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec2 norm = vec2(0.0);
    norm.x -= sign(position.x) / aspect * (uDepthSkew * 0.5 + 1.0);
    norm.y -= sign(position.y);
    projPos.xy += norm * inner * outlineThickness;

    gl_Position = projPos;

    vOuter = outer;
}

#!SHADER: Fragment
#require(mousefluid.fs)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    float steppedTime = floor(time * 8.0) / 8.0;
    float noise = texture2D(tMap, vPos.xy * vec2(uFluidEdge.xy * 0.2) + vec2(0.0, steppedTime)).r;

    float value = 1.0;
    value *= (1.0 - vInner);


    // fluid on the edges
    float ax = abs(vPos.x);
    float ay = abs(vPos.y);

    // blend 0..1 across a small band near the diagonal
    float blend = smoothstep(0.9, 1.1, ax / max(ay, 1e-5));

    float edgeTB = uFluidEdge.z * 0.05;
    float edgeLR = uFluidEdge.w * 0.05;

    float edge = mix(edgeTB, edgeLR, blend);

    if (edge > 0.0 && uTransition > 0.95) {
        vec2 screenUv = gl_FragCoord.xy / resolution.xy;
        float fluidMask = smoothstep(0.0, 1.0, texture2D(tFluidMask, screenUv).r) * 0.8;
    
        float outer = smoothstep(0.0, edge, vOuter);
        value *= 1.0 - fluidMask * (1.0 - outer);
    }

    // value *= vUv.y;

    value -= noise * 0.6;

    float outline = aastep(0.4, value);
    vec3 color = max(vec3(18.0 / 255.0), outline * uColor);

    float alpha = aastep(0.01, value);

    // color = vec3(vOuter);
    // alpha = 1.0;

    // alpha = 1.0;
    // color = vec3(step(0.9, vOuter));

    // alpha = 1.0;
    // color = vec3(vInner);

    if (vFadeTop > 0.5) {
        alpha = smoothstep(0.0, 0.5, vOuter);
        color = vec3(18.0 / 255.0);
    }

    gl_FragColor = vec4(color, alpha);
    // gl_FragColor = vec4(vDepth, 1.0, 1.0, 1.0);
    // gl_FragDepth = gl_FragCoord.z + vDepth * 0.0125;
}{@}FloatingFrameShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;

#!VARYINGS
varying vec2 vUv;
varying vec3 vNdc;

#!SHADER: Vertex
void main() {
    vUv = uv;

    vec3 pos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdc = gl_Position.xyz / gl_Position.w;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    // check if ndc point is inside rectangle
    vec3 pos1 = uPoint1;
    vec3 pos2 = uPoint2;
    vec3 pos3 = uPoint3;
    vec3 pos4 = uPoint4;

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    // make sdf from distances
    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);
    float sdf = max(sdfx, sdfy);

    if (sdf > 0.0025) discard;

    vec3 color = texture2D(tMap, vUv).rgb;

    // if (sdf > 0.0025) color = vec3(1.0, 0.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}{@}GLUIButtonShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform vec3 uBorder;
uniform float alpha;
uniform float uAspectRatio;
uniform sampler2D tNoise;
uniform float uHover;

#!VARYINGS
varying vec2 vUv;

#!SHADER: GLUIButtonShader.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: GLUIButtonShader.fs

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    vec2 uv = vUv;
    // vec3 color = uColor;

    float steppedTime = floor(time * 8.0) / 8.0;
    float noise = texture2D(tNoise, vUv.xy * (vec2(0.5)) + vec2(0.0, -steppedTime)).r;
    // float lines = texture2D(tLines, vUv.xy * (vec2(5.5)) + vec2(0.0, -steppedTime)).r;

    float baseCut = 0.03;
    baseCut += uHover * 0.03;

    float border = 1.0;
    float cut = baseCut + (noise * (0.01 + uHover * 0.01));
    border *= aastep(cut, vUv.x);
    border *= 1.0 - aastep(1.0 - cut, vUv.x);
    border *= aastep(cut * uAspectRatio, vUv.y);
    border *= 1.0 - aastep(1.0 - cut * uAspectRatio, vUv.y);

    vec3 color = mix(uColor, uBorder, 1.0 - border);
    // vec3 color = uBorder;

    float alphaBorder = 1.0;
    float cutOut = 0.002 + (noise * (0.01 + uHover * 0.01));
    alphaBorder *= aastep(cutOut, vUv.x);
    alphaBorder *= 1.0 - aastep(1.0 - cutOut, vUv.x);
    alphaBorder *= aastep(cutOut * uAspectRatio, vUv.y);
    alphaBorder *= 1.0 - aastep(1.0 - cutOut * uAspectRatio, vUv.y);


    float opacity = alphaBorder;
    opacity = aastep(0.5, opacity);
    // opacity = mix(1.0, (1.0 - border) * noise, 1.0 - border);


    gl_FragColor = vec4(color, opacity * alpha);
}{@}GLUICursorBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tNoise;
uniform float uHover;
uniform vec2 uVelocity;
uniform vec2 uDiscard;

#!VARYINGS
varying vec2 vUv;
varying float vNdcHeight;

#!SHADER: Vertex

void main() {
  vec3 pos = position;

  // Calculate velocity magnitude for stretch intensity
  vec2 vel2D = uVelocity;
  float velocityMag = length(vel2D);

  // Normalize velocity direction
  vec2 velDir = normalize(vel2D);

  if(velocityMag > 0.) {
  // Create stretch factor (adjust multiplier for more/less stretch)
    float stretchFactor = velocityMag * mix(0.01, 0.04, uHover);
    stretchFactor = min(stretchFactor, 1.0); // Cap maximum stretch

  // Offset the entire mesh center backward along velocity to create trailing effect
    vec2 centerOffset = -velDir * stretchFactor;
    vec2 pos2D = pos.xy + centerOffset;

    float projectionAlongVel = dot(pos2D, velDir);
    vec2 parallelComponent = velDir * projectionAlongVel;
    vec2 perpendicularComponent = pos2D - parallelComponent;

  // Stretch along velocity direction, compress perpendicular slightly
    vec2 stretchedPos2D = parallelComponent * (1.0 + stretchFactor) +
      perpendicularComponent * (1.0 - stretchFactor * 0.1);

    pos.xy = stretchedPos2D;
  }

  gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
  vUv = uv;

  vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
#require(aastep.glsl)

void main() {
  // float scale = 1.0 - mix(0.5, 1.0, clamp(uDiscard.y - vNdcHeight, 0.0, 1.0));
  // vec2 uv = (vUv - 0.5) / scale + 0.5;
  if (uDiscard.x - vNdcHeight > 0.0 || uDiscard.y - vNdcHeight < 0.0) discard;

  float steppedTime = floor(time * 8.0) / 8.0;
  float noise = texture2D(tNoise, vUv + vec2(0.0, steppedTime)).r;

  float disc = length(vUv - 0.5);
  float outer = aastep(0.5, disc + noise * 0.025);
  float border = mix(0.44, 0.42, uHover);
  float outline = 1.0 - (aastep(border, disc - noise * 0.01) + outer);

  vec3 color = max(vec3(18.0 / 255.0), outline);

  gl_FragColor = vec4(color, 1.0 - outer);
}{@}HeaderBgShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tNoise;
uniform sampler2D tScene;
uniform vec3 uColor;
uniform vec3 uColor2;
uniform float uAspectRatio;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}


float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    vec2 uv = vUv;

    float steppedTime = floor(time * 8.0) / 8.0;
    float noise = texture2D(tNoise, vUv.xy * (vec2(0.5)) + vec2(0.0, -steppedTime)).r;

    float border = 1.0;
    float cut = 0.005 + (noise * 0.003);
    border *= aastep(cut, vUv.x);
    border *= 1.0 - aastep(1.0 - cut, vUv.x);
    border *= aastep(cut * uAspectRatio, vUv.y);
    border *= 1.0 - aastep(1.0 - cut * uAspectRatio, vUv.y);

    vec3 color = mix(uColor, uColor2, 1.0 - border);
    // vec3 color = uBorder;


    float opacity = 1.0;
    // float alphaBorder = 1.0;
    // float cutOut = 0.001 + (noise * 0.002);
    // alphaBorder *= aastep(cutOut, vUv.x);
    // alphaBorder *= 1.0 - aastep(1.0 - cutOut, vUv.x);
    // alphaBorder *= aastep(cutOut * uAspectRatio, vUv.y);
    // alphaBorder *= 1.0 - aastep(1.0 - cutOut * uAspectRatio, vUv.y);


    // float opacity = alpha * alphaBorder;
    // opacity = aastep(0.5, opacity);
    // opacity = mix(1.0, (1.0 - border) * noise, 1.0 - border);


    gl_FragColor = vec4(color, opacity);
}{@}LogoShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tLogo;
uniform sampler2D tScene;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform vec3 uColor;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform float uShow;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
#require(range.glsl)
#require(mousefluid.fs)

float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

void main() {
  vec4 color = texture2D(tLogo, vUv);

  vec2 screenUV = gl_FragCoord.xy / resolution.xy;
  vec3 scene = texture2D(tScene, screenUV).rgb;
  float sceneLuma = luma(scene);
  float isDark = step(0.3, sceneLuma);

  float tempo = floor(time * 8.0) / 8.0;
  float noise = texture2D(tNoise, vUv * 0.2 + vec2(0.0, -tempo)).r;
  color.rgb = mix(uColor2, uColor, isDark);

  float alpha = rangeTransition(uShow, noise, 0.5);
  color.a *= alpha;


  // 
  // float fluidMask = smoothstep(0.1, 0.7, texture2D(tFluidMask, screenUV).r);
  // vec3 fluid = vec3(texture2D(tFluid, screenUV).xy * fluidMask, fluidMask);

  // // color.rgb = fluid;

  // color.rgb += fluid * 0.001;


  gl_FragColor = color;
}{@}ScreenQuadColor.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;

#!VARYINGS

#!SHADER: ScreenQuadColor.vs
void main() {
    vec3 pos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: ScreenQuadColor.fs
void main() {
    gl_FragColor = vec4(uColor, 1.0);
}{@}ScrollbarThumbShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tNoise;
uniform sampler2D tScene;

uniform float uDelta;
uniform float uHover;
uniform float uShow;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;

#!SHADER: Vertex
void main() {
  vUv = uv;
  vPos = position;

    // vPos.y -= 0.5;
    // vPos.y *= 1.0 + (uDelta * 0.004);
    // vPos.y += 0.5;

    vPos.xy -= vec2(0.8, 0.5);
    // vPos.x *= 1.0 + (uHover * 4.4);
    vPos.x *= 1.0 + min(0.7, abs(uDelta * 0.008));
    vPos.xy += vec2(0.8, 0.5);

  gl_Position = projectionMatrix * modelViewMatrix * vec4(vPos, 1.0);
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float parabola( float x, float k )
{
    return pow( 4.0*x*(1.0-x), k );
}

float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec2 screenUV = gl_FragCoord.xy / resolution.xy;
    vec3 scene = texture2D(tScene, screenUV).rgb;
    float sceneLuma = luma(scene);
    float isDark = step(0.3, sceneLuma);

    vec3 baseColor = vec3(0.0);
    vec3 outColor = mix(vec3(0.784,0.161,0.141), vec3(0.071,0.071,0.071), isDark);
    float steppedTime = floor(time * 8.0) / 8.0;
    
    float noise = texture2D(tNoise, vPos.xy * 0.4 + vec2(0.0, steppedTime)).r;

    float value = 1.0;
    value *= parabola(vUv.x, 1.0);
    value *= parabola(vUv.y, 0.7);
    value -= noise * 0.6;

    value -= 0.8 * (1.0 - uShow);
    value += 0.2 * uHover;

    float outline = aastep(0.4, value);
    vec3 color = max(outColor, outline * baseColor);

    float alpha = aastep(0.01, value);
    gl_FragColor = vec4(color, alpha);
}{@}ShadowShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform float uLinesAngle;
uniform float uLinesSpeed;
uniform float uLinesStrength;
uniform float uGradient;
uniform float uGradientAngle;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec2 vGradientUv;

#!SHADER: Vertex

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

void main() {
    vUv = uv;
    vLineUv = vUv - 0.5;
    vLineUv = rotate2d(uLinesAngle) * vLineUv;
    vLineUv *= uLinesTile;
    vLineUv = vLineUv + 0.5;

    vGradientUv = uv - 0.5;
    vGradientUv = rotate2d(uGradientAngle) * vGradientUv;
    vGradientUv += 0.5;

    vec3 pos = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {

    float steppedTime = floor(time * 8.0) / 8.0 * 0.5 * uLinesTile;
    float t = time * 0.28 * uLinesTile * uLinesSpeed;

    float map = texture2D(tMap, vec2(1.0 - vUv.x, 1.0 - vUv.y)).r;
    float lines = texture2D(tLines, vLineUv - vec2(0.0, steppedTime)).r;
    
    float alpha = lines * uLinesStrength;
    alpha += vGradientUv.y * uGradient;
    alpha *= (1.0 - map);
    alpha = aastep(0.3, alpha);

    vec3 nearBlack = vec3(18.0 / 255.0);
    vec3 color = nearBlack;

    gl_FragColor = vec4(color, alpha);
}{@}InverseSkinShader.glsl{@}
#!ATTRIBUTES

#!UNIFORMS
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uDisplacement;

#!VARYINGS
varying vec2 vUv;
varying vec3 vNormal;
varying float vNdcHeight;

#!SHADER: Vertex

#require(skinning.glsl)

void main() {
    vUv = uv;
    vNormal = normalize(normal);

    vec3 pos = position;
    applySkin(pos, vNormal);
    
    // float steppedTime = floor(time * 8.0);
    // float displacementStrength = 0.008 * uDisplacement;
    // vec3 displacement = vNormal * displacementStrength;
    // pos += displacement;

    vec4 projectionPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec4 projectionNormal = projectionMatrix * modelViewMatrix * vec4(vNormal, 0.0);
    
    vec2 screenNormal = normalize(projectionNormal.xy);
    projectionPos.xy += screenNormal * uDisplacement * projectionPos.w * 0.004;

    gl_Position = projectionPos;

    // gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    vec3 color = vec3(18.0 / 255.0);

    gl_FragColor = vec4(color, 1.0);
}{@}SkinShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute vec3 color;

#!UNIFORMS
uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;

uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uLightDir;
uniform vec3 uColor;
uniform vec3 uDrinkColor;
uniform float uColorScan;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vEyeMask;
varying float vNdcHeight;

#!SHADER: Vertex

#require(skinning.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vUv2 = uv2;
    vPos = position;
    vNormal = normalize(normalMatrix * normal);
    // Use the blue channel for AO, aligning with the MRO convention - In future it may be better to use a separate attribute float attribute for AO
    vAo = 1.0 - color.b;
    //use green channel for eye mask
    vEyeMask = color.g;

    vec3 pos = position;
    applySkin(pos, vNormal);

    float steppedTime = floor(time * 8.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    // if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    // trim pattern
    vec4 trimData = texture2D(tTrim, vUv);
    float trim = trimData.r;
    if (trimData.a < 0.3) discard;
    trim = aastep(0.4, trim);

    float skinMask = step(0.55, vUv2.y);
    vec3 normal = normalize(vNormal);
    
    float steppedTime = floor(time * 8.0);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x += steppedTime / uLinesTile * 0.2;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // detail texture
    float atlas = texture2D(tAtlas, vUv2).r;
    atlas = aastep(0.55, atlas);

    // lighting
    vec3 lightDir = normalize(uLightDir);

    // float lighting = dot(normal, lightDir);
    float lighting = dot(normal, lightDir) * vAo;
    
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.3, lighting + lines * 0.3 + skinMask * 0.2);
    float terminatorhigh = aastep(0.85, lighting + lines * 0.1 - 0.1);
    float terminatorbounce = 1.0 - aastep(-0.91, lighting - lines * 0.2);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * pow(lightMask, 2.0) * 3.0;
    maskedLines = aastep(0.01, maskedLines);
    // Prevent masked lines appearing in the eyes
    maskedLines += vEyeMask;

    // compositing;
    vec3 color = vec3(1.0);

    vec3 alt = uColor;

    // for DrinkPour scene: drink uvs are stored in very top right of uv2 map, 
    // so we can mask them without needing more attributes
    float drinkMask = min(step(0.98, vUv2.x), step(0.98, vUv2.y));
    drinkMask *= step(1.6, vPos.y);
    drinkMask *= 1.0 - step(1.725, vPos.y);

    // DrinkPourScene: affect clothes color
    drinkMask += 1.0 - min(1.0, step(-uColorScan * 1.5, vPos.y * 3.5 + noise * 0.1 + lines * 0.1 + sin(-steppedTime * 0.3 + vPos.x * 8.0 + uColorScan * 6.0) * 0.15) + skinMask);

    color = mix(alt, vec3(1.0), skinMask);
    color = mix(color, vec3(1.0), skinMask);
    color = mix(color, uDrinkColor, drinkMask);
    color = mix(vec3(18.0 / 255.0), color, terminatormid);
    color *= maskedLines;
    color *= trim;
    color *= atlas;

    if (!gl_FrontFacing) {
        color = vec3(0.0);
    }
    
    color = max(vec3(18.0 / 255.0), color);

    gl_FragColor = vec4(color, 1.0);

}{@}SkinShaderBase.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;

uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;
varying float vNdcHeight;

#!SHADER: Vertex

#require(skinning.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalize(normalMatrix * normal);

    vec3 pos = position;
    applySkin(pos, vNormal);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    gl_FragColor = vec4(vNormal, 1.0);
}{@}StaticCharacterBaseShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float windmask;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLinesAxis;
uniform float uLinesAngle;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec4 uWindAxisAngle;
uniform vec3 uWindParams;
uniform vec3 uBreathe;
uniform vec3 uColor;
uniform float uBend;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vSkinMask;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vUv2 = uv2;
    vNormal = normal;
    vLineUv = (rotation3d(normalize(uLinesAxis), uLinesAngle) * position).xy;
    vSkinMask = step(0.55, uv2.y);

    float steppedTime = floor(time * 18.0) / 18.0;

    vec3 pos = position;

    // wind animation
    vec3 windAxis = normalize(uWindAxisAngle.xyz);
    float windAngle = uWindAxisAngle.w;
    vec3 windPos = rotation3d(windAxis, windAngle) * pos;

    float displacement = sin(windPos.y * uWindParams.y + steppedTime * uWindParams.z) * uWindParams.x * windmask;
    displacement += sin(windPos.y * uWindParams.y * 0.34159 + windPos.z * 0.5 * uWindParams.y + steppedTime * uWindParams.z * 3.14159 * 0.673) * uWindParams.x * windmask;
    displacement += sin(windPos.y * uWindParams.y * 0.2772 + windPos.z * 0.5 * uWindParams.y + steppedTime * uWindParams.z * 3.14159 * 0.673) * uWindParams.x * windmask * 0.5;
    
    pos.y += displacement;
    pos.x -= displacement * 0.5;
    vNormal.y += displacement * 7.0;

    // breathe animation
    float mask = smoothstep(uBreathe.x, uBreathe.y, position.y);
    vec3 pivot = vec3(0.0, 0.2, -0.1);
    pos -= pivot;
    pos = rotation3d(vec3(1.0, 0.0, 0.0), (2.5 * uBreathe.z + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2) * uBreathe.z + uBend * mask) * pos;
    pos += pivot;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    // trim texture
    vec4 trimData = texture2D(tTrim, vUv);
    if (trimData.a < 0.5) discard;
    float trim = trimData.r;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // detail texture
    float atlas = texture2D(tAtlas, vUv2).r;
    atlas = aastep(0.55, atlas * trim);

    // lighting
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    vec3 alt = uColor;
    alt = mix(alt, vec3(1.0), vSkinMask);

    color = mix(vec3(0.0), alt, terminatormid);
    color = mix(color, vec3(1.0), terminatorhigh);
    color *= maskedLines;
    color *= atlas;

    color = max(vec3(18.0 / 255.0), color);

    if (!gl_FrontFacing) {
        color = vec3(0.0);
    }

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}StaticCharacterBaseShaderInverse.glsl{@}#!ATTRIBUTES
attribute float windmask;

#!UNIFORMS
uniform sampler2D tTrim;
uniform float uLineWidth;
uniform vec4 uWindAxisAngle;
uniform vec3 uWindParams;
uniform vec3 uBreathe;
uniform float uBend;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;

    float steppedTime = floor(time * 18.0) / 18.0;

    vec3 pos = position;

    // wind animation
    vec3 windAxis = normalize(uWindAxisAngle.xyz);
    float windAngle = uWindAxisAngle.w;
    vec3 windPos = rotation3d(windAxis, windAngle) * pos;

    float displacement = sin(windPos.y * uWindParams.y + steppedTime * uWindParams.z) * uWindParams.x * windmask;
    displacement += sin(windPos.y * uWindParams.y * 0.34159 + windPos.z * 0.5 * uWindParams.y + steppedTime * uWindParams.z * 3.14159 * 0.673) * uWindParams.x * windmask;
    displacement += sin(windPos.y * uWindParams.y * 0.2772 + windPos.z * 0.5 * uWindParams.y + steppedTime * uWindParams.z * 3.14159 * 0.673) * uWindParams.x * windmask * 0.5;
    
    pos.y += displacement;
    pos.x -= displacement * 0.5;

    // breathe animation
    float mask = smoothstep(uBreathe.x, uBreathe.y, position.y);
    vec3 pivot = vec3(0.0, 0.2, -0.1);
    pos -= pivot;
    pos = rotation3d(vec3(1.0, 0.0, 0.0), (2.5 * uBreathe.z + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2) * uBreathe.z + uBend * mask) * pos;
    pos += pivot;
    pos += normal * uLineWidth;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

void main() {
    // trim texture
    float trimAlpha = texture2D(tTrim, vUv).a;
    if (trimAlpha < 0.95) discard;

    vec3 color = vec3(0.0);

    float alpha = 1.0;
    
    gl_FragColor = vec4(color, alpha);
}{@}StaticObjectBaseShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uDistanceCompensation;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vDistance;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;
    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * modelViewPos;

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vDistance = -modelViewPos.z;
    
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    vec2 lineUvDistanceCompensated = lineUv * mix(2.0, 0.5, pow(clamp(vDistance * 0.0325, 0.0, 1.0), 2.0)) * 0.5;
    lineUv = mix(lineUv, lineUvDistanceCompensated, uDistanceCompensation);
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float verticalGrad = smoothstep(uVerticalGrad.x, uVerticalGrad.y, vPos.y);
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45 - vAo * 0.15 - verticalGrad);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1 - vAo * 0.15 - verticalGrad);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask + lighting * 0.3;
    maskedLines = aastep(0.2, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), uColor, terminatormid);
    color = mix(color, uColorHighlight, terminatorhigh);
    color *= maskedLines;

    float alpha = 1.0 - color.r;
    color = max(vec3(18.0 / 255.0), color);

    gl_FragColor = vec4(color, alpha);
}{@}StaticObjectBaseShaderInverse.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uLineWidth;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying float vNdcHeight;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vec3 pos = position;

    vec4 projectionPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec4 projectionNormal = projectionMatrix * modelViewMatrix * vec4(normal, 0.0);
    
    float aspect = resolution.x / resolution.y;
    projectionNormal.z = projectionNormal.z;
    // projectionNormal.x /= aspect * 0.5;
    projectionPos.xy += projectionNormal.xy * uLineWidth * sqrt(projectionPos.w) * 2.0;
    
    gl_Position = projectionPos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    vec3 color = vec3(18.0 / 255.0);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}StaticObjectNoDiscard.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float verticalGrad = smoothstep(uVerticalGrad.x, uVerticalGrad.y, vPos.y);
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45 - vAo - verticalGrad);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1 - vAo - verticalGrad);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask + lighting * 0.3;
    maskedLines = aastep(0.2, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), uColor, terminatormid);
    color = mix(color, uColorHighlight, terminatorhigh);
    color *= maskedLines;

    color = max(vec3(18.0 / 255.0), color);

    // color = vec3(terminatorhigh);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}CompositeShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tDiffuse;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform sampler2D tBlueNoise;
uniform float uAgeGate;
uniform float uDPR;
uniform float uLoaderFinished;
uniform float uMenuHover;
uniform float uScrollY;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;
  gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
#require(mousefluid.fs)
#require(blendmodes.glsl)

float rand(float co) { return fract(sin(co*(91.3458)) * 47453.5453); }
float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
float rand(vec3 co){ return rand(co.xy+rand(co.z)); }

void main() {
  vec2 screenUv = gl_FragCoord.xy / resolution.xy;
  vec3 color = texture2D(tDiffuse, vUv).rgb;

  if (uAgeGate > 0.01) {
    vec2 blueUv = screenUv;
    blueUv.x *= resolution.x / resolution.y;
    blueUv *= 4.0;
    blueUv.y -= time * 0.04;
    vec3 bnoise = texture2D(tBlueNoise, blueUv).rgb;

    float fluidMask = smoothstep(0.4, 0.7, texture2D(tFluidMask, screenUv).r);
    vec3 fluid = vec3(texture2D(tFluid, screenUv).xy * fluidMask, fluidMask);

    fluid.z *= 1.0 - (bnoise.r) * 0.99;
    float steppedTime = floor(time * 8.0) / 8.0;
    float n1 = texture2D(tNoise, screenUv * 1.3 + vec2(-steppedTime * 0.05, steppedTime * 0.02)).r;
    fluid.z *= 0.1 + sin(steppedTime + n1 * 4.0) * 0.5 + 0.5;

    fluid.z *= uAgeGate;
    color = mix(color, color + 0.02, step(0.9, sin(fluid.z * 4.0)));
  }

    vec2 buv = screenUv;
    buv.x *= resolution.x / resolution.y;
    buv *= 10.0;
    vec3 bnoise = texture2D(tBlueNoise, buv).rgb;

    vec2 noiseUv = screenUv;
    noiseUv.x *= resolution.x / resolution.y;

    float st = floor(time * 8.0) / 8.0;
    float n1 = texture2D(tNoise, noiseUv * 0.2 + vec2(-st * 0.05, st * 0.02)).r;
    float n2 = texture2D(tNoise, noiseUv * 0.3 + vec2(-st * 0.03, st * 0.01)).r;
    
    // CLOUD NOISE
    // float clouds = 0.0;
    // clouds += (n1 * 0.7);
    // clouds -= (bnoise.r * 0.5);
    // clouds += smoothstep(1.0, 0.65, vUv.y);
    // clouds += smoothstep(0.8, 0.0, vUv.x);
    // clouds = step(0.31, clouds);
    // float blnd = ((1.0 - clouds) * uLoaderFinished) * 0.25;
    // color = blendMultiply(color, vec3(0.1), blnd);



    // RANDOM NOISE
    // vec3 randomNoise = vec3(rand(vUv));
    // color = randomNoise;
    // color = blendOverlay(color, randomNoise, .15);

    // SCROLLED BLUE NOISE
    vec2 scrolledUvs = screenUv;
    scrolledUvs.x *= resolution.x / resolution.y;
    scrolledUvs *= 5.;
    scrolledUvs.y += uScrollY * 1.5;
    vec3 globalNoise = vec3(texture(tBlueNoise, scrolledUvs).r * 2. + 0.1);

    color = blendMultiply(color, globalNoise, .1);


    // float layer2 = 0.0;
    // layer2 += (n1 + n2) * 0.45;
    // layer2 -= (bnoise.r * 0.3);
    // layer2 = step(0.31, layer2);
    // color = blendMultiply(color, vec3(0.0), (1.0 - layer2) * 0.05);
    

  gl_FragColor = vec4(color, 1.0);
}
{@}AntiGravSkinShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;

uniform float uLinesTile;
uniform float uDisplacement;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uTime;
uniform float uInverse;
uniform vec3 uLightDir;
uniform vec3 uColor;
uniform float uWindSpeed;
#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vNdcHeight;

#!SHADER: Vertex

#require(skinning.glsl)
#require(simplenoise.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalize(normalMatrix * normal);


    vec3 pos = position;
    applySkin(pos, vNormal);


    float steppedTime = floor(time * 8.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;

    vAo = uv2.x;
    vPos = pos;

    float hairmask = step(0.001, vUv2.y);

    float hairWindMask = step(vPos.y - 1.54, 0.8);

    float clothesMask = 1.0 - step(0.55, vUv2.y);

    pos.xz += (cnoise(pos.xz * 10.0 + (uTime * uWindSpeed)) * 0.01 * clothesMask) * hairmask;

    pos.xz += (cnoise(pos.xz * 5.0 + (uTime * uWindSpeed)) * 0.01 * (1.0 - hairmask) * (1.0 - hairWindMask));

    vec4 projectionPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec4 projectionNormal = projectionMatrix * modelViewMatrix * vec4(vNormal, 0.0);
    
    vec2 screenNormal = normalize(projectionNormal.xy);
    projectionPos.xy += screenNormal * uDisplacement * projectionPos.w * 0.004;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    gl_Position = mix(gl_Position, projectionPos, uInverse);


    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float ao = abs(vAo);
    float skinMask = step(0.55, vUv2.y);
    float hairstrips = step(0.8, vUv2.y);
    vec3 normal = normalize(vNormal);
    
    float steppedTime = floor(time * 8.0);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x += steppedTime / uLinesTile * 0.2;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // trim pattern
    float trim = texture2D(tTrim, vUv).r;
    trim = aastep(0.55, trim);

    // lighting
    vec3 lightDir = normalize(uLightDir);
    float lighting = dot(normal, lightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(-0.3, lighting + lines * 1.3 - vAo);
    float terminatorhigh = aastep(0.85, lighting + lines * 0.1 - 0.1 - vAo);
    float terminatorbounce = 1.0 - aastep(-0.91, lighting - lines * 0.2);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);

    vec3 alt = uColor;

    color = mix(vec3(18.0 / 255.0), alt, terminatormid);
    color = mix(color, vec3(1.0), skinMask);
    color *= maskedLines;
    color = mix(color, alt, terminatorbounce);
    color *= trim;

    // color = vec3(skinMask);


    color = max(vec3(18.0 / 255.0), color);

    color =  mix(color, vec3(18.0 / 255.0), uInverse);

    gl_FragColor = vec4(color, 1.0);

}{@}AntiGravityFloorShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    // keep alive animation
    // float mask = smoothstep(-0.2, 0.3, position.y);
    // pos = rotation3d(vec3(1.0, 0.0, 0.5), (2.5 + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2)) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    // vec3 normal = normalize(vNormal);
    
    // lines
    // // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, vUv * 3.2 - vec2(steppedTime * 0.2, -steppedTime)).r;
    float noise2 = texture2D(tNoise, vUv * 1.5 - vec2(-steppedTime * 0.3, steppedTime)).r;

    float lineTile = uLinesTile;
    vec2 lineUv = vUv.yx * lineTile;
    lineUv.x -= steppedTime * 2.0;

    //lineUv.xy /= distCenter;
    

    float distCenter = distance(vUv + vec2((noise * 2.0 - 1.0) - 0.5) * 0.1, vec2(0.5, 0.5));
    distCenter = smoothstep(0.3, 0.55, distCenter);
    float alpha = 1.0;


    float lines = texture2D(tLines, lineUv.yx).r;

    float tile = 120.0;
    float value = sin(vUv.y * tile * 0.5) * 0.5 + 0.5;
    value = min(value, sin(vUv.x * tile) * 0.5 + 0.5);
    // value += 0.1;
    value += noise * 0.015;
    value += noise2 * 0.02;
    value -= lines * 0.001;
    value = aastep(0.05, 1.0 - pow(1.0 - value, 2.0));

    float lineTexture = lines * 0.75;
    value *= aastep(clamp(mix(0.2, 0.45, 1.0 - distCenter), 0.0, 1.0), lineTexture * (1.0 - clamp(length(vUv - 0.5) * 1.0, 0.0, 1.0)));

    vec3 color = uColorHighlight * value;
    color = max(vec3(18.0 / 255.0), color);

    


    gl_FragColor = vec4(color, alpha );
}{@}BlobShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;
attribute vec3 lookup;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPrevPos;
uniform sampler2D tVelocity;
uniform vec3 uColor;
uniform sampler2D tMap;
uniform float uDPR;
uniform float uFade;
uniform float uInverse;
uniform float uAnimate;
uniform sampler2D tLife;

#!VARYINGS
varying vec3 vColor;
varying float vLife;
varying vec2 vUv;
varying vec4 vRandom;
varying vec4 vVelocity;
varying vec3 vWorldNormal;
varying vec3 vView;
#!SHADER: Vertex

#require(range.glsl)
#require(simplenoise.glsl)
#require(instance.vs)
#require(curl.glsl)

mat3 calcLookAtMatrix(vec3 vector, float roll) {

    vec3 rr = vec3(sin(roll), cos(roll), 0.0);

    vec3 ww = normalize(vector);
    vec3 uu = normalize(cross(ww, rr));
    vec3 vv = normalize(cross(uu, ww));

    return mat3(uu, ww, vv);

}

#define PI 3.1415926535897

void main() {
    vUv = uv;
    vec4 decodedPos = texture2D(tPos, lookup.xy);
    vec4 decodedPrevPos = texture2D(tPrevPos, lookup.xy);
    vec3 offset = decodedPos.xyz;
    vec3 prevOffset = decodedPrevPos.xyz;
    vec3 velocity = offset - prevOffset;
    vVelocity = vec4(velocity, 1.0);
    float outScale = 0.01 + random.r * 0.1;
    float scale = random.x * 0.025;
    float life = texture2D(tLife, lookup.xy).r;
    if(life < 0.0)
        life = 1.0;
    vLife = life;
    vRandom = random;

    float stretchAmount = clamp(length(max(vec3(0.0), smoothstep(0.0, 1.0, velocity)) * 350.), 0.0, 5.0);
    float stretchMask = smoothstep(0.0, 1.0, -position.y);
    stretchAmount *= stretchMask;

    vec3 stretchDirection = normalize(velocity);
    vec3 noise = snoiseVec3((position.xyz * 0.5) + time * 2.);
    vec3 localPos = position + noise * 0.05;

    localPos *= smoothstep(0.0, 0.1, 1.0 - life) * smoothstep(1.0, 0.9, 1.0 - life);

    localPos += normal * uInverse * 0.3;

    localPos *= 1.0 - uAnimate;

    stretchAmount *= mix(1.0, 0.8, uInverse);
    vec3 stretchedPos = localPos * (scale * vec3(1.0, 1.0 + (stretchAmount * 1.0), 1.0));

    stretchedPos.y *= 1.5;

    if(length(velocity) > 0.6) {
        return;
    }

    vec3 worldNormal = (modelMatrix * vec4(normal, 0.0)).xyz;

    mat4 lookAt = mat4(calcLookAtMatrix(normalize(velocity), 0.0));
    vec3 rotatedPos = (lookAt * vec4(stretchedPos, 1.0)).xyz;

    vec3 rotatedNormal = (lookAt * vec4(worldNormal, 0.0)).xyz;
    vWorldNormal = rotatedNormal;

    vec3 transformedPos = rotatedPos + offset;
    vec4 worldPos = modelMatrix * vec4(transformedPos, 1.0);
    vView = worldPos.xyz - cameraPosition;
    vec4 mvPosition = modelViewMatrix * vec4(transformedPos, 1.0);
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

float fresnel(float amount, vec3 normal, vec3 view) {
    return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

#require(transformUV.glsl)
void main() {
    float multiplier = 1.0;
    float alpha = vLife * multiplier;

    float fresn = fresnel(1.0, vWorldNormal, -vView);
    fresn = step(0.5, fresn);
    //vec3 color = normalize(vVelocity.xxx);
    gl_FragColor = vec4(mix(uColor, vec3(0.0), uInverse), 1.0);
}{@}BlobShaderDrawn.glsl{@}#!ATTRIBUTES
attribute vec4 random;
attribute vec3 lookup;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPrevPos;
uniform sampler2D tVelocity;
uniform vec3 uColor;
uniform sampler2D tMap;
uniform float uDPR;
uniform float uFade;
uniform float uInverse;
uniform float uAnimate;
uniform sampler2D tLife;

#!VARYINGS
varying vec3 vColor;
varying float vLife;
varying vec2 vUv;
varying vec4 vRandom;
varying vec4 vVelocity;
varying vec3 vWorldNormal;
varying vec3 vView;
#!SHADER: Vertex

#require(range.glsl)
#require(simplenoise.glsl)
#require(instance.vs)
#require(curl.glsl)

mat3 calcLookAtMatrix(vec3 vector, float roll) {

  vec3 rr = vec3(sin(roll), cos(roll), 0.0);

  vec3 ww = normalize(vector);
  vec3 uu = normalize(cross(ww, rr));
  vec3 vv = normalize(cross(uu, ww));

  return mat3(uu, ww, vv);

}

#define PI 3.1415926535897

void main() {
    vUv = uv;
    vec4 decodedPos = texture2D(tPos, lookup.xy);
    vec4 decodedPrevPos = texture2D(tPrevPos, lookup.xy);
    vec3 offset = decodedPos.xyz;
    vec3 prevOffset = decodedPrevPos.xyz;
    vec3 velocity = offset - prevOffset;
    vVelocity = vec4(velocity, 1.0);
    float outScale = 0.01 + random.r * 0.1;
    float scale = range(random.x, 0.0, 1.0, 0.01, 0.028);
    float life = texture2D(tLife, lookup.xy).r;
    if (life < 0.0) life = 1.0;    
    vLife = life;
    vRandom = random;

    float stretchAmount = clamp(length(max(vec3(0.0), smoothstep(0.0, 1.0, velocity)) * 350.), 0.0, 5.0);
    float stretchMask = smoothstep(0.0, 1.0, -position.y);
    stretchAmount *= stretchMask;

    vec3 stretchDirection = normalize(velocity);
    vec3 noise = snoiseVec3((position.xyz * 0.3) + (time + (random.x * 1000.)) * 2.0);
    vec3 localPos = position + noise * 0.1;


    localPos *= smoothstep(0.0, 0.05, 1.0 - life) * smoothstep(1.0, 0.9, 1.0 - life);

    
    localPos += normal * uInverse * 0.3;
    localPos *= 1.0 - uAnimate;
    
    stretchAmount *= mix(1.0, 0.8, uInverse);
    vec3 stretchedPos = localPos * (scale * vec3(1.0, 1.0 + (stretchAmount * 0.7), 1.0));

    stretchedPos.y *= 1.5;

    // if(length(velocity) > 0.6) {
    //     return;
    // }

    vec3 worldNormal = (modelMatrix * vec4(normal, 0.0)).xyz;

    mat4 lookAt = mat4( calcLookAtMatrix( normalize(velocity), 0.0 ) );
    vec3 rotatedPos    = ( lookAt * vec4(stretchedPos, 1.0 ) ).xyz;

    vec3 rotatedNormal = (lookAt * vec4(worldNormal, 0.0)).xyz;
    vWorldNormal = rotatedNormal;
    

    vec3 transformedPos = rotatedPos + offset;
    vec4 worldPos = modelMatrix * vec4(transformedPos, 1.0);
    vView = worldPos.xyz - cameraPosition;
    vec4 mvPosition = modelViewMatrix * vec4(transformedPos, 1.0);
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


#require(transformUV.glsl)
void main() {
    float multiplier = 1.0;
    float alpha = vLife * multiplier;
    

    float fresn = fresnel(1.0, vWorldNormal, -vView);
    fresn = step(0.5, fresn);

    vec3 outColor = mix(uColor, vec3(1.0), step(0.8, vRandom.y));
    outColor = mix(uColor, outColor, 1.0 - uInverse);
    //vec3 color = normalize(vVelocity.xxx);
    gl_FragColor = vec4(mix(outColor, vec3(0.0), uInverse), 1.0);
}{@}FloatingFrameEyesShaderAG.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute vec3 color;
attribute vec3 openeyes;
attribute vec3 eyemasks;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
uniform float uOpenEyesWeight;
uniform float uTransitionEyeColor;
uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec3 uColor;
uniform vec3 uColorBG;
uniform vec3 uColorFlavor;
uniform float uTransition;
// uniform float uAspectRatio;
uniform float uDPR;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying vec3 vColor;
varying float vAo;
varying float vBackground;
varying vec3 vNdc;
varying vec3 vLightDir;
varying vec3 vTransformed;
varying float vSteppedTime;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

#require(skinning.glsl)

void main() {
    vColor = color;
    vUv = uv;
    vUv2 = uv2;
    vPos = position;
    vNormal = normalize(normalMatrix * normal);
    vLineUv = (rotation3d(normalize(vec3(0.0, 0.0, 1.0)), 1.57) * position).xy;
    vLightDir = normalize(uLightDir);
    vSteppedTime = floor(time * 8.0) / 8.0 * 0.15;
    vAo = 1.0 - color.b;

    vec3 pos = position;

    applySkin(pos, vNormal);

    pos = rotation3d(vec3(1.0, 0.0, 0.5), sin((time * 2.0) * 0.5 + pos.x * 1.0 - pos.z * 2.0) * 0.005) * pos;
    
    // transition between blend shapes
    pos += (openeyes * (uOpenEyesWeight * 11.0));

    vTransformed = pos;

    // Add a little tremor to the eye highlights as the eyes open
    pos.y += sin(time * 60.0) * vColor.g * 0.001 * uOpenEyesWeight;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdc = gl_Position.xyz / gl_Position.w;

}


#!SHADER: Fragment
#require(simplenoise.glsl)
#require(range.glsl)
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
    return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
}

void main() {
    // gl_FragColor = vec4(vUv, 1.0, 1.0);
    // gl_FragDepth = -10.0;
    // return;
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = uPoint1;
    vec3 pos2 = uPoint2;
    vec3 pos3 = uPoint3;
    vec3 pos4 = uPoint4;

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise


    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(vSteppedTime, 0.0)).r;
    sdfx += edgeNoise * 0.003;
    sdfy += edgeNoise * 0.003;
    float sdf = max(sdfx * aspect, sdfy);
    // sdf * aspect;

    // float dx = dFdx(vNdc.x);
    // float dy = dFdy(vNdc.y);

    // float verticalRatio = resolution.y / resolution.x;
    // float horizontalRatio = resolution.x / resolution.y;
    
    // float width = 0.0025;
    // float outline = aastep(width, -sdf);
    // outline *= aastep(width, -sdfy);

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);
    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.015) discard;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= vSteppedTime * 3.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // atlas texture
    vec2 displacement = vec2(sin(vPos.y * 100.0 + floor(time * 6.0) * 1.5), 0.0);
    float atlas = texture2D(tAtlas, vUv2 + displacement * 0.0003).r;
    atlas += (lines) * 0.15;
    atlas = aastep(0.25, atlas);

    // trim texture
    float trim = texture2D(tTrim, vUv).r;
    trim = aastep(0.55, trim);

    // lighting
    vec3 lightDir = vLightDir;
    float lighting = dot(normal, lightDir) * vAo;
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.1, lighting + lines * 0.3);
    float terminatorhigh = aastep(0.2, lighting + lines * 1.075);
    float terminatorbounce = 1.0 - aastep(-0.13, lighting * 0.7 - lines * 0.2);


    // reduce lines in areas of brightness
    float maskedLines = lines;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;

    float gradMask = 1.0 - (vPos.y - 0.95);
    maskedLines += pow(gradMask, 2.0);
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    // eye
    vec3 eyeColor = uColor;
  
    // iris
    float irisMask = step(0.5, vColor.r);
  

    float noiseIris = cnoise(vPos * vec3(15.0, 20.0, 20.0)) * 0.5 + 0.5;
    // transition eye color
    float transitionRange = range(uTransitionEyeColor, 0.0, 1.0, -0.1, 1.5);
    noiseIris = aastep(1.0 - transitionRange, noiseIris);
    color = mix(color, mix(eyeColor, uColorFlavor, noiseIris), irisMask);

    float shine = step(0.5, vColor.g) * 0.5;
    maskedLines = mix(maskedLines, 1.0, pow(shine,0.01));

    // eye rings
    color *= maskedLines;
    color = mix(color, vec3(1.0), terminatorbounce);
    color *= atlas;
    color *= trim;

    vec3 backgroundColor = vec3(58.0) / 255.0;

    float alpha = 1.0 - aastep(0.0025, sdf);


    if (!gl_FrontFacing) {
        color = vec3(0.0);
    }

    if(vPos.z < 0.0) {
        color = uColorBG;
    }

    color *= outline;
    color = max(vec3(18.0 / 255.0), color);

    gl_FragColor = vec4(color, 1.0);
    // gl_FragColor = vec4(vec3(vAo), 1.0);


    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.1;
}{@}LeafShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;
attribute vec3 lookup;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPrevPos;
uniform sampler2D tVelocity;
uniform sampler2D tColor;
uniform vec3 uColor;
uniform sampler2D tMap;
uniform float uDPR;
uniform float uFade;
uniform sampler2D tLife;

#!VARYINGS
varying vec3 vColor;
varying float vLife;
varying vec2 vUv;
varying vec4 vRandom;
varying vec4 vVelocity;
varying vec3 vWorldNormal;
varying vec3 vView;
#!SHADER: Vertex

#require(range.glsl)
#require(simplenoise.glsl)
#require(instance.vs)
#require(curl.glsl)

mat3 calcLookAtMatrix(vec3 vector, float roll) {

  vec3 rr = vec3(sin(roll), cos(roll), 0.0);

  vec3 ww = normalize(vector);
  vec3 uu = normalize(cross(ww, rr));
  vec3 vv = normalize(cross(uu, ww));

  return mat3(uu, ww, vv);

}

#define PI 3.1415926535897


#require(quaternion.glsl)
float parabola( float x, float k ){
    return pow( 4.0*x*(1.0-x), k );
}

void main() {
    vUv = uv;
    vec4 decodedPos = texture2D(tPos, lookup.xy);
    vec4 decodedPrevPos = texture2D(tPrevPos, lookup.xy);
    vec3 offset = decodedPos.xyz;
    vec3 prevOffset = decodedPrevPos.xyz;
    vec3 velocity = offset - prevOffset;
    vVelocity = vec4(velocity, 1.0);
    float scale = (random.x + 0.6) * 0.06;
    float life = texture2D(tLife, lookup.xy).r;
    if (life < 0.0) life = 1.0;    
    vLife = life;
    vRandom = random;

    vec3 localPos = position;

    float noise = cnoise(localPos.xyz * 10.0);
    noise = noise * 0.1;
    localPos.z += noise;

    localPos *= scale;

    localPos *= parabola(vLife, 0.1);

    // give random rotation to the leaf

    vec3 worldNormal = (modelMatrix * vec4(normal, 0.0)).xyz;

    vec3 rotatedPos    = localPos; //( lookAt * vec4(localPos, 1.0 ) ).xyz;


    vec3 rotatedNormal = worldNormal; //(lookAt * vec4(worldNormal, 0.0)).xyz;
    vWorldNormal = rotatedNormal;

    rotatedPos = rotateVertexPosition(rotatedPos, vec3(0.0, 0.0, 1.0), (random.y + 1.0) * 360. + (time * 30.));
    rotatedPos = rotateVertexPosition(rotatedPos, vec3(1.0, 0.0, 0.0), (random.x + 1.0) * 360. * PI + (time * 30.));

    offset.y += 0.95 * (random.x * 2.0 - 1.0);
    offset.x += 0.2 * (random.y * 2.0 - 1.0);
    

    vec3 transformedPos = rotatedPos + offset;
    vec4 worldPos = modelMatrix * vec4(transformedPos, 1.0);
    vView = worldPos.xyz - cameraPosition;
    vec4 mvPosition = modelViewMatrix * vec4(transformedPos, 1.0);
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


#require(transformUV.glsl)

void main() {
    float multiplier = 1.0;
    float alpha = vLife * multiplier;
    

    float fresn = fresnel(1.0, vWorldNormal, -vView);
    fresn = step(0.5, fresn);

    vec4 color = texture2D(tMap, vUv);

    vec3 lightGreen = vec3(0.1, 0.3, 0.1);

    color.rgb = mix(color.rgb, uColor, pow(color.r, 1.0));

    if(color.a < 0.5) discard;
    //vec3 color = normalize(vVelocity.xxx);
    gl_FragColor = vec4(color.rgb, color.a);
}{@}LightBeamShader.glsl{@}#!ATTRIBUTES


#!UNIFORMS
uniform vec3 color;
uniform vec3 color2;
uniform float alpha;
uniform float uDiscardBottom;
uniform float uDiscardTop;
uniform vec3 colorB;
uniform sampler2D tWindNoise;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uTime;
uniform float uTimeUp;
// Vertex shader uniforms - grouped by type
uniform vec3 uScale;              // x, y, z scale
uniform float uOffsetX;           // x offset
uniform vec2 uMask;               // multiplier, timeSpeed
uniform vec3 uNoise;              // scale, timeSpeed, amount
uniform vec2 uRotation;           // angle, timeSpeed
uniform vec2 uXZScale;            // min, max
uniform vec2 uSmoothstep;         // min, max
uniform float uParabolaK;         // parabola exponent
// Fragment shader uniforms - grouped by type
uniform vec2 uEndNoise;           // rotation, scale
uniform vec2 uEndsMask;           // threshold, parabolaK
uniform vec2 uNoiseUVTimeSpeed;   // x, y timeSpeed
uniform vec2 uNoiseUVScaleA;      // x, y scale for noiseUv
uniform vec2 uNoiseUVScaleB;      // x, y scale for noiseUvB
uniform float uWindNoiseThreshold;
uniform float uAnimateInMask;
uniform float uAnimateNoise;
uniform mat4 modelMatrix;

#!VARYINGS
varying vec2 vUv;
varying float vNdcHeight;
varying vec3 vNormal;
varying float vMask;
varying vec3 vWorldPos;
varying float vDotProduct;
varying vec3 vViewDir;
#!SHADER: LightBeamShader.vs


float parabola( float x, float k ){
    return pow( 4.0*x*(1.0-x), k );
}

#require(quaternion.glsl)
#require(simplenoise.glsl)

void main() {

    vec3 worldPos = position;
    vNormal = normal;
    
    worldPos *= uScale;
  
    float mask = (worldPos.y * uMask.x) - (uTime * uMask.y);
    vMask = mask;
    float noise = cnoise((worldPos.xyz * uNoise.x) - (uTime * uNoise.y)) * uNoise.z;


    worldPos = rotateVertexPosition(worldPos, vec3(0.0, 1.0, 0.0), mask * uRotation.x);
    vNormal = rotateVertexPosition(vNormal, vec3(0.0, 1.0, 0.0), mask * uRotation.x);

    worldPos.xz = mix(worldPos.xz * uXZScale.x, worldPos.xz, (1.0 - parabola(uv.y, uParabolaK)));
    worldPos.xz = mix(worldPos.xz * uXZScale.y, worldPos.xz, smoothstep(uSmoothstep.x, uSmoothstep.y, uv.y));

    worldPos = rotateVertexPosition(worldPos, vec3(0.0, 1.0, 0.0), -uTimeUp * uRotation.y);
    vNormal = rotateVertexPosition(vNormal, vec3(0.0, 1.0, 0.0), -uTimeUp * uRotation.y);

    worldPos.xz -= noise;

    vWorldPos = worldPos;

    worldPos.x *= uAnimateInMask;


    float dotProduct = dot(vNormal, vec3(0.0, 0.0, 1.0));
    vDotProduct = dotProduct;

    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(worldPos, 1.0);
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
    vViewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
}

#!SHADER: LightBeamShader.fs

float parabola( float x, float k ){
    return pow( 4.0*x*(1.0-x), k );
}

#require(transformUV.glsl)
#require(range.glsl)
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    if(vDotProduct < 0.2) discard;

    vec2 noiseUv = vUv;
    noiseUv.y -= uTime * uNoiseUVTimeSpeed.y;
    noiseUv = scaleUV(noiseUv, uNoiseUVScaleA);

    noiseUv += vec2(
        texture2D(tNoise, (noiseUv * 1.0) + vec2(uTime * 0.025)).r,
        texture2D(tNoise, (noiseUv * 1.0) + vec2((uTime + 5.0) * 0.025)).r
    ) * 0.2;

    vec2 noiseUvB = vUv;

    noiseUvB.y -= uTime * uNoiseUVTimeSpeed.y;
    noiseUvB = scaleUV(noiseUvB, uNoiseUVScaleB);

    noiseUvB += vec2(
        texture2D(tNoise, (noiseUvB * 1.0) + vec2(uTime * 0.025)).r,
        texture2D(tNoise, (noiseUvB * 1.0) + vec2((uTime + 10.0) * 0.025)).r
    ) * 0.1;


    float windNoiseA = texture2D(tNoise, noiseUv).r;
    float windNoiseB = texture2D(tNoise, noiseUvB).r;

    vec3 lightDir = vec3(0.25, 0.25, 1.25);
    float lighting = dot(vNormal, lightDir);
    float lightMask = max(0.0, lighting);

    vec2 lineUv = vUv * 4.;

    lineUv = rotateUV(lineUv, 0.4);

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    lineUv.x -= steppedTime * 30.;

    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    float maskedLines = lines;

    float gradMask = (vWorldPos.y + 2.75);
    float fresn = getFresnel(vNormal , normalize(vViewDir), 0.5);
    float fresnel = aastep(windNoiseA * 0.6, fresn);
    vec3 finalColor = mix(color, colorB, fresnel);

    vec3 taperMaskColor = mix(finalColor, colorB, vec3(1.0 - step(windNoiseB * 0.3, gradMask)));

    if(taperMaskColor.r < 0.01) discard;
    gl_FragColor = vec4(taperMaskColor, taperMaskColor.r);

    float animateInMask = step(vWorldPos.y + mix(-4.0, 4.0, 1.0 - uAnimateNoise), windNoiseB + windNoiseA);

    float fadeTop = 1.0 - smoothstep(0.95, 1.0, vUv.y);

    fadeTop += (windNoiseB) * 0.4;
    fadeTop = step(0.4, fadeTop);

    animateInMask *= fadeTop;

    gl_FragColor.a *= animateInMask;

    // gl_FragColor = vec4(vUv.y, 1.0, 1.0, 1.0);

    //gl_FragColor = vec4(vec3(vDotProduct), 1.0);
}{@}LineDrawnShader.glsl{@}#!ATTRIBUTES
attribute vec3 previous;
attribute vec3 next;
attribute float side;
attribute float width;
attribute float lineIndex;
attribute vec2 uv2;

#!UNIFORMS
uniform float uLineWidth;
uniform float uBaseWidth;
uniform float uOpacity;
uniform vec3 uColor;

#!VARYINGS
varying float vLineIndex;
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vColor;
varying float vOpacity;
varying float vWidth;
varying float vDist;
varying float vFeather;
varying float vLengthScale;


#!SHADER: Vertex

//params

vec2 fix(vec4 i, float aspect) {
    vec2 res = i.xy / i.w;
    res.x *= aspect;
    return res;
}

void main() {
#test RenderManager.type == RenderManager.VR
    float aspect = (resolution.x / 2.0) / resolution.y;
#endtest
#test RenderManager.type != RenderManager.VR
    float aspect = resolution.x / resolution.y;
#endtest

    vUv = uv;
    vUv2 = uv2;
    vLineIndex = lineIndex;
    vColor = uColor;
    vOpacity = uOpacity;
    vFeather = 0.1;

    vec3 pos = position;
    vec3 prevPos = previous;
    vec3 nextPos = next;
    float lineWidth = 1.0;
    //main

    //startMatrix
    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 finalPosition = m * vec4(pos, 1.0);
    vec4 pPos = m * vec4(prevPos, 1.0);
    vec4 nPos = m * vec4(nextPos, 1.0);
    //endMatrix

    vec2 currentP = fix(finalPosition, aspect);
    vec2 prevP = fix(pPos, aspect);
    vec2 nextP = fix(nPos, aspect);

    float w = uBaseWidth * uLineWidth * width * lineWidth;
    vWidth = w;

    vec4 temp1 = vec4(0.0, 0.0, pos.z, 1.0);
    temp1 = m * temp1;
    vec4 temp2 = vec4(1.0, 0.0, pos.z, 1.0);
    temp2 = m * temp2;
    vLengthScale = abs(temp2.x - temp1.x);

    vec2 dirNC = currentP - prevP;
    vec2 dirPC = nextP - currentP;
    if (length(dirNC) >= 0.0001) dirNC = normalize(dirNC);
    if (length(dirPC) >= 0.0001) dirPC = normalize(dirPC);
    vec2 dir = normalize(dirNC + dirPC);

    //direction
    vec2 normal = vec2(-dir.y, dir.x);
    normal.x /= aspect;
    normal *= 0.5 * w;

    vDist = finalPosition.z / 10.0;

    finalPosition.xy += normal * side;
    gl_Position = finalPosition;
}

#!SHADER: Fragment

//fsparams

#require(aastep.glsl)

void main() {
    float d = (1.0 / (5.0 * vWidth + 1.0)) * vFeather * (vDist * 5.0 + 0.5);
    vec2 uvButt = vec2(0.0, vUv.y);
    float buttLength = 0.5 * vWidth;
    uvButt.x = min(0.5, vUv2.x * vLengthScale / buttLength) + (0.5 - min(0.5, (vUv2.y - vUv2.x) * vLengthScale / buttLength));
    float round = length(uvButt - 0.5);
    float alpha = 1.0 - smoothstep(0.45, 0.5, round);

    /*
        If you're having antialiasing problems try:
        Remove line 93 to 98 and replace with
        `
            float signedDist = tri(vUv.y) - 0.5;
            float alpha = clamp(signedDist/fwidth(signedDist) + 0.5, 0.0, 1.0);

            if (w <= 0.3) {
                discard;
                return;
            }

            where tri function is

            float tri(float v) {
                return mix(v, 1.0 - v, step(0.5, v)) * 2.0;
            }
        `

        Then, make sure your line has transparency and remove the last line
        if (gl_FragColor.a < 0.1) discard;
    */

    vec3 color = vColor;

    float stepped = aastep(0.5, vUv.y);
    color = mix(vec3(18.0 / 255.0), vec3(1.0), stepped);

    gl_FragColor.rgb = color;
    gl_FragColor.a = alpha * 0.2; 
    gl_FragColor.a *= vOpacity;

    //fsmain

    if (gl_FragColor.a < 0.1) discard;
}
{@}LineProtonCustom.glsl{@}#!ATTRIBUTES
attribute float angle;
attribute vec2 tuv;
attribute float cIndex;
attribute float cNumber;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLife;
uniform float radialSegments;
uniform float thickness;
uniform float taper;
uniform float segmentSpacing;

#!VARYINGS
varying float vLength;
varying vec3 vNormal;
varying vec3 vViewPosition;
varying vec3 vPos;
varying vec2 vUv;
varying vec2 vUv2;
varying float vIndex;
varying float vLife;
varying vec3 vDiscard;
varying float vPosIndex;

#!SHADER: Vertex

//neutrinoparams

#require(ProtonTubesUniforms.fs)
#require(range.glsl)
#require(conditionals.glsl)
#require(simplenoise.glsl)

void main() {
    float headIndex = getIndex(cNumber, 0.0, lineSegments);
    vec2 iuv = getUVFromIndex(headIndex, textureSize);
    vUv2 = iuv;
    float life = texture2D(tLife, iuv).x;
    vLife = life;

    float scale = 1.0;
    //neutrinovs
    vec2 volume = vec2(thickness * 0.065 * scale);

    vec3 transformed;
    vec3 objectNormal;

    //extrude tube
    float posIndex = getIndex(cNumber, cIndex, lineSegments);
    float nextIndex = getIndex(cNumber, cIndex + 1.0, lineSegments);

    vLength = cIndex / (lineSegments - 2.0);
    vIndex = cIndex;

    vec3 current = texture2D(tPos, getUVFromIndex(posIndex, textureSize)).xyz;
    vec3 next = texture2D(tPos, getUVFromIndex(nextIndex, textureSize)).xyz;

    if(distance(current, next) > 0.5) {
        return;
    }

    vDiscard = next - current;
    vec3 T = normalize((next - current));
    vec3 B = normalize(cross(T, next + current));
    vec3 N = -normalize(cross(B, T));

    float tubeAngle = angle;
    float circX = cos(tubeAngle);
    float circY = sin(tubeAngle);

    volume *= mix(crange(vLength, 1.0 - taper, 1.0, 1.0, 0.0) * crange(vLength, 0.0, taper, 0.0, 1.0), 1.0, when_eq(taper, 0.0));

    volume *= smoothstep(0.0, 0.1, 1.0 - life) * smoothstep(1.0, 0.9, 1.0 - life);

    objectNormal.xyz = normalize(B * circX + N * circY);
    transformed.xyz = current + B * volume.x * circX + N * volume.y * circY;
    //extrude tube
    transformed += cnoise(vec3(posIndex * 0.05)) * 0.005;

    vec3 transformedNormal = normalMatrix * objectNormal;

    vec3 pos = transformed;
    vec4 mvPosition = modelViewMatrix * vec4(transformed, 1.0);
    vViewPosition = -mvPosition.xyz;
    vPos = pos;
    vPosIndex = posIndex;
    gl_Position = projectionMatrix * mvPosition;

    //neutrinovspost

    vNormal = normalize(transformedNormal);
    vUv = tuv.yx;
}

#!SHADER: Fragment

#require(simplenoise.glsl)
void main() {


    float noise = cnoise(vec3((vPosIndex + 1.0) * 0.1));

    float gaps = step(0.01, sin(noise * 0.5));

    // if(gaps > 0.0) {
    //     discard;
    // }

    gl_FragColor = vec4(vec3(1.0), gaps);
    
}   {@}ApproachBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform vec3 uColor;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vNdcHeight;
varying float vAspect;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vUv = uv;
    vPos = position;

    float aspect = resolution.y / resolution.x;
    vPos.x *= aspect;
    vPos.x *= 2.0;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vAspect = resolution.x / resolution.y;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

        vec2 screenUv = gl_FragCoord.xy / resolution;

        float steppedTime = -floor(time * 24.0) * 0.00075;
        vec2 uv =  (vUv - vec2(0.5, 0.0)) * vec2(5.0, 2.5) - vec2(-steppedTime, steppedTime * 0.5);

        float n1 = texture2D(tNoise, uv + steppedTime * 0.5).r;

        float noise = texture2D(tMap, uv * vec2(2.0, 1.0)).r;
        noise *= texture2D(tMap, uv * 1.5 * vec2(2.0, 1.0) + steppedTime * 0.5).r;
        noise = clamp(noise, 0.0, 1.0);
        noise = pow(noise, 2.0);

        // float haloGrad = length((vPos - vec3(0.0, 0.0, -1.0)) * 0.5);
        // haloGrad = pow(smoothstep(0.30, 0.08, haloGrad), 3.0);
        float haloGrad = 1.0 - vPos.x * 6.0 - vPos.y * 0.7 + 0.1;
        haloGrad = pow(haloGrad, 3.0);
        float horizonGrad = smoothstep(0.65, 0.52, vUv.y);
        float value = haloGrad + horizonGrad;
        value *= 1.4;
        value -= (1.0 - pow(noise, 2.0)) * 0.6;
        value -= n1 * 0.5;

        float thickness = resolution.y * 0.0035;
        float scan = 0.5;
        float mask = aastep(scan, value);
        float line = mask;
        float width = 0.03;
        line *= 1.0 - aastep(scan + width, value);
        line = 1.0 - line;

        vec3 color = mix(uColor, vec3(1.0), step(scan, value));

        // make black at bottom to hide part where ground cuts off
        color *= step(0.5, vUv.y);

    gl_FragColor = vec4(color, 1.0);
}{@}FloatingFrameSkinShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;
varying float vBackground;
varying vec3 vNdc;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vAo = ao;
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalize(normalMatrix * normal);
    vLineUv = (rotation3d(normalize(vec3(1.0, 0.0, 2.5)), 0.5) * position).xy;
    vLightDir = normalize(uLightDir);

    vec3 pos = position;

    // subtle keep alive animation
    pos = rotation3d(vec3(1.0, 0.0, 0.5), sin(floor(time * 8.0) * 0.5 + position.x * 1.0 - position.z * 2.0) * 0.03) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdc = gl_Position.xyz / gl_Position.w;
    vBackground = 1.0 - step(-0.5, position.z - position.x);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = uPoint1;
    vec3 pos2 = uPoint2;
    vec3 pos3 = uPoint3;
    vec3 pos4 = uPoint4;

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    float invaspect = resolution.y / resolution.x;
    float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;
    sdfx += edgeNoise * 0.0002;
    sdfy += edgeNoise * 0.0002;
    float sdf = max(sdfx, sdfy);
    sdf *= aspect;

    float dx = dFdx(vNdc.x);
    float dy = dFdy(vNdc.y);

    float verticalRatio = resolution.y / resolution.x;
    float horizontalRatio = resolution.x / resolution.y;
    
    float width = 0.001;
    float outline = aastep(width, -sdf);
    // outline *= aastep(width, -sdfy);

    if (sdf > 0.005) discard;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= steppedTime * 3.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // trim texture
    float atlas = texture2D(tAtlas, vUv).r;
    atlas = aastep(0.55, atlas);

    // trim texture
    float trim = texture2D(tTrim, vUv2).r;
    trim = aastep(0.55, trim);

    // lighting
    vec3 lightDir = vLightDir;
    float lighting = dot(normal, lightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.1, lighting + lines * 0.3 - vAo);
    float terminatorhigh = aastep(0.9, lighting + lines * 0.075 - vAo);
    float terminatorbounce = 1.0 - aastep(-0.91, lighting + vAo * 0.2 - lines * 0.2);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    vec3 brown = vec3(176.0, 156.0, 118.0) / 255.0;
    color = mix(vec3(0.0), brown, terminatormid);
    color = mix(color, vec3(1.0), terminatorhigh);
    color *= maskedLines;
    color = mix(color, brown, terminatorbounce);
    color *= trim;
    color *= atlas;

    vec3 backgroundColor = vec3(58.0) / 255.0;
    color *= outline;

    float alpha = 1.0 - aastep(0.0025, sdf);

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.3;
}{@}FloatingFrameWalkShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
uniform vec3 uCenter;
uniform float uTransition;
// uniform float uAspectRatio;
uniform float uDPR;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform float uHover;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vBackground;
varying float vFloor;
varying vec3 vNdc;
varying vec3 vPos;
varying vec3 vLightDir;

#!SHADER: Vertex

#require(skinning.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vPos = position;
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalMatrix * normal;
    vLightDir = normalize(vec3(0.0, 0.5, -0.5));
    vLineUv = (rotation3d(normalize(vec3(-1.0, 0.0, 0.1)), 0.2) * position).xy;

    // masks for background, floor
    vBackground = position.z < -1.0 ? 1.0 : 0.0;
    vFloor = position.y < -0.001 && position.z > -1.1 ? 1.0 : 0.0;

    vec3 pos = position;
    applySkin(pos, vNormal);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdc = gl_Position.xyz / gl_Position.w;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    float transition = uTransition + 0.01;
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = mix(uCenter, uPoint1, transition);
    vec3 pos2 = mix(uCenter, uPoint2, transition);
    vec3 pos3 = mix(uCenter, uPoint3, transition);
    vec3 pos4 = mix(uCenter, uPoint4, transition);

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;

    edgeNoise -= uHover * 70.0;

    sdfx += edgeNoise * 0.0002 * transition;
    sdfy += edgeNoise * 0.0002 * transition;
    float sdf = max(sdfx, sdfy);
    sdf *= aspect;

    // float dx = dFdx(vNdc.x);
    // float dy = dFdy(vNdc.y);

    // float verticalRatio = resolution.y / resolution.x;
    // float horizontalRatio = resolution.x / resolution.y;
    
    // float width = mix(0.00001, 0.005, uTransition);
    // float outline = aastep(width, -sdf);
    // outline *= aastep(width, -sdfy);
    // float widthX = mix(0.00001, 0.002, uTransition);
    // float widthY = mix(0.00001, 0.002 * uAspectRatio, uTransition);

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);

    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.005) discard;

    bool isFloor = vFloor > 0.5;
    bool isBackground = vBackground > 0.5;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * 5.0;
    lineUv.x -= steppedTime * 3.0;

    // scroll floor texture to match feet
    if (isFloor) {
        lineUv.y -= time * 0.9;
    }

    float lines = texture2D(tLines, lineUv.yx * (0.7 - vBackground * 0.2)).r * 2.0 - 1.0;

    // trim texture
    // float atlas = texture2D(tAtlas, vUv2).r;
    // atlas = aastep(0.55, atlas);

    // trim texture
    float trim = texture2D(tTrim, vUv).r;
    trim = aastep(0.55, trim);

    // lighting
    vec3 lightDir = normalize(vec3(-0.25, 0.75, 1.0));
    float lighting = dot(normal, lightDir) * 0.5 + 0.5;
    lighting *= clamp(vPos.y * 0.5 + 0.8, 0.0, 1.0);
    lighting = pow(lighting - 0.1, 4.0);
    // lighting = clamp(lighting, 0.0, 1.0);

    // floor shadow
    float floorShadow = min(1.0, length(vUv * vec2(1.0, 0.5) - vec2(0.5, 0.25)) * 1.1);
    if (isFloor) {
        lighting *= max(0.75, floorShadow);
        lighting += (floorShadow) * 0.5;
    }

    // compositing
    vec3 backgroundColor = mix(uColor1, uColor3, aastep(0.01, vPos.y + lines * 0.1));
    float skinMask = step(0.55, vUv2.y);
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    float value = aastep(0.5, lighting + (1.0 - lines) * 0.3 + noise * lighting + vBackground);
    vec3 color = mix(mix(uColor2, backgroundColor, step(0.5, vBackground)), vec3(1.0), min(1.0, skinMask));
    color = mix(color, uColor1, vFloor);
    color *= mix(trim, 1.0, min(1.0, vFloor + vBackground));
    color *= vec3(value);

    // frame outline
    color *= outline;

    vec3 nearBlack = vec3(18.0 / 255.0);
    color = max(nearBlack, color);

    float alpha = 1.0 - aastep(0.00001, sdf);

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.03;
}{@}PortalShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uSteppedTime;
uniform float uLinesTile;
uniform float uStep;
uniform vec3 uColor1;
uniform vec3 uColor2;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vPos;
varying float vNdcHeight;
varying float vAspect;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {
    vUv2 = position.xz + 0.5;

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vUv = uv;
    vPos = position;

    float aspect = resolution.y / resolution.x;
    vPos.x *= aspect;
    vPos.x *= 2.0;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vAspect = resolution.x / resolution.y;
}

#!SHADER: Fragment
#require(mousefluid.fs)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    // if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;
    vec2 uv = vUv;
    uv.x -= uv.y * 0.5;

    vec2 screenUv = gl_FragCoord.xy / resolution.xy;
    float fluidMask = smoothstep(0.4, 0.7, texture2D(tFluidMask, screenUv).r);
    vec3 fluid = vec3(texture2D(tFluid, screenUv).xy * fluidMask, fluidMask);

    fluid *= smoothstep(0.0, 0.3, length(vUv2 - 0.5));

    float steppedTime = floor(time * uSteppedTime) / uSteppedTime;
    // float value = texture2D(tMap, uv * vec2(2.0, 1.0) + vec2(-steppedTime * 0.3, steppedTime * 0.05)).r;
    // value = mix(value, 1.0, 0.35);
    // float edge = aastep(0.01, pow(value, 3.0) - (pow(vUv.x, 5.0) * 0.1 + 1.0 * smoothstep(0.8, 1.0, vPos.z)));
    // float edge2 = 1.0 - pow(vUv.x, 20.0);
    // value *= edge2;
    // value += pow(1.0 - vUv.x, 15.0);
    // value = aastep(0.3, value);

    vec3 color1 = vec3(0.0);
    vec3 color2 = vec3(1.0);

    vec2 nuv = vUv;

    // nuv += (fluid.xy * 0.00001);
    nuv += step(0.2, fluid.z) * 0.03;

    float value = texture2D(tLines, nuv * vec2(1.0 * uLinesTile, 4.0) + vec2(-steppedTime * 0.05, -steppedTime * 0.3)).r;
    float n1 = texture2D(tNoise, nuv + vec2(-steppedTime * 0.05, steppedTime * 0.02) + fluid.z).r;
    float n2 = texture2D(tNoise, nuv * 1.0 * uLinesTile + vec2(steppedTime * 0.025, steppedTime * 0.025)).r;

    // n1 += fluid.z * 0.2;
    // n2 -= fluid.z * 0.2;

    fluid.z *= 0.1 + sin(steppedTime + n1 * 3.0) * 0.5 + 0.5;
    fluid.z *= n2;

    value += fluid.z * 0.1;
    value += pow(n1, 5.0);
    value += pow(n2, 5.0) * 0.5;
    value += smoothstep(0.65, 1.0, nuv.x);
    value = aastep(0.35 + uStep + fluid.z * 0.1, value);
    vec3 color = mix(uColor2, uColor1, value - fluid.z * 0.2);

    color = mix(color, color * 0.86, step(0.9, sin(fluid.z * 4.0)));

    // color.r = pow(color.r, 1.0 - fluid.z * 0.3);

    // color += 0.2;

    // float fluidMask = smoothstep(0.9, 1.0, texture2D(tFluidMask, screenUv).r);
    // color.r += (n1 + n2) * fluidMask * 0.2;


    // alpha
    float alpha = 1.0;
    alpha *= smoothstep(1.0, 0.7, vUv.x);
    alpha += pow(n2, 2.0) * smoothstep(1.0, 0.8 - fluid.z * 0.5, vUv.x);
    alpha = clamp(alpha, 0.0, 1.0);
    color *= aastep(0.55, alpha);

    // color = mix(1.0 - color, color, 1.0 - fluidMask);

    // color += step(0.4, fluidMask);

    // vec3 oColor = color;

    alpha = aastep(0.5, alpha);
    // alpha += fluidMask;

    gl_FragColor = vec4(color, alpha);
}{@}CathedralBackgroundShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    // keep alive animation
    // float mask = smoothstep(-0.2, 0.3, position.y);
    // pos = rotation3d(vec3(1.0, 0.0, 0.5), (2.5 + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2)) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    // lines
    vec2 lineUv = vUv.yx * uLinesTile;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;

    // lighting
    float grad = 1.0 - clamp(length(vUv - 0.5) * 2.0, 0.0, 1.0);
    float absx = abs(vPos.x);
    grad = mix(grad, smoothstep(0.0, 0.1 + (absx - absx * 0.5) * 2.0, grad), 0.6);
    grad *= smoothstep(0.95, 0.3, vUv.y);

    // final composite
    float value = lines + noise * pow(grad, 2.0);
    value += (grad * 2.0 - 1.0) * 0.5;
    value = aastep(0.5, value);

    vec3 color = vec3(value);
    color *= uColor;
    color = max(vec3(18.0 / 255.0), color);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}CathedralFloorShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    // keep alive animation
    // float mask = smoothstep(-0.2, 0.3, position.y);
    // pos = rotation3d(vec3(1.0, 0.0, 0.5), (2.5 + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2)) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    // vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vUv.yx * uLinesTile;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r;
    // // lines -= texture2D(tNoise, lineUv.yx * vec2(1.0, 0.05)).r * 0.5;

    // // lighting
    // float verticalGrad = smoothstep(uVerticalGrad.x, uVerticalGrad.y, vPos.y);
    // float lighting = vUv.y;
    // float lightMask = max(0.0, lighting);
    // float terminatormid = aastep(uThreshold.x, lighting + lines * 0.3 - vAo - verticalGrad);
    // float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1 - vAo - verticalGrad);

    // // reduce lines in areas of brightness
    // float maskedLines = lines;

    // // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, vUv * 3.2 - vec2(steppedTime * 0.2, -steppedTime)).r;
    float noise2 = texture2D(tNoise, vUv * 1.5 - vec2(-steppedTime * 0.3, steppedTime)).r;
    // maskedLines -= noise * lightMask * 1.0;
    // maskedLines *= 1.0 - clamp(length(vUv - 0.5) * 1.0, 0.0, 1.0);
    // maskedLines *= smoothstep(0.95, 0.3, vUv.y);
    // maskedLines = aastep(0.5, maskedLines);

    // // compositing;
    // vec3 color = uColorHighlight;
    // color *= maskedLines;

    // color = max(vec3(18.0 / 255.0), color);

    float tile = 120.0;
    float value = sin(vUv.y * tile * 0.5) * 0.5 + 0.5;
    value = min(value, sin(vUv.x * tile) * 0.5 + 0.5);
    // value += 0.1;
    value += noise * 0.015;
    value += noise2 * 0.02;
    // value -= lines * 0.5;
    value = aastep(0.05, 1.0 - pow(1.0 - value, 2.0));

    float lineTexture = lines + noise * 0.75;
    value *= aastep(0.4, lineTexture * (1.0 - clamp(length(vUv - 0.5) * 1.5, 0.0, 1.0)));

    vec3 color = uColorHighlight * value;
    color = max(vec3(18.0 / 255.0), color);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}FloatingFrameEyesShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float colorid;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
// uniform float uAspectRatio;
uniform float uTransition;
uniform float uDPR;
uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec3 uColor;


#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vIrisMask;
varying float vBackground;
varying vec3 vNdc;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vIrisMask = step(0.5, colorid);
    vUv = uv;
    vUv2 = uv2;
    vPos = position;
    vNormal = normalize(normalMatrix * normal);
    vLineUv = (rotation3d(normalize(vec3(0.0, 0.0, 1.0)), 1.57) * position).xy;
    vLightDir = normalize(uLightDir);

    vec3 pos = position;

    // pos = rotation3d(vec3(1.0, 0.0, 0.5), sin(floor(time * 8.0) * 0.5 + position.x * 1.0 - position.z * 2.0) * 0.03) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdc = gl_Position.xyz / gl_Position.w;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = uPoint1;
    vec3 pos2 = uPoint2;
    vec3 pos3 = uPoint3;
    vec3 pos4 = uPoint4;

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;
    sdfx += edgeNoise * 0.0005;
    sdfy += edgeNoise * 0.0005;
    float sdf = max(sdfx, sdfy);
    sdf * aspect;

    // float dx = dFdx(vNdc.x);
    // float dy = dFdy(vNdc.y);

    // float verticalRatio = resolution.y / resolution.x;
    // float horizontalRatio = resolution.x / resolution.y;
    
    // float width = 0.0025;
    // float outline = aastep(width, -sdf);
    // outline *= aastep(width, -sdfy);

    // float widthX = 0.002;
    // float widthY = 0.002 * uAspectRatio;
    // float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);
    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.005) discard;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= steppedTime * 3.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // trim texture
    vec2 displacement = vec2(sin(vPos.y * 20.0 + floor(time * 6.0) * 1.5), 0.0);
    float atlas = texture2D(tAtlas, vUv + displacement * 0.0003).r;
    atlas += (lines) * 0.15;
    atlas = aastep(0.25, atlas);

    // trim texture
    float trim = texture2D(tTrim, vUv2).r;
    trim = aastep(0.55, trim);

    // lighting
    vec3 lightDir = vLightDir;
    float lighting = dot(normal, lightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.1, lighting + lines * 0.3);
    float terminatorhigh = aastep(0.9, lighting + lines * 0.075);
    float terminatorbounce = 1.0 - aastep(-0.91, lighting * 0.2 - lines * 0.2);

    // reduce lines in areas of brightness
    float maskedLines = lines;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;
    maskedLines += pow(1.0 - (vPos.y * 0.5 + 0.4), 2.0);
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color *= maskedLines;
    color = mix(color, vec3(1.0), terminatorbounce);
    color *= atlas;
    color *= mix(vec3(1.0), uColor, vIrisMask);

    vec3 backgroundColor = vec3(58.0) / 255.0;
    color *= outline;

    float alpha = 1.0 - aastep(0.0025, sdf);

    color = max(vec3(18.0 / 255.0), color);

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.3;
}{@}GlassLiquidPBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform vec3 uColorDark;
uniform vec3 uColor2;
uniform vec3 uColor2Dark;
uniform float uTransition;
uniform sampler2D tRefraction;
uniform sampler2D tNoise;
uniform float uMultiplier;
uniform float uOpacity;
uniform float uFillAmount;
uniform vec3 uObjectPosition;
uniform float uWobbleX;
uniform float uWobbleZ;
uniform vec2 uRefractionStrength;

#!VARYINGS
varying vec3 vWorldPosition;
varying vec3 vLocalPosition;
varying vec3 vFoamPosition;
#!SHADER: Vertex

#require(pbr.vs)

mat3 rotateAboutAxis(vec3 axis, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    return mat3(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c);
}

void main() {
    vec3 pos = position;
    setupPBR(position);
    vWorldPosition = (modelMatrix * vec4(pos, 1.0)).xyz;
    vFoamPosition = vWorldPosition - uObjectPosition;
    mat3 wobbleZMatrix = rotateAboutAxis(vec3(0.0, 0.0, 1.0), 0.05 * uWobbleZ);
    mat3 wobbleXMatrix = rotateAboutAxis(vec3(1.0, 0.0, 0.0), 0.05 * uWobbleX);
    mat3 wobble = wobbleZMatrix * wobbleXMatrix;
    vFoamPosition = wobble * vFoamPosition;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(pbr.fs)

float lodweight(float t, float log2radius, float gamma) {
    return exp(-gamma * pow(log2radius - t, 2.));
}

float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

vec4 lodBlur(sampler2D tMap, vec2 uv, float radius, float gamma) {
    vec4 pix = vec4(0.);
    float norm = 0.;
	//weighted integration over mipmap levels
    for(float i = 0.; i < 10.; i += 0.5) {
        float k = lodweight(i, log2(radius), gamma);
        pix += k * textureLod(tMap, uv, i);
        norm += k;
    }
	//nomalize, and a bit of brigtness hacking
    return pix * pow(norm, -0.99);
}

void main() {
    // PBR Config
    // this is the default config that can be tweaked
    PBRConfig baseConfig;
    baseConfig.clearcoat = 1.0;
    baseConfig.reflection = 1.0;
    baseConfig.color = vec3(1.0, 1.0, 1.0);

    vec2 screenUv = (gl_FragCoord.xy / resolution.xy);
    vec3 refractedDir = refract(-normalize(vV), normalize(vWorldNormal), 1.0 / 1.5);
    vec2 bluenoise = texture2D(tNoise, screenUv * 10.0).xy * 2.0 - 1.0;
    float refraction = texture(tRefraction, screenUv).r;

    vec3 pbr = getPBR(vec3(1.0, 1.0, 1.0), baseConfig).rgb;

    float fresnel = getFresnel(vWorldNormal, vV, 4.0);

    float progress = smoothstep(uTransition - 0.01, uTransition, vFoamPosition.y * 0.5 + 0.1);
    vec3 color = mix(uColor, uColor2, 1.0 - progress);
    vec3 colorDark = mix(uColorDark, uColor2Dark, 1.0 - progress);

    vec3 col = mix(color, colorDark, refraction) * (uRefractionStrength.y + (1.0 - refraction) * uRefractionStrength.x);

    col *= uMultiplier;

    if(!gl_FrontFacing) {
        col = col * 1.05;
    }

    gl_FragColor = vec4(col, 1.0 * uOpacity);

    // foam edge
    vec3 foamPosition = vFoamPosition;

    float waveFrequency = 5.0;
    float foamWave = ((foamPosition.x * waveFrequency) + (foamPosition.z * waveFrequency)) + (time * 1.2);
    foamWave = sin(foamWave) * 0.025;
    foamPosition.y += foamWave * (uWobbleX + uWobbleZ);

    float foam = smoothstep(uFillAmount, uFillAmount - 0.005, foamPosition.y + 0.075);

    //gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb * 1.05, 1.0 - foam);

    // Use local position so the liquid moves with the parent
    if(foamPosition.y - uFillAmount > 0.0) {
        discard;
    }
}{@}GlassShader.glsl{@}#!ATTRIBUTES
attribute float ao;
attribute float thickness;

#!UNIFORMS
uniform sampler2D tText;
uniform sampler2D tEnvDiffuse;
uniform sampler2D tEnvSpecular;
uniform float uOpacity;

#!VARYINGS
varying vec2 vUv;
varying float vThickness;
varying float vAo;
varying vec3 viewDir;
varying vec3 vNormal;
varying vec3 vPosition;
varying vec3 vWorldPosition;

#!SHADER: Vertex
void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

  vWorldPosition = vec3(modelMatrix * vec4(position, 1.0));
  viewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
  vNormal = normalize(normalMatrix * normal);
  vUv = uv;
  vThickness = thickness;
  vAo = ao;
  vPosition = position;
}

#!SHADER: Fragment
float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

vec4 getRGB(sampler2D tDiffuse, vec2 uv, float angle, float amount) {
    vec2 offset = vec2(cos(angle), sin(angle)) * amount;
    vec4 r = texture2D(tDiffuse, uv + offset);
    vec4 g = texture2D(tDiffuse, uv);
    vec4 b = texture2D(tDiffuse, uv - offset);
    return vec4(r.r, g.g, b.b, g.a);
}

vec4 blur(sampler2D tDiffuse, vec2 uv, float sampleDist, float strength) {
    float samples[6];
    samples[0] = -0.08;
    samples[1] = -0.03;
    samples[2] = -0.01;
    samples[3] =  0.01;
    samples[4] =  0.03;
    samples[5] =  0.08;

    vec2 dir = normalize(0.5 - uv);
    vec4 texel = texture2D(tDiffuse, uv);
    vec4 sum = texel;

    for (int i = 0; i < 6; i++) {
        sum += texture2D(tDiffuse, uv + (dir * samples[i] * sampleDist * strength));
    }

    sum /= 6.0;
    return sum;
}

const vec2 INV_ATAN = vec2(0.1591, 0.3183);
const float LN2 = 0.6931472;
const float ENV_LODS = 7.0;

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 fresnelSphericalGaussianRoughness(float cosTheta, vec3 F0, float roughness) {
	return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(2.0, (-5.55473 * cosTheta - 6.98316) * cosTheta);
}

vec2 sampleSphericalMap(vec3 v)
{
    vec2 uv = vec2(atan(v.z, v.x), asin(v.y));
    uv *= INV_ATAN;
    uv += 0.5;

    // match default C4D baked HDRI
    uv.x = fract(uv.x + 0.25 + 0.0 + 0.8 - 0.1);

    return uv;
}

vec4 SRGBtoLinear(vec4 srgb) {
    vec3 linOut = pow(srgb.xyz, vec3(2.2));
    return vec4(linOut, srgb.w);
}

vec3 linearToSRGB(vec3 color) {
    return pow(color, vec3(0.4545454545454545));
}

vec4 RGBMToLinear(vec4 value) {
    float maxRange = 6.0;
    return vec4(value.xyz * value.w * maxRange, 1.0);
}

vec4 autoToLinear(vec4 texel, float uHDR) {
    vec4 color = RGBMToLinear(texel);
    if (uHDR == 0.0) { color = SRGBtoLinear(texel); }
    return color;
}

void main() {
  float fresnel = getFresnel(vNormal, viewDir, 1.0);
  vec2 screenUv = (gl_FragCoord.xy / resolution.xy);

  float ior = 1.0 / 1.0;

  float refractAmount = smoothstep(0.08, 0.15, vPosition.y);

  vec3 refractedDir = refract(viewDir, vNormal, 0.7);

  screenUv += refractedDir.xy * (1.0 - refractAmount);
  vec4 textColor = blur(tText, screenUv, 0.2, 0.2);
  textColor.rgb = mix(vec3(1.0), vec3(0.5), textColor.r);
  vec3 baseColor = vec3(0.0);

  float alpha = 1.0;

  vec3 finalColor = mix(baseColor, textColor.rgb, 0.53);
  vec3 lightDir = normalize(vec3(1.0, 1.0, 0.1));
  vec3 diffuse = max(0.0, dot(vNormal, lightDir)) * vec3(1.0);

  alpha -= clamp(refractAmount, 0.0, 0.15) * 6.0 * (1.0 - fresnel);

  vec2 diffuseUV = sampleSphericalMap(vNormal);
  vec3 envSpecular = texture2D(tEnvSpecular, diffuseUV).rgb;
  finalColor += envSpecular * 3.0;
  finalColor -= diffuse * 0.615;
  finalColor += fresnel * 1.;

 
  gl_FragColor = vec4(finalColor.rgb, alpha * uOpacity);


  //gl_FragColor = vec4(vec3(smoothstep(0.08, 0.13, vPosition.y)), 1.0);
}{@}TestShaderMasked.glsl{@}#!ATTRIBUTES
attribute float rowIndex;
attribute float quadIndex;
attribute float rowCount;

#!UNIFORMS
uniform sampler2D tMSDF;
uniform float uTranslateIn;
uniform vec3 uColor;
uniform vec2 uBoundsX;
uniform mat4 uFixedCameraMatrix;
uniform float uFixed;
uniform float uWhiteBits;
uniform float uRowCount;
uniform float uOffset;
uniform float uStaggerAmount;

#!VARYINGS
varying vec3 vNormal;
varying vec2 vUv;

varying float vRowIndex;
varying float vQuadIndex;
varying float vRowCount;
varying vec3 vWorldPos;
varying float vT;
varying float vOT;

#!SHADER: TextShaderMasked.vs
#require(range.glsl)
#require(eases.glsl)
#require(transformUV.glsl)

void main() {
    vec3 pos = position;
    vRowIndex = rowIndex;
    vQuadIndex = quadIndex;
    vRowCount = rowCount;
    vUv = uv;
    vNormal = normalMatrix * normal;

    float quadIndex = vQuadIndex / vRowCount;

    float offsetAmount = uOffset;

    offsetAmount *= (quadIndex * 2.0 - 1.0);

    float staggerAmount = uStaggerAmount;
    float charTime = (rowIndex / uRowCount) * staggerAmount;
    float t = clamp((uTranslateIn - charTime) / (1.0 - staggerAmount), 0.0, 1.0);
    t = smoothstep(0.0, 1.0, t);
    vT = expoOut(t * 4.0);
    vOT = expoOut(t * 4.0);
    t = expoOut(t);


    pos.x += (1.0 - t) * offsetAmount;

    vWorldPos = (modelMatrix * vec4(pos, 1.0)).xyz;

    if (uFixed > 0.5) {
        pos.y += 0.15;
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(pos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }
}


#!SHADER: TextShaderMasked.fs

#require(aastep.glsl)
#require(eases.glsl)
#require(msdf.glsl)

void main() {
    if(vWorldPos.x < uBoundsX.x || vWorldPos.x > uBoundsX.y) discard;
        vec3 tex = texture2D(tMSDF, vUv).rgb;
    float sdf = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float d = fwidth(sdf);
    float padding = 1.0 - vT;
    float alpha = smoothstep(-d + padding, d + padding, sdf);
    gl_FragColor = vec4(uColor, alpha * vOT);
}{@}TextAnimatedShader.glsl{@}#!ATTRIBUTES
attribute float rowIndex;
attribute float quadIndex;
attribute float rowCount;

#!UNIFORMS
uniform sampler2D tMSDF;
uniform float uTranslateIn;
uniform vec3 uColor;
uniform vec2 uBoundsX;
uniform mat4 uFixedCameraMatrix;
uniform float uFixed;
uniform float uWhiteBits;
uniform float uRowCount;
uniform float uOffset;
uniform float uStaggerAmount;

#!VARYINGS
varying vec3 vNormal;
varying vec2 vUv;

varying float vRowIndex;
varying float vQuadIndex;
varying float vRowCount;
varying vec3 vWorldPos;
varying float vT;

#!SHADER: TextAnimatedShader.vs
#require(range.glsl)
#require(eases.glsl)
#require(transformUV.glsl)

void main() {
    vec3 pos = position;
    vRowIndex = rowIndex;
    vQuadIndex = quadIndex;
    vRowCount = rowCount;
    vUv = uv;
    vNormal = normalMatrix * normal;

    float quadIndex = vQuadIndex / vRowCount;

    float offsetAmount = uOffset;
    float staggerAmount = uStaggerAmount;
    offsetAmount *= (quadIndex * 2.0 - 1.0);

    float charTime = (rowIndex / uRowCount) * staggerAmount;
    float t = clamp((uTranslateIn - charTime) / (1.0 - staggerAmount), 0.0, 1.0);
    t = smoothstep(0., 1.0, t);
    float t2 = t;
    vT = expoOut(t * 4.0);
    t = expoOut(t);

    
    if (uWhiteBits > 0.5) {
        float useWhiteRight = step(vUv.y, 0.5) * (step(0.94, vUv.x));
        float useWhiteLeft = step(vUv.y, 0.5) * (step(vUv.x, 0.06));
        float t3 = expoInOut(t2);
        pos.x *= mix(1.0, 2.0 - t3, useWhiteRight);
        pos.x *= mix(1.0,  2.0 - t3, useWhiteLeft);
        pos.x -= mix(0.0, 1.0 - t3, useWhiteRight);
        pos.x += mix(0.0, 1.0 - t3, useWhiteLeft);
        t = mix(t, expoOut(t2), useWhiteRight + useWhiteLeft);
        vT = mix(vT, expoOut(t2 * 2.0), useWhiteRight + useWhiteLeft);
    }

    pos.x += (1.0 - t) * offsetAmount;

    vWorldPos = (modelMatrix * vec4(pos, 1.0)).xyz;

    if (uFixed > 0.5) {
        pos.y += 0.15;
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(pos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }
}

#!SHADER: TextAnimatedShader.fs

#require(aastep.glsl)
#require(eases.glsl)
#require(msdf.glsl)

void main() {
    vec3 tex = texture2D(tMSDF, vUv).rgb;
    float sdf = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float d = fwidth(sdf);
    float padding = 1.0 - vT;
    float alpha = smoothstep(-d + padding, d + padding, sdf);

    vec3 color = uColor;

    if (uWhiteBits > 0.5) {
        float useWhite = step(vUv.y, 0.5) * (step(vUv.x, 0.06) + step(0.94, vUv.x));

        color = mix(color, vec3(1.0), useWhite);
    }

    gl_FragColor = vec4(color, alpha * vT);

    // gl_FragColor = vec4(vQuadIndex / vRowCount);
}{@}kawaseblur.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uStep;
uniform float uBlit;
uniform float uBlurAmount;
uniform sampler2D tNoise;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
    vUv = uv;
}

    #!SHADER: Fragment
void main() {

    if(uBlit > 0.5) {
        vec4 col = texture2D(tMap, vUv);
        col.xyz = smoothstep(0.05, 1.0, col.xyz);
        gl_FragColor = col;
    } else {
        vec2 texelSize = 1.0 / resolution.xy;
        vec2 stp = (texelSize * (uStep * 0.35)) + (texelSize * 0.5);
        vec2 noise = (texture2D(tNoise, vUv * 1.0).xy * 2.0 - 1.0) * 0.001;
        vec4 tL = texture2D(tMap, vUv + vec2(-stp.x, stp.y) + noise);
        vec4 tR = texture2D(tMap, vUv + vec2(stp.x, stp.y) + noise);
        vec4 bL = texture2D(tMap, vUv + vec2(-stp.x, -stp.y) + noise);
        vec4 bR = texture2D(tMap, vUv + vec2(stp.x, -stp.y) + noise);
        gl_FragColor = (tL + tR + bL + bR)*0.25;
    }

}{@}ColosseumFloatingRockShader.glsl{@}#!ATTRIBUTES
attribute float colorid;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uAngleAccum;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec3 uRotationAxis;
uniform vec3 uRotationParams;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vInverseHull;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vPos = position;
    vInverseHull = step(0.5, colorid);

    vec3 pos = position;

    float steppedTime = floor(time * 8.0) / 8.0;
    mat3 rotMatrix = rotation3d(uRotationAxis, steppedTime * uRotationParams.x + uRotationParams.y + uAngleAccum * sign(uRotationParams.x));
    pos = rotMatrix * pos;
    vNormal = normalize(normalMatrix * rotMatrix * normal);

    pos.y += sin(steppedTime + uRotationParams.y * 10.0) * 0.4;

    // inverse hull is bundled with geo
    vec4 projectionPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec4 projectionNormal = projectionMatrix * modelViewMatrix * vec4(vNormal, 0.0);
    float outlineWidth = 0.005;
    projectionPos.xy += projectionNormal.xy * outlineWidth * sqrt(projectionPos.w) * 2.0 * vInverseHull;

    gl_Position = projectionPos;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vUv * 3.0 * uLinesTile;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask;
    maskedLines = aastep(0.2, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), vec3(1.0), terminatormid);
    // color = mix(color, uColorHighlight, terminatorhigh);
    color *= maskedLines;

    color *= mix(1.0, 0.0, vInverseHull);

    color = max(vec3(18.0 / 255.0), color);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}ColosseumFloorShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    // keep alive animation
    // float mask = smoothstep(-0.2, 0.3, position.y);
    // pos = rotation3d(vec3(1.0, 0.0, 0.5), (2.5 + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2)) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    // if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    // lines
    float textureBlend = abs(dot(normalize(vNormal), vec3(0.0, 0.0, 1.0)));
    // vec2 lineUv = mix(vPos.zx, vPos.yx, uvBlend) * uLinesTile * 0.025;
    vec2 lineUv1 = vPos.zx * uLinesTile * 0.025;
    vec2 lineUv2 = vPos.yx * uLinesTile * 0.025;
    lineUv1.x += steppedTime * 2.0;
    lineUv2.x += steppedTime * 2.0;

    // tiles
    vec2 tileUv = vec2(abs(fract(vUv * 17.0 * vec2(1.0, 0.15) + 0.5 + vec2(0.0, 0.25)) - 0.5));
    float noise2 = texture2D(tNoise, vUv * 1.5 - vec2(steppedTime * 0.1, -steppedTime * 0.5)).r;
    noise2 = smoothstep(0.5, 1.0, noise2);
    // float tiles = max(aastep(0.485, tileUv.x - noise2 * 0.125 - smoothstep(0.9, 1.0, vUv.y)), aastep(0.485, tileUv.y - noise2 * 0.5));
    float tiles = aastep(0.49, tileUv.x - noise2 * 0.125 - smoothstep(0.9, 1.0, vUv.y));
    tiles += aastep(0.497, tileUv.y - noise2 * 0.125);
    tiles = 1.0 - tiles;

    // lines
    float lines = texture2D(tLines, lineUv1.yx).r;
    lines = mix(lines, texture2D(tLines, lineUv2.yx).r, textureBlend);
    float noise = texture2D(tNoise, lineUv1 * 2.0).r;
    noise = mix(noise, texture2D(tNoise, lineUv2 * 2.0).r, textureBlend);
    float lightMask = pow(1.0 - vUv.y, 4.0);
    float maskedLines = lines + lightMask;
    maskedLines += noise * lightMask;
    maskedLines = aastep(0.25, maskedLines);

    // lighting
    float lighting = dot(normalize(vNormal), vec3(0.0, 1.0, 0.0)) * 0.5 + 0.4;
    lighting += lines * 0.4;
    lighting = aastep(0.4, lighting);

    // compositing
    float value = 0.0;
    value = maskedLines;
    value *= tiles;
    value *= lighting;

    vec3 color = vec3(max(18.0/255.0, value));

    float alpha = 1.0;
    
    gl_FragColor = vec4(color, alpha);
}{@}ColosseumRockShadowShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;
varying float vScale;

#!SHADER: Vertex

void main() {
    vUv = uv;

    vec3 pos = position;

    // extract x scale from model matrix
    vScale = length(modelMatrix[0].xyz);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    vec2 uv = vUv;
    uv.x *= vScale;

    float steppedTime = floor(time * 8.0) / 8.0;
    float lines = texture2D(tNoise, uv.xy * 1.0 + vec2(0.0, steppedTime * 0.1)).r;

    float edgeGrad = 1.0 - smoothstep(1.0, 0.1, abs(vUv.x - 0.5) * 2.0);
    float verticalGrad = 1.0 - vUv.y;

    float cloudNoise = texture2D(tMap, uv * 0.05).r;
    cloudNoise -= texture2D(tMap, uv * 0.2).r * 0.5;

    float value = max(verticalGrad, edgeGrad) + cloudNoise * 0.5 - lines * 0.005;
    value = aastep(0.99, value);

    vec3 nearBlack = vec3(18.0/255.0);
    vec3 color = vec3(nearBlack);

    float alpha = 1.0 - value;
    
    gl_FragColor = vec4(color, alpha);
}{@}ColosseumTitleShader.glsl{@}#!ATTRIBUTES
attribute float charindex;
attribute float charsperline;
attribute float row;

#!UNIFORMS
uniform sampler2D tOpacity;
uniform sampler2D tLines;
uniform sampler2D tDistance;
uniform sampler2D tNoise;
uniform float uScreenHeightWorld;
uniform float uProgress;
uniform float uMaxWidth;
uniform float uDPR;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uScale;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vOffset;
varying float vProgress;
varying float vProgress2;
varying float vNdcHeight;

#!SHADER: Vertex

float qinticInOut(float t) {
    return t < 0.5
        ? + 16.0 * pow(t, 5.0)
        : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float quarticInOut(float t) {
    return t < 0.5
        ? +8.0 * pow(t, 4.0)
        : -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

float exponentialInOut(float t) {
    return t == 0.0 || t == 1.0
        ? t
        : t < 0.5
        ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
        : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float cubicInOut(float t) {
    return t < 0.5
        ? 4.0 * t * t * t
        : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

void main() {
    float t = uProgress;

    // temp while testing
    // t = fract(t);

    // row time offset
    float rowOffset = row * 0.5;

    // individual character time offset
    vOffset = abs((charindex + 1.0) / charsperline - 0.5) * 2.0;
    vOffset *= 0.5;
    vOffset += rowOffset * 0.5;

    // is char on left or right
    float charsign = sign(charindex - charsperline * 0.5);

    // specific timing for top row ('the')
    if (row < 0.1) {
        vOffset = abs(charindex - 1.0) * 0.1 + 0.35;
        charsign = sign(charindex - 1.0);
    }

    // progress value with no character offset
    float flatProgress = clamp((t - 0.25) * 0.7, 0.0, 1.0);

    // animation with character offset
    float overlap = 0.5;
    vProgress = clamp((t) * (1.0 + overlap) - vOffset * overlap, 0.0, 1.0);

    float rowDelay = 0.125;

    if (row < 0.1) {
        rowDelay = 0.32;
    }

    // animation with row offset
    vProgress2 = clamp((t - rowDelay) * (1.0 + overlap) - rowOffset * overlap * 0.6, 0.0, 1.0);

    // move characters from outwards, in
    vec3 pos = position;
    float xDistance = 0.25;
    pos.x += exponentialInOut(1.0 - vProgress) * xDistance * charsign;

    // animate rows vertically
    float yDistance = row < 0.1 ? - 0.1 : 0.15;
    pos.y -= exponentialInOut(1.0 - vProgress2) * yDistance;

    // animate entire block of text on z axis
    pos.z += ((1.0 - pow(1.0 - flatProgress, 4.0)));

    pos.z += vOffset * 0.002;

    // pos.z = 0.95;

    // scale to fit screen
    float aspect = resolution.x / resolution.y;
    float width = uScreenHeightWorld * aspect;
    float resx = resolution.x / uDPR;
    float widthClamped = uScreenHeightWorld * (uMaxWidth / resx) * aspect;
    float blend = resx < uMaxWidth ? 1.0 : 0.0;
    width = mix(widthClamped, width, blend);
    float padPercent = resx < 760.0 ? 0.05 : 0.43;
    pos *= width * (0.5 - padPercent * 0.5);

    // pos *= uScale;

    vUv = uv;
    vPos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float cubicInOut(float t) {
    return t < 0.5
        ? 4.0 * t * t * t
        : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float quarticInOut(float t) {
    return t < 0.5
        ? +8.0 * pow(t, 4.0)
        : -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

float exponentialOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    vec2 uv = vUv;

    float steppedTime = floor(time * 6.0) / 6.0;
    vec2 displacement = texture2D(tNoise, vUv * 3.0 + steppedTime).rg * 2.0 - 1.0;
    uv += displacement * 0.00175;

    vec3 color = vec3(1.0);

    float opacity = texture2D(tOpacity, uv).r;
    float dist = texture2D(tDistance, uv).r;

    float ease = clamp(1.0 - cubicInOut(vProgress), 0.0, 1.0);
    float maskin = smoothstep(ease - 0.1, ease + 0.1, dist - 0.1);
    float mask = aastep(0.5, opacity);

    mask *= maskin;

    float alpha = mask;

    gl_FragColor = vec4(color, alpha);
}{@}DrinkPourBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform vec3 uColor;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vNdcHeight;
varying float vAspect;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vUv = uv;
    vPos = position;

    float aspect = resolution.y / resolution.x;
    vPos.x *= aspect;
    // vPos.x *= 2.0;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vAspect = resolution.x / resolution.y;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0 + 0.05) discard;

        vec3 color = uColor;

    gl_FragColor = vec4(color, 1.0);
}{@}DrinkPourBottleShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uDistanceCompensation;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec3 uVelocity;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uWaterLineOffset;
uniform float uPourStrength;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying vec3 vWorldPos;
varying float vHeight;
varying float vDistance;
varying float vNdcHeight;
varying vec3 vLightDir;
varying vec3 vTranslation;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vTranslation = modelMatrix[3].xyz;
    vUv = uv;
    vNormal = normalMatrix * normal;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;
    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * modelViewPos;

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vDistance = -modelViewPos.z;
    vWorldPos = (modelMatrix * vec4(position, 1.0)).xyz;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    // if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float steppedTime2 = floor(time * 18.0) / 18.0 * 0.15;

    vec3 normal = normalize(vNormal);

    // texture

    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    vec2 lineUvDistanceCompensated = lineUv * mix(2.0, 0.5, pow(clamp(vDistance * 0.0325, 0.0, 1.0), 2.0)) * 0.5;
    lineUv = mix(lineUv, lineUvDistanceCompensated, uDistanceCompensation);
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask * 0.3;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask + lighting * 0.3;
    maskedLines = aastep(0.3, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), vec3(1.0), terminatormid);
    color *= maskedLines;

    // texture
    float tex = texture2D(tMap, vUv).r;
    color *= aastep(0.5, tex);

    // liquid
    vec3 liquidColor = uColor;
    float liquidMask = 1.0 - step(0.2, vUv.y);
    float waterLine = vTranslation.y - vWorldPos.y + uWaterLineOffset + vPos.y;
    float speed = pow(min(0.03, length(uVelocity)) * 30.0, 5.0);
    waterLine += texture2D(tNoise, vWorldPos.xy * 0.1 + vec2(-steppedTime2 * 3.5, 0.0)).r * max(0.75, uPourStrength * 1.25) * 0.125;
    waterLine = aastep(0.0, waterLine);
    liquidMask *= waterLine;
    color *= mix(vec3(1.0), liquidColor, liquidMask);

    color = max(vec3(18.0 / 255.0), color);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}DrinkPourGlassShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uDistanceCompensation;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vDistance;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;
    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * modelViewPos;

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vDistance = -modelViewPos.z;
    
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    // if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    vec2 lineUvDistanceCompensated = lineUv * mix(2.0, 0.5, pow(clamp(vDistance * 0.0325, 0.0, 1.0), 2.0)) * 0.5;
    lineUv = mix(lineUv, lineUvDistanceCompensated, uDistanceCompensation);
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float verticalGrad = smoothstep(uVerticalGrad.x, uVerticalGrad.y, vPos.y);
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45 - vAo * 0.15 - verticalGrad);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1 - vAo * 0.15 - verticalGrad);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask + lighting * 0.3;
    maskedLines = aastep(0.2, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), uColor, terminatormid);
    color = mix(color, uColorHighlight, terminatorhigh);
    color *= maskedLines;

    float alpha = 1.0 - color.r;
    alpha += aastep(0.158, vPos.y + vPos.x * 0.032 - noise * 0.001);
    alpha += 1.0 - aastep(0.158, vPos.y + 0.1565 + vPos.x * 0.04 - noise * 0.0005);
    color = vec3(18.0 / 255.0);

    gl_FragColor = vec4(color, alpha);
}{@}FloatingFrameDrinkShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
uniform vec3 uCenter;
uniform float uTransition;
// uniform float uAspectRatio;
uniform float uDPR;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uDrinkColor;
uniform float uHover;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vBackground;
varying float vFloor;
varying vec3 vNdc;
varying vec3 vPos;
varying vec3 vViewPos;
varying vec3 vLightDir;

#!SHADER: Vertex

#require(skinning.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vPos = position;
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalMatrix * normal;
    vLightDir = vec3(-0.4, 0.2, 1.2);
    vLineUv = (rotation3d(normalize(vec3(-0.25, 0.0, 1.0)), 1.0) * position).xy * 5.0;
    vBackground = position.x < 0.9 ? 0.0 : 1.0;
    vLineUv = mix(vLineUv, vUv * 8.0, vBackground);

    vec3 pos = position;
    applySkin(pos, vNormal);

    pos.z -= 0.1;

    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    vViewPos = -modelViewPos.xyz;

    gl_Position = projectionMatrix * modelViewPos;

    vNdc = gl_Position.xyz / gl_Position.w;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    float transition = uTransition + 0.01;
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = mix(uCenter, uPoint1, transition);
    vec3 pos2 = mix(uCenter, uPoint2, transition);
    vec3 pos3 = mix(uCenter, uPoint3, transition);
    vec3 pos4 = mix(uCenter, uPoint4, transition);

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;

    edgeNoise -= uHover * 100.0;

    sdfx += edgeNoise * 0.0002 * transition;
    sdfy += edgeNoise * 0.0002 * transition;
    float sdf = max(sdfx, sdfy);
    sdf *= aspect;

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);

    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.005) discard;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv.yx;
    lineUv.x -= steppedTime * 1.0;

    float lines = texture2D(tLines, lineUv.yx * (0.7 - vBackground * 0.1)).r * 2.0 - 1.0;

    // trim texture
    float atlas = texture2D(tAtlas, vUv2).r;
    atlas = aastep(0.55, atlas);

    // trim texture
    vec4 trimData = texture2D(tTrim, vUv);
    if (trimData.a + vBackground < 0.2) discard;
    float trim = trimData.r;
    trim = aastep(0.55, trim * atlas);

    // lighting
    vec3 lightDir = vLightDir;
    float lighting = dot(normal, lightDir) * 0.5 + 0.5;
    lighting = pow(lighting - 0.1, 2.0);
    lighting *= vPos.y * 2.0 - 2.25;

    // compositing
    float skinMask = step(0.55, vUv2.y);
    float fresnel = max(0.0, dot(normalize(vNormal), normalize(vViewPos)));
    fresnel = (1.0 - fresnel) * skinMask;
    vec3 nearBlack = vec3(18.0 / 255.0);
    vec3 backgroundColor = mix(uColor1, nearBlack, aastep(0.1, -vPos.y * 2.1 - 0.8 + lines * 0.75));
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    float value = aastep(0.5, lighting + lines + noise * lighting - fresnel);
    vec3 color = mix(mix(uColor2, backgroundColor, step(0.5, vBackground)), vec3(1.0), skinMask);
    color *= mix(trim, 1.0, vBackground);

    // for DrinkPour scene: drink uvs are stored in very top right of uv2 map, 
    // so we can mask them without needing more attributes
    float drinkMask = min(step(0.98, vUv2.x), step(0.98, vUv2.y));
    drinkMask *= step(1.6, vPos.y);
    drinkMask *= 1.0 - step(1.725, vPos.y);
    color = mix(color, uDrinkColor, drinkMask);

    // frame outline
    color *= value;
    color *= outline;

    color = max(nearBlack, color);

    float alpha = 1.0 - aastep(0.00001, sdf);

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.03;
}{@}PourBasePlaneShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tNoise;
uniform vec3 uColor;
uniform vec3 uImpactPos;
uniform vec3 uSpawnPos;
uniform float uPourStrength;
uniform float uWaterLine;

#!VARYINGS
varying vec2 vUv;
varying vec3 vWorldPos;
varying vec3 vTranslation;

#!SHADER: Vertex

void main() {
    vTranslation = modelMatrix[3].xyz;
    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vWorldPos = worldPos.xyz;

    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vUv = uv;
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    float steppedTime = floor(time * 18.0) / 18.0 * 1.2;

    // distance to impact
    vec3 impactPos = uImpactPos;
    impactPos.y = max(vTranslation.y + 0.3, impactPos.y);
    impactPos.z = vTranslation.z + 0.22;
    float dist = distance(impactPos, vWorldPos);

    // scroll texture away from impact, horizontally
    float impactSign = sign(vWorldPos.x - impactPos.x);

    // splashy texture close to impact
    vec2 uv = vUv * 4.0;
    uv += vec2(-steppedTime * 2.0 * impactSign, 0.0);
    float noise = texture2D(tNoise, uv * 0.65).r;

    // diagonal mask for martini glass
    float diagonals = min((vUv.x * 1.1 + vUv.y) * 0.5, ((1.0 - vUv.x) * 1.1 + vUv.y) * 0.5);
    diagonals += noise * 0.01;

    // compositing
    float waterLine = smoothstep(1.0, 0.4, vUv.y);
    float invDist = 1.0 - clamp(dist * 1.8, 0.0, 1.0);
    float waves = sin(dist * 40.0 - steppedTime * 15.0) * 0.5 + 0.5;
    waves = waves * 0.5 + (sin(vUv.x * 8.0 - steppedTime * 15.0) * 0.5 + 0.5) * 0.6;
    float closeSplash = smoothstep(0.4, 0.0, dist);
    float powPourStrength = pow(uPourStrength, 3.0);
    float value = waterLine - (waves * invDist) * 0.4 * powPourStrength;
    float impactGradient = abs(vWorldPos.x - impactPos.x);
    impactGradient = clamp(impactGradient, 0.0, 1.0);
    value += noise * pow(invDist, 3.0) * 15.0 * impactGradient * 1.0 * powPourStrength;
    value += texture2D(tNoise, vUv * 2.0 + steppedTime * 0.5).r * 0.035;

    float alpha = aastep(0.3, value) * aastep(0.4, diagonals);

    vec3 color = uColor;

    gl_FragColor = vec4(color, alpha);
}
{@}PourLineShader.glsl{@}#!ATTRIBUTES
attribute vec3 currpos;
attribute vec3 nextpos;
attribute vec3 prevpos;
attribute float random;

#!UNIFORMS
uniform sampler2D tNoise;
uniform float uPourStrength;
uniform float uClipHeight;
uniform float uClipAngle;
uniform float uThickness;
uniform vec3 uColor;
uniform vec3 uBasePlanePos;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vPos;
varying vec3 vTranslation;
varying vec2 vNorm;
varying float vRandom;
varying float vThickness;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vUv2 = uv;
    vTranslation = modelMatrix[3].xyz;

    mat4 m = projectionMatrix * viewMatrix;
    vec4 projCurrPos = m * vec4(currpos, 1.0);
    vec4 projNextPos = m * vec4(nextpos, 1.0);
    vec4 projPrevPos = m * vec4(prevpos, 1.0);

    vec2 screenCurrPos = projCurrPos.xy / projCurrPos.w;
    vec2 screenNextPos = projNextPos.xy / projNextPos.w;
    vec2 screenPrevPos = projPrevPos.xy / projPrevPos.w;

    vec2 dir1 = normalize(screenNextPos - screenCurrPos);
    vec2 dir2 = normalize(screenCurrPos - screenPrevPos);
    vec2 tangent = normalize(dir1 + dir2);

    vec2 norm = normalize(vec2(-tangent.y, tangent.x));

    float aspect = resolution.y / resolution.x;
    norm.x *= aspect;

    float thickness = 0.75 * (vUv.y * 0.5 + 0.5) * smoothstep(-0.6, 0.2, vUv.y);
    vec4 pos = projCurrPos;

    thickness *= uThickness;

    pos.xy += norm.xy * ((uv.x - 0.5) * 2.0) * thickness;

    vPos = currpos;
    vRandom = random;
    vThickness = thickness;
    vNorm = norm;

    gl_Position = pos;
}

#!SHADER: Fragment
#require(transformUV.glsl)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold - afwidth, threshold + afwidth, value);
}

void main() {
    vec2 clipPlane = vTranslation.xy + vec2(0.0, uClipHeight);
    if (vPos.y < clipPlane.y) discard;

    // clip along a given angle to stop the pour clipping out of the right side of the glass

    // NOTE(balraj): This logic is a little iffy and doesn't generalise to the left side of the glass also,
    // a less bad angled clip plane function would be better
    vec2 fragDirectionFromClipPlane = normalize(vPos.xy - clipPlane);
    vec2 clipPlaneDirectionFromOrigin = rotateUV(vec2(0.0, 1.0), uClipAngle, vec2(0.0));
    float isInsideGlass = 2.0 * dot(fragDirectionFromClipPlane, clipPlaneDirectionFromOrigin) - 1.0;
    if (isInsideGlass < .35 && vPos.x > 0.0) discard;

    vec2 uv = vUv * vec2(1.25, 1.0);

    float steppedTime = floor(time * 18.0) / 18.0;
    uv.y -= steppedTime * 1.75;
    uv.x += steppedTime * 0.1;

    // edge gradient
    float gradient = (1.0 - pow(abs(vUv.x - 0.5) * 2.0, 1.0)) - (1.0 - uPourStrength);

    // fade at start to hide seam
    // gradient *= smoothstep(0.0, 0.05, vUv.y);

    // scrolling noise texture
    float noise = texture2D(tNoise, uv).r;
    noise = pow(noise, 2.0);
    float value = gradient - noise * (1.0 - gradient) * 3.0;
    value = aastep(0.3, value);

    vec3 color = uColor;

    gl_FragColor = vec4(color, value);
}
{@}DrinkSelectionBorderShader.glsl{@}#!ATTRIBUTES
attribute float inner;
attribute float outer;

#!UNIFORMS
uniform sampler2D tMap;

uniform vec3 uCloudColor;
uniform vec3 uSkyColor;

uniform float uPadX;
uniform float uPadY;
uniform float uSceneHeightWorld;
uniform float uScreenHeightWorld;
uniform float uFixedWidth;
uniform float uDepthSkew;
uniform float uDepthOffset;
uniform float uFragDepth;
uniform float uSkewCorrection;
uniform float uMaxWidth;
uniform float uDPR;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vLocalPos;
varying float vInner;
varying float vDepth;

#!SHADER: Vertex
void main() {
    vUv = uv;
    vInner = inner;
    vLocalPos = position;

    vec3 pos = position;
    float aspect = resolution.x / resolution.y;
    float maxAspect = 2.0;
    float clampedAspect = min(maxAspect, aspect);

    float mask = 1.0 - outer;

    float halfWidth = uScreenHeightWorld * aspect * 0.5;
    float halfHeight = uSceneHeightWorld * 0.5;

    // clamp width to max pixel width
    float resx = resolution.x / uDPR;
    float halfWidthClamped = uScreenHeightWorld * (uMaxWidth / resx) * 0.5 * aspect;
    float blend = resx < uMaxWidth ? 1.0 : outer;
    float width = mix(halfWidthClamped, halfWidth, blend);

    float padx = width * uPadX;
    float pady = halfHeight * uPadY;

    float outlineThickness = 0.1;

    // fit border to world space screen size, with padding
    // if (uFixedWidth > 0.5) {
    //     padx = width - uPadX;
    // }

    if (pos.x < 0.0) {
        pos.x = -width;
        pos.x += mask * padx;
    }

    if (pos.x > 0.0) {
        pos.x = width;
        pos.x -= mask * padx;
    }

    if (pos.y > 0.0) {
        pos.y = halfHeight;
        pos.y -= mask * pady;
    }

    if (pos.y < 0.0) {
        pos.y = -halfHeight;
        pos.y += mask * pady;
    }

    // extend outer edges
    if (abs(position.x) > 0.9) {
        pos.x += outer * pos.x;
    }

    // skew along depth when objects need to pop out
    float ygrad = sign(position.y);
    ygrad = ygrad + 1.0;
    float depthGrad = ygrad * uDepthSkew;
    float depthMask = (1.0 - outer);
    pos.z -= depthGrad * depthMask;
    pos.z += uDepthOffset * depthMask;

    // vDepth = (1.0 - (position.y * 0.5 + 0.5)) * uFragDepth * depthMask;

    // skew along x axis to correct for perspective distortion
    pos.x += ygrad * uSkewCorrection * sign(position.x);

    // pass transformed pos to fragment shader
    vPos = position;

    // extrude outline in screen space
    vec4 projPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec2 norm = vec2(0.0);
    norm.x -= sign(position.x) / aspect * (uDepthSkew * 0.5 + 1.0);
    norm.y -= sign(position.y);
    projPos.xy += norm * inner * outlineThickness;

    gl_Position = projPos;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {

    
    float steppedTime = floor(time * 8.0) / 8.0;
    
    float noise = texture2D(tMap, vPos.xy * 3.0 + vec2(0.0, steppedTime)).r;

    float value = 1.0;
    value *= (1.0 - vInner);
    value -= noise * 0.6;

    float outline = aastep(0.4, value);
    vec3 nearBlack = vec3(18.0 / 255.0);
    vec3 color = vec3(max(18.0 / 255.0, outline * step(-0.35, vLocalPos.y)));

    float alpha = aastep(0.01, value);

    gl_FragColor = vec4(color, alpha);
    gl_FragDepth = gl_FragCoord.z + clamp(1.0 - (vLocalPos.y * 0.5 + 0.5), 0.0, 0.015);
}{@}DrinkSelectionBottleShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uDistanceCompensation;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vDistance;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normalMatrix * normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;
    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * modelViewPos;

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vDistance = -modelViewPos.z;
    
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);

    // texture
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    vec2 lineUvDistanceCompensated = lineUv * mix(2.0, 0.5, pow(clamp(vDistance * 0.0325, 0.0, 1.0), 2.0)) * 0.5;
    lineUv = mix(lineUv, lineUvDistanceCompensated, uDistanceCompensation);
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float verticalGrad = smoothstep(uVerticalGrad.x, uVerticalGrad.y, vPos.y);
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45 - vAo * 0.15 - verticalGrad);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1 - vAo * 0.15 - verticalGrad);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask + lighting * 0.3;
    maskedLines = aastep(0.2, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), uColor, terminatormid);
    // color = mix(color, uColorHighlight, terminatorhigh);
    color *= maskedLines;

    // texture
    float tex = texture2D(tMap, vUv).r;
    color *= aastep(0.5, tex);

    // liquid
    vec3 liquidColor = uColorHighlight;
    float liquidMask = step(0.6, vUv.x) * (1.0 - step(0.1, vUv.y)) * (1.0 - step(1.085, vPos.y));
    color *= mix(vec3(1.0), liquidColor, liquidMask);

    color = max(vec3(18.0 / 255.0), color);



    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}FloatingFrameHandShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uBorderWidth;
uniform sampler2D tNoise;
uniform float uAspectRatio;
uniform float uDPR;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vUv = uv;
}

#!SHADER: Fragment

void main() {
    vec4 color = texture2D(tMap, vUv);
    float steppedTime = floor(time * 8.0) / 8.0 * 0.45;
    float edgeNoise = texture2D(tNoise, vec2(vUv * 0.05) + vec2(steppedTime, 0.0)).r * 0.005;

    float borderWidth = uBorderWidth + edgeNoise;
    // borderWidth *= 5.0;
    float border = step(vUv.x, borderWidth / uAspectRatio) + step(1.0 - borderWidth / uAspectRatio, vUv.x) +
        step(vUv.y, borderWidth) + step(1.0 - borderWidth, vUv.y);
    border = clamp(border, 0.0, 1.0);

    const float uAlphaBorderWidth = 0.005;
    float alphaBorderWidth = uAlphaBorderWidth + edgeNoise;
    float alphaBorder = step(vUv.x, alphaBorderWidth / uAspectRatio) + step(1.0 - alphaBorderWidth / uAspectRatio, vUv.x) +
        step(vUv.y, alphaBorderWidth) + step(1.0 - alphaBorderWidth, vUv.y);
    float alpha = 1.0 - alphaBorder;

    vec3 finalColor = mix(color.rgb, vec3(18.0 / 255.0), border);

    gl_FragColor = vec4(finalColor, alpha);
}{@}HandOutputRender.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
#!SHADER: Vertex
void main() {
  gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
#require(fastblur.fs)
#require(blendmodes.glsl)

void main() {
  vec2 vUv = gl_FragCoord.xy / resolution.xy;
  vec4 color = texture2D(tMap, vUv);
  gl_FragColor = color;
}{@}InverseHandPass.fs{@}uniform sampler2D tDiffuse;
uniform sampler2D tHand;
uniform sampler2D tHeightmap;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform sampler2D tBlueNoise;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;
uniform float uScroll;

#require(blendmodes.glsl)
#require(rgb2hsv.fs)

float sampleHeightmap(sampler2D tex, vec2 uv) {
    vec2 texSize = vec2(256.0);
    vec2 texel = 1.0 / texSize;

    // Convert UV to texel space, offset by half-texel to get to texel centers
    vec2 f = fract(uv * texSize - 0.5);
    vec2 base = (floor(uv * texSize - 0.5) + 0.5) * texel;

    // Sample the 4 nearest texels
    float tl = texture2D(tex, base).x;
    float tr = texture2D(tex, base + vec2(texel.x, 0.0)).x;
    float bl = texture2D(tex, base + vec2(0.0, texel.y)).x;
    float br = texture2D(tex, base + vec2(texel.x, texel.y)).x;

    // Bilinear blend
    float top = mix(tl, tr, f.x);
    float bottom = mix(bl, br, f.x);
    return mix(top, bottom, f.y);
}

void main() {
  vec2 screenUv = gl_FragCoord.xy / resolution.xy;

  vec2 screenUvFlipped = screenUv;
  screenUvFlipped.x = 1.0 - screenUvFlipped.x;

  float heightValue = sampleHeightmap(tHeightmap, screenUvFlipped);
  float steppedTime = floor(time * 8.0) / 8.0;

  vec3 color = uColor1;

  vec2 lineuv = screenUv;
  lineuv /= resolution.x > resolution.y ? vec2(1.0, resolution.x / resolution.y) : vec2(resolution.y / resolution.x, 1.0);
  lineuv.x -= sin(lineuv.y) * 0.3;
  lineuv.y += steppedTime * 0.05;
  lineuv.x -= steppedTime * 0.015;
  lineuv *= 0.8;

  lineuv += heightValue * 0.01;

  vec4 lines = texture2D(tLines, lineuv);
  vec4 noise = texture2D(tNoise, lineuv * 0.4 + vec2(steppedTime * 0.01, 0.0));
  vec4 noise2 = texture2D(tBlueNoise, lineuv * 6.0 + vec2(steppedTime * 0.01, 0.0));

  float value = 0.0;
  value += lines.r;
  value -= noise.r * 0.2;
  value = step(0.7 + noise.r * 0.04, value);

  color = mix(color, uColor2, value);

  float minval = 0.3;

  color = mix(color, vec3(0.0), step(minval + 0.01 + noise2.b * 0.1, heightValue));
  color = mix(color, uColor4, step(minval + 0.1 + noise2.b * 0.1, heightValue));
  color = mix(color, uColor3, step(minval + 1.5 - noise2.g * 0.1, heightValue));

  vec2 handUv = screenUv;
  handUv.y -= uScroll;
  handUv -= 0.5;
  handUv += noise2.rg * 0.05;
  handUv += 0.5;
  vec4 hand = texture2D(tHand, handUv, 0.0);

  // hand *= hand.r;

  color = blendNormal(color,uColor4, hand.r * 0.3);

  gl_FragColor = vec4(color, 1.0);

screenUv.y -= uScroll;
  hand = texture2D(tHand, screenUv, 0.0);
  gl_FragColor.rgb = blendNormal(texture2D(tDiffuse, screenUv).rgb, gl_FragColor.rgb, 1.0 - hand.g * hand.r);
  // gl_FragColor = hand;
}{@}InverseSkinHandShader.glsl{@}
#!ATTRIBUTES

#!UNIFORMS
uniform vec2 uDiscard;
uniform float uDisplacement;
uniform vec4 uPortalPlane;
uniform float uPortalFeather;

#!VARYINGS
varying vec2 vUv;
varying vec3 vNormal;
varying float vNdcHeight;
varying vec3 vViewDir;
varying vec3 vWorldPos;
varying float vDepth;

#!SHADER: Vertex

#require(skinning.glsl)

void main() {
    vUv = uv;
    vNormal = normalize(normal);

    vec3 pos = position;
    applySkin(pos, vNormal);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    vec4 projectionPos = projectionMatrix * mvPosition;
    vec4 projectionNormal = projectionMatrix * modelViewMatrix * vec4(vNormal, 0.0);

    vec2 screenNormal = normalize(projectionNormal.xy);
    projectionPos.xy += screenNormal * uDisplacement * projectionPos.w * 0.004;

    gl_Position = projectionPos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vec3 worldPos = (modelMatrix * vec4(pos, 1.0)).xyz;

    vViewDir = -mvPosition.xyz;
    vWorldPos = worldPos;

    vDepth = dot(worldPos, uPortalPlane.xyz) + uPortalPlane.w;
}

#!SHADER: Fragment
#require(range.glsl)

bool isClipping(vec2 vUv, vec3 vWorldPos) {
    vec2 uvRepeat = fract(vUv * 1000.0) - 0.5;
    float radius = smoothstep(1.25, .9, length(cameraPosition - vWorldPos));

    float circle = 1.0 - smoothstep(radius - radius * 0.1, radius, length(uvRepeat));
    return circle > 0.5;
}

void main() {
    if(isClipping(vViewDir.xz * 0.07, vWorldPos))
        discard;

    if(uDiscard.y - vNdcHeight > 0.0 || uDiscard.x - vNdcHeight < 0.0)
        discard;

    float depthMask = smoothstep(-uPortalFeather, uPortalFeather, vDepth);
    float fringe = 1.0 - smoothstep(0.0, uPortalFeather, abs(vDepth));

    vec3 color = vec3(18.0 / 255.0);

    float distBeforePortal = smoothstep(1., uPortalFeather , vDepth);

    #drawbuffer HandInfo gl_FragColor = vec4(distBeforePortal, 1.0 - depthMask, fringe, 1.0);
    #drawbuffer Color gl_FragColor = vec4(color, depthMask);
}{@}SkinHandShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;

uniform float uLinesTile;
uniform vec2 uDiscard;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec4 uPortalPlane;
uniform float uPortalFeather;
uniform vec3 uLightDir;
uniform vec3 uColor;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;
varying float vNdcHeight;
varying float vDepth;
varying vec3 vViewDir;
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(skinning.glsl)

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c);
}

void main() {
  vUv = uv;
  vUv2 = uv2;
  vNormal = normalize(normalMatrix * normal);

  vec3 pos = position;
  applySkin(pos, vNormal);

  float steppedTime = floor(time * 8.0);

  vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;

  vAo = uv2.x;

  vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);

  gl_Position = projectionMatrix * mvPosition;

  vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

  // Signed distance to portal plane in world space
  vec3 worldPos = (modelMatrix * vec4(pos, 1.0)).xyz;
  vDepth = dot(worldPos, uPortalPlane.xyz) + uPortalPlane.w;

  vViewDir = -mvPosition.xyz;
  vWorldPos = worldPos;
}

#!SHADER: Fragment
#require(range.glsl)
#require(blendmodes.glsl)

float aastep(float threshold, float value) {
  float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
  return smoothstep(threshold - afwidth, threshold + afwidth, value);
}

bool isClipping(vec2 vUv, vec3 vWorldPos) {
  vec2 uvRepeat = fract(vUv * 1000.0) - 0.5;
  float radius = smoothstep(1.25, .9, length(cameraPosition - vWorldPos));

  float circle = 1.0 - smoothstep(radius - radius * 0.1, radius, length(uvRepeat));
  return circle > 0.5;
}

void main() {
  if(isClipping(vViewDir.xz * 0.07, vWorldPos))
    discard;

  if(uDiscard.y - vNdcHeight > 0.0 || uDiscard.x - vNdcHeight < 0.0)
    discard;

  float ao = abs(vAo);
  float skinMask = 1.0 - step(-0.5, vAo);
  vec3 normal = normalize(vNormal);

  float steppedTime = floor(time * 8.0);

    // lines
  vec2 lineUv = vLineUv * uLinesTile;
  lineUv.x += steppedTime / uLinesTile * 0.2;
  float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // trim pattern
  float trim = texture2D(tTrim, vUv).r;
  trim = aastep(0.55, trim);

    // lighting
  vec3 lightDir = normalize(uLightDir);
  float lighting = dot(normal, lightDir);
  float lightMask = max(0.0, lighting);
  float terminatormid = aastep(0.3, lighting + lines * 0.3 - vAo);
  float terminatorhigh = aastep(0.85, lighting + lines * 0.1 - 0.1 - vAo);
  float terminatorbounce = 1.0 - aastep(-0.91, lighting - lines * 0.2);

    // reduce lines in areas of brightness
  float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
  float noise = texture2D(tNoise, lineUv * 2.0).r;
  maskedLines += noise * pow(lightMask, 2.0) * 3.0;
  maskedLines = aastep(0.01, maskedLines);

    // compositing;
  vec3 color = vec3(1.0);

  vec3 alt = uColor;

  color = mix(vec3(18.0 / 255.0), alt, terminatormid);
  color = mix(color, vec3(1.0), skinMask);
  color *= maskedLines;
  color = mix(color, alt, terminatorbounce);
  color *= trim;

  if(!gl_FrontFacing) {
    color = vec3(0.0);
  }

  color = max(vec3(18.0 / 255.0), color);

  float depthMask = smoothstep(-uPortalFeather, uPortalFeather, vDepth);
  float fringe = 1.0 - smoothstep(0.0, uPortalFeather + 0.1, abs(vDepth - 0.01));

  color *= step(0.1, 1.0 - fringe);

  float distBeforePortal = smoothstep(1., uPortalFeather , vDepth);

  #drawbuffer HandInfo gl_FragColor = vec4(distBeforePortal, 1.0 - depthMask, fringe, 1.0);
  #drawbuffer Color gl_FragColor = vec4(color, depthMask);
}{@}WaterHandShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D heightmap;
uniform sampler2D tHand;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform sampler2D tBlueNoise;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;
// uniform float heightScale;
// uniform float WIDTH;
// uniform float BOUNDS;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;
uniform float uScroll;
uniform float uPageScroll;

#!VARYINGS
varying vec3 vNormal;
varying vec2 vUv;
varying float vHeight;

#!SHADER: Vertex

// vec3 calculateWaterPos() {
//     vec2 cellSize = vec2( 1.0 / WIDTH, 1.0 / WIDTH );

//     vec3 objectNormal = vec3(
//                         ( texture2D( heightmap, uv + vec2( - cellSize.x, 0 ) ).x - texture2D( heightmap, uv + vec2( cellSize.x, 0 ) ).x ) * WIDTH / BOUNDS,
//                         ( texture2D( heightmap, uv + vec2( 0, - cellSize.y ) ).x - texture2D( heightmap, uv + vec2( 0, cellSize.y ) ).x ) * WIDTH / BOUNDS,
//                         1.0 );


//     vNormal = normalize(normalMatrix * objectNormal);

//     float heightValue = texture2D(heightmap, uv).x;

//     vHeight = heightValue;
//     vec3 pos = position;

//     // pos.xy += vNormal.xy * 1.5;
//     // pos.z += heightValue * 1.5;
//     // z += length(vNormal.xy) * 10.5;
//     // pos.z += heightValue * heightScale;

//     // pos.z += (1.0 - heightValue) * 3.0;
//     // pos.z += (1.0 - step(0.2, heightValue)) * 0.6;

//     // if (heightValue > 0.4) {
//     //     pos.z += .0;
//     // }

//     // pos.z += heightValue * 4.5;
//     // pos.x += heightValue * 2.2;

//     return pos;
// }

void main() {
    // vec3 pos = calculateWaterPos();
    vec3 pos = position;
    
    pos.z -= 0.5;
    pos.xy *= 1.1;
    
    if (uFixed > 0.5) {
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(pos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }


    vUv = uv;
}

#!SHADER: Fragment
#require(blendmodes.glsl)
#require(rgb2hsv.fs)

// bilinear sampling of heightmap
float sampleHeightmap(sampler2D tex, vec2 uv) {
    vec2 texSize = vec2(256.0);
    vec2 texel = 1.0 / texSize;

    // Convert UV to texel space, offset by half-texel to get to texel centers
    vec2 f = fract(uv * texSize - 0.5);
    vec2 base = (floor(uv * texSize - 0.5) + 0.5) * texel;

    // Sample the 4 nearest texels
    float tl = texture2D(tex, base).x;
    float tr = texture2D(tex, base + vec2(texel.x, 0.0)).x;
    float bl = texture2D(tex, base + vec2(0.0, texel.y)).x;
    float br = texture2D(tex, base + vec2(texel.x, texel.y)).x;

    // Bilinear blend
    float top = mix(tl, tr, f.x);
    float bottom = mix(bl, br, f.x);
    return mix(top, bottom, f.y);
}

void main() {
//   vec2 screenUv = gl_FragCoord.xy / resolution.xy;
  vec2 screenUv = vUv;

  // float heightValue = vHeight;
  // float heightValue = texture2D(heightmap, screenUv).x;
  float heightValue = sampleHeightmap(heightmap, screenUv);
  float steppedTime = floor(time * 8.0) / 8.0;

  vec3 color = uColor1;

  vec2 lineuv = vUv;
  lineuv -= 0.5;
  lineuv /= resolution.x > resolution.y ? vec2(1.0, resolution.x / resolution.y) : vec2(resolution.y / resolution.x, 1.0);
  lineuv *= 1.4;
  lineuv += 0.5;

  lineuv.x -= sin(lineuv.y) * 0.3;
  lineuv.y += time * 0.05;
  lineuv.x -= time * 0.015;
  // lineuv.y += uPageScroll * 0.15;
  lineuv *= 0.8;

  lineuv += heightValue * 0.01;

  vec4 lines = texture2D(tLines, lineuv);
  vec4 noise = texture2D(tNoise, lineuv * 0.4 + vec2(steppedTime * 0.01, steppedTime * 0.04));
  vec4 noise2 = texture2D(tBlueNoise, lineuv * 6.0 + vec2(steppedTime * 0.2, 0.0));

  float value = 0.0;
  value += lines.r;
  // value -= (noise.r - (noise2.r * 0.1)) * 1.2;
  // value += step(0.8, heightValue);
  value -= noise.r * 0.2;
  // value += lines.r * length(vNormal.xy) * 0.5;
  // value -= (lines.r * 0.1) * length(vNormal.xy) * 20.0;
  // value += length(vNormal.xy) * 4.0;
  // value -= heightValue * 0.5;
  value = step(0.7 + noise.r * 0.04, value);

  color = mix(color, uColor2, value);

  float minval = 0.3;

  color = mix(color, vec3(0.0), step(minval + 0.01 + noise2.b * 0.1, heightValue));
  color = mix(color, uColor4, step(minval + 0.1 + noise2.b * 0.1, heightValue));
  color = mix(color, uColor3, step(minval + 1.5 - noise2.g * 0.1, heightValue));


// Hue
//   color.rgb = rgb2hsv(color.rgb);
//   color.r += vNormal.x * 0.06;
//   color.g += vNormal.y * 0.35;
//   color.rgb = hsv2rgb(color.rgb);

  // color.rgb = blendPhoenix(color.rgb, hand.rgb, hand.a);
  // color.rgb = hand.rgb;
  // color -= ((1.0 - hand.r) * hand.g) * 0.2;

  // color *= (1.0 - hand.r) - step(0.4, hand.g);

  vec2 handUv = screenUv;
  handUv.y -= uScroll;
  handUv -= 0.5;
  // handUv += (vNormal.xy * 0.5) * 0.3;// + (noise2.r * 0.02);
  handUv += noise2.rg * 0.02;
  handUv += 0.5;
  vec4 hand = texture2D(tHand, handUv, 0.0);

  color.rgb = blendNormal(color.rgb, uColor4, hand.g * 0.3);

  // add light
  // float light = dot(nearbyNormal.xy, vec2(0.0, 1.0));
  color.rgb -= step(0.1, heightValue) * 0.04;


  gl_FragColor = vec4(color, 1.0);
  // gl_FragColor = vec4(nearbyNormal.xyz, 1.0);
  // gl_FragColor = vec4(vHeight, 0.0, 0.0, 1.0);
  // gl_FragColor = vec4(vNormal.xyz, 1.0);

  // gl_FragColor = hand;
}{@}FloatingFramePortalShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float windmask;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
uniform vec3 uCenter;
uniform float uTransition;
// uniform float uAspectRatio;
uniform float uDPR;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform float uHover;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;
varying float vWindMask;
varying float vBackground;
varying vec3 vNdc;
varying vec3 vPos;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vPos = position;
    vWindMask = windmask;
    vUv = uv;
    vUv2 = uv2;
    vNormal = normal;
    vLineUv = (rotation3d(normalize(vec3(1.0, 0.0, 2.5)), 3.14159 * 0.5) * position).xy;
    vLightDir = normalize(vec3(0.0, 0.5, -0.5));

    vec3 pos = position;

    float steppedTime = floor(time * 12.0) / 12.0;

    float freq = 25.0;
    float speed = 1.25;
    float amp = 0.05;
    float displacement = sin(pos.x * freq + steppedTime * speed) * amp * windmask;
    displacement += sin(pos.x * freq * 0.34159 + pos.z * 0.5 * freq + steppedTime * speed * 3.14159 * 0.673) * amp * windmask;
    displacement += sin(pos.x * freq * 0.2772 + pos.z * 0.5 * freq + steppedTime * speed * 3.14159 * 0.673) * amp * windmask * 0.5;

    pos.y += displacement;

    // subtle keep alive animation
    // pos = rotation3d(vec3(1.0, 0.0, 0.5), sin(floor(time * 8.0) * 0.5 - position.y * 0.8 + position.x * 2.0) * max(0.0, position.y + 0.8) * 0.03) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdc = gl_Position.xyz / gl_Position.w;
    vBackground = 1.0 - step(-0.5, position.z);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    float transition = uTransition + 0.01;
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = mix(uCenter, uPoint1, transition);
    vec3 pos2 = mix(uCenter, uPoint2, transition);
    vec3 pos3 = mix(uCenter, uPoint3, transition);
    vec3 pos4 = mix(uCenter, uPoint4, transition);

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;

    edgeNoise -= uHover * 100.0;

    sdfx += edgeNoise * 0.0002 * transition;
    sdfy += edgeNoise * 0.0002 * transition;
    float sdf = max(sdfx, sdfy);
    sdf *= aspect;

    // float dx = dFdx(vNdc.x);
    // float dy = dFdy(vNdc.y);

    // float verticalRatio = resolution.y / resolution.x;
    // float horizontalRatio = resolution.x / resolution.y;
    
    // float width = mix(0.00001, 0.005, uTransition);
    // float outline = aastep(width, -sdf);
    // outline *= aastep(width, -sdfy);

    // float widthX = mix(0.00001, 0.002, uTransition);
    // float widthY = mix(0.00001, 0.002 * uAspectRatio, uTransition);

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);

    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.005) discard;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= steppedTime * 3.0;
    float lines = texture2D(tLines, lineUv.yx * 0.7).r * 2.0 - 1.0;

    // trim texture
    float atlas = texture2D(tAtlas, vUv).r;
    atlas = aastep(0.55, atlas);

    // trim texture
    float trim = texture2D(tTrim, vUv2).r;
    trim = aastep(0.55, trim);

    // lighting
    // vec3 lightDir = vLightDir;
    vec3 lightDir = normalize(vec3(0.15, 0.0, 1.0));
    float lighting = max(0.0, dot(normal, lightDir));
    lighting *= clamp(vPos.y * 0.5 + 0.8, 0.0, 1.0);
    lighting = pow(lighting - 0.1, 4.0);
    lighting = clamp(lighting, 0.0, 1.0);

    // compositing
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    float value = aastep(0.5, lighting + (1.0 - lines) * 0.3 + noise * lighting);
    vec3 color = uColor2 * vec3(value);
    // color *= trim;
    color *= atlas;

    // color background
    vec3 backgroundColor = uColor3;
    if (vBackground > 0.5) color = backgroundColor;

    // frame outline
    color *= outline;

    vec3 nearBlack = vec3(18.0 / 255.0);
    color = max(nearBlack, color);

    float alpha = 1.0 - aastep(0.00001, sdf);

    // alpha = 1.0;
    // color = vec3(sdf);

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.3;
}{@}NearBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform vec3 uColor;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vNdcHeight;
varying float vAspect;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vUv = uv;
    vPos = position;

    float aspect = resolution.y / resolution.x;
    vPos.x *= aspect;
    vPos.x *= 2.0;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vAspect = resolution.x / resolution.y;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

        vec2 screenUv = gl_FragCoord.xy / resolution;

        float steppedTime = -floor(time * 16.0) * 0.004;
        vec2 uv =  (vUv - vec2(0.5, 0.0)) * vec2(4.0, 2.5) - vec2(-steppedTime * 0.4, steppedTime * 0.2);

        float n1 = texture2D(tNoise, uv * vec2(5.0, 1.0) + steppedTime * 0.1).r;

        float noise = texture2D(tMap, uv * vec2(5.0, 1.0) * 0.5).r;
        noise *= texture2D(tMap, uv * vec2(5.0, 1.0) * 1.0 + steppedTime * 0.1).r;
        noise = clamp(noise, 0.0, 1.0);
        noise = pow(noise, 2.0);

        // float haloGrad = length((vPos - vec3(0.0, 0.0, -1.0)) * 0.5);
        float haloGrad = vPos.x * 5.0 + 0.7;
        haloGrad = pow(haloGrad, 3.0);
        float horizonGrad = smoothstep(0.6, 0.3, vUv.y);
        float value = haloGrad + horizonGrad * 2.5;
        value *= 1.4;
        value -= (1.0 - pow(noise, 2.0)) * 0.6;
        value -= n1 * 0.5;

        float thickness = resolution.y * 0.0035;
        float scan = 0.5;
        float mask = aastep(scan, value);
        float line = mask;
        float width = 0.03;
        line *= 1.0 - aastep(scan + width, value);
        line = 1.0 - line;

        vec3 color = mix(uColor, vec3(1.0), step(scan, value));

    gl_FragColor = vec4(color, 1.0);
}{@}NearGroundShader.glsl{@}#!ATTRIBUTES
attribute float ao;

#!UNIFORMS
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    // keep alive animation
    // float mask = smoothstep(-0.2, 0.3, position.y);
    // pos = rotation3d(vec3(1.0, 0.0, 0.5), (2.5 + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2)) * position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    // vec3 normal = normalize(vNormal);

    float altMask = smoothstep(0.4, 1.0, vUv.y);
    altMask = max(altMask, smoothstep(0.1, 1.0, abs(vUv.x - 0.5) * 2.0));
    
    // lines
    vec2 lineUv = vUv.yx * uLinesTile;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx * vec2(2.0, 1.0)).r;

    // // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, vUv * 3.2 * vec2(5.0, 1.0) - vec2(steppedTime * 0.2, -steppedTime)).r;
    float noise2 = texture2D(tNoise, vUv * 1.5 * vec2(5.0, 1.0) - vec2(steppedTime * 0.1, -steppedTime * 0.5)).r;
    float noise3 = texture2D(tNoise, vUv * 0.6 * vec2(8.0, 1.0) - vec2(0.0, -steppedTime * 0.5)).r;

    float value = lines;
    value = aastep(0.4, value + smoothstep(0.6, 0.95, noise3) + altMask + vUv.y * 0.2);

    // tiles
    vec2 tileUv = vec2(abs(fract(vUv * 17.0 * vec2(3.0, 1.0) + 0.65) - 0.5));
    noise2 = smoothstep(0.5, 1.0, noise2);
    float tiles = max(aastep(0.485, tileUv.x - noise2 * 0.125 - altMask), aastep(0.485, tileUv.y - noise2 * 0.5 - altMask));
    tiles = 1.0 - tiles;
    value *= tiles;

    vec3 color = vec3(value);

    altMask += noise3 * 0.3;
    altMask += lines * abs(vUv.x - 0.5) * 3.0;
    altMask = aastep(0.5, altMask);
    color *= mix(uColor, vec3(1.0), altMask);
    color = max(vec3(18.0 / 255.0), color);

    // color = vec3(vUv, 1.0);

    float alpha = 1.0;
    gl_FragColor = vec4(color, alpha);
}{@}NearShadowShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform float uAngle;
uniform float uSpeed;
uniform vec3 uColor;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;

#!SHADER: Vertex

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

void main() {
    vUv = uv;
    vLineUv = vUv - 0.5;
    vLineUv = rotate2d(uAngle) * vLineUv;
    vLineUv *= uLinesTile;
    vLineUv = vLineUv + 0.5;
    vec3 pos = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {

    float steppedTime = floor(time * 8.0) / 8.0 * 0.5 * uLinesTile;
    float t = time * 0.28 * uLinesTile;
    float alpha = texture2D(tMap, vec2(1.0 - vUv.x, 1.0 - vUv.y)).r + 0.5;
    alpha = pow(alpha, 2.0);
    float lines = texture2D(tLines, (vLineUv.xy * 1.25 - vec2(0.0, steppedTime)) * 0.7 ).r;
    alpha -= 1.0 - lines * 1.1;
    alpha = aastep(0.55, alpha);

    vec3 color = vec3(1.0 - alpha);

    float altMask = smoothstep(0.7, 1.0, vUv.y);
    altMask = max(altMask, smoothstep(0.7, 1.0, abs(vUv.x - 0.5) * 2.0));
    altMask += lines * 0.3;
    altMask = aastep(0.5, altMask);
    color *= mix(uColor, vec3(1.0), altMask);
    color = max(vec3(18.0 / 255.0), color);


    gl_FragColor = vec4(color, 1.0);
}{@}FloatingFramePillarShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float colorid;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
uniform vec3 uCenter;
uniform float uTransition;
// uniform float uAspectRatio;
uniform float uDPR;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform float uHover;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vBackground;
varying float vBlobs;
varying vec3 vNdc;
varying vec3 vPos;
varying vec3 vLightDir;
varying vec3 vViewPos;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vec3 pos = position;

    vPos = position;
    vUv = uv;
    vUv2 = uv2;
    vNormal = normalMatrix * normal;
    vLightDir = normalize(vec3(0.0, 0.5, -0.5));
    vLineUv = (rotation3d(normalize(vec3(-1.0, 0.0, 0.5)), 0.5) * position).xy;

    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    vViewPos = -modelViewPos.xyz;

    // masks for layers
    float dist = length(position.xz);
    vBackground = step(1.2, dist);
    vBlobs = 1.0 - step(-0.01, uv.y); // blob mask stored in negative uv space

    gl_Position = projectionMatrix * modelViewPos;

    vNdc = gl_Position.xyz / gl_Position.w;
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    float transition = uTransition + 0.01;
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = mix(uCenter, uPoint1, transition);
    vec3 pos2 = mix(uCenter, uPoint2, transition);
    vec3 pos3 = mix(uCenter, uPoint3, transition);
    vec3 pos4 = mix(uCenter, uPoint4, transition);

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;

    edgeNoise -= uHover * 100.0;

    sdfx += edgeNoise * 0.0002 * transition;
    sdfy += edgeNoise * 0.0002 * transition;
    float sdf = max(sdfx, sdfy);
    sdf *= aspect;

    // float dx = dFdx(vNdc.x);
    // float dy = dFdy(vNdc.y);

    // float verticalRatio = resolution.y / resolution.x;
    // float horizontalRatio = resolution.x / resolution.y;
    
    // float width = mix(0.00001, 0.005, uTransition);
    // float outline = aastep(width, -sdf);

    // float widthX = mix(0.00001, 0.002, uTransition);
    // float widthY = mix(0.00001, 0.002 * uAspectRatio, uTransition);

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);

    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.005) discard;

    vec3 normal = normalize(vNormal);

    // blobs
    float t = floor(time * 12.0) / 12.0 * 0.31;

    vec2 blobUv = vUv + vec2(0.0, 1.0);
    float blobValue = 1.0;
    float edgeGrad = 1.0 - abs(blobUv.x - 0.5) * 2.0;
    edgeGrad = smoothstep(0.65, 1.0, edgeGrad);

    float blobNoise = texture2D(tNoise, blobUv * vec2(0.3, 1.30) + vec2(0.0, -t * 0.2)).r;
    blobNoise *= texture2D(tNoise, blobUv * vec2(0.15, 1.11415) + vec2(0.0, -t * 0.2)).r;

    blobValue = edgeGrad;
    blobValue *= blobNoise;
    blobValue *= smoothstep(1.0, 0.95, blobUv.y);

    float blobAlpha = aastep(0.3, blobValue);
    float blobOutline = aastep(0.6, blobValue);

    // lines
    vec2 lineUv = vLineUv.yx * 2.2;
    lineUv.x -= steppedTime * 1.0;

    float lines = texture2D(tLines, lineUv.yx * (0.7 - vBackground * 0.1)).r * 2.0 - 1.0;

    // trim texture
    float atlas = texture2D(tAtlas, vUv2).r;

    // trim texture
    float trim = texture2D(tTrim, vUv).r;
    trim = aastep(0.55, trim * atlas);

    // lighting
    vec3 lightDir = normalize(vec3(-0.9, 0.1, 1.0));
    float lighting = dot(normal, lightDir) * 0.5 + 0.5;
    lighting *= clamp(vPos.y * 0.5 + 0.88, 0.0, 1.0);
    lighting = pow(lighting - 0.1, 4.0);

    // compositing
    float skinMask = step(0.55, vUv2.y);
    float fresnel = max(0.0, dot(normalize(vNormal), normalize(vViewPos)));
    fresnel = (1.0 - fresnel) * skinMask;
    vec3 nearBlack = vec3(18.0 / 255.0);
    vec3 backgroundColor = mix(uColor1, nearBlack, aastep(0.1, -vPos.y * 2.1 - 0.8 + lines * 0.75));
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    float value = aastep(0.4, lighting + (1.0 - lines) * 0.3 + noise * lighting + vBackground - fresnel * 0.8);
    vec3 color = mix(mix(uColor2, backgroundColor, step(0.5, vBackground)), vec3(1.0), skinMask);
    color = mix(color, nearBlack, vBlobs * blobOutline);
    color *= mix(trim, 1.0, vBackground + vBlobs);
    color *= mix(atlas, 1.0, vBackground + vBlobs);
    color = mix(color, vec3(1.0), blobAlpha);
    color *= vec3((value + vBlobs) * (blobOutline + (1.0 - vBlobs)));

    // frame outline
    color *= outline;

    color = max(nearBlack, color);

    float alpha = 1.0 - aastep(0.00001, sdf);

    alpha *= 1.0 - vBlobs;
    alpha += blobAlpha;

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.03;
}{@}PillarFractureShader.glsl{@}#!ATTRIBUTES
attribute float ao;
attribute vec3 pivot;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uDistanceCompensation;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uFractureThreshold;
uniform float uTimeOffset;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform vec3 uMouse;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vDistance;
varying float vNdcHeight;

#!SHADER: Vertex
#require(simplenoise.glsl)
#require(range.glsl)
#require(eases.glsl)

//----------------------------------------------------------------------------------------
//  3 out, 1 in...
vec3 hash31(float p)
{
   vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
   p3 += dot(p3, p3.yzx+33.33);
   return fract((p3.xxy+p3.yzz)*p3.zyx); 
}

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normalMatrix * normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    float steppedTime = floor(time * 6.0 + uTimeOffset) * 0.1;

    vec3 dir = normalize(pivot);
    vec3 axis = hash31(pivot.x + pivot.y);
    axis = axis * 2.0 - 1.0;
    axis = normalize(axis);
    float angle = max(0.0, pivot.y - 0.5 - sin(steppedTime + pivot.z * 15.0 + uFractureThreshold) * 0.2) * 0.5;
    float angle2 = abs(sin(pivot.y * 55.0 - steppedTime + pivot.z * 10.0) * pivot.y);
    
    mat3 r = rotation3d(axis, angle + angle2 * 0.25);

    float scale = 1.0 + angle2 * 0.1;
    pos -= pivot;
    pos = r * pos;
    pos *= scale;
    pos += dir * vec3(1.0, 0.2, 1.0) * angle;
    pos.y += pow(pivot.y, 5.0) * 0.5;
    pos.x += angle2 * 0.01;
    pos += pivot;


    // worldPosition
    vec3 worldPos = (modelMatrix * vec4(pivot, 1.0)).xyz;
    float mouseDist = distance(worldPos, uMouse);
    float forceDist = 1.0 - smoothstep(0.0, 1.3, mouseDist);
    forceDist = cubicInOut(forceDist);

    float nn = crange(sin(time * 2.5), -1.0, 1.0, 1.0, 0.6);
    pos.xz += (pivot.xz * forceDist * 1.5) * nn;

    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * modelViewPos;

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vDistance = -modelViewPos.z;
    
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    vec2 lineUvDistanceCompensated = lineUv * mix(2.0, 0.5, pow(clamp(vDistance * 0.0325, 0.0, 1.0), 2.0)) * 0.5;
    lineUv = mix(lineUv, lineUvDistanceCompensated, uDistanceCompensation);
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float verticalGrad = smoothstep(uVerticalGrad.x, uVerticalGrad.y, vPos.y);
    float lighting = dot(normal, uLightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(uThreshold.x, lighting + lines * 0.45 - vAo * 0.15 - verticalGrad);
    float terminatorhigh = aastep(uThreshold.y, lighting + lines * 0.1 - vAo * 0.15 - verticalGrad);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise * lightMask + lighting * 0.3;
    maskedLines = aastep(0.2, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(18.0 / 255.0), uColor, terminatormid);
    color = mix(color, uColorHighlight, terminatorhigh);
    color *= maskedLines;

    float alpha = 1.0 - color.r;
    color = max(vec3(18.0 / 255.0), color);

    gl_FragColor = vec4(color, alpha);
}{@}PillarFractureShaderInverse.glsl{@}#!ATTRIBUTES
attribute float ao;
attribute vec3 pivot;

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec2 uThreshold;
uniform vec3 uAxis;
uniform float uAngle;
uniform float uDistanceCompensation;
uniform vec3 uColorHighlight;
uniform vec3 uColor;
uniform vec2 uVerticalGrad;
uniform float uFractureThreshold;
uniform float uTimeOffset;
uniform float uLineWidth;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform vec3 uMouse;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying vec3 vPos;
varying float vAo;
varying float vHeight;
varying float vDistance;
varying float vNdcHeight;

#!SHADER: Vertex
#require(simplenoise.glsl)
#require(range.glsl)
#require(eases.glsl)

//----------------------------------------------------------------------------------------
//  3 out, 1 in...
vec3 hash31(float p)
{
   vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
   p3 += dot(p3, p3.yzx+33.33);
   return fract((p3.xxy+p3.yzz)*p3.zyx); 
}

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normalMatrix * normal);
    vAo = ao;
    vHeight = position.y;
    vPos = position;

    vec3 pos = position;

    float steppedTime = floor(time * 6.0 + uTimeOffset) * 0.1;

    vec3 dir = normalize(pivot);
    vec3 axis = hash31(pivot.x + pivot.y);
    axis = axis * 2.0 - 1.0;
    axis = normalize(axis);
    float angle = max(0.0, pivot.y - 0.5 - sin(steppedTime + pivot.z * 15.0 + uFractureThreshold) * 0.2) * 0.5;
    float angle2 = abs(sin(pivot.y * 55.0 - steppedTime + pivot.z * 10.0) * pivot.y);
    
    mat3 r = rotation3d(axis, angle + angle2 * 0.25);

    float scale = 1.0 + angle2 * 0.1;

    pos -= pivot;
    pos = r * pos;
    // pos *= scale;
    pos += dir * vec3(1.0, 0.2, 1.0) * angle;
    pos.y += pow(pivot.y, 5.0) * 0.5;
    pos.x += angle2 * 0.01;
    pos += pivot;

    // worldPosition
    vec3 worldPos = (modelMatrix * vec4(pivot, 1.0)).xyz;
    float mouseDist = distance(worldPos, uMouse);
    float forceDist = 1.0 - smoothstep(0.0, 1.3, mouseDist);
    forceDist = cubicInOut(forceDist);

    float nn = crange(sin(time * 2.5), -1.0, 1.0, 1.0, 0.6);
    pos.xz += (pivot.xz * forceDist * 1.5) * nn;


    vec4 modelViewPos = modelViewMatrix * vec4(pos, 1.0);

    vec4 projectionPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vec4 projectionNormal = projectionMatrix * modelViewMatrix * vec4(normal, 0.0);
    
    float aspect = resolution.x / resolution.y;
    projectionPos.xy += projectionNormal.xy * uLineWidth * sqrt(projectionPos.w) * 2.0;
    
    gl_Position = projectionPos;

    vLineUv = (rotation3d(normalize(uAxis), uAngle) * position).xy;
    vDistance = -modelViewPos.z;
    
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    vec3 color = vec3(0.0);
    float alpha = 1.0;

    gl_FragColor = vec4(color, alpha);
}{@}CopyShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;

  if (uFixed > 0.5) {
    gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(position, 1.0);
  } else {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
}

#!SHADER: Fragment
void main() {
  gl_FragColor = texture2D(tMap, vUv);
  gl_FragColor.a *= uAlpha;
  gl_FragColor.rgb /= gl_FragColor.a;
}{@}CursorShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tText;
uniform vec3 uTint;
uniform vec2 uVelocity;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;

    vec3 pos = position;

    // Calculate velocity magnitude for stretch intensity
    vec2 vel2D = uVelocity;
    float velocityMag = length(vel2D);

    // Normalize velocity direction
    vec2 velDir = normalize(vel2D);

    if (velocityMag > 0.) {
        // Create stretch factor (adjust multiplier for more/less stretch)
        float stretchFactor = velocityMag * 0.03;
        stretchFactor = min(stretchFactor, 1.0); // Cap maximum stretch

        // Offset the entire mesh center backward along velocity to create trailing effect
        vec2 centerOffset = -velDir * stretchFactor;
        vec2 pos2D = pos.xy;

        float projectionAlongVel = dot(pos2D, velDir);
        vec2 parallelComponent = velDir * projectionAlongVel;
        vec2 perpendicularComponent = pos2D - parallelComponent;

        // Stretch along velocity direction, compress perpendicular slightly
        vec2 stretchedPos2D = parallelComponent * (1.0 + stretchFactor) +
                perpendicularComponent * (1.0 - stretchFactor * 0.1);

        pos.xy = stretchedPos2D;
    }

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
#require(aastep.glsl)

void main() {
    vec2 screenPos = gl_FragCoord.xy / resolution.xy;
    float color = texture2D(tText, screenPos).r;
    float alpha = aastep(0.5, 1.0 - length(vUv - 0.5));
    gl_FragColor = vec4(mix(vec3(1.0), uTint, color), alpha);
}
{@}TempTextShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;
#!VARYINGS
varying vec2 vUv;
#!SHADER: Vertex
void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  vUv = uv;
}

#!SHADER: Fragment
void main() {
  gl_FragColor = texture2D(tMap, vUv);
}{@}TextCarouselShader.glsl{@}#!ATTRIBUTES
attribute float rowIndex;
attribute float quadIndex;
attribute float rowCount;

#!UNIFORMS
uniform sampler2D tMSDF;
// uniform float uDissolveOut;
uniform float uTranslateIn;
uniform vec3 uColor;
uniform vec2 uBoundsX;
uniform float uDirection;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;

#!VARYINGS
varying vec3 vNormal;
varying vec2 vUv;

varying float vRowIndex;
varying float vQuadIndex;
varying float vRowCount;
varying vec3 vWorldPos;
varying float vT;

#!SHADER: TextCarouselShader.vs
#require(range.glsl)
#require(eases.glsl)

void main() {
    vec3 pos = position;
    vRowIndex = rowIndex;
    vQuadIndex = quadIndex;
    vRowCount = rowCount;
    vUv = uv;
    vNormal = normalMatrix * normal;

    float quadIndex = vQuadIndex / vRowCount;

    float rowTime = rowIndex / 3.;
    float staggerAmount = .1;

    if(abs(uDirection) < 0.01) {
        float distoffset = 0.5;
        float anim = (quadIndex * 2.0 - 1.0) * distoffset;
        float delay = rowTime * staggerAmount;
        delay = clamp((uTranslateIn - delay) / (1.0 - staggerAmount), 0.0, 1.0);
        delay = smoothstep(0., 1.0, delay);
        delay = expoOut(delay);

        pos.x += (1.0 - delay) * anim;
        vT = delay;
    } else {
        float dirIn = sign(uDirection);

        float edgeIndexIn = (dirIn > 0.0) ? (vRowCount - vQuadIndex) : vQuadIndex;

        float rowDen = max(vRowCount, 1.0);
        float startIn = (1.0 - (edgeIndexIn) / rowDen) * staggerAmount;

        float tIn = clamp((uTranslateIn - startIn) / (1.0 - staggerAmount), 0.0, 1.0);
        tIn = smoothstep(0., 1.0, tIn);
        vT = cubicIn(tIn);
        tIn = expoIn(tIn);

        pos.x += (1.0 - tIn) * (dirIn * rowIndex);
        // vT = tIn;
        // vOT = expoIn(tIn * 4.0);
    }

    vWorldPos = (modelMatrix * vec4(pos, 1.0)).xyz;

    if(uFixed > 0.5) {
        // pos.y += 0.1;
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(pos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }
}

#!SHADER: TextCarouselShader.fs

#require(aastep.glsl)
#require(eases.glsl)
#require(msdf.glsl)

void main() {
    // float quadIndex = vQuadIndex / vRowCount;
    // float dist = texture2D(tSDF, vUv).r;
    // float opacity = texture2D(tMap, vUv).r;
    // dist = pow(dist, 1.0 + (3. * (uDissolveOut)));
    // float signedDist = aastep(0.4, dist);
    // if(vWorldPos.x < uBoundsX.x || vWorldPos.x > uBoundsX.y)
    //     discard;
    // gl_FragColor = vec4(uColor, signedDist * aastep(0.5, opacity) * (1.0 - uDissolveOut));

    // if(vWorldPos.x < uBoundsX.x || vWorldPos.x > uBoundsX.y) discard;

    vec3 tex = texture2D(tMSDF, vUv).rgb;
    float sdf = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float d = fwidth(sdf);
    float padding = 1.0 - vT;
    float alpha = smoothstep(-d + padding, d + padding, sdf);

    gl_FragColor = vec4(uColor, alpha * vT);
}{@}HairShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform vec3 uBreathe;
uniform float uBend;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;
varying float vHeight;
varying float vNdcHeight;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vUv = uv;
    vNormal = normalize(normalMatrix * normal);
    vLineUv = (rotation3d(normalize(vec3(1.0, 0.0, 0.3)), 0.75) * position).xy;
    vHeight = position.y;

    vec3 pos = position;

    // breathe animation
    float mask = smoothstep(uBreathe.x, uBreathe.y, position.y);
    vec3 pivot = vec3(0.0, 0.2, -0.1);
    pos -= pivot;
    pos = rotation3d(vec3(1.0, 0.0, 0.0), (2.5 * uBreathe.z + sin(floor(time * 8.0) * 0.3 - mask * 2.0)) * 0.02 * (mask * 0.6 + 0.2) * uBreathe.z + uBend * mask) * pos;
    pos += pivot;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    // hair card texture
    vec4 atlas = texture2D(tAtlas, vUv);
    if (atlas.a < 0.3) discard;

    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vUv * 0.4;
    lineUv.x -= steppedTime * 2.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // lighting
    float lighting = dot(normal, normalize(vec3(0.5, 0.75, 2.0)));
    lighting = pow(lighting, 3.0);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.8, lighting - lines * 0.4 - vUv.x * 0.8);

    // compositing;
    vec3 color = vec3(terminatormid);

    // make sure bottom half of character sits inside window frame
    // gl_FragDepth = gl_FragCoord.z + clamp(-vHeight, 0.0, 1.0) * 0.01;

    if (!gl_FrontFacing) {
        color = vec3(18.0 / 255.0);
    }

    color = max(vec3(18.0 / 255.0), color);

    float alpha = aastep(0.1, atlas.a);
    gl_FragColor = vec4(color, alpha);

    float heightMask = smoothstep(0.5, 0.51, vHeight);
    // gl_FragColor.rgb = mix(gl_FragColor.rgb, vec3(1.0, 0.0, 0.0), heightMask);
    
    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.003 * heightMask * step(0.2, vNdcHeight);
}{@}ProfileBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying float vNdcHeight;
varying float vAspect;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    
    vUv = uv;
    vUv -= 0.5;
    vUv = rotate2d(-3.14 * 0.15) * vUv;
    vUv += 0.5;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vAspect = resolution.x / resolution.y;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    vec3 brown = vec3(176.0, 156.0, 118.0) / 255.0;
    vec3 lightbrown = vec3(243.0, 242.0, 235.0) / 255.0;

    // scroll uvs
    float steppedTime = -floor(time * 24.0) * 0.002;
    vec2 uv =  vUv * vec2(2.0) - vec2(-steppedTime * vAspect, steppedTime * 0.5);

    // rough noise
    float n1 = texture2D(tNoise, uv + steppedTime * 0.25).r;

    // cloud shapes
    float noise = texture2D(tMap, uv * 0.5).r;
    noise *= texture2D(tMap, uv + steppedTime * 0.5).r;
    noise = clamp(noise, 0.0, 1.0);
    noise = pow(noise, 2.0);

    float scan = 0.2;
    float value = 1.0 - vUv.y;
    value -= (1.0 - pow(noise, 2.0)) * 0.3;
    value -= n1 * 0.2;
    value = clamp(value, 0.0, 1.0);

    float thickness = resolution.y * 0.0035;
    float mask = aastep(scan, value);

    vec3 color = mix(lightbrown, vec3(1.0), aastep(scan, value));

    gl_FragColor = vec4(color, 1.0);
}{@}RetailBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform sampler2D tNoise;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
#require(mousefluid.fs)

void main() {
  vec3 color = uColor;

  vec2 screenUv = gl_FragCoord.xy / resolution.xy;
  screenUv -= 0.5;
  screenUv *= 0.9;
  screenUv += 0.5;
  float fluidMask = smoothstep(0.4, 0.7, texture2D(tFluidMask, screenUv).r);
  vec3 fluid = vec3(texture2D(tFluid, screenUv).xy * fluidMask, fluidMask);

  float steppedTime = floor(time * 8.0) / 8.0;
  float n1 = texture2D(tNoise, screenUv * 1.3 + vec2(-steppedTime * 0.05, steppedTime * 0.02)).r;

  color += fluid * 0.00004;

  // fluid.z *= 0.1 + sin(steppedTime + n1 * 4.0) * 0.5 + 0.5;

  float show = smoothstep(0.0, 0.2 * n1, length(fluid.xy) * 0.01);

  color = mix(color, color - 0.01, step(0.5, fluid.z * n1 * 1.2) * show);

  gl_FragColor = vec4(color, 1.0);
}{@}TargetBorderShader.glsl{@}#!ATTRIBUTES
attribute float inner;
attribute float outer;
attribute vec3 dir;
attribute vec3 color;

#!UNIFORMS
uniform sampler2D tMap;

uniform vec3 uCloudColor;
uniform vec3 uSkyColor;

uniform float uSceneHeightWorld;
uniform float uScreenHeightWorld;
uniform float uMaxWidth;
uniform float uDPR;
uniform float uProgress;
uniform float uDiscardTop;
uniform float uDiscardBottom;
#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vInner;
varying float vOuter;
varying float vDepth;
varying vec3 vColor;
varying float vNdcHeight;

#!SHADER: Vertex
#require(range.glsl)
#require(eases.glsl)
void main() {
    vInner = inner;
    vOuter = outer;
    vUv = uv;
    vColor = color;

    vec3 pos = position;
    float aspect = resolution.x / resolution.y;

    float halfWidth = uScreenHeightWorld * aspect * 0.5;
    float halfHeight = uSceneHeightWorld * 0.5;

    pos.y *= min(halfWidth, halfHeight);
    pos.x *= min(halfWidth, halfHeight);

    if (outer > 0.5) {
        // extend edges
        pos.x += sign(position.x) * outer * halfWidth;
        pos.y += sign(position.y) * outer * halfHeight;
    }

    if (outer < 0.5) {
        pos *= crange(resolution.x, 1600.0, 344.0, 0.75, 1.);
    }


    float scale = 0.8;
    float translate = 0.5;
    float easedProgress = sineOut(uProgress);
    vec4 corners = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 cornerMin = vec4(0.0, 1.5, 3.0, 4.5);
    vec4 cornerMax = vec4(1.5, 3.0, 4.5, 6.0);
    corners = crange(vec4(easedProgress), vec4(0.0), vec4(0.5), vec4(0.0), cornerMax);
    corners = range(corners, cornerMin, cornerMax, vec4(0.0), vec4(1.));
    // color attribute indicates top left corner is red
    if(color == vec3(1.0, 0.0, 0.0)) {
        pos += mix( sign(position) * translate, vec3(0.0), corners.x);
        pos *= mix(scale, 1.0, corners.x);
    }

    // color attribute indicates top right corner is green
    if(color == vec3(0.0, 1.0, 0.0)) {
        pos += mix( sign(position) * translate, vec3(0.0), corners.y);
        pos *= mix(scale, 1.0, corners.y);
    }

    // color attribute indicates bottom left corner is blue
    if(color == vec3(0.0, 0.0, 1.0)) {
        pos += mix( sign(position) * translate, vec3(0.0), corners.z);
        pos *= mix(scale, 1.0, corners.z);
    }

    // color attribute indicates bottom right corner is purple
    if(color == vec3(1.0, 0.0, 1.0)) {
        pos += mix( sign(position) * translate, vec3(0.0), corners.w);
        pos *= mix(scale, 1.0, corners.w);
    }

    // color attribute indicates circle is cyan
    if(color == vec3(0.0, 1.0, 1.0)) {
        pos *= mix(scale, 1.0, corners.w);
    }


    vec4 projPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    projPos.xyz += dir * 0.02;

    gl_Position = projPos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
#require(range.glsl)
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight - 0.05 > 0.0 || uDiscardTop - vNdcHeight + 0.05 < 0.0) discard;

    float steppedTime = floor(time * 8.0) / 8.0;
    
    float noise = texture2D(tMap, vUv.xy * 3.0 + vec2(0.0, steppedTime)).r;


    float thickness = crange(resolution.x, 1600.0, 390.0, 0.4, 0.3);
    float value = 1.0;
    value *= (1.0 - vInner);
    value -= noise * thickness;
    float outline = aastep(1.0 -thickness, value);
    vec3 color = vec3(max(18.0 / 255.0, outline));

    float alpha = aastep(0.01, value);

    gl_FragColor = vec4(color, alpha);
}{@}TargetCharacterShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float windmask;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tTrim;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uSteppedTime;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform float uCutout;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vPos;
varying vec3 vLocalPos;
varying vec3 vNormal;
varying float vNdcHeight;
varying float vAspect;
varying float vCenter;
varying float vWindMask;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {
    vWindMask = windmask;
    vNormal = normal;
    vLocalPos = position;

    float t = floor(time * uSteppedTime) / uSteppedTime;

    vec3 pos = position;

    // wind animation
    pos.y += windmask * sin(t * 1.6 + pos.x * 31.4) * 0.01;
    pos.y += windmask * sin(t * 2.0 + pos.x * 27.4) * 0.015;
    pos.z += windmask * sin(t * 1.47 + pos.y * 5.4) * 0.13;

    float displacement = 0.05;
    pos += normal * displacement * sin(normal * 5.0 + position * 16.0 + t * 5.0) * displacement;

    vec4 worldPos = modelMatrix * vec4(pos, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vAspect = resolution.x / resolution.y;
    vUv = uv;
    vUv2 = uv2;

    // for portal window mask
    vPos = gl_Position.xyz / gl_Position.w;
    vPos.x *= vAspect;
    vPos = 1.0 - (vPos * 0.5 + 0.5);
    vPos.x -= 0.5;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vCenter = (uDiscardBottom + uDiscardTop) * 0.5;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float t = floor(time * uSteppedTime) / uSteppedTime * 0.5;

    vec4 trimData = texture2D(tTrim, vUv);
    if (trimData.a < 0.5) discard;


    float trim = aastep(0.5, trimData.r);
    float atlas = aastep(0.5, texture2D(tMap, vUv2).r);

    float steppedTime = floor(time * uSteppedTime) / uSteppedTime;

    float lines = texture2D(tLines, vLocalPos.xy * vec2(1.5) + vec2(-steppedTime * 0.01, steppedTime * 0.3)).r;
    float theta = dot(normalize(vNormal), normalize(vec3(0.0, 0.0, 1.0))) * 0.5 + 0.5;
    float lighting = theta;
    lighting -= lines * 0.2;
    lighting *= trim;
    lighting *= atlas;
    lighting *= max(0.0, vLocalPos.y - 0.5) * 0.5;
    float value = aastep(0.075, lighting) * (1.0 - aastep(0.3, theta));

    vec3 nearBlack = vec3(18.0 / 255.0);
    vec3 color = vec3(value) * uColor2;
    color = max(nearBlack, color);

    if (length(vPos - vec3(0.0, vCenter, 0.0)) > uCutout) {
        discard;
    };

    gl_FragColor = vec4(color, 1.0);
}{@}TargetPortalShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uSteppedTime;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform float uCutout;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vNdcHeight;
varying float vAspect;
varying float vCenter;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vAspect = resolution.x / resolution.y;
    vUv = uv;

    // for portal window mask
    vPos = gl_Position.xyz / gl_Position.w;
    vPos.x *= vAspect;
    vPos = 1.0 - (vPos * 0.5 + 0.5);
    vPos.x -= 0.5;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vCenter = (uDiscardBottom + uDiscardTop) * 0.5;
}

#!SHADER: Fragment
#require(mousefluid.fs)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    vec2 screenUv = gl_FragCoord.xy / resolution.xy;
    float fluidMask = smoothstep(0.4, 0.7, texture2D(tFluidMask, screenUv).r);
    vec3 fluid = vec3(texture2D(tFluid, screenUv).xy * fluidMask, fluidMask);

    float steppedTime = floor(time * uSteppedTime) / uSteppedTime;

    vec2 nuv = vUv;
    // nuv += (fluid.xy * 0.00001);

    nuv += step(0.2, fluid.z) * 0.03;

    float value = texture2D(tLines, nuv * vec2(1.85, 4.0) + vec2(-steppedTime * 0.05, -steppedTime * 0.3)).r;
    float n1 = texture2D(tNoise, nuv + vec2(-steppedTime * 0.05, steppedTime * 0.02)).r;
    float n2 = texture2D(tNoise, nuv * 1.0 + vec2(steppedTime * 0.025, steppedTime * 0.025)).r;

    fluid.z *= 0.1 + sin(steppedTime + n1 * 3.0) * 0.5 + 0.5;

    fluid.z *= n2;

    value += fluid.z * 0.1;
    value += pow(n1, 5.0) * 2.0;
    value += pow(n2, 5.0) * 0.5;
    value += smoothstep(0.65, 1.0, nuv.x);
    value = aastep(0.35 + fluid.z * 0.1, value);
    vec3 color = mix(uColor2, uColor1, value - fluid.z * 0.2);

    color = mix(color, color * 0.86, step(0.5, sin(fluid.z * 4.0)));

    // vec2 screenUv = gl_FragCoord.xy / resolution.xy;
    // float fluidMask = smoothstep(0.4, 1.0, texture2D(tFluidMask, screenUv).r);
    // color.r += (n1 - n2) * fluidMask * 0.9;

    if (length(vPos - vec3(0.0, vCenter, 0.0)) > uCutout) {
        discard;
    };

    // color = vec3(vUv, 1.0);

    gl_FragColor = vec4(color, 1.0);
}{@}TransitionLineShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uScroll;
uniform float uRepeat;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
  vUv = uv;

  if (uFixed > 0.5) {
    gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(position, 1.0);
  } else {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
}

#!SHADER: Fragment
#require(range.glsl)

float parabola( float x, float k )
{
    return pow( 4.0*x*(1.0-x), k );
}

void main() {

  float blackValue = 1.0;
  blackValue = mix(1.0, 0.0, smoothstep(0.0, 0.8, 1.0 -vUv.y));


  float steppedTime = time * 0.1;//floor(time * 8.0) / 8.0;
  steppedTime += uScroll * 0.0002;

  vec2 noiseUV = vUv.xy;
  noiseUV -= 0.5;
  noiseUV *= uRepeat;
  noiseUV += 0.5;

  float noise = texture2D(tNoise, noiseUV.xy * vec2(4.6, 2.0) + vec2(0.0, -steppedTime)).r;
  float lines = texture2D(tLines, noiseUV.xy * vec2(7.5, 3.0) + vec2(0.0, -steppedTime)).r;

  noise -= blackValue;
  // noise += 0.04;
  noise += lines * 0.65;
  noise *= 1.0 - smoothstep(0.95, 1.0, vUv.y);

  blackValue -= step(0.4, noise);

  // blackValue -= step(0.4, noise) * alpha;

  float alpha = 1.0;

  float bottomNoise = noise;
  bottomNoise = mix(bottomNoise, 0.0, smoothstep(0.0, 0.2, vUv.y));
  alpha = smoothstep(0.0, 0.12 - bottomNoise * 0.2, vUv.y);

  // alpha = smoothstep(0.0, 0.12 - step(0.4, noise * 0.3), vUv.y);

  // float noise2 = smoothstep(0.0, 0.2, 1.0 - vUv.y);
  // noise2 += lines * 0.65;


  vec3 color = mix(vec3(0.071,0.071,0.071), vec3(1.0), step(0.1, blackValue));

  gl_FragColor = vec4(color, alpha);
}{@}FloatingFrameBaseShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute float ao;
attribute float colorid;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uPoint1;
uniform vec3 uPoint2;
uniform vec3 uPoint3;
uniform vec3 uPoint4;
uniform vec3 uCenter;

uniform sampler2D tAtlas;
uniform sampler2D tTrim;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;
uniform vec3 uLightDir;
uniform float uTransition;
uniform float uHover;
// uniform float uAspectRatio;
uniform float uDPR;
uniform float uIdleAnimationOffset;
uniform float uIdleAnimationStrength;
uniform vec3 uColor1;
uniform vec3 uColor2;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec2 vLineUv;
varying vec3 vNormal;
varying float vAo;
varying float vSkinMask;
varying float vBackgroundMask;
varying float vEyeMask;
varying float vIrisMask;
varying float vBackground;
varying vec3 vNdc;
varying vec4 vMvPos;
varying vec3 vLightDir;

#!SHADER: Vertex

mat3 rotation3d(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

void main() {
    vAo = ao;
    vUv = uv;
    vUv2 = uv2;
    vSkinMask = step(0.5, vUv2.y);
    vBackgroundMask = (colorid > 0.5 && colorid < 1.5) ? 1.0 : 0.0;
    vEyeMask = step(1.5, colorid);
    vIrisMask = (colorid > 2.5 && colorid < 3.5) ? 1.0 : 0.0;
    vNormal = normalize(normalMatrix * normal);
    vLineUv = (rotation3d(normalize(vec3(1.0, 0.0, 2.5)), 0.5) * position).xy;
    vLightDir = normalize(uLightDir);

    vec3 pos = position;

    // up/down walking motion
    float t = time * 1.25 + uIdleAnimationOffset;
    pos = rotation3d(vec3(1.0, 0.0, 0.5), sin(floor((t * 8.0 - 5.0)) * 0.5 + position.x * 1.0 - position.z * 2.0) * 0.03 * uIdleAnimationStrength) * position;
    
    // left/right walking motion
    pos = rotation3d(vec3(0.0, 1.0, 0.0), sin(floor(t * 8.0) * 0.25) * 0.1 * uIdleAnimationStrength) * pos;

    vMvPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * vMvPos;

    vNdc = gl_Position.xyz / gl_Position.w;
    vBackground = 1.0 - step(-0.5, position.z - position.x);
}

#!SHADER: Fragment
    float aastep(float threshold, float value) {
        float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
        return smoothstep(threshold-afwidth, threshold+afwidth, value);
    }

    float isLeft( vec3 P0, vec3 P1, vec3 P2 ) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
    }

void main() {
    float transition = uTransition + 0.01;
    // check if ndc point is inside rectangle and discard anything outside
    vec3 pos1 = mix(uCenter, uPoint1, transition);
    vec3 pos2 = mix(uCenter, uPoint2, transition);
    vec3 pos3 = mix(uCenter, uPoint3, transition);
    vec3 pos4 = mix(uCenter, uPoint4, transition);

    float grad1 = isLeft(pos1, pos2, vNdc);
    float grad2 = isLeft(pos2, pos3, vNdc);
    float grad3 = isLeft(pos3, pos4, vNdc);
    float grad4 = isLeft(pos4, pos1, vNdc);

    float sdfx = max(grad2, grad4);
    float sdfy = max(grad1, grad3);

    float aspect = resolution.x / resolution.y;
    // float invaspect = resolution.y / resolution.x;
    // float largestAspect = aspect > invaspect ? aspect : invaspect;

    // add noise
    float steppedTime = floor(time * 8.0) / 8.0 * 0.15;
    float edgeNoise = texture2D(tNoise, vec2(vNdc) + vec2(steppedTime, 0.0)).r;

    edgeNoise -= uHover * 70.0;

    sdfx += edgeNoise * 0.0002 * transition;
    sdfy += edgeNoise * 0.0002 * transition;
    float sdf = max(sdfx, sdfy);
    sdf *= aspect;

    // float dx = dFdx(vNdc.x);
    // float dy = dFdy(vNdc.y);

    // float verticalRatio = resolution.y / resolution.x;
    // float horizontalRatio = resolution.x / resolution.y;
    
    // float width = mix(0.00001, 0.03, uTransition);
    // float outline = aastep(width, -sdf);
    // outline *= aastep(width, -sdfy);

    // float widthX = mix(0.00001, 0.002, uTransition);
    // float widthY = mix(0.00001, 0.002 * uAspectRatio, uTransition);

    float pixelWidth = 3.0 * uDPR; // desired width in pixels
    float widthX = mix(0.00001, pixelWidth * fwidth(sdfx), uTransition);
    float widthY = mix(0.00001, pixelWidth * fwidth(sdfy), uTransition);

    float outline = aastep(widthX, -sdfx) * aastep(widthY, -sdfy);

    if (sdf > 0.005) discard;

    vec3 normal = normalize(vNormal);
    
    // lines
    vec2 lineUv = vLineUv * uLinesTile;
    lineUv.x -= steppedTime * 3.0;
    float lines = texture2D(tLines, lineUv.yx).r * 2.0 - 1.0;

    // trim texture
    float trim = texture2D(tTrim, vUv).r;

    // atlas texture
    float atlas = texture2D(tAtlas, vUv2).r;
    atlas = aastep(0.55, atlas * trim);

    // lighting
    vec3 lightDir = vLightDir;
    float lighting = dot(normal, lightDir);
    float lightMask = max(0.0, lighting);
    float terminatormid = aastep(0.0, lighting + lines * 0.1);
    float terminatorhigh = aastep(0.9, lighting + lines * 0.075);
    float terminatorbounce = 1.0 - aastep(-0.91, lighting - lines * 0.2);

    // reduce lines in areas of brightness
    float maskedLines = lines + lightMask * 0.7;

    // break up lines with dots as light gets brighter
    float noise = texture2D(tNoise, lineUv * 2.0).r;
    maskedLines += noise* pow(lightMask, 2.0) * 3.0;
    maskedLines = aastep(0.01, maskedLines);

    // compositing;
    vec3 color = vec3(1.0);
    color = mix(vec3(0.0), uColor1, terminatormid);
    color = mix(color, vec3(1.0), vSkinMask);
    color = mix(color, uColor2, vIrisMask);
    color *= maskedLines;
    color *= trim;
    color *= atlas;
    color = mix(color, vec3(44.0, 44.0, 46.0) / 255.0, vBackgroundMask);

    // vec3 backgroundColor = vec3(1.0);
    // color = mix(color, backgroundColor, step(0.5, vBackground));
    color *= outline;

    if (!gl_FrontFacing) {
        color = vec3(0.0);
    }

    float fresnel = dot(vNormal, -normalize(vMvPos.xyz));
    fresnel = pow(fresnel, 5.0);
    fresnel = aastep(0.01, fresnel + noise * 0.01);
    color *= mix(fresnel, 1.0, vBackgroundMask);

    // if (sdf > 0.0025) color = vec3(1.0, 0.0, 0.0);
    float alpha = (1.0 - aastep(0.00001, sdf));

    color = max(vec3(18.0 / 255.0), color);

    gl_FragColor = vec4(color, alpha);

    // move elements in front of frame border
    gl_FragDepth = gl_FragCoord.z - 0.3;
}{@}WanderBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uScroll;
uniform float uHeightWorld;
uniform float uProgress;

uniform sampler2D tMap;
uniform sampler2D tNoise;
uniform vec3 uColor;
uniform vec3 uCloudColor;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vNdcHeight;
varying float vAspect;

#!SHADER: Vertex
void main() {

    vAspect = resolution.y / resolution.x;
    vPos = position;
    vPos.x /= vAspect;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vPos, 1.0);
    
    vUv = uv;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment
#require(mousefluid.fs)
#require(range.glsl)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    float fluidMask = getFluidMask();

    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    // scroll uvs
    float steppedTime = -floor(time * 24.0) * 0.004;
    vec2 uv =  vUv * vec2(3.0 / vAspect, 3.0) - vec2(-steppedTime * vAspect, steppedTime * 0.5);

    // rough noise
    float n1 = texture2D(tNoise, uv + steppedTime * 0.25).r;

    // cloud shapes
    float noise = texture2D(tMap, uv * 0.75).r;
    noise *= texture2D(tMap, uv + steppedTime * 0.5).r;
    noise = clamp(noise, 0.0, 1.0);
    noise = pow(noise, 2.0);

    // animate in on scroll
    // float scrollFactor = 1.0 - min(1.0, -uScroll / uHeightWorld);
    float scrollFactor = smoothstep(0.0, 0.8, vUv.y);
    scrollFactor -= crange(-uScroll, 0.0, uHeightWorld, 0.0, 1.0);
    float scan = pow(scrollFactor, 2.0);

    // scan -= fluidMask * 0.05;

    // circular gradient around center
    float haloGrad = length((vPos.xy) * 0.7);
    haloGrad = pow(smoothstep(0.30, 0.08, haloGrad), 3.0);
    float horizonGrad = smoothstep(0.55, 0.45, vUv.y);
    float value = haloGrad * 1.75 + horizonGrad * 1.95;
    value = value * 0.5;
    value += 0.325;
    value += fluidMask * 0.03;
    value -= (1.0 - pow(noise, 2.0)) * 0.6;
    value -= n1 * 0.35;
    value = clamp(value, 0.0, 1.0);

    value *= uProgress;


    float thickness = resolution.y * 0.0035;
    float mask = aastep(scan, value);

    float alpha = aastep(scan + 0.01, value);
    if (alpha < 0.5) discard;

    // vec3 color = mix(uColor, uCloudColor, aastep(scan + 0.01, value));
    vec3 color = vec3(1.0);
    // color = vec3(1.0, 0.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}{@}WanderBorderShader.glsl{@}#!ATTRIBUTES
attribute float inner;
attribute float outer;
attribute float dist;

#!UNIFORMS
uniform sampler2D tMap;

uniform vec3 uCloudColor;
uniform vec3 uSkyColor;

uniform float uPadX;
uniform float uPadY;
uniform float uSceneHeightWorld;
uniform float uScreenHeightWorld;
uniform float uFixedWidth;
uniform float uScroll;
uniform float uProgress;
uniform float uMaxWidth;
uniform float uDPR;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vDist;
varying float vInner;
varying float vOuter;

#!SHADER: Vertex

float qinticInOut(float t) {
  return t < 0.5
    ? +16.0 * pow(t, 5.0)
    : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float exponentialInOut(float t) {
  return t == 0.0 || t == 1.0
    ? t
    : t < 0.5
      ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
      : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float exponentialIn(float t) {
  return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
}

float exponentialOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

void main() {
    vUv = uv;
    vInner = inner;
    vOuter = outer;
    vDist = dist;

    // use scroll or time, whichever value is larger
    float easedScroll = exponentialOut(-uScroll * 2.0 / uSceneHeightWorld);
    float progress = min(1.0, max(uProgress, exponentialIn(min(1.0, easedScroll))));

    vec3 pos = position;
    float aspect = resolution.x / resolution.y;

    vUv.x *= aspect;

    float mask = 1.0 - outer;

    // animate in
    mask *= progress;

    float halfWidth = uScreenHeightWorld * aspect * 0.5;
    float halfHeight = uScreenHeightWorld * 0.5;

    // clamp width to max pixel width
    float resx = resolution.x / uDPR;
    float halfWidthClamped = uScreenHeightWorld * (uMaxWidth / resx) * 0.5 * aspect;
    float blend = resx < uMaxWidth ? 1.0 : outer;
    float width = mix(halfWidthClamped, halfWidth, blend);

    float padx = halfWidth * uPadX;
    float pady = halfHeight * uPadY;
    
    float outlineThickness = 0.1;

    vec3 startPos = position;

    // fit border to world space screen size, with padding
    // if (uFixedWidth > 0.5) {
    //     padx = halfWidth - halfWidth * uPadX;
    // }

    if (pos.x < 0.0) {
        pos.x = -width;
        pos.x += mask * padx;

        startPos.x = -1.0;
    }

    if (pos.x > 0.0) {
        pos.x = width;
        pos.x -= mask * padx;

        startPos.x = 1.0;
    }

    if (pos.y > 0.0) {
        pos.y = halfHeight;
        pos.y -= mask * pady;

        startPos.y = 1.0;
    }

    if (pos.y < 0.0) {
        pos.y = -halfHeight;
        pos.y += mask * pady;

        startPos.y = -1.0;
    }

    // extend top for border of first scene, so you don't see the edge when camera moves
    // additional verts were exported just past the 1.0 range for this purpose
    pos.y += step(1.01, position.y) * 0.2;

    // extend bottom of border for first scene
    pos.y -= (1.0 - step(-1.01, position.y)) * 0.2;

    // extend outer edges
    if (abs(position.x) > 1.01) {
        pos.x += outer * pos.x * 0.15;
    }

    // border of this scene moves with scroll and then halts at the border of the next scene
    pos.y += uScreenHeightWorld;
    pos.y -= min(-uScroll, uSceneHeightWorld - uScreenHeightWorld);
    pos.y -= uScreenHeightWorld * 0.25;

    // position the geometry at the border of the screen
    vec2 norm = vec2(0.0);
    norm.x -= sign(position.x) / aspect;
    norm.y -= sign(position.y);

    // extrude outline in screen space
    vec4 projPos = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    projPos.xy += norm * inner * outlineThickness;

    vec4 finalPos = mix(vec4(startPos, 1.0), projPos, min(1.0, progress));

    gl_Position = finalPos;
}

#!SHADER: Fragment
#require(mousefluid.fs)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float exponentialInOut(float t) {
  return t == 0.0 || t == 1.0
    ? t
    : t < 0.5
      ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
      : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float exponentialOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

float exponentialIn(float t) {
  return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
}

void main() {
    vec2 screenUv = gl_FragCoord.xy / resolution.xy;
    float fluidMask = smoothstep(0.0, 1.0, texture2D(tFluidMask, screenUv).r);
    // fluidMask = faastep(0.5, fluidMask);

    float steppedTime = floor(time * 8.0) / 8.0 * 0.5;
    float noise = texture2D(tMap, vUv * 6.0 + vec2(steppedTime * 0.23, steppedTime)).r;

    // use scroll or time, whichever value is larger
    float easedScroll = exponentialOut(-uScroll * 2.0 / uSceneHeightWorld);
    float progress = 1.0 - min(1.0, max(uProgress, exponentialIn(min(1.0, easedScroll))));

    float inner = vInner;

    float outer = smoothstep(0.0, 0.15, vOuter);

    float alpha = 1.0;
    alpha *= (1.0 - inner);
    alpha *= 1.0 - fluidMask * (1.0 - outer);
    alpha -= noise * 0.6;

    float outline = aastep(0.4, alpha);
    vec3 color = vec3(max(18.0 / 255.0, outline));

    color = mix(vec3(18.0 / 255.0), color, 1.0);

    alpha = aastep(0.0, alpha);

    // alpha = 1.0;
    // color = vec3(vOuter, 1.0, 1.0);

    gl_FragColor = vec4(color, alpha);
}{@}WanderShadow.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tLines;
uniform sampler2D tNoise;
uniform float uLinesTile;

#!VARYINGS
varying vec2 vUv;
varying vec2 vLineUv;

#!SHADER: Vertex

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

void main() {
    vUv = uv;
    vLineUv = vUv - 0.5;
    vLineUv = rotate2d(-0.5) * vLineUv;
    vLineUv *= uLinesTile;
    vLineUv = vLineUv + 0.5;
    vec3 pos = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {

    float steppedTime = floor(time * 8.0) / 8.0 * 0.5 * uLinesTile;
    float t = time * 0.28 * uLinesTile;
    float alpha = texture2D(tMap, vec2(1.0 - vUv.x, 1.0 - vUv.y)).r + 0.55;
    alpha -= texture2D(tLines, (vLineUv.xy * 1.25 - vec2(t, 0.0)) * 0.7 ).r;
    alpha -= texture2D(tNoise, (vUv.xy * 3.0 - vec2(t * 2.0, -steppedTime)) * 0.7).r * (1.0 - vUv.y) * 0.5;
    alpha -= (1.0 - vUv.x) * 0.8;
    alpha = aastep(0.5, alpha);
    if (alpha < 0.5) discard;
    
    vec3 color = vec3(0.0);

    gl_FragColor = vec4(color, alpha);
}{@}WanderSkyShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tNoise;
uniform sampler2D tCloudsNoise;
uniform sampler2D tLines;
uniform float uLinesTile;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uScroll;
uniform float uProgress;
uniform vec3 uColor1;
uniform vec3 uColor2;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying float vNdcHeight;
varying float vAspect;

mat2 rotate2d(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

#!SHADER: Vertex
void main() {

    vec3 pos = position;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vUv2 = uv;

    vUv = uv;
    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);

    vAspect = resolution.x / resolution.y;
}

#!SHADER: Fragment
#require(mousefluid.fs)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float exponentialOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

void main() {
    float fluidMask = getFluidMask();

    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = floor(time * 24.0) / 24.0;
    float t = steppedTime * 0.05;

    vec2 uv = vUv;

    vec2 distortion = vec2(0.0, sin(uv.x * 7.0) + sin(uv.x * 5.3)) * 0.1;

    float progress = floor(uProgress * 84.0) / 84.0;
    // float invprogress = 1.0 - progress;
    float invexpprogress = 1.0 - exponentialOut(progress);

    invexpprogress -= fluidMask * 0.05;
    // float cloudsnoise = texture2D(tCloudsNoise, vUv * 2.0 + vec2(-t, 0.0)).r;
    float lines = texture2D(tLines, vUv * 3.0 * vec2(2.0, 1.0) + vec2(-t, 0.0) + distortion).r;
    float grad = sin(-steppedTime + vUv.x * 30.0 + vUv.y * 12.0) * 0.5 + 0.5;
    float circularGrad = clamp(1.1 * length((vUv - vec2(0.5, 0.0)) * vec2(2.0, 1.0)), 0.0, 1.0);

    lines = aastep(0.6, circularGrad - lines * 0.25 + grad * 0.1 + uScroll * 0.025 + invexpprogress);

    vec3 color = mix(uColor1, uColor2, lines);

    gl_FragColor = vec4(color, 1.0);
}{@}WanderTitleShader.glsl{@}#!ATTRIBUTES
attribute float charindex;
attribute float charsperline;
attribute float row;

#!UNIFORMS
uniform sampler2D tOpacity;
uniform sampler2D tLines;
uniform sampler2D tDistance;
uniform sampler2D tNoise;
uniform float uScreenHeightWorld;
uniform float uProgress;
uniform float uMaxWidth;
uniform float uDPR;
uniform float uScale;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying float vOffset;
varying float vProgress;
varying float vProgress2;

#!SHADER: Vertex

float qinticInOut(float t) {
    return t < 0.5
        ? + 16.0 * pow(t, 5.0)
        : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float quarticInOut(float t) {
    return t < 0.5
        ? +8.0 * pow(t, 4.0)
        : -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

float exponentialInOut(float t) {
    return t == 0.0 || t == 1.0
        ? t
        : t < 0.5
        ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
        : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float cubicInOut(float t) {
    return t < 0.5
        ? 4.0 * t * t * t
        : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

void main() {
    float t = uProgress;

    // temp while testing
    // t = fract(t);

    // row time offset
    float rowOffset = row * 0.5;

    // individual character time offset
    vOffset = abs((charindex + 1.0) / charsperline - 0.5) * 2.0;
    vOffset *= 0.5;
    vOffset += rowOffset * 0.5;

    // is char on left or right
    float charsign = sign(charindex - charsperline * 0.5);

    // specific timing for top row ('the')
    if (row < 0.1) {
        vOffset = abs(charindex - 1.0) * 0.1 + 0.35;
        charsign = sign(charindex - 1.0);
    }

    // progress value with no character offset
    float flatProgress = clamp((t - 0.25) * 0.7, 0.0, 1.0);

    // animation with character offset
    float overlap = 0.5;
    vProgress = clamp((t) * (1.0 + overlap) - vOffset * overlap, 0.0, 1.0);

    float rowDelay = 0.125;

    if (row < 0.1) {
        rowDelay = 0.32;
    }

    // animation with row offset
    vProgress2 = clamp((t - rowDelay) * (1.0 + overlap) - rowOffset * overlap * 0.6, 0.0, 1.0);

    // move characters from outwards, in
    vec3 pos = position;
    pos *= uScale;

    float xDistance = 0.25;
    pos.x += exponentialInOut(1.0 - vProgress) * xDistance * charsign;

    // animate rows vertically
    float yDistance = row < 0.1 ? - 0.1 : 0.15;
    pos.y -= exponentialInOut(1.0 - vProgress2) * yDistance;

    // animate entire block of text on z axis
    pos.z += ((1.0 - pow(1.0 - flatProgress, 4.0)));

    // scale to fit screen
    // float aspect = resolution.x / resolution.y;
    // float width = uScreenHeightWorld * aspect;
    // float resx = resolution.x / uDPR;
    // float widthClamped = uScreenHeightWorld * (uMaxWidth / resx) * aspect;
    // float blend = resx < uMaxWidth ? 1.0 : 0.0;
    // width = mix(widthClamped, width, blend);
    // float padPercent = resx < 760.0 ? 0.25 : 0.45;
    // pos *= width * (0.5 - padPercent * 0.5);
    // pos *= uScale;


    vUv = uv;
    vPos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
#require(mousefluid.fs)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float cubicInOut(float t) {
    return t < 0.5
        ? 4.0 * t * t * t
        : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float quarticInOut(float t) {
    return t < 0.5
        ? +8.0 * pow(t, 4.0)
        : -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

float exponentialOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

void main() {
    vec2 uv = vUv;
    float fluidMask = getFluidMask();

    float steppedTime = floor(time * 6.0) / 6.0;
    vec2 displacement = texture2D(tNoise, vUv * 3.0 + steppedTime).rg * 2.0 - 1.0;
    uv += displacement * 0.00125;

    vec3 color = vec3(1.0);

    float opacity = texture2D(tOpacity, uv).r;
    float dist = texture2D(tDistance, uv).r;

    float ease = clamp(1.0 - cubicInOut(vProgress), 0.0, 1.0);
    float maskin = smoothstep(ease - 0.1, ease + 0.1, dist - 0.1);
    float mask = aastep(0.5, opacity);

    mask *= maskin;


    float alpha = mask;

    // float lines = texture2D(tLines, vUv * 2.0).r;
    // float grad = 1.0 - min(1.0, length(vPos.xy) * 0.8);
    // vec3 grey = vec3(58.0 / 255.0);
    // float animatedMask = aastep(1.0 - exponentialOut(vProgress * 1.5 - 0.5), grad - lines * 0.05);
    // color = mix(grey, vec3(1.0), animatedMask);

    color -= fluidMask * 0.1;

    gl_FragColor = vec4(color, alpha);
}{@}DrinkLineShader.glsl{@}#!ATTRIBUTES
attribute vec3 currpos;
attribute vec3 nextpos;
attribute vec3 prevpos;
attribute float random;

#!UNIFORMS
uniform sampler2D tMap;
uniform float uScroll;
uniform float uSpeed;
uniform float uThreshold;
uniform float uThickness;
uniform float uTile;
uniform float uFrameRate;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uAnimate;

#!VARYINGS
varying vec2 vUv;
varying float vRandom;
varying vec3 vPos;
varying float vNdcHeight;

#!SHADER: Vertex

#require(simplenoise.glsl)

void main() {
    vUv = uv;

    float steppedTime = -time * 0.525;

    // if uAnimatePosition set, scroll along in a loop. the pattern must be 20 units long
    vec3 offset = vec3(0.0, 0.0, 0.0);
    vec3 displacedCurrPos = currpos + offset;
    vec3 displacedNextPos = nextpos + offset;
    vec3 displacedPrevPos = prevpos + offset;

    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 projCurrPos = m * vec4(displacedCurrPos, 1.0);
    vec4 projNextPos = m * vec4(displacedNextPos, 1.0);
    vec4 projPrevPos = m * vec4(displacedPrevPos, 1.0);

    vec2 screenCurrPos = projCurrPos.xy / projCurrPos.w;
    vec2 screenNextPos = projNextPos.xy / projNextPos.w;
    vec2 screenPrevPos = projPrevPos.xy / projPrevPos.w;

    vec2 dir1 = normalize(screenNextPos - screenCurrPos);
    vec2 dir2 = normalize(screenCurrPos - screenPrevPos);
    vec2 tangent = normalize(dir1 + dir2);

    vec2 norm = normalize(vec2(-tangent.y, tangent.x));

    // correct for resolution
    float aspect = resolution.y / resolution.x;
    norm.x *= aspect;

    vec4 pos = projCurrPos;
    float thickness = uThickness * pos.w;

    // fade in thickness tip on both sides of the line
    thickness *= smoothstep(0.0, 0.05, uv.y);
    thickness *= smoothstep(0.0, 0.05, 1.0 - uv.y);

    float progressIn = uAnimate + thickness;
    float progressOut = uAnimate;
    float progress = uAnimate > 1.0 ? smoothstep(progressOut - 1.0, progressIn - 1.0, uv.y) : smoothstep(progressIn, progressOut, uv.y);

    float sinNoise = sin(vUv.y * 20.0 + time * 0.1) * 0.3 + sin(vUv.y * 40.0 + time * 0.2) * 0.1;
    vec2 noiseInfluence = vec2(0.05, 0.45);
    pos.xy += vec2(
        -(noiseInfluence.x / 2.0) + sinNoise * noiseInfluence.x,
        -(noiseInfluence.y / 2.0) + sinNoise * noiseInfluence.y
    );
    pos.xy += (norm.xy) * ((uv.x - 0.5) * 2.0) * thickness * progress;

    vPos = currpos;
    // vRandom = random;

    gl_Position = pos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

#require(simplenoise.glsl)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold - afwidth, threshold + afwidth, value);
}

void main() {
    if(uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0)
        discard;

    float steppedTime = -floor(time * uFrameRate) / uFrameRate * uSpeed;
    float noise = texture2D(tMap, vec2(0.0, vUv.y * 1.0 * uTile) + vec2(0.0, steppedTime)).r;

    float scrollFactor = 1.0 - min(1.0, -uScroll * 0.25 + 0.5);

    float threshold = uThreshold + scrollFactor * 0.4 * uAnimate;

    float alpha = 1.0 - abs(vUv.x - 0.5) * 2.0;

    alpha *= step(threshold, noise);

    if(alpha < 0.26)
        discard;
    alpha = aastep(0.25, alpha);

    float stepped = aastep(0.5, vUv.x);
    vec3 color = mix(vec3(1.0), vec3(18.0 / 255.0), stepped);

    // if (uDiscardTop - vNdcHeight < 0.0) {
    //     alpha = 1.0;
    //     color = vec3(1.0, 0.0, 0.0);
    // }

    gl_FragColor = vec4(color, alpha);
}{@}WindBlobShader.glsl{@}#!ATTRIBUTES
attribute vec3 currpos; 
attribute vec3 nextpos;
attribute vec3 prevpos;
attribute float random;

#!UNIFORMS
uniform sampler2D tMap;
uniform float uScroll;
uniform float uSpeed;
uniform float uThreshold;
uniform float uAnimatePosition;
uniform float uTile;
uniform float uFrameRate;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying float vRandom;
varying vec3 vPos;
varying float vNdcHeight;

#!SHADER: Vertex

void main() {
    vUv = uv;

    float steppedTime = -time * 0.725;

    // if uAnimatePosition set, scroll along in a loop. the pattern must be 20 units long
    vec3 offset = vec3((-fract(steppedTime / 20.0) * 20.0 + 15.0) * uAnimatePosition, 0.0, 0.0);
    vec3 displacedCurrPos = currpos + offset;
    vec3 displacedNextPos = nextpos + offset;
    vec3 displacedPrevPos = prevpos + offset;

    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 projCurrPos = m * vec4(displacedCurrPos, 1.0); 
    vec4 projNextPos = m * vec4(displacedNextPos, 1.0);
    vec4 projPrevPos = m * vec4(displacedPrevPos, 1.0);

    vec2 screenCurrPos = projCurrPos.xy / projCurrPos.w;
    vec2 screenNextPos = projNextPos.xy / projNextPos.w;
    vec2 screenPrevPos = projPrevPos.xy / projPrevPos.w;

    vec2 dir1 = normalize(screenNextPos - screenCurrPos);
    vec2 dir2 = normalize(screenCurrPos - screenPrevPos);
    vec2 tangent = normalize(dir1 + dir2);

    vec2 norm = normalize(vec2(-tangent.y, tangent.x));

    // correct for resolution
    float aspect = resolution.y / resolution.x;
    norm.x *= aspect;

    vec4 pos = projCurrPos; 
    float thickness = mix(0.015, 0.0025, fract(random * 16.0 + 0.5)) * pos.w;

    pos.xy += norm.xy * ((uv.x - 0.5) * 2.0) * thickness;

    vPos = currpos;
    vRandom = random;

    gl_Position = pos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float t = floor(time * 16.0) / 16.0;

    float value = 1.0;
    float edgeGrad = 1.0 - abs(vUv.x - 0.5) * 2.0;

    value *= 1.0 - pow(1.0 - edgeGrad, 3.0);

    float noise = texture2D(tMap, vUv * vec2(0.01, 2.0) + vRandom - vec2(0.0, t * 0.1)).r;
    noise *= texture2D(tMap, vUv * vec2(0.005, 2.0) + vRandom * 10.0 - vec2(0.0, t * 0.12)).r;
    noise = pow(noise, 5.0);
    value *= noise;

    // float largeblobs = 1.0;
    // largeblobs *= smoothstep(0.7, 0.9, sin(vUv.y * 10.0 - t + vRandom * 30.0) * 0.5 + 0.5);
    // value *= largeblobs;

    // float smallblobs = 1.0;
    // smallblobs *= smoothstep(0.0, 0.9, sin(vUv.y * 61.0 - t * 1.5 + vRandom * 10.0) * 0.5 + 0.5);
    // smallblobs *= sin(vUv.y * 17.0 - t * 0.5 + vRandom * 10.0);
    // smallblobs = 1.0 - pow(1.0 - smallblobs, 5.0);
    // value += smallblobs * 0.7;

    float alpha = aastep(0.5, value);
    vec3 color = vec3(1.0);

    gl_FragColor = vec4(color, alpha); 
}{@}WindDustShader.glsl{@}#!ATTRIBUTES
attribute vec3 currpos; 
attribute vec3 nextpos;
attribute vec3 prevpos;
attribute float random;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uScroll;
uniform float uSpeed;
uniform float uThreshold;
uniform float uAnimatePosition;
uniform float uTile;
uniform float uFrameRate;
uniform float uThickness;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying float vRandom;
varying vec3 vPos;
varying float vNdcHeight;

#!SHADER: Vertex

void main() {
    vUv = uv;

    float steppedTime = -time * 0.725;

    // if uAnimatePosition set, scroll along in a loop. the pattern must be 20 units long
    vec3 offset = vec3((-fract(steppedTime / 20.0) * 20.0 + 15.0) * uAnimatePosition, 0.0, 0.0);
    vec3 displacedCurrPos = currpos + offset;
    vec3 displacedNextPos = nextpos + offset;
    vec3 displacedPrevPos = prevpos + offset;

    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 projCurrPos = m * vec4(displacedCurrPos, 1.0); 
    vec4 projNextPos = m * vec4(displacedNextPos, 1.0);
    vec4 projPrevPos = m * vec4(displacedPrevPos, 1.0);

    vec2 screenCurrPos = projCurrPos.xy / projCurrPos.w;
    vec2 screenNextPos = projNextPos.xy / projNextPos.w;
    vec2 screenPrevPos = projPrevPos.xy / projPrevPos.w;

    vec2 dir1 = normalize(screenNextPos - screenCurrPos);
    vec2 dir2 = normalize(screenCurrPos - screenPrevPos);
    vec2 tangent = normalize(dir1 + dir2);

    vec2 norm = normalize(vec2(-tangent.y, tangent.x));

    // correct for resolution
    float aspect = resolution.y / resolution.x;
    norm.x *= aspect;

    vec4 pos = projCurrPos; 
    float thickness = mix(0.1, 0.06, random) * pos.w;

    pos.xy += norm.xy * ((uv.x - 0.5) * 2.0) * thickness;

    vPos = currpos;
    vRandom = random;

    gl_Position = pos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float t = floor(time * 12.0) / 12.0;

    float value = 1.0;
    float edgeGrad = 1.0 - abs(vUv.x - 0.5) * 2.0;
    edgeGrad = smoothstep(0.65, 1.0, edgeGrad);

    float noise = texture2D(tMap, vUv * vec2(0.7, mix(3.0, 4.0, vRandom)) + vRandom * 10.0 + vec2(0.0, -t * 0.2)).r;
    noise *= texture2D(tMap, vUv * vec2(0.5, 3.0) + vRandom * 5.0 + vec2(0.0, -t * 0.1)).r;

    value = edgeGrad;
    value *= noise;
    value *= smoothstep(1.0, 0.95, vUv.y);
    value -= (sin(t * 0.25- vUv.y * 4.0 + vRandom * 12.0) * 0.5 + 0.5) * 0.15;

    float alpha = aastep(0.5, value);
    float outline = aastep(0.5 + uThickness * 0.05 * 4.0, value);
    vec3 color = vec3(mix(uColor, vec3(1.0), outline));

    if (alpha < 0.5) {
        discard;
    }

    gl_FragColor = vec4(color, alpha); 
}{@}WindLineShader.glsl{@}#!ATTRIBUTES
attribute vec3 currpos; 
attribute vec3 nextpos;
attribute vec3 prevpos;
attribute float random;

#!UNIFORMS
uniform sampler2D tMap;
uniform float uScroll;
uniform float uSpeed;
uniform float uThreshold;
uniform float uAnimatePosition;
uniform float uTile;
uniform float uFrameRate;
uniform float uDiscardTop;
uniform float uDiscardBottom;

#!VARYINGS
varying vec2 vUv;
varying float vRandom;
varying vec3 vPos;
varying float vNdcHeight;

#!SHADER: Vertex

void main() {
    vUv = uv;

    float steppedTime = -time * 0.725;

    // if uAnimatePosition set, scroll along in a loop. the pattern must be 20 units long
    vec3 offset = vec3((-fract(steppedTime / 20.0) * 20.0 + 15.0) * uAnimatePosition, 0.0, 0.0);
    vec3 displacedCurrPos = currpos + offset;
    vec3 displacedNextPos = nextpos + offset;
    vec3 displacedPrevPos = prevpos + offset;

    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 projCurrPos = m * vec4(displacedCurrPos, 1.0); 
    vec4 projNextPos = m * vec4(displacedNextPos, 1.0);
    vec4 projPrevPos = m * vec4(displacedPrevPos, 1.0);

    vec2 screenCurrPos = projCurrPos.xy / projCurrPos.w;
    vec2 screenNextPos = projNextPos.xy / projNextPos.w;
    vec2 screenPrevPos = projPrevPos.xy / projPrevPos.w;

    vec2 dir1 = normalize(screenNextPos - screenCurrPos);
    vec2 dir2 = normalize(screenCurrPos - screenPrevPos);
    vec2 tangent = normalize(dir1 + dir2);

    vec2 norm = normalize(vec2(-tangent.y, tangent.x));

    // correct for resolution
    float aspect = resolution.y / resolution.x;
    norm.x *= aspect;

    vec4 pos = projCurrPos; 
    float thickness = 0.003 * pos.w;

    pos.xy += norm.xy * ((uv.x - 0.5) * 2.0) * thickness;

    vPos = currpos;
    vRandom = random;

    gl_Position = pos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = -floor(time * uFrameRate) / uFrameRate * mix(0.075, 0.2, vRandom) * uSpeed;
    float noise = texture2D(tMap, vec2(vRandom * 0.314, vUv.y * 1.0 * uTile) + vec2(0.0, steppedTime + vRandom * 2.23 * uTile)).r;
    
    float scrollFactor = 1.0 - min(1.0, -uScroll * 0.25 + 0.5);
    float alpha = 1.0 - abs(vUv.x - 0.5) * 2.0;
    alpha *= step(uThreshold + scrollFactor * 0.4, noise);

    if (alpha < 0.26) discard;
    alpha = aastep(0.25, alpha);

    // vec3 color = vec3(aastep(0.5, vUv.x));
    vec3 color = vec3(18.0 / 255.0);

    // if (uDiscardTop - vNdcHeight < 0.0) {
    //     alpha = 1.0;
    //     color = vec3(1.0, 0.0, 0.0);
    // }

    gl_FragColor = vec4(color, alpha); 
}{@}WindLinesSketchShader.glsl{@}#!ATTRIBUTES
attribute vec3 currpos; 
attribute vec3 nextpos;
attribute vec3 prevpos;
attribute float random;

#!UNIFORMS
uniform sampler2D tMap;
uniform float uScroll;
uniform float uSpeed;
uniform float uThreshold;
uniform float uAnimatePosition;
uniform float uTile;
uniform float uFrameRate;
uniform float uDiscardTop;
uniform float uDiscardBottom;
uniform float uTime;

#!VARYINGS
varying vec2 vUv;
varying float vRandom;
varying vec3 vPos;
varying float vNdcHeight;

#!SHADER: Vertex

#require(simplenoise.glsl)

void main() {
    vUv = uv;

    float steppedTime = -time * 0.525;

    // if uAnimatePosition set, scroll along in a loop. the pattern must be 20 units long
    vec3 offset = vec3((-fract(steppedTime / 20.0) * 20.0 + 15.0) * uAnimatePosition, 0.0, 0.0);
    vec3 displacedCurrPos = currpos + offset;
    vec3 displacedNextPos = nextpos + offset;
    vec3 displacedPrevPos = prevpos + offset;

    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 projCurrPos = m * vec4(displacedCurrPos, 1.0); 
    vec4 projNextPos = m * vec4(displacedNextPos, 1.0);
    vec4 projPrevPos = m * vec4(displacedPrevPos, 1.0);

    vec2 screenCurrPos = projCurrPos.xy / projCurrPos.w;
    vec2 screenNextPos = projNextPos.xy / projNextPos.w;
    vec2 screenPrevPos = projPrevPos.xy / projPrevPos.w;

    vec2 dir1 = normalize(screenNextPos - screenCurrPos);
    vec2 dir2 = normalize(screenCurrPos - screenPrevPos);
    vec2 tangent = normalize(dir1 + dir2);

    vec2 norm = normalize(vec2(-tangent.y, tangent.x));

    // correct for resolution
    float aspect = resolution.y / resolution.x;
    norm.x *= aspect;

    vec4 pos = projCurrPos; 
    float thickness = 0.01 * pos.w;

    pos.xy += norm.xy * ((uv.x - 0.5) * 2.0) * thickness;

    vPos = currpos;
    vRandom = random;

    gl_Position = pos;

    vNdcHeight = 1.0 - (gl_Position.y / gl_Position.w * 0.5 + 0.5);
}

#!SHADER: Fragment

#require(simplenoise.glsl)

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    if (uDiscardBottom - vNdcHeight > 0.0 || uDiscardTop - vNdcHeight < 0.0) discard;

    float steppedTime = -floor((uTime * 6.) * uFrameRate) / uFrameRate * mix(0.075, 0.2, vRandom) * 0.2;
    float noise = texture2D(tMap, vec2(vRandom * 0.314, vUv.y * 1.0 * uTile) + vec2(0.0, steppedTime + vRandom * 2.23 * uTile)).r;
    
    float scrollFactor = 1.0 - min(1.0, -uScroll * 0.25 + 0.5);
    float alpha = 1.0 - abs(vUv.x - 0.5) * 2.0;
    alpha *= step(uThreshold + scrollFactor * 0.4, noise);

    if (alpha < 0.26) discard;
    alpha = aastep(0.25, alpha);

    float n = cnoise(vPos.xyz * 1.1);
    float stepped = aastep(0.5, vUv.x + n * 0.3);
    vec3 color = mix(vec3(18.0 / 255.0), vec3(1.0), stepped);

    // if (uDiscardTop - vNdcHeight < 0.0) {
    //     alpha = 1.0;
    //     color = vec3(1.0, 0.0, 0.0);
    // }

    gl_FragColor = vec4(color, alpha); 
}{@}AntimatterSpawn.fs{@}uniform float uMaxCount;
uniform float uSetup;
uniform float decay;
uniform vec2 decayRandom;
uniform sampler2D tLife;
uniform sampler2D tAttribs;
uniform float HZ;

#require(range.glsl)

void main() {
    vec2 uv = vUv;
    #test !window.Metal
    uv = gl_FragCoord.xy / fSize;
    #endtest

    vec4 data = texture2D(tInput, uv);

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    vec4 life = texture2D(tLife, uv);
    vec4 random = texture2D(tAttribs, uv);
    if (life.x > 0.5) {
        data.xyz = life.yzw;
        data.x -= 999.0;
    } else {
        if (data.x < -500.0) {
            data.x = 1.0;
        } else {
            data.x -= 0.005 * decay * crange(random.w, 0.0, 1.0, decayRandom.x, decayRandom.y) * HZ;
        }
    }

    if (uSetup > 0.5) {
        data = vec4(0.0);
    }

    gl_FragColor = data;
}{@}Cube2Equi.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform samplerCube tCube;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = vec2( 1.- uv.x, uv.y );
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#define M_PI 3.1415926535897932384626433832795

void main() {
    vec2 uv = vUv;
    float longitude = uv.x * 2. * M_PI - M_PI + M_PI / 2.;
    float latitude = uv.y * M_PI;

    vec3 dir = vec3(
        - sin( longitude ) * sin( latitude ),
        cos( latitude ),
        - cos( longitude ) * sin( latitude )
    );

    normalize(dir);
    gl_FragColor = textureCube(tCube, dir);
}{@}curve3d.vs{@}uniform sampler2D tCurve;
uniform float uCurveSize;

vec2 getCurveUVFromIndex(float index) {
    float size = uCurveSize;
    vec2 ruv = vec2(0.0);
    float p0 = index / size;
    float y = floor(p0);
    float x = p0 - y;
    ruv.x = x;
    ruv.y = y / size;
    return ruv;
}

vec3 transformAlongCurve(vec3 pos, float idx) {
    vec3 offset = texture2D(tCurve, getCurveUVFromIndex(idx * (uCurveSize * uCurveSize))).xyz;
    vec3 p = pos;
    p.xz += offset.xz;
    return p;
}
{@}advectionManualFilteringShader.fs{@}varying vec2 vUv;
uniform sampler2D uVelocity;
uniform sampler2D uSource;
uniform vec2 texelSize;
uniform vec2 dyeTexelSize;
uniform float dt;
uniform float dissipation;
vec4 bilerp (sampler2D sam, vec2 uv, vec2 tsize) {
    vec2 st = uv / tsize - 0.5;
    vec2 iuv = floor(st);
    vec2 fuv = fract(st);
    vec4 a = texture2D(sam, (iuv + vec2(0.5, 0.5)) * tsize);
    vec4 b = texture2D(sam, (iuv + vec2(1.5, 0.5)) * tsize);
    vec4 c = texture2D(sam, (iuv + vec2(0.5, 1.5)) * tsize);
    vec4 d = texture2D(sam, (iuv + vec2(1.5, 1.5)) * tsize);
    return mix(mix(a, b, fuv.x), mix(c, d, fuv.x), fuv.y);
}
void main () {
    vec2 coord = vUv - dt * bilerp(uVelocity, vUv, texelSize).xy * texelSize;
    gl_FragColor = dissipation * bilerp(uSource, coord, dyeTexelSize);
    gl_FragColor.a = 1.0;
}{@}advectionShader.fs{@}varying vec2 vUv;
uniform sampler2D uVelocity;
uniform sampler2D uSource;
uniform vec2 texelSize;
uniform float dt;
uniform float dissipation;
uniform vec2 uScrollDelta;

void main () {
    vec2 coord = vUv - dt * texture2D(uVelocity, vUv).xy * texelSize;
    // coord -= uScrollDelta;
    coord.y -= uScrollDelta.y * 0.5;
    gl_FragColor = dissipation * texture2D(uSource, coord);
    gl_FragColor.a = 1.0;
}{@}backgroundShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
uniform float aspectRatio;
#define SCALE 25.0
void main () {
    vec2 uv = floor(vUv * SCALE * vec2(aspectRatio, 1.0));
    float v = mod(uv.x + uv.y, 2.0);
    v = v * 0.1 + 0.8;
    gl_FragColor = vec4(vec3(v), 1.0);
}{@}clearShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
uniform float value;
void main () {
    gl_FragColor = value * texture2D(uTexture, vUv);
}{@}colorShader.fs{@}uniform vec4 color;
void main () {
    gl_FragColor = color;
}{@}curlShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uVelocity;
void main () {
    float L = texture2D(uVelocity, vL).y;
    float R = texture2D(uVelocity, vR).y;
    float T = texture2D(uVelocity, vT).x;
    float B = texture2D(uVelocity, vB).x;
    float vorticity = R - L - T + B;
    gl_FragColor = vec4(0.5 * vorticity, 0.0, 0.0, 1.0);
}{@}displayShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
void main () {
    vec3 C = texture2D(uTexture, vUv).rgb;
    float a = max(C.r, max(C.g, C.b));
    gl_FragColor = vec4(C, a);
}{@}divergenceShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uVelocity;
void main () {
    float L = texture2D(uVelocity, vL).x;
    float R = texture2D(uVelocity, vR).x;
    float T = texture2D(uVelocity, vT).y;
    float B = texture2D(uVelocity, vB).y;
    vec2 C = texture2D(uVelocity, vUv).xy;
   if (vL.x < 0.0) { L = -C.x; }
   if (vR.x > 1.0) { R = -C.x; }
   if (vT.y > 1.0) { T = -C.y; }
   if (vB.y < 0.0) { B = -C.y; }
    float div = 0.5 * (R - L + T - B);
    gl_FragColor = vec4(div, 0.0, 0.0, 1.0);
}
{@}fluidBase.vs{@}varying vec2 vUv;
varying vec2 vL;
varying vec2 vR;
varying vec2 vT;
varying vec2 vB;
uniform vec2 texelSize;

void main () {
    vUv = uv;
    vL = vUv - vec2(texelSize.x, 0.0);
    vR = vUv + vec2(texelSize.x, 0.0);
    vT = vUv + vec2(0.0, texelSize.y);
    vB = vUv - vec2(0.0, texelSize.y);
    gl_Position = vec4(position, 1.0);
}{@}gradientSubtractShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uPressure;
uniform sampler2D uVelocity;
vec2 boundary (vec2 uv) {
    return uv;
    // uv = min(max(uv, 0.0), 1.0);
    // return uv;
}
void main () {
    float L = texture2D(uPressure, boundary(vL)).x;
    float R = texture2D(uPressure, boundary(vR)).x;
    float T = texture2D(uPressure, boundary(vT)).x;
    float B = texture2D(uPressure, boundary(vB)).x;
    vec2 velocity = texture2D(uVelocity, vUv).xy;
    velocity.xy -= vec2(R - L, T - B);
    gl_FragColor = vec4(velocity, 0.0, 1.0);
}{@}pressureShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uPressure;
uniform sampler2D uDivergence;
vec2 boundary (vec2 uv) {
    return uv;
    // uncomment if you use wrap or repeat texture mode
    // uv = min(max(uv, 0.0), 1.0);
    // return uv;
}
void main () {
    float L = texture2D(uPressure, boundary(vL)).x;
    float R = texture2D(uPressure, boundary(vR)).x;
    float T = texture2D(uPressure, boundary(vT)).x;
    float B = texture2D(uPressure, boundary(vB)).x;
    float C = texture2D(uPressure, vUv).x;
    float divergence = texture2D(uDivergence, vUv).x;
    float pressure = (L + R + B + T - divergence) * 0.25;
    gl_FragColor = vec4(pressure, 0.0, 0.0, 1.0);
}{@}splatShader.fs{@}varying vec2 vUv;
uniform sampler2D uTarget;
uniform sampler2D uSplatTexture;
uniform float isSplatTexture;
uniform float isSplatSpeed;
uniform float aspectRatio;
uniform vec3 color;
uniform vec3 bgColor;
uniform vec2 point;
uniform vec2 prevPoint;
uniform float radius;
uniform float canRender;
uniform float uAdd;

float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}

vec3 blendScreen(vec3 base, vec3 blend) {
    return vec3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
}

float l(vec2 uv, vec2 point1, vec2 point2) {
    vec2 pa = uv - point1, ba = point2 - point1;
    pa.x *= aspectRatio;
    ba.x *= aspectRatio;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

float cubicOut(float t) {
    float f = t - 1.0;
    return f * f * f + 1.0;
}

void main () {
    vec3 splat = vec3(0.);

    if(isSplatTexture > 0.5) {
        vec2 st = vUv;
        st = 2.*st -1.;
        st.x *= aspectRatio * 0.5625;
        st = 0.5 * st + 0.5;

        if(isSplatSpeed > 0.5) {
            splat = vec3( texture2D(uSplatTexture, st).xy, 1.);
        } else {
            splat = texture2D(uSplatTexture, st).z * color;
        }
    } else {
        splat = (1.0 - cubicOut(clamp(l(vUv, prevPoint.xy, point.xy) / radius, 0.0, 1.0))) * color;
    }

    
    vec3 base = texture2D(uTarget, vUv).xyz;
    base *= canRender;

    vec3 outColor = mix(blendScreen(base, splat), base + splat, uAdd);
    gl_FragColor = vec4(outColor, 1.0);
}{@}vorticityShader.fs{@}varying vec2 vUv;
varying vec2 vL;
varying vec2 vR;
varying vec2 vT;
varying vec2 vB;
uniform sampler2D uVelocity;
uniform sampler2D uCurl;
uniform float curl;
uniform float dt;
void main () {
    float L = texture2D(uCurl, vL).x;
    float R = texture2D(uCurl, vR).x;
    float T = texture2D(uCurl, vT).x;
    float B = texture2D(uCurl, vB).x;
    float C = texture2D(uCurl, vUv).x;
    vec2 force = 0.5 * vec2(abs(T) - abs(B), abs(R) - abs(L));
    force /= length(force) + 0.0001;
    force *= curl * C;
    force.y *= -1.0;
//    force.y += 400.3;
    vec2 vel = texture2D(uVelocity, vUv).xy;
    gl_FragColor = vec4(vel + force * dt, 0.0, 1.0);
}{@}FindTextureMinMaxShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
	vUv = uv;
	gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
uniform sampler2D tMap;
uniform vec2 uSize;
varying vec2 vUv;

const int CELL_SIZE = 2;

void main() {
  // compute the first pixel the source cell
  vec2 srcPixel = floor(gl_FragCoord.xy) * float(CELL_SIZE);

  // one pixel in source
  vec2 onePixel = vec2(1) / uSize;

  // uv for first pixel in cell. +0.5 for center of pixel
  vec2 uv = (srcPixel + 0.5) * onePixel;

  vec4 resultColor = vec4(0.0);

  for (int y = 0; y < CELL_SIZE; ++y) {
    for (int x = 0; x < CELL_SIZE; ++x) {
      resultColor = max(resultColor, texture2D(tMap, uv + vec2(x, y) * onePixel));
    }
  }

  gl_FragColor = resultColor;
}
{@}GainMapDecoderShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
	vUv = uv;
	gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
// min half float value
#define HALF_FLOAT_MIN vec3( -65504, -65504, -65504 )
// max half float value
#define HALF_FLOAT_MAX vec3( 65504, 65504, 65504 )

uniform sampler2D tMap;
uniform sampler2D tGainMap;
uniform vec3 uGamma;
uniform vec3 uOffsetHdr;
uniform vec3 uOffsetSdr;
uniform vec3 uGainMapMin;
uniform vec3 uGainMapMax;
uniform float uWeightFactor;

varying vec2 vUv;

void main() {
  vec3 rgb = texture2D( tMap, vUv ).rgb;
  vec3 recovery = texture2D( tGainMap, vUv ).rgb;
  vec3 logRecovery = pow( recovery, uGamma );
  vec3 logBoost = uGainMapMin * ( 1.0 - logRecovery ) + uGainMapMax * logRecovery;
  vec3 hdrColor = (rgb + uOffsetSdr) * exp2( logBoost * uWeightFactor ) - uOffsetHdr;
  vec3 clampedHdrColor = max( HALF_FLOAT_MIN, min( HALF_FLOAT_MAX, hdrColor ));
  gl_FragColor = vec4( clampedHdrColor , 1.0 );
}
{@}GainMapEncoderShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
	vUv = uv;
	gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
uniform sampler2D tMap;
uniform sampler2D tHDR;
uniform vec3 uGamma;
uniform vec3 uOffsetSDR;
uniform vec3 uOffsetHDR;
uniform float uMinLog2;
uniform float uMaxLog2;

varying vec2 vUv;

void main() {
  vec3 sdrColor = texture2D(tMap, vUv).rgb;
  vec3 hdrColor = texture2D(tHDR, vUv).rgb;

  vec3 pixelGain = (hdrColor + uOffsetHDR) / (sdrColor + uOffsetSDR);
  vec3 logRecovery = (log2(pixelGain) - uMinLog2) / (uMaxLog2 - uMinLog2);
  vec3 clampedRecovery = saturate(logRecovery);
  gl_FragColor = vec4(pow(clampedRecovery, uGamma), 1.0);
}
{@}GPUCompute.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
uniform sampler2D tMap;
void main() {
    gl_FragColor = texture2D(tMap, gl_FragCoord.xy / resolution);
}{@}Line.glsl{@}#!ATTRIBUTES
attribute vec3 previous;
attribute vec3 next;
attribute float side;
attribute float width;
attribute float lineIndex;
attribute vec2 uv2;

#!UNIFORMS
uniform float uLineWidth;
uniform float uBaseWidth;
uniform float uOpacity;
uniform vec3 uColor;

#!VARYINGS
varying float vLineIndex;
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vColor;
varying float vOpacity;
varying float vWidth;
varying float vDist;
varying float vFeather;
varying float vLengthScale;


#!SHADER: Vertex

//params

vec2 fix(vec4 i, float aspect) {
    vec2 res = i.xy / i.w;
    res.x *= aspect;
    return res;
}

void main() {
#test RenderManager.type == RenderManager.VR
    float aspect = (resolution.x / 2.0) / resolution.y;
#endtest
#test RenderManager.type != RenderManager.VR
    float aspect = resolution.x / resolution.y;
#endtest

    vUv = uv;
    vUv2 = uv2;
    vLineIndex = lineIndex;
    vColor = uColor;
    vOpacity = uOpacity;
    vFeather = 0.1;

    vec3 pos = position;
    vec3 prevPos = previous;
    vec3 nextPos = next;
    float lineWidth = 1.0;
    //main

    //startMatrix
    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 finalPosition = m * vec4(pos, 1.0);
    vec4 pPos = m * vec4(prevPos, 1.0);
    vec4 nPos = m * vec4(nextPos, 1.0);
    //endMatrix

    vec2 currentP = fix(finalPosition, aspect);
    vec2 prevP = fix(pPos, aspect);
    vec2 nextP = fix(nPos, aspect);

    float w = uBaseWidth * uLineWidth * width * lineWidth;
    vWidth = w;

    vec4 temp1 = vec4(0.0, 0.0, pos.z, 1.0);
    temp1 = m * temp1;
    vec4 temp2 = vec4(1.0, 0.0, pos.z, 1.0);
    temp2 = m * temp2;
    vLengthScale = abs(temp2.x - temp1.x);

    vec2 dirNC = currentP - prevP;
    vec2 dirPC = nextP - currentP;
    if (length(dirNC) >= 0.0001) dirNC = normalize(dirNC);
    if (length(dirPC) >= 0.0001) dirPC = normalize(dirPC);
    vec2 dir = normalize(dirNC + dirPC);

    //direction
    vec2 normal = vec2(-dir.y, dir.x);
    normal.x /= aspect;
    normal *= 0.5 * w;

    vDist = finalPosition.z / 10.0;

    finalPosition.xy += normal * side;
    gl_Position = finalPosition;
}

#!SHADER: Fragment

//fsparams

void main() {
    float d = (1.0 / (5.0 * vWidth + 1.0)) * vFeather * (vDist * 5.0 + 0.5);
    vec2 uvButt = vec2(0.0, vUv.y);
    float buttLength = 0.5 * vWidth;
    uvButt.x = min(0.5, vUv2.x * vLengthScale / buttLength) + (0.5 - min(0.5, (vUv2.y - vUv2.x) * vLengthScale / buttLength));
    float round = length(uvButt - 0.5);
    float alpha = 1.0 - smoothstep(0.45, 0.5, round);

    /*
        If you're having antialiasing problems try:
        Remove line 93 to 98 and replace with
        `
            float signedDist = tri(vUv.y) - 0.5;
            float alpha = clamp(signedDist/fwidth(signedDist) + 0.5, 0.0, 1.0);

            if (w <= 0.3) {
                discard;
                return;
            }

            where tri function is

            float tri(float v) {
                return mix(v, 1.0 - v, step(0.5, v)) * 2.0;
            }
        `

        Then, make sure your line has transparency and remove the last line
        if (gl_FragColor.a < 0.1) discard;
    */

    vec3 color = vColor;

    gl_FragColor.rgb = color;
    gl_FragColor.a = alpha;
    gl_FragColor.a *= vOpacity;

    //fsmain

    if (gl_FragColor.a < 0.1) discard;
}
{@}LottieShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uSolidColor;
uniform vec3 uSecondColor;
uniform float uSharp;
uniform float uSharpEdge;
uniform float uUseSolidColor;
uniform float uScale;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex

void main() {
  vec3 pos = position * uScale;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
  vUv = uv;
}

#!SHADER: Fragment
float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
  vec4 color = texture2D(tMap, vUv);

  if (uSharp > 0.5) {
    color.a *= aastep(uSharpEdge, color.a);
  }

  if (uUseSolidColor > 0.5) {
    float cut = aastep(0.5, length(color.rgb));
    color.rgb = mix(uSolidColor, uSecondColor, cut);
  }

  gl_FragColor = color;
}{@}mousefluid.fs{@}uniform sampler2D tFluid;
uniform sampler2D tFluidMask;

vec2 getFluidVelocity() {
    float fluidMask = smoothstep(0.1, 0.7, texture2D(tFluidMask, vUv).r);
    return texture2D(tFluid, vUv).xy * fluidMask;
}

vec3 getFluidVelocityMask() {
    float fluidMask = smoothstep(0.1, 0.7, texture2D(tFluidMask, vUv).r);
    return vec3(texture2D(tFluid, vUv).xy * fluidMask, fluidMask);
}

float faastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

float getFluidMask() {
    vec2 screenUv = gl_FragCoord.xy / resolution.xy;
    float fluidMask = smoothstep(0.1, 0.7, texture2D(tFluidMask, screenUv).r);
    return faastep(0.5, fluidMask);
}{@}ProtonAntimatter.fs{@}uniform sampler2D tOrigin;
uniform sampler2D tAttribs;
uniform float uMaxCount;
//uniforms

#require(range.glsl)
//requires

void main() {
    vec2 uv = vUv;
    #test !window.Metal
    uv = gl_FragCoord.xy / fSize;
    #endtest

    vec3 origin = texture2D(tOrigin, uv).xyz;
    vec4 inputData = texture2D(tInput, uv);
    vec3 pos = inputData.xyz;
    vec4 random = texture2D(tAttribs, uv);
    float data = inputData.w;

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    //code

    gl_FragColor = vec4(pos, data);
}{@}ProtonAntimatterLifecycle.fs{@}uniform sampler2D tOrigin;
uniform sampler2D tAttribs;
uniform sampler2D tSpawn;
uniform float uMaxCount;
//uniforms

#require(range.glsl)
//requires

void main() {
    vec3 origin = texture2D(tOrigin, vUv).rgb;
    vec4 inputData = texture2D(tInput, vUv);
    vec3 pos = inputData.xyz;
    vec4 random = texture2D(tAttribs, vUv);
    float data = inputData.w;

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    vec4 spawn = texture2D(tSpawn, vUv);
    float life = spawn.x;

    if (spawn.x < -500.0) {
        pos = spawn.xyz;
        pos.x += 999.0;
        spawn.x = 1.0;
        gl_FragColor = vec4(pos, data);
        return;
    }

    //abovespawn
    if (spawn.x <= 0.0) {
        pos.x = 9999.0;
        gl_FragColor = vec4(pos, data);
        return;
    }

    //abovecode
    //code

    gl_FragColor = vec4(pos, data);
}{@}ProtonNeutrino.fs{@}//uniforms

#require(range.glsl)
//requires

void main() {
    //code
}{@}ProtonTube.glsl{@}#!ATTRIBUTES
attribute float angle;
attribute vec2 tuv;
attribute float cIndex;
attribute float cNumber;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLife;
uniform float radialSegments;
uniform float thickness;
uniform float taper;

#!VARYINGS
varying float vLength;
varying vec3 vNormal;
varying vec3 vViewPosition;
varying vec3 vPos;
varying vec2 vUv;
varying vec2 vUv2;
varying float vIndex;
varying float vLife;
varying vec3 vDiscard;

#!SHADER: Vertex

//neutrinoparams

#require(ProtonTubesUniforms.fs)
#require(range.glsl)
#require(conditionals.glsl)

void main() {
    float headIndex = getIndex(cNumber, 0.0, lineSegments);
    vec2 iuv = getUVFromIndex(headIndex, textureSize);
    vUv2 = iuv;
    float life = texture2D(tLife, iuv).x;
    vLife = life;

    float scale = 1.0;
    //neutrinovs
    vec2 volume = vec2(thickness * 0.065 * scale);

    vec3 transformed;
    vec3 objectNormal;

    //extrude tube
    float posIndex = getIndex(cNumber, cIndex, lineSegments);
    float nextIndex = getIndex(cNumber, cIndex + 1.0, lineSegments);

    vLength = cIndex / (lineSegments - 2.0);
    vIndex = cIndex;

    vec3 current = texture2D(tPos, getUVFromIndex(posIndex, textureSize)).xyz;
    vec3 next = texture2D(tPos, getUVFromIndex(nextIndex, textureSize)).xyz;

    vDiscard = next - current;
    vec3 T = normalize(next - current);
    vec3 B = normalize(cross(T, next + current));
    vec3 N = -normalize(cross(B, T));

    float tubeAngle = angle;
    float circX = cos(tubeAngle);
    float circY = sin(tubeAngle);

    volume *= mix(crange(vLength, 1.0 - taper, 1.0, 1.0, 0.0) * crange(vLength, 0.0, taper, 0.0, 1.0), 1.0, when_eq(taper, 0.0));

    objectNormal.xyz = normalize(B * circX + N * circY);
    transformed.xyz = current + B * volume.x * circX + N * volume.y * circY;
    //extrude tube

    vec3 transformedNormal = normalMatrix * objectNormal;

    vec3 pos = transformed;
    vec4 mvPosition = modelViewMatrix * vec4(transformed, 1.0);
    vViewPosition = -mvPosition.xyz;
    vPos = pos;
    gl_Position = projectionMatrix * mvPosition;

    //neutrinovspost

    vNormal = normalize(transformedNormal);
    vUv = tuv.yx;
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(1.0);
}{@}ProtonTubesMain.fs{@}void main() {
    vec3 index = getData(tIndices, vUv);

    float CHAIN = index.x;
    float LINE = index.y;
    float HEAD = index.z;

    if (HEAD > 0.9) {

        //main

    } else {

        float followIndex = getIndex(LINE, CHAIN-1.0, lineSegments);
        float headIndex = getIndex(LINE, 0.0, lineSegments);
        vec3 followPos = texture2D(tInput, getUVFromIndex(followIndex, textureSize)).xyz;
        vec4 followSpawn = texture2D(tSpawn, getUVFromIndex(headIndex, textureSize));

        if (followSpawn.x <= 0.0) {
            pos.x = 9999.0;
            gl_FragColor = vec4(pos, data);
            return;
        }

        if (length(followPos - pos) > uResetDelta) {
            followPos = texture2D(tInput, getUVFromIndex(headIndex, textureSize)).xyz;
            pos = followPos;
        }

        pos += (followPos - pos) * (uLerp * timeScale * HZ);
    }
}{@}ProtonTubesUniforms.fs{@}uniform sampler2D tIndices;
uniform float textureSize;
uniform float lineSegments;
uniform float uLerp;
uniform float uResetDelta;

vec2 getUVFromIndex(float index, float textureSize) {
    float size = textureSize;
    vec2 ruv = vec2(0.0);
    float p0 = index / size;
    float y = floor(p0);
    float x = p0 - y;
    ruv.x = x;
    ruv.y = y / size;
    return ruv;
}

float getIndex(float line, float chain, float lineSegments) {
    return (line * lineSegments) + chain;
}{@}SceneLayout.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vec3 pos = position;
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = texture2D(tMap, vUv);
    gl_FragColor.a *= uAlpha;
    gl_FragColor.rgb /= gl_FragColor.a;
}{@}GaussianBlurPass.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec2 uSize;
uniform vec2 uDirection;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Fragment
#require(gaussianblur.fs)

#test Tests.blurSamples() == 13
    #define blur blur13
#endtest
#test Tests.blurSamples() == 9
    #define blur blur9
#endtest
#test Tests.blurSamples() == 5
    #define blur blur5
#endtest

void main() {
    vec2 uv = vUv;
    gl_FragColor = texture2D(tDiffuse, uv);
}
{@}GLUIShape.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS

#!SHADER: Vertex
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(uColor, uAlpha);
}{@}GLUIShapeBitmap.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tMask;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = texture2D(tMap, vUv) * texture2D(tMask, vUv).a;
    gl_FragColor.a *= uAlpha;
}{@}Text3D.glsl{@}#!ATTRIBUTES
attribute vec3 animation;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;
uniform float uOpacity;
uniform vec3 uTranslate;
uniform vec3 uRotate;
uniform float uTransition;
uniform float uWordCount;
uniform float uLineCount;
uniform float uLetterCount;
uniform float uByWord;
uniform float uByLine;
uniform float uPadding;
uniform vec3 uBoundingMin;
uniform vec3 uBoundingMax;
uniform float uFixed;
uniform mat4 uFixedCameraMatrix;

#!VARYINGS
varying float vTrans;
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(range.glsl)
#require(eases.glsl)
#require(rotation.glsl)
#require(conditionals.glsl)

void main() {
    vUv = uv;
    vTrans = 1.0;

    vec3 pos = position;

    if (uTransition > 0.0 && uTransition < 1.0) {
        float padding = uPadding;
        float letter = (animation.x + 1.0) / uLetterCount;
        float word = (animation.y + 1.0) / uWordCount;
        float line = (animation.z + 1.0) / uLineCount;

        float letterTrans = rangeTransition(uTransition, letter, padding);
        float wordTrans = rangeTransition(uTransition, word, padding);
        float lineTrans = rangeTransition(uTransition, line, padding);

        vTrans = mix(cubicOut(letterTrans), cubicOut(wordTrans), 0.0);
        vTrans = mix(vTrans, cubicOut(lineTrans), 1.0);

        float invTrans = (1.0 - vTrans);
        vec3 nRotate = normalize(uRotate);
        vec3 axisX = vec3(1.0, 0.0, 0.0);
        vec3 axisY = vec3(0.0, 1.0, 0.0);
        vec3 axisZ = vec3(0.0, 0.0, 1.0);
        vec3 axis = mix(axisX, axisY, when_gt(nRotate.y, nRotate.x));
        axis = mix(axis, axisZ, when_gt(nRotate.z, nRotate.x));
        pos = vec3(vec4(position, 1.0) * rotationMatrix(axis, radians(max(max(uRotate.x, uRotate.y), uRotate.z) * invTrans)));
        pos += uTranslate * invTrans;
    }

    vPos = pos;
	vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));

    if (uFixed > 0.5) {
        gl_Position = projectionMatrix * uFixedCameraMatrix * modelMatrix * vec4(pos, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }
}

#!SHADER: Fragment

#require(range.glsl)
#require(msdf.glsl)
#require(simplenoise.glsl)

vec2 getBoundingUV() {
    vec2 uv;
    uv.x = crange(vPos.x, uBoundingMin.x, uBoundingMax.x, 0.0, 1.0);
    uv.y = crange(vPos.y, uBoundingMin.y, uBoundingMax.y, 0.0, 1.0);
    return uv;
}

void main() {
    float alpha = msdf(tMap, vUv);

    //float noise = 0.5 + smoothstep(-1.0, 1.0, cnoise(vec3(vUv*50.0, time* 0.3))) * 0.5;

    gl_FragColor.rgb = uColor;
    gl_FragColor.a = alpha * uAlpha * uOpacity * vTrans;
}
{@}TweenUILPathFallbackShader.glsl{@}#!ATTRIBUTES
attribute float speed;

#!UNIFORMS
uniform vec3 uColor;
uniform vec3 uColor2;
uniform float uOpacity;

#!VARYINGS
varying vec3 vColor;

#!SHADER: Vertex

void main() {
    vColor = mix(uColor, uColor2, speed);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(vColor, uOpacity);
}
{@}TweenUILPathShader.glsl{@}#!ATTRIBUTES
attribute float speed;

#!UNIFORMS
uniform vec3 uColor2;

#!VARYINGS

#!SHADER: Vertex

void main() {
    vColor = mix(uColor, uColor2, speed);
}

void customDirection() {
    // Use screen space coordinates for final position, so line thickness is
    // independent of camera.
    finalPosition = vec4(currentP.x / aspect, currentP.y, min(0.0, finalPosition.z), 1.0);
}

#!SHADER: Fragment
float tri(float v) {
    return mix(v, 1.0 - v, step(0.5, v)) * 2.0;
}

void main() {
    float signedDist = tri(vUv.y) - 0.5;
    gl_FragColor.a *= clamp(signedDist/fwidth(signedDist) + 0.5, 0.0, 1.0);
}
{@}InteractiveWaterHeightmap.fs{@}
// uniform vec2 mousePos;
// uniform float mouseSize;
uniform sampler2D tHand;
uniform float viscosityConstant;
uniform float WIDTH;
uniform float uScroll;
// uniform float BOUNDS;

#ifndef PI
#define PI 3.141592653589793
#endif


void main()	{
    vec2 cellSize = 1.0 / resolution;

    vec2 screenUv = gl_FragCoord.xy / resolution.xy;
    screenUv.y -= uScroll;
    vec4 handData = texture2D(tHand, screenUv);
    handData.rgb *= handData.a;
    float handFringe = handData.b;

    vec2 uv = gl_FragCoord.xy * cellSize;

    // heightmapValue.x == height from previous frame
    // heightmapValue.y == height from penultimate frame
    // heightmapValue.z, heightmapValue.w not used
    vec4 heightmapValue = texture2D( heightmap, uv );


    // Get neighbours - treat out-of-bounds as zero (open boundary)
    float mul = 1.0;
    vec2 uvN = uv + vec2(0.0, cellSize.y * mul);
    vec2 uvS = uv + vec2(0.0, -cellSize.y * mul);
    vec2 uvE = uv + vec2(cellSize.x * mul, 0.0);
    vec2 uvW = uv + vec2(-cellSize.x * mul, 0.0);

    // Clamp check - if sampling outside [0,1], use zero instead
    vec4 north = (uvN.y > 1.0) ? vec4(0.0) : texture2D(heightmap, uvN);
    vec4 south = (uvS.y < 0.0) ? vec4(0.0) : texture2D(heightmap, uvS);
    vec4 east  = (uvE.x > 1.0) ? vec4(0.0) : texture2D(heightmap, uvE);
    vec4 west  = (uvW.x < 0.0) ? vec4(0.0) : texture2D(heightmap, uvW);

    // https://web.archive.org/web/20080618181901/http://freespace.virgin.net/hugo.elias/graphics/x_water.htm

    float viscosity = 0.96;
    float newHeight = ( ( north.x + south.x + east.x + west.x ) * 0.5 - heightmapValue.y ) * viscosity;

    // float force = 0.0;
    // force += clamp(handDepth * 0.2, 0.0, 0.3);

    // newHeight += force * 2.5;
    newHeight += handFringe;
    newHeight = clamp(newHeight, -4.0, 100.0);

    heightmapValue.y = heightmapValue.x;
    heightmapValue.x = newHeight;

    gl_FragColor = heightmapValue;

}{@}WaterShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS
varying vec3 vNormal;

#!SHADER: Vertex

#require(water.vs)

void main() {
    vec3 pos = calculateWaterPos();
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(vNormal, 1.0);
}{@}water.vs{@}uniform sampler2D heightmap;
uniform float heightScale;
uniform float WIDTH;
uniform float BOUNDS;

vec3 calculateWaterPos() {
    vec2 cellSize = vec2( 1.0 / WIDTH, 1.0 / WIDTH );
    vec3 objectNormal = vec3(
                        ( texture2D( heightmap, uv + vec2( - cellSize.x, 0 ) ).x - texture2D( heightmap, uv + vec2( cellSize.x, 0 ) ).x ) * WIDTH / BOUNDS,
                        ( texture2D( heightmap, uv + vec2( 0, - cellSize.y ) ).x - texture2D( heightmap, uv + vec2( 0, cellSize.y ) ).x ) * WIDTH / BOUNDS,
                        1.0 );


    vNormal = normalize(normalMatrix * objectNormal);

    float heightValue = texture2D(heightmap, uv).x;
    vec3 pos = position;
    pos.z += heightValue * heightScale;

    return pos;
}{@}DrawShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tSource;
uniform vec2 uPosition;
uniform vec2 uResolution;
uniform float uSharp;
uniform float uSize;
uniform float uTrail;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment

void main() {
    vec2 uv = gl_FragCoord.xy / uResolution.xx;

    float trail = texture2D(tSource, vUv).r;

    vec2 mousePos = vec2(uPosition.x, uResolution.y - uPosition.y) / uResolution.xx;

    float sharp = uSharp * 0.5;
    float circleDist = smoothstep(0. + sharp, 1. - sharp, min(distance(mousePos, uv ) / uSize * 20., 1.));

    gl_FragColor = vec4(vec3(1. - circleDist), 1.);

    gl_FragColor.rgb += trail * uTrail;
}{@}fastblur.fs{@}// from https://www.shadertoy.com/view/ltScRG

#define num_samples 16
#define level_of_detail 2 
#define tile_size (1 << level_of_detail)
#define sigma_val float(num_samples) * 0.25

float gaussian(vec2 i) {
    return exp( -0.5 * dot(i/sigma_val, i/sigma_val) ) / ( 6.28 * sigma_val*sigma_val );
}

vec4 blur(sampler2D sp, vec2 uv, vec2 scale) {
    vec4 result = vec4(0.);  
    int s = num_samples/tile_size;
    for ( int i = 0; i < s*s; i++ ) {
        vec2 d = vec2(i%s, i/s)*float(tile_size) - float(num_samples)/2.;
        result += gaussian(d) * textureLod( sp, uv + scale * d, float(level_of_detail) );
    }
    return result / result.a;
}

vec4 blurAlpha(sampler2D sp, vec2 uv, vec2 scale) {
    vec4 result = vec4(0.);
    float totalWeight = 0.0;
    int s = num_samples/tile_size;
    for ( int i = 0; i < s*s; i++ ) {
        vec2 d = vec2(i%s, i/s)*float(tile_size) - float(num_samples)/2.;
        float weight = gaussian(d);
        vec4 v = textureLod( sp, uv + scale * d, float(level_of_detail) );
        // Premultiply RGB by alpha before accumulating
        result.rgb += weight * v.rgb * v.a;
        result.a += weight * v.a;
        totalWeight += weight;
    }
    // Un-premultiply to get final color
    result.rgb = result.a > 0.001 ? result.rgb / result.a : vec3(0.0);
    result.a /= totalWeight;
    return result;
}
