import React, { useState, useEffect } from 'react';

export default function RotatePhonePrompt() {
  const [showPrompt, setShowPrompt] = useState(false);

  useEffect(() => {
    const checkOrientation = () => {
      const isMobileDevice = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent || '');
      if (isMobileDevice) {
        // If the window is taller than it is wide, we are in portrait mode
        if (window.innerHeight > window.innerWidth) {
          setShowPrompt(true);
        } else {
          setShowPrompt(false);
        }
      } else {
        setShowPrompt(false);
      }
    };

    // Initial check
    checkOrientation();

    // Re-check on resize or orientation change
    window.addEventListener('resize', checkOrientation);
    window.addEventListener('orientationchange', checkOrientation);

    return () => {
      window.removeEventListener('resize', checkOrientation);
      window.removeEventListener('orientationchange', checkOrientation);
    };
  }, []);

  if (!showPrompt) return null;

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      width: '100vw',
      height: '100vh',
      backgroundColor: 'rgba(20, 20, 20, 0.95)',
      color: 'white',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      zIndex: 999999,
      textAlign: 'center',
      padding: '20px',
      backdropFilter: 'blur(5px)'
    }}>
      <div style={{
        fontSize: '4rem',
        marginBottom: '20px',
        animation: 'rotateAnimation 2s infinite ease-in-out'
      }}>
        📱
      </div>
      <h2 style={{
        fontFamily: 'Inter, sans-serif',
        margin: 0,
        marginBottom: '10px',
        fontSize: '1.5rem',
        fontWeight: 'bold'
      }}>
        Please rotate your phone
      </h2>
      <p style={{
        fontFamily: 'Inter, sans-serif',
        margin: 0,
        opacity: 0.8,
        fontSize: '1rem',
        maxWidth: '300px',
        lineHeight: '1.5'
      }}>
        For the best immersive 3D experience, please view this website in landscape mode.
      </p>

      <style>
        {`
          @keyframes rotateAnimation {
            0% { transform: rotate(0deg); }
            50% { transform: rotate(-90deg); }
            100% { transform: rotate(0deg); }
          }
        `}
      </style>
    </div>
  );
}
