import { useState, useEffect, useRef } from 'react';
import * as THREE from 'three';
import gsap from 'gsap';

// High-Performance GLSLHills 3D Animated Shader Background Component
const GLSLHills = ({ cameraZ = 125, planeSize = 256, speed = 0.5 }) => {
  const canvasRef = useRef(null);

  useEffect(() => {
    if (!canvasRef.current) return;

    class Plane {
      constructor() {
        this.uniforms = {
          time: { type: 'f', value: 0 },
        };
        this.mesh = this.createMesh();
        this.time = speed;
      }

      createMesh() {
        // Optimized 120x120 grid resolution for 60fps performance without visual loss
        return new THREE.Mesh(
          new THREE.PlaneGeometry(planeSize, planeSize, 120, 120),
          new THREE.RawShaderMaterial({
            uniforms: this.uniforms,
            vertexShader: `
              #define GLSLIFY 1
              attribute vec3 position;
              uniform mat4 projectionMatrix;
              uniform mat4 modelViewMatrix;
              uniform float time;
              varying vec3 vPosition;

              mat4 rotateMatrixX(float radian) {
                return mat4(
                  1.0, 0.0, 0.0, 0.0,
                  0.0, cos(radian), -sin(radian), 0.0,
                  0.0, sin(radian), cos(radian), 0.0,
                  0.0, 0.0, 0.0, 1.0
                );
              }

              vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
              vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
              vec4 permute(vec4 x) { return mod289(((x*34.0)+1.0)*x); }
              vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }
              vec3 fade(vec3 t) { return t*t*t*(t*(t*6.0-15.0)+10.0); }

              float cnoise(vec3 P) {
                vec3 Pi0 = floor(P);
                vec3 Pi1 = Pi0 + vec3(1.0);
                Pi0 = mod289(Pi0);
                Pi1 = mod289(Pi1);
                vec3 Pf0 = fract(P);
                vec3 Pf1 = Pf0 - vec3(1.0);
                vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
                vec4 iy = vec4(Pi0.yy, Pi1.yy);
                vec4 iz0 = Pi0.zzzz;
                vec4 iz1 = Pi1.zzzz;

                vec4 ixy = permute(permute(ix) + iy);
                vec4 ixy0 = permute(ixy + iz0);
                vec4 ixy1 = permute(ixy + iz1);

                vec4 gx0 = ixy0 * (1.0 / 7.0);
                vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
                gx0 = fract(gx0);
                vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
                vec4 sz0 = step(gz0, vec4(0.0));
                gx0 -= sz0 * (step(0.0, gx0) - 0.5);
                gy0 -= sz0 * (step(0.0, gy0) - 0.5);

                vec4 gx1 = ixy1 * (1.0 / 7.0);
                vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
                gx1 = fract(gx1);
                vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
                vec4 sz1 = step(gz1, vec4(0.0));
                gx1 -= sz1 * (step(0.0, gx1) - 0.5);
                gy1 -= sz1 * (step(0.0, gy1) - 0.5);

                vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
                vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
                vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
                vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
                vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
                vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
                vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
                vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

                vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
                g000 *= norm0.x;
                g010 *= norm0.y;
                g100 *= norm0.z;
                g110 *= norm0.w;
                vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
                g001 *= norm1.x;
                g011 *= norm1.y;
                g101 *= norm1.z;
                g111 *= norm1.w;

                float n000 = dot(g000, Pf0);
                float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
                float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
                float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
                float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
                float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
                float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
                float n111 = dot(g111, Pf1);

                vec3 fade_xyz = fade(Pf0);
                vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
                vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
                float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x);
                return 2.2 * n_xyz;
              }

              void main(void) {
                vec3 updatePosition = (rotateMatrixX(radians(90.0)) * vec4(position, 1.0)).xyz;
                float sin1 = sin(radians(updatePosition.x / 128.0 * 90.0));
                vec3 noisePosition = updatePosition + vec3(0.0, 0.0, time * -30.0);
                float noise1 = cnoise(noisePosition * 0.08);
                float noise2 = cnoise(noisePosition * 0.06);
                vec3 lastPosition = updatePosition + vec3(0.0,
                  noise1 * sin1 * 8.0
                  + noise2 * sin1 * 8.0
                  + pow(sin1, 2.0) * 40.0, 0.0);

                vPosition = lastPosition;
                gl_Position = projectionMatrix * modelViewMatrix * vec4(lastPosition, 1.0);
              }
            `,
            fragmentShader: `
              precision highp float;
              #define GLSLIFY 1
              varying vec3 vPosition;

              void main(void) {
                float opacity = (96.0 - length(vPosition)) / 256.0 * 0.75;
                vec3 color = vec3(0.95, 0.7, 0.35); // Warm golden amber hill lines
                gl_FragColor = vec4(color, opacity);
              }
            `,
            transparent: true
          })
        );
      }

      render(time) {
        this.uniforms.time.value += time * this.time;
      }
    }

    const renderer = new THREE.WebGLRenderer({ canvas: canvasRef.current, antialias: false, alpha: true });
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 10000);
    const clock = new THREE.Clock();
    const plane = new Plane();

    let animId;

    const resize = () => {
      const canvas = canvasRef.current;
      if (!canvas) return;
      renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 1.5));
      renderer.setSize(window.innerWidth, window.innerHeight);
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
    };

    const renderLoop = () => {
      const delta = Math.min(clock.getDelta(), 0.033);
      plane.render(delta);
      renderer.render(scene, camera);
      animId = requestAnimationFrame(renderLoop);
    };

    const init = () => {
      renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 1.5));
      renderer.setSize(window.innerWidth, window.innerHeight);
      renderer.setClearColor(0x000000, 0);
      camera.position.set(0, 16, cameraZ);
      camera.lookAt(new THREE.Vector3(0, 28, 0));
      scene.add(plane.mesh);
      window.addEventListener('resize', resize);
      resize();
      renderLoop();
    };

    init();

    return () => {
      window.removeEventListener('resize', resize);
      cancelAnimationFrame(animId);
      plane.mesh.geometry.dispose();
      plane.mesh.material.dispose();
      renderer.dispose();
    };
  }, [cameraZ, planeSize, speed]);

  return (
    <canvas
      ref={canvasRef}
      style={{
        position: 'absolute',
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        width: '100%',
        height: '100%',
        zIndex: 1,
        pointerEvents: 'none',
      }}
    />
  );
};

export { GLSLHills };

// Preloader Component
const Preloader = ({ onComplete, ready }) => {
  const [isDone, setIsDone] = useState(false);
  const [realProgress, setRealProgress] = useState(0);
  const [active, setActive] = useState(true);
  const [displayProgress, setDisplayProgress] = useState(0);
  const [isMobile, setIsMobile] = useState(false);

  const containerRef = useRef(null);
  const trackerRef = useRef({ val: 0 });
  const readyRef = useRef(ready);
  const exitStarted = useRef(false);

  useEffect(() => {
    readyRef.current = ready;
  }, [ready]);

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth < 768);
    };
    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  // Track THREE loading manager progress
  useEffect(() => {
    let animFrame;
    const origOnStart = THREE.DefaultLoadingManager.onStart;
    const origOnProgress = THREE.DefaultLoadingManager.onProgress;
    const origOnLoad = THREE.DefaultLoadingManager.onLoad;

    THREE.DefaultLoadingManager.onStart = (url, loaded, total) => {
      setActive(true);
      origOnStart?.(url, loaded, total);
    };

    THREE.DefaultLoadingManager.onProgress = (url, loaded, total) => {
      cancelAnimationFrame(animFrame);
      animFrame = requestAnimationFrame(() => {
        setRealProgress((loaded / total) * 100);
      });
      origOnProgress?.(url, loaded, total);
    };

    THREE.DefaultLoadingManager.onLoad = () => {
      cancelAnimationFrame(animFrame);
      setRealProgress(100);
      setActive(false);
      origOnLoad?.();
    };

    return () => {
      THREE.DefaultLoadingManager.onStart = origOnStart;
      THREE.DefaultLoadingManager.onProgress = origOnProgress;
      THREE.DefaultLoadingManager.onLoad = origOnLoad;
    };
  }, []);

  // Compute target progress
  const [targetProgress, setTargetProgress] = useState(0);

  useEffect(() => {
    let newTarget = 0;
    if (active) {
      newTarget = (realProgress / 100) * 88;
    } else {
      if (ready) {
        newTarget = 100;
      } else {
        newTarget = 94;
      }
    }
    setTargetProgress((prev) => Math.max(prev, newTarget));
  }, [realProgress, active, ready]);

  // GSAP smooth interpolation for numbers (0% -> 100%)
  useEffect(() => {
    const distance = targetProgress - trackerRef.current.val;
    let duration = 0.4;
    if (distance > 50) duration = 1.2;
    else if (distance > 25) duration = 0.8;

    gsap.to(trackerRef.current, {
      val: targetProgress,
      duration,
      ease: 'power2.out',
      overwrite: true,
      onUpdate: () => {
        const val = trackerRef.current.val;
        setDisplayProgress(val);

        if (val >= 99.5 && readyRef.current && !exitStarted.current) {
          exitStarted.current = true;
          startExit();
        }
      },
    });
  }, [targetProgress]);

  // Fallback trigger if ready turns true after reaching 99.5%
  useEffect(() => {
    if (trackerRef.current.val >= 99.5 && ready && !exitStarted.current) {
      exitStarted.current = true;
      startExit();
    }
  }, [ready]);

  // Smooth exit transition into website
  const startExit = () => {
    exitStarted.current = true;

    gsap.to(containerRef.current, {
      opacity: 0,
      scale: 1.03,
      duration: 0.7,
      ease: 'power3.inOut',
      onComplete: () => {
        setIsDone(true);
        onComplete?.();
      },
    });
  };

  if (isDone) return null;

  const currentPercentText = `${Math.round(Math.min(100, Math.max(0, displayProgress)))}%`;

  return (
    <div
      ref={containerRef}
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 500,
        width: '100vw',
        height: '100vh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
        background: 'linear-gradient(to bottom, #110e0b, #1e1710)',
        fontFamily: "'Inter', system-ui, -apple-system, sans-serif",
        userSelect: 'none',
        WebkitUserSelect: 'none',
      }}
    >
      {/* === GLSL HILLS ANIMATED SHADER BACKGROUND === */}
      <GLSLHills cameraZ={125} planeSize={256} speed={0.5} />

      {/* === CENTER CONTENT: LIVE LOADING PERCENTAGE === */}
      <div
        style={{
          position: 'relative',
          zIndex: 30,
          margin: 'auto',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          textAlign: 'center',
          paddingLeft: '16px',
          paddingRight: '16px',
        }}
      >
        {/* Large Percentage Counter */}
        <div
          style={{
            color: '#FFFFFF',
            fontSize: isMobile ? '64px' : '96px',
            fontWeight: 900,
            letterSpacing: '-0.02em',
            textShadow: '0 4px 20px rgba(0, 0, 0, 0.4)',
            marginBottom: '8px',
            lineHeight: 1,
          }}
        >
          {currentPercentText}
        </div>

        {/* Progress Bar Track & Fill */}
        <div
          style={{
            width: isMobile ? '260px' : '320px',
            maxWidth: '85vw',
            height: '12px',
            backgroundColor: 'rgba(255, 255, 255, 0.15)',
            borderRadius: '9999px',
            overflow: 'hidden',
            padding: '2px',
            backdropFilter: 'blur(6px)',
            WebkitBackdropFilter: 'blur(6px)',
            border: '1px solid rgba(255, 255, 255, 0.25)',
            marginBottom: '16px',
            boxShadow: 'inset 0 1px 3px rgba(0, 0, 0, 0.3)',
          }}
        >
          <div
            style={{
              height: '100%',
              backgroundColor: '#FFA534',
              borderRadius: '9999px',
              width: `${Math.min(100, Math.max(0, displayProgress))}%`,
              transition: 'width 0.2s ease-out',
              boxShadow: '0 0 12px rgba(255, 165, 52, 0.8)',
            }}
          />
        </div>

        {/* Pill Badge Subtitle */}
        <div
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '8px',
            padding: '8px 24px',
            borderRadius: '9999px',
            backgroundColor: 'rgba(255, 255, 255, 0.12)',
            border: '1px solid rgba(255, 255, 255, 0.25)',
            backdropFilter: 'blur(8px)',
            WebkitBackdropFilter: 'blur(8px)',
            color: '#FFFFFF',
            fontSize: isMobile ? '11px' : '13px',
            fontWeight: 700,
            letterSpacing: '0.15em',
            textTransform: 'uppercase',
            boxShadow: '0 4px 16px rgba(0, 0, 0, 0.2)',
          }}
        >
          <span>LOADING PORTFOLIO EXPERIENCE</span>
        </div>
      </div>
    </div>
  );
};

export default Preloader;
