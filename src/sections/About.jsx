import React, { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

const capabilities = [
  { title: "Web Development", desc: "Custom full-stack and frontend architectural builds." },
  { title: "WordPress Systems", desc: "Tailored themes, API integrations, and core setups." },
  { title: "React Applications", desc: "Interactive client-side interfaces and responsive frameworks." },
  { title: "Frontend Engineering", desc: "Semantic HTML5, modular CSS, clean vanilla JS logic." },
  { title: "UI Implementation", desc: "Converting advanced designer mockups into pixel-perfect structures." },
  { title: "Technical SEO", desc: "Meta tags, clean indexing structure, schema, and page speeds." },
  { title: "Digital Products", desc: "Monetized tools, bookmark savers, and habit platforms." },
  { title: "Content Platforms", desc: "Community information portals and publishing systems." }
];

export default function About() {
  const sectionRef = useRef(null);
  const leftColRef = useRef(null);
  const cardsRef = useRef([]);

  useEffect(() => {
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (prefersReducedMotion) return;

    // Fade in left side on scroll
    gsap.fromTo(leftColRef.current,
      { opacity: 0, y: 50 },
      {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: 'power3.out',
        scrollTrigger: {
          trigger: leftColRef.current,
          start: 'top 80%',
          toggleActions: 'play none none none'
        }
      }
    );

    // Fade in capabilities cards sequentially
    gsap.fromTo(cardsRef.current,
      { opacity: 0, y: 30 },
      {
        opacity: 1,
        y: 0,
        duration: 0.6,
        stagger: 0.1,
        ease: 'power2.out',
        scrollTrigger: {
          trigger: sectionRef.current,
          start: 'top 70%',
          toggleActions: 'play none none none'
        }
      }
    );
  }, []);

  return (
    <section
      id="about"
      ref={sectionRef}
      style={{
        backgroundColor: 'var(--background-secondary)',
        borderTop: '1px solid var(--border-primary)',
        borderBottom: '1px solid var(--border-primary)',
      }}
    >
      <div className="container">
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr',
            gap: '60px',
          }}
          className="about-grid"
        >
          {/* Left Column - Biography */}
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
              ABOUT ME
            </p>
            <h2
              style={{
                fontSize: 'clamp(2rem, 5vw, 3rem)',
                lineHeight: 1.15,
                fontWeight: 500,
                marginBottom: '24px'
              }}
            >
              Developer by skill.<br />
              <span className="text-gradient-purple">Builder by nature.</span>
            </h2>
            <p
              style={{
                fontSize: '1.1rem',
                lineHeight: 1.7,
                color: 'var(--text-secondary)',
                marginBottom: '20px',
                fontWeight: 300
              }}
            >
              I'm Mariya Ansari, a developer and digital creator focused on building useful, visually distinctive web experiences. From WordPress and custom frontend development to digital products and content platforms, I enjoy turning ideas into products people can actually use.
            </p>
            <p
              style={{
                fontSize: '1.1rem',
                lineHeight: 1.7,
                color: 'var(--text-secondary)',
                margin: 0,
                fontWeight: 300
              }}
            >
              I bridge the gap between creative visual execution and rigorous code optimization. My process ensures websites don't just look stunning—they load instantly, rank on Google, and convert visitors into active users.
            </p>
          </div>

          {/* Right Column - Capabilities Grid */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '30px' }}>
            <h3
              style={{
                fontFamily: 'var(--font-heading)',
                fontSize: '1.1rem',
                fontWeight: 600,
                color: 'var(--text-primary)',
                letterSpacing: '0.5px',
                textTransform: 'uppercase',
                margin: 0,
                textAlign: 'left',
                borderBottom: '1px solid var(--border-primary)',
                paddingBottom: '12px'
              }}
            >
              Core Capabilities
            </h3>
            
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
                gap: '20px',
              }}
            >
              {capabilities.map((cap, idx) => (
                <div
                  key={cap.title}
                  ref={el => cardsRef.current[idx] = el}
                  className="glass-panel capability-card"
                  style={{
                    padding: '24px',
                    textAlign: 'left',
                    height: '100%',
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'space-between',
                  }}
                >
                  <div>
                    <h4
                      style={{
                        fontSize: '1.2rem',
                        fontWeight: 500,
                        color: 'var(--text-primary)',
                        marginBottom: '8px'
                      }}
                    >
                      {cap.title}
                    </h4>
                    <p
                      style={{
                        fontSize: '0.9rem',
                        color: 'var(--text-secondary)',
                        lineHeight: 1.5,
                        margin: 0,
                        fontWeight: 300
                      }}
                    >
                      {cap.desc}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>

        </div>
      </div>

      <style>{`
        @media (min-width: 992px) {
          .about-grid {
            grid-template-columns: 0.9fr 1.1fr !important;
          }
        }
        .capability-card {
          border-left: 3px solid var(--border-primary) !important;
        }
        .capability-card:hover {
          border-left-color: var(--accent-secondary) !important;
        }
      `}</style>
    </section>
  );
}
