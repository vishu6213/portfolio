import React, { useState, useEffect } from 'react';

export default function RotatePhonePrompt() {
  const [showPrompt, setShowPrompt] = useState(false);
  const [isDismissed, setIsDismissed] = useState(false);

  useEffect(() => {
    // Check if user already dismissed during this session
    try {
      if (sessionStorage.getItem('rotate_prompt_dismissed') === 'true') {
        setIsDismissed(true);
        return;
      }
    } catch (e) {}

    const checkOrientation = () => {
      const isMobileDevice = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent || '');
      if (isMobileDevice && !isDismissed) {
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
  }, [isDismissed]);

  const handleDismiss = () => {
    setIsDismissed(true);
    setShowPrompt(false);
    try {
      sessionStorage.setItem('rotate_prompt_dismissed', 'true');
    } catch (e) {}
  };

  if (!showPrompt || isDismissed) return null;

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      width: '100vw',
      height: '100vh',
      backgroundColor: 'rgba(20, 20, 20, 0.92)',
      color: 'white',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      zIndex: 999999,
      textAlign: 'center',
      padding: '24px',
      backdropFilter: 'blur(8px)'
    }}>
      <div style={{
        fontSize: '3.5rem',
        marginBottom: '16px',
        animation: 'rotateAnimation 2.2s infinite ease-in-out'
      }}>
        📱
      </div>
      <h2 style={{
        fontFamily: "'Inter', sans-serif",
        margin: 0,
        marginBottom: '10px',
        fontSize: '1.4rem',
        fontWeight: '700',
        letterSpacing: '-0.02em'
      }}>
        Rotate Phone for Best View
      </h2>
      <p style={{
        fontFamily: "'Inter', sans-serif",
        margin: 0,
        marginBottom: '24px',
        opacity: 0.8,
        fontSize: '0.95rem',
        maxWidth: '300px',
        lineHeight: '1.5'
      }}>
        For the full wide 3D experience, landscape mode is recommended.
      </p>

      <button
        onClick={handleDismiss}
        style={{
          padding: '12px 24px',
          fontSize: '0.95rem',
          fontWeight: '600',
          fontFamily: "'Inter', sans-serif",
          color: '#1a1a1a',
          backgroundColor: '#fdf8e2',
          border: 'none',
          borderRadius: '30px',
          cursor: 'pointer',
          boxShadow: '0 4px 14px rgba(0,0,0,0.3)',
          transition: 'transform 0.15s ease, opacity 0.15s ease'
        }}
      >
        Continue in Portrait ➔
      </button>

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
