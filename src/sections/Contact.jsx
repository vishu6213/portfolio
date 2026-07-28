import React, { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import ContactForm from '../components/ContactForm';

gsap.registerPlugin(ScrollTrigger);

export default function Contact() {
  const containerRef = useRef(null);
  const leftColRef = useRef(null);
  const rightColRef = useRef(null);

  useEffect(() => {
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (prefersReducedMotion) return;

    gsap.fromTo(leftColRef.current,
      { opacity: 0, x: -30 },
      {
        opacity: 1,
        x: 0,
        duration: 0.8,
        ease: 'power3.out',
        scrollTrigger: {
          trigger: containerRef.current,
          start: 'top 80%',
        }
      }
    );

    gsap.fromTo(rightColRef.current,
      { opacity: 0, x: 30 },
      {
        opacity: 1,
        x: 0,
        duration: 0.8,
        ease: 'power3.out',
        scrollTrigger: {
          trigger: containerRef.current,
          start: 'top 80%',
        }
      }
    );
  }, []);

  return (
    <section
      id="contact"
      ref={containerRef}
      style={{
        borderBottom: '1px solid var(--border-primary)',
      }}
    >
      <div className="container">
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr',
            gap: '60px',
            alignItems: 'start',
          }}
          className="contact-layout-grid"
        >
          {/* Left Column - Contact Info */}
          <div
            ref={leftColRef}
            style={{
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'flex-start',
              textAlign: 'left'
            }}
          >
            <p
              style={{
                fontFamily: 'var(--font-heading)',
                fontSize: '0.85rem',
                fontWeight: 600,
                color: 'var(--accent-secondary)',
                letterSpacing: '1.5px',
                textTransform: 'uppercase',
                marginBottom: '16px'
              }}
            >
              GET IN TOUCH
            </p>
            <h2
              style={{
                fontSize: 'clamp(2rem, 5vw, 3rem)',
                lineHeight: 1.15,
                fontWeight: 500,
                marginBottom: '24px'
              }}
            >
              Have an idea?<br />
              <span className="text-gradient-purple">Let's build it.</span>
            </h2>
            <p
              style={{
                fontSize: '1.1rem',
                lineHeight: 1.7,
                color: 'var(--text-secondary)',
                marginBottom: '40px',
                fontWeight: 300
              }}
            >
              I'm open to selected freelance projects, collaborations and interesting digital products. Drop a line using the form or reach out directly via email.
            </p>

            {/* Direct Contacts List */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                <span style={{ fontSize: '0.8rem', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                  Write me an email
                </span>
                <a
                  href="mailto:mariya.ansari@example.com"
                  style={{
                    fontSize: '1.15rem',
                    color: 'var(--text-primary)',
                    fontWeight: 500,
                    textDecoration: 'underline',
                    textUnderlineOffset: '4px'
                  }}
                  className="contact-item-hover"
                >
                  mariya.ansari@example.com
                </a>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', marginTop: '10px' }}>
                <span style={{ fontSize: '0.8rem', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                  Socials & Networks
                </span>
                <div style={{ display: 'flex', gap: '20px', flexWrap: 'wrap', marginTop: '4px' }}>
                  <a
                    href="#github"
                    style={{ fontSize: '0.95rem', color: 'var(--text-secondary)' }}
                    className="contact-item-hover"
                    aria-label="GitHub Profile"
                  >
                    GitHub
                  </a>
                  <a
                    href="#linkedin"
                    style={{ fontSize: '0.95rem', color: 'var(--text-secondary)' }}
                    className="contact-item-hover"
                    aria-label="LinkedIn Profile"
                  >
                    LinkedIn
                  </a>
                  <a
                    href="#instagram"
                    style={{ fontSize: '0.95rem', color: 'var(--text-secondary)' }}
                    className="contact-item-hover"
                    aria-label="Instagram Profile"
                  >
                    Instagram
                  </a>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column - Form */}
          <div ref={rightColRef} style={{ display: 'flex', justifyContent: 'center' }}>
            <ContactForm />
          </div>
        </div>
      </div>

      <style>{`
        @media (min-width: 992px) {
          .contact-layout-grid {
            grid-template-columns: 0.9fr 1.1fr !important;
          }
        }
        .contact-item-hover:hover {
          color: var(--accent-secondary) !important;
        }
      `}</style>
    </section>
  );
}
