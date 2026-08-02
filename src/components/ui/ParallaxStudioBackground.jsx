import React, { useEffect, useRef, useState } from 'react';
import '../../styles/ParallaxStudioBackground.scss';

const defaultLayers = [
  {
    src: '/textures/parallax/background.png',
    alt: 'background',
    speedX: 0.03,
    speedY: 0.038,
    speedZ: 0,
    rotation: 0,
    distance: -200,
    zIndex: 1,
    initialTop: 'calc(50% - 50px)',
    initialLeft: 'calc(50% + 0px)',
    width: '3200px',
  },
  {
    src: '/textures/parallax/fog-7.png',
    alt: 'fog-7',
    speedX: 0.27,
    speedY: 0.32,
    speedZ: 0,
    rotation: 0,
    distance: 850,
    zIndex: 2,
    initialTop: 'calc(50% - 100px)',
    initialLeft: 'calc(50% + 300px)',
    width: '1900px',
  },
  {
    src: '/textures/parallax/mountain-10.png',
    alt: 'mountain-10',
    speedX: 0.095,
    speedY: 0.005,
    speedZ: 0,
    rotation: 0,
    distance: 1110,
    zIndex: 3,
    initialTop: 'calc(50% + 169px)',
    initialLeft: 'calc(50% + 330px)',
    width: '1200px',
  },
  {
    src: '/textures/parallax/fog-6.png',
    alt: 'fog-6',
    speedX: 0.25,
    speedY: 0.28,
    speedZ: 0,
    rotation: 0,
    distance: 1400,
    zIndex: 4,
    initialTop: 'calc(50% + 285px)',
    initialLeft: 'calc(50%)',
    width: '2200px',
    className: 'opacity-30',
  },
  {
    src: '/textures/parallax/mountain-9.png',
    alt: 'mountain-9',
    speedX: 0.125,
    speedY: 0.155,
    speedZ: 0.15,
    rotation: 0.02,
    distance: 1700,
    zIndex: 51,
    initialTop: 'calc(50% + 313px)',
    initialLeft: 'calc(50% - 557px)',
    width: '670px',
  },
  {
    src: '/textures/parallax/fog-5.png',
    alt: 'fog-5',
    speedX: 0.16,
    speedY: 0.105,
    speedZ: 0,
    rotation: 0,
    distance: 1900,
    zIndex: 7,
    initialTop: 'calc(50% + 360px)',
    initialLeft: 'calc(50% + 40px)',
    width: '650px',
  },
  {
    src: '/textures/parallax/mountain-7.png',
    alt: 'mountain-7',
    speedX: 0.1,
    speedY: 0.1,
    speedZ: 0,
    rotation: 0.09,
    distance: 2000,
    zIndex: 19,
    initialTop: 'calc(50% + 223px)',
    initialLeft: 'calc(50% + 495px)',
    width: '738px',
  },
  {
    src: '/textures/parallax/mountain-6.png',
    alt: 'mountain-6',
    speedX: 0.065,
    speedY: 0.05,
    speedZ: 0.05,
    rotation: 0.12,
    distance: 2300,
    zIndex: 18,
    initialTop: 'calc(50% + 120px)',
    initialLeft: 'calc(50% + 590px)',
    width: '408px',
  },
  {
    src: '/textures/parallax/fog-4.png',
    alt: 'fog-4',
    speedX: 0.135,
    speedY: 0.1,
    speedZ: 0,
    rotation: 0,
    distance: 2400,
    zIndex: 11,
    initialTop: 'calc(50% + 223px)',
    initialLeft: 'calc(50% + 460px)',
    width: '590px',
    className: 'opacity-50',
  },
  {
    src: '/textures/parallax/mountain-5.png',
    alt: 'mountain-5',
    speedX: 0.08,
    speedY: 0.05,
    speedZ: 0.13,
    rotation: 0.1,
    distance: 2550,
    zIndex: 12,
    initialTop: 'calc(50% + 320px)',
    initialLeft: 'calc(50% + 230px)',
    width: '725px',
  },
  {
    src: '/textures/parallax/fog-3.png',
    alt: 'fog-3',
    speedX: 0.11,
    speedY: 0.018,
    speedZ: 0,
    rotation: 0,
    distance: 2800,
    zIndex: 113,
    initialTop: 'calc(50% + 210px)',
    initialLeft: 'calc(50% + 5px)',
    width: '1600px',
  },
  {
    src: '/textures/parallax/mountain-4.png',
    alt: 'mountain-4',
    speedX: 0.059,
    speedY: 0.024,
    speedZ: 0.35,
    rotation: 0.14,
    distance: 3200,
    zIndex: 15,
    initialTop: 'calc(50% + 196px)',
    initialLeft: 'calc(50% - 698px)',
    width: '1100px',
  },
  {
    src: '/textures/parallax/mountain-3.png',
    alt: 'mountain-3',
    speedX: 0.04,
    speedY: 0.018,
    speedZ: 0.32,
    rotation: 0.05,
    distance: 3400,
    zIndex: 20,
    initialTop: 'calc(50% - 20px)',
    initialLeft: 'calc(50% + 750px)',
    width: '630px',
  },
  {
    src: '/textures/parallax/fog-2.png',
    alt: 'fog-2',
    speedX: 0.15,
    speedY: 0.0115,
    speedZ: 0,
    rotation: 0,
    distance: 3600,
    zIndex: 16,
    initialTop: 'calc(50% - 20px)',
    initialLeft: 'calc(50% + 698px)',
    width: '1100px',
  },
  {
    src: '/textures/parallax/mountain-2.png',
    alt: 'mountain-2',
    speedX: 0.0235,
    speedY: 0.013,
    speedZ: 0.42,
    rotation: 0.15,
    distance: 3800,
    zIndex: 17,
    initialTop: 'calc(50% + 256px)',
    initialLeft: 'calc(50% + 528px)',
    width: '800px',
  },
  {
    src: '/textures/parallax/mountain-1.png',
    alt: 'mountain-1',
    speedX: 0.027,
    speedY: 0.018,
    speedZ: 0.53,
    rotation: 0.2,
    distance: 4000,
    zIndex: 18,
    initialTop: 'calc(50% + 196px)',
    initialLeft: 'calc(50% - 728px)',
    width: '1100px',
  },
  {
    src: '/textures/parallax/fog-1.png',
    alt: 'fog-1',
    speedX: 0.12,
    speedY: 0.01,
    speedZ: 0,
    rotation: 0,
    distance: 4200,
    zIndex: 21,
    initialTop: 'calc(100% - 355px)',
    initialLeft: 'calc(50% + 100px)',
    width: '1900px',
    className: 'opacity-50',
  },
];

const ParallaxStudioBackground = ({ layers = defaultLayers }) => {
  const containerRef = useRef(null);
  const layerRefs = useRef([]);
  const textRef = useRef(null);

  useEffect(() => {
    let animationFrameId;
    let targetX = 0;
    let targetY = 0;
    let currentX = 0;
    let currentY = 0;

    const handleMouseMove = (e) => {
      targetX = e.clientX - window.innerWidth / 2;
      targetY = e.clientY - window.innerHeight / 2;
    };

    window.addEventListener('mousemove', handleMouseMove);

    const animate = () => {
      // Smooth interpolation
      currentX += (targetX - currentX) * 0.1;
      currentY += (targetY - currentY) * 0.1;

      const cursorPosition = currentX + window.innerWidth / 2;
      const rotateDeg = (currentX / (window.innerWidth / 2)) * 20;

      layerRefs.current.forEach((el, index) => {
        if (!el) return;

        const layer = layers[index];
        const { speedX, speedY, speedZ, rotation } = layer;

        // Extract left value from style instead of computed style for performance
        let computedLeft = window.innerWidth / 2;
        if (layer.initialLeft.includes('calc')) {
          const match = layer.initialLeft.match(/([+-]?\d+)px/);
          if (match) {
            computedLeft += parseInt(match[1]);
          }
        } else if (layer.initialLeft.includes('%')) {
           computedLeft = window.innerWidth * (parseInt(layer.initialLeft) / 100);
        }

        const isInLeft = computedLeft < window.innerWidth / 2 ? 1 : -1;
        const zValue = (cursorPosition - computedLeft) * isInLeft * 0.1;

        el.style.transform = `perspective(2300px) translateZ(${
          zValue * speedZ
        }px) rotateY(${rotateDeg * rotation}deg) translateX(calc(-50% + ${
          -currentX * speedX
        }px)) translateY(calc(-50% + ${currentY * speedY}px))`;
      });

      if (textRef.current) {
        const textSpeedX = 0.07;
        const textSpeedY = 0.05;
        const textSpeedZ = 0.08;
        const textRotation = 0.04;
        const computedLeft = window.innerWidth / 2;
        const isInLeft = computedLeft < window.innerWidth / 2 ? 1 : -1;
        const zValue = (cursorPosition - computedLeft) * isInLeft * 0.1;

        textRef.current.style.transform = `perspective(2300px) translateZ(${
          zValue * textSpeedZ
        }px) rotateY(${rotateDeg * textRotation}deg) translateX(calc(-50% + ${
          -currentX * textSpeedX
        }px)) translateY(calc(-50% + ${currentY * textSpeedY}px))`;
      }

      animationFrameId = requestAnimationFrame(animate);
    };

    animate();

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      cancelAnimationFrame(animationFrameId);
    };
  }, [layers]);

  return (
    <div ref={containerRef} className="parallax-studio-bg">
      <div className="overlay-vignette" />
      {layers.map((layer, index) => (
        <img
          key={index}
          ref={(el) => {
            if (el) layerRefs.current[index] = el;
          }}
          src={layer.src}
          alt={layer.alt}
          decoding="async"
          loading="lazy"
          className={`parallax-layer ${layer.className || ''}`}
          style={{
            width: layer.width,
            top: layer.initialTop,
            left: layer.initialLeft,
            zIndex: layer.zIndex,
            transform: 'translate(-50%, -50%)',
            opacity: layer.className?.includes('opacity-30') ? 0.3 : layer.className?.includes('opacity-50') ? 0.5 : 1
          }}
        />
      ))}
      <div
        ref={textRef}
        className="parallax-text"
        style={{
          top: 'calc(50% - 130px)',
          left: '50%',
          transform: 'translate(-50%, -50%)',
        }}
      >
        <h1>STUDIO</h1>
      </div>
    </div>
  );
};

export default ParallaxStudioBackground;
