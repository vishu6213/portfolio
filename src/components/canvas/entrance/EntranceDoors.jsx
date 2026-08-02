import { useRef, useState, useEffect, useMemo } from 'react';
import { useFrame, useThree } from '@react-three/fiber';
import { Text, useTexture } from '@react-three/drei';
import * as THREE from 'three';
import gsap from 'gsap';
import '../shaders/RevealMaterial'; // Registers alpha-discard reveal shader
import { playBackgroundMusic } from '../../../utils/audioManager';
import { useAchievements } from '../../../context/AchievementsContext';
import { isTouchDevice } from '../../../utils/deviceDetect';

// Use same font as App.jsx preload (Inter) - works reliably
const FONT_URL = 'https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuLyfAZ9hjp-Ek-_EeA.woff';



/**
 * EntranceDoors Component - 3D Entrance to the Corridor
 * 
 * Doors that open and camera flies through.
 * EmptyCorridor provides the surrounding corridor context.
 */
const EntranceDoors = ({
    position = [0, 0, 22],
    onComplete,
    corridorHeight = 8, // Taller wall
    corridorWidth = 15 // Wider wall
}) => {
    const leftDoorRef = useRef();
    const rightDoorRef = useRef();
    const leftHandleRef = useRef();
    const rightHandleRef = useRef();
    const rightDoorMaterialRef = useRef(); // GSAP shader control
    const leftDoorMaterialRef = useRef(); // Left door reveal control
    const leftHandleMaterialRef = useRef(); // Left handle reveal control
    const rightHandleMaterialRef = useRef(); // Right handle reveal control
    const leftHandlePaintedRef = useRef(); // Painted handle mesh visibility
    const rightHandlePaintedRef = useRef(); // Painted handle mesh visibility
    const groupRef = useRef();
    const [isOpen, setIsOpen] = useState(false);
    const [isHovered, setIsHovered] = useState(false);
    const [isAnimating, setIsAnimating] = useState(false);
    const [isWindowHovered, setIsWindowHovered] = useState(false);
    const windowAvatarRef = useRef();
    const { camera } = useThree();
    const { unlockAchievement } = useAchievements();

    const [isMobile, setIsMobile] = useState(false);

    useEffect(() => {
        setIsMobile(isTouchDevice() || window.innerWidth < 1000);
    }, []);

    // Dla hooków tekstur musimy obliczyć to raz na starcie
    const isMobileDevice = typeof window !== 'undefined' && (isTouchDevice() || window.innerWidth < 1000);
    const dummyTex = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

    const frameTexture = useTexture('/textures/doors/frame_sketch.webp');
    const doorLeftTexture = useTexture('/textures/doors/door_left_sketch.webp');
    const doorRightTexture = useTexture('/textures/doors/door_right_sketch.webp');

    // Mobile optimization: Don't load painted textures or handles on phones
    const doorRightPaintedTexture = useTexture(isMobileDevice ? dummyTex : '/textures/doors/door_right_painted.webp');
    const doorLeftPaintedTexture = useTexture(isMobileDevice ? dummyTex : '/textures/doors/door_left_painted.webp');
    const handleLeftTexture = useTexture('/textures/doors/handle_left_sketch.webp');
    const handleLeftPaintedTexture = useTexture(isMobileDevice ? dummyTex : '/textures/doors/handle_left_painted.webp');
    const handleRightTexture = useTexture('/textures/doors/handle_right_sketch.webp');
    const handleRightPaintedTexture = useTexture(isMobileDevice ? dummyTex : '/textures/doors/handle_right_painted.webp');

    // Dynamic textures for mobile
    const doorBackTexture = useTexture(isMobileDevice ? '/textures/doors/door_back.webp' : '/textures/doors/door_back_left_sketch.webp');
    const edgeTexture = useTexture(isMobileDevice ? '/textures/doors/pien_sketch.webp' : '/textures/doors/pien.webp');

    const bricksTexture = useTexture('/textures/entrance/wall_bricks_2.webp');
    const stonePathTexture = useTexture('/textures/entrance/stone-path.webp');
    // const catTexture = useTexture('/textures/entrance/cat_sketch.webp'); // Old side cat
    const catFrontBodyTexture = useTexture('/textures/entrance/cat_front_body.webp');
    const windowSketchTexture = useTexture('/textures/entrance/window_sketch.webp');
    const avatarWindowTexture = useTexture('/textures/entrance/avatar_window.webp');
    const treeTexture = useTexture('/textures/entrance/tree_sketch_green.webp');
    const birdTexture = useTexture('/textures/entrance/bird_sketch.webp');
    const mouseTexture = useTexture('/textures/entrance/mouse_hanging.webp');
    const potTexture = useTexture('/textures/entrance/pot_with_duck_colored.webp');
    const bugTexture = useTexture('/textures/entrance/bug_sketch.webp');
    const lampTexture = useTexture(isMobileDevice ? dummyTex : '/textures/entrance/vintage_street_lamp.png');
    const inkSplashTexture = useTexture('/images/ink-splash.webp');
    const speechBubbleTexture = useTexture('/textures/entrance/speech_bubble.webp');

    // Cat Ref
    const leftPupilRef = useRef();
    const rightPupilRef = useRef();
    const catGroupRef = useRef(); // To get world position for tracking
    const bugRef = useRef();

    // Bug Click Animation State
    const [isBugClicked, setIsBugClicked] = useState(false);
    const [textVisible, setTextVisible] = useState(false);
    const [clipProgress, setClipProgress] = useState(0); // 0-1 for pencil drawing reveal
    const inkSplashRef = useRef();
    const handleHideDelayRef = useRef(); // Track pending gsap.delayedCall for handle visibility
    const bugFixedTextRef = useRef();
    const bugClickPos = useRef({ x: 0, y: 0 }); // Store click position

    // Duck Speech Bubble State (Rubber Duck Debugging)
    const [isDuckSpeaking, setIsDuckSpeaking] = useState(false);
    const [duckQuote, setDuckQuote] = useState('');
    const speechBubbleRef = useRef();

    // Rubber Duck Debugging Quotes
    const duckQuotes = [
        "Have you tried console.log()?",
        "Did you clear the cache?",
        "It works on my machine! 🤷",
        "Have you turned it off and on again?",
        "Maybe it's a CSS issue?",
        "Check for missing semicolons!",
        "Did you read the error message?",
        "Have you tried Stack Overflow?",
        "Is it plugged in?",
        "Works in production! 🚀",
    ];

    // Bug Click Handler
    const handleBugClick = (e) => {
        e.stopPropagation();
        if (isBugClicked) return; // Already clicked

        // Store bug position at click time
        if (bugRef.current) {
            bugClickPos.current = {
                x: bugRef.current.position.x,
                y: bugRef.current.position.y
            };
        }

        setIsBugClicked(true);
        document.body.style.cursor = "auto";

        // Animate ink splash scale up
        if (inkSplashRef.current) {
            // Position ink splash at bug's last position
            inkSplashRef.current.position.x = bugClickPos.current.x;
            inkSplashRef.current.position.y = bugClickPos.current.y;
            inkSplashRef.current.scale.set(0, 0, 0);
            inkSplashRef.current.material.opacity = 1;

            gsap.to(inkSplashRef.current.scale, {
                x: 0.8,
                y: 0.8,
                z: 1,
                duration: 0.4,
                ease: 'back.out(1.7)'
            });
        }

        // Pencil drawing effect - smooth reveal from left to right
        setTextVisible(true);
        setClipProgress(0);

        if (bugFixedTextRef.current) {
            bugFixedTextRef.current.position.x = bugClickPos.current.x;
            bugFixedTextRef.current.position.y = bugClickPos.current.y;
        }

        // Animate clip progress from 0 to 1 (reveals text like pencil drawing)
        gsap.to({ progress: 0 }, {
            progress: 1,
            duration: 0.8,
            ease: 'power1.inOut',
            onUpdate: function () {
                setClipProgress(this.targets()[0].progress);
            },
            onComplete: () => {
                // Fade out after a delay
                setTimeout(() => {
                    if (inkSplashRef.current) {
                        gsap.to(inkSplashRef.current.material, {
                            opacity: 0,
                            duration: 1,
                            ease: 'power2.out'
                        });
                    }
                }, 1500);
            }
        });
    };

    // Duck Click Handler (Rubber Duck Debugging)
    const handleDuckClick = (e) => {
        e.stopPropagation();
        if (isDuckSpeaking) return; // Already speaking

        // Pick random quote
        const randomQuote = duckQuotes[Math.floor(Math.random() * duckQuotes.length)];
        setDuckQuote(randomQuote);
        setIsDuckSpeaking(true);

        // Scale in animation for speech bubble
        if (speechBubbleRef.current) {
            speechBubbleRef.current.scale.set(0, 0, 0);
            gsap.to(speechBubbleRef.current.scale, {
                x: 1,
                y: 1,
                z: 1,
                duration: 0.3,
                ease: 'back.out(1.7)'
            });
        }

        // Hide after 3 seconds
        setTimeout(() => {
            if (speechBubbleRef.current) {
                gsap.to(speechBubbleRef.current.scale, {
                    x: 0,
                    y: 0,
                    z: 0,
                    duration: 0.2,
                    ease: 'power2.in',
                    onComplete: () => setIsDuckSpeaking(false)
                });
            } else {
                setIsDuckSpeaking(false);
            }
        }, 3000);
    };

    // ... (lines omitted)



    // Door dimensions - calculated from texture proportions (332x848 = 1:2.55)
    // Door dimensions - calculated from texture proportions (332x848 = 1:2.55)
    const doorWidth = 0.94;
    const doorHeight = 2.4;
    const doorOpeningWidth = doorWidth * 2; // Both doors together
    const wallThickness = 0.07;

    // Frame dimensions from texture (718x877 = 1:1.22)
    const frameWidth = doorOpeningWidth + 0.16; // Extra for frame borders
    const frameHeight = frameWidth * (877 / 718); // Maintain texture aspect ratio

    // Floor Y must remain at standard level (-1.75) regardless of wall height
    const floorY = -1.75;
    const doorBottomY = floorY;
    const doorCenterY = doorBottomY + doorHeight / 2;
    const wallCenterY = floorY + corridorHeight / 2;
    const topWallHeight = corridorHeight - doorHeight;
    const topWallCenterY = doorBottomY + doorHeight + topWallHeight / 2;
    const sideWallWidth = (corridorWidth - doorOpeningWidth) / 2;



    // Cat Interaction State


    // Handle click
    const handleClick = (e) => {
        e.stopPropagation();
        if (isOpen || isAnimating) return;

        // Reset cursor immediately on transition start
        document.body.style.cursor = "auto";

        setIsOpen(true);
        setIsAnimating(true);
        playBackgroundMusic();
        unlockAchievement('corridor_enter');

        const tl = gsap.timeline({
            onComplete: () => {
                onComplete?.();
            }
        });

        // Press handles down fully (like really opening)
        if (leftHandleRef.current) {
            tl.to(leftHandleRef.current.rotation, {
                z: 0.4,
                duration: 0.15,
                ease: 'power2.out'
            }, 0);
        }
        if (rightHandleRef.current) {
            tl.to(rightHandleRef.current.rotation, {
                z: -0.4,
                duration: 0.15,
                ease: 'power2.out'
            }, 0);
        }

        // Open doors - smoother angle (matches SegmentDoors)
        tl.to(leftDoorRef.current.rotation, {
            y: -Math.PI * 0.55,
            duration: 0.9,
            ease: 'power2.out'
        }, 0.1);

        tl.to(rightDoorRef.current.rotation, {
            y: Math.PI * 0.55,
            duration: 0.9,
            ease: 'power2.out'
        }, 0.1);

        // Camera flies through - STOP CLOSER to avatar/VISHU
        tl.to(camera.position, {
            z: 11,  // Closer stop point (was 11)
            y: 0.2, // Match hook's base Y position
            duration: 1.8,
            ease: 'power2.inOut'
        }, 0.3);
    };

    // Handle hover - doors slightly open to indicate interactivity
    const handlePointerEnter = () => {
        if (isOpen || isAnimating || isMobile) return;
        setIsHovered(true);
        document.body.style.cursor = "pointer";

        // Slightly open doors on hover
        gsap.to(leftDoorRef.current.rotation, {
            y: -0.08,
            duration: 0.3,
            ease: 'power2.out',
            overwrite: true
        });
        gsap.to(rightDoorRef.current.rotation, {
            y: 0.08,
            duration: 0.3,
            ease: 'power2.out',
            overwrite: true
        });

        // Rotate handles down slightly (hint effect)
        if (leftHandleRef.current) {
            gsap.to(leftHandleRef.current.rotation, {
                z: 0.1,
                duration: 0.2,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (rightHandleRef.current) {
            gsap.to(rightHandleRef.current.rotation, {
                z: -0.1,
                duration: 0.2,
                ease: 'power2.out',
                overwrite: true
            });
        }

        // Brush-stroke reveal: discard sketch pixels to show painted door beneath
        if (rightDoorMaterialRef.current) {
            gsap.to(rightDoorMaterialRef.current, {
                uProgress: 1.0,
                duration: 0.8,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (leftDoorMaterialRef.current) {
            gsap.to(leftDoorMaterialRef.current, {
                uProgress: 1.0,
                duration: 0.8,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (leftHandleMaterialRef.current) {
            gsap.to(leftHandleMaterialRef.current, {
                uProgress: 1.0,
                duration: 0.8,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (rightHandleMaterialRef.current) {
            gsap.to(rightHandleMaterialRef.current, {
                uProgress: 1.0,
                duration: 0.8,
                ease: 'power2.out',
                overwrite: true
            });
        }
        // Show painted handles (kill any pending hide from previous leave)
        if (handleHideDelayRef.current) handleHideDelayRef.current.kill();
        if (leftHandlePaintedRef.current) leftHandlePaintedRef.current.visible = true;
        if (rightHandlePaintedRef.current) rightHandlePaintedRef.current.visible = true;
    };

    const handlePointerLeave = () => {
        if (isOpen || isAnimating || isMobile) return;
        setIsHovered(false);
        document.body.style.cursor = "auto";

        // Close doors back
        gsap.to(leftDoorRef.current.rotation, {
            y: 0,
            duration: 0.3,
            ease: 'power2.out',
            overwrite: true
        });
        gsap.to(rightDoorRef.current.rotation, {
            y: 0,
            duration: 0.3,
            ease: 'power2.out',
            overwrite: true
        });

        // Reset handles
        if (leftHandleRef.current) {
            gsap.to(leftHandleRef.current.rotation, {
                z: 0,
                duration: 0.2,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (rightHandleRef.current) {
            gsap.to(rightHandleRef.current.rotation, {
                z: 0,
                duration: 0.2,
                ease: 'power2.out',
                overwrite: true
            });
        }

        // Reverse brush-stroke reveal
        if (rightDoorMaterialRef.current) {
            gsap.to(rightDoorMaterialRef.current, {
                uProgress: 0.0,
                duration: 0.5,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (leftDoorMaterialRef.current) {
            gsap.to(leftDoorMaterialRef.current, {
                uProgress: 0.0,
                duration: 0.5,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (leftHandleMaterialRef.current) {
            gsap.to(leftHandleMaterialRef.current, {
                uProgress: 0.0,
                duration: 0.5,
                ease: 'power2.out',
                overwrite: true
            });
        }
        if (rightHandleMaterialRef.current) {
            gsap.to(rightHandleMaterialRef.current, {
                uProgress: 0.0,
                duration: 0.5,
                ease: 'power2.out',
                overwrite: true
            });
        }

        // Hide painted handles after reverse animation completes
        handleHideDelayRef.current = gsap.delayedCall(0.55, () => {
            if (leftHandlePaintedRef.current) leftHandlePaintedRef.current.visible = false;
            if (rightHandlePaintedRef.current) rightHandlePaintedRef.current.visible = false;
        });
    };



    // --- Cat Eye Tracking Logic ---
    useFrame((state) => {
        if (!leftPupilRef.current || !rightPupilRef.current) return;

        // Mouse position in normalized device reference (-1 to +1)
        const { x, y } = state.pointer;

        // Configuration
        const MAX_EYE_MOVEMENT = 0.015; // How far pupils can move from center

        // Simple mapping
        const targetX = x * MAX_EYE_MOVEMENT * 2;
        const targetY = y * MAX_EYE_MOVEMENT * 2;

        // Smoothly interpolate current pupil position to target
        // Left Eye Original: [-0.063, 0.27]
        leftPupilRef.current.position.x = THREE.MathUtils.lerp(leftPupilRef.current.position.x, -0.075 + targetX, 0.1);
        leftPupilRef.current.position.y = THREE.MathUtils.lerp(leftPupilRef.current.position.y, 0.28 + targetY, 0.1);

        // Right Eye Original: [0.0615, 0.27]
        rightPupilRef.current.position.x = THREE.MathUtils.lerp(rightPupilRef.current.position.x, 0.043 + targetX, 0.1);
        rightPupilRef.current.position.y = THREE.MathUtils.lerp(rightPupilRef.current.position.y, 0.28 + targetY, 0.1);
    });

    // --- Mouse Swinging Animation ---
    const mousePivotRef = useRef();
    useFrame(({ clock }) => {
        if (mousePivotRef.current) {
            // Gentle swing: sin wave
            // Amplitude: 0.05 radians (approx 3 degrees)
            // Speed: 1.5
            mousePivotRef.current.rotation.x = Math.sin(clock.elapsedTime * 1.5) * 0.05;
        }

        // --- Bug Animation ---
        if (bugRef.current) {
            const time = clock.elapsedTime;
            // Wandering logic: slightly complex sine waves for "random" walking felt
            // Initial Pos: [2.5, floorY + 3.0, 0.16] (Above window)
            // Range: +/- 0.3 in X, +/- 0.3 in Y

            const xOffset = Math.sin(time * 0.8) * 0.3 + Math.sin(time * 1.5) * 0.1;
            const yOffset = Math.cos(time * 0.6) * 0.2 + Math.cos(time * 1.1) * 0.1;

            bugRef.current.position.x = 3 + xOffset;
            bugRef.current.position.y = (floorY + 3.8) + yOffset;

            // Random rotation jitter
            bugRef.current.rotation.z = Math.sin(time * 5) * 0.1 + Math.atan2(yOffset, xOffset) * 0.2;
        }
    });



    // Helper for window hover
    const handleWindowEnter = (e) => {
        e.stopPropagation();
        setIsWindowHovered(true);
        document.body.style.cursor = "pointer";

        if (windowAvatarRef.current) {
            gsap.to(windowAvatarRef.current.position, {
                x: 2.5,
                duration: 0.5,
                ease: 'back.out(1.7)',
                overwrite: true
            });
            gsap.to(windowAvatarRef.current.rotation, {
                z: 0.1,
                duration: 0.5,
                ease: 'power2.out',
                overwrite: true
            });
        }
    };

    const handleWindowLeave = (e) => {
        e.stopPropagation();
        setIsWindowHovered(false);
        document.body.style.cursor = "auto";

        if (windowAvatarRef.current) {
            gsap.to(windowAvatarRef.current.position, {
                x: 3.5,
                duration: 0.4,
                ease: 'power2.in',
                overwrite: true
            });
            gsap.to(windowAvatarRef.current.rotation, {
                z: 0,
                duration: 0.4,
                ease: 'power2.in',
                overwrite: true
            });
        }
    };

    // Frame center Y - aligned with doors
    const frameCenterY = doorBottomY + frameHeight / 2;

    const facadeYOffset = -1.65;


    const pathWidth = frameWidth + 0.4;
    // New texture is 1005x2317 (approx 1:2.3 ratio). 
    // Width 2.44 * 2.3 = ~5.6 height.
    const pathLength = 5.62;

    return (
        <group ref={groupRef} position={[position[0], 0, position[2]]}>

            {/* === STONE PATH FLOOR (On Top - in front of entrance) === */}
            {/* WYSOKOŚĆ STONE PATH: zmień 'floorY + 0.02' - większa liczba = wyżej */}
            <mesh
                position={[0, floorY + 0.02, pathLength / 2]}
                rotation={[-Math.PI / 2, 0, 0]}
            >
                <planeGeometry args={[pathWidth, pathLength]} />
                <meshBasicMaterial color="#5c534c"
                    map={stonePathTexture}
                    transparent={true}
                />
            </mesh>


            {/* LEFT WALL PANEL */}
            <mesh position={[-(doorOpeningWidth / 2 + sideWallWidth / 2), wallCenterY, 0]}>
                <boxGeometry args={[sideWallWidth, corridorHeight, wallThickness]} />
                <meshBasicMaterial color="#4a4a4a" roughness={0.95} />
            </mesh>

            {/* RIGHT WALL PANEL */}
            <mesh position={[(doorOpeningWidth / 2 + sideWallWidth / 2), wallCenterY, 0]}>
                <boxGeometry args={[sideWallWidth, corridorHeight, wallThickness]} />
                <meshBasicMaterial color="#4a4a4a" roughness={0.95} />
            </mesh>

            {/* TOP WALL PANEL */}
            <mesh position={[0, topWallCenterY, 0]}>
                <boxGeometry args={[doorOpeningWidth, topWallHeight, wallThickness]} />
                <meshBasicMaterial color="#4a4a4a" roughness={0.95} />
            </mesh>

            {/* === BRICK FACADE === */}
            {/* 
                DOSTOSOWANIE OBRAZKA (TEXTURE ADJUSTMENT):
                1. args={[Szerokość, Wysokość]} - Rozmiar obrazka
                2. facadeYOffset - Przesunięcie góra/dół (np. -1 obniży, 1 podwyższy)
            */}
            <mesh position={[0, wallCenterY + facadeYOffset + 1.65, 0.15]}>
                {/* args={[Szerokość, Wysokość]} - Zmieniaj te liczby (np. 7, 8) */}
                <planeGeometry args={[16., 8]} />
                <meshBasicMaterial color="#4a4a4a"
                    map={bricksTexture}
                    transparent={true}
                    alphaTest={0.01}
                    roughness={0.9}
                />
            </mesh>

            {/* === CAPABILITY SIGN BANNERS ABOVE GATE === */}
            {[
                { text: "Vishu", x: -1.8 },
                { text: "Web Developer", x: -0.6 },
                { text: "Website Developer", x: 0.6 },
                { text: "AI Engineer", x: 1.8 }
            ].map((banner, index) => (
                <group key={index} position={[banner.x, frameCenterY + 1.65, 0.2]}>
                    {/* Shadow / Border plane */}
                    <mesh position={[0.015, -0.015, -0.002]}>
                        <planeGeometry args={[1.13, 0.38]} />
                        <meshBasicMaterial color="#311059" transparent opacity={0.8} />
                    </mesh>
                    {/* Card plane */}
                    <mesh position={[0, 0, -0.001]}>
                        <planeGeometry args={[1.1, 0.35]} />
                        <meshBasicMaterial color="#d4a373" />
                    </mesh>
                    {/* Text */}
                    <Text
                        position={[0, 0, 0.002]}
                        fontSize={0.11}
                        color="#311059"
                        anchorX="center"
                        anchorY="middle"
                        font="/fonts/CabinSketch-Bold.ttf"
                    >
                        {banner.text}
                    </Text>
                </group>
            ))}

            {/* === TEXTURED FRAME === */}
            <mesh position={[0, frameCenterY, 0.12]}>
                <planeGeometry args={[frameWidth, frameHeight]} />
                <meshBasicMaterial color="#fcf3c6"
                    map={frameTexture}
                    transparent={true}
                    alphaTest={0.1}
                    roughness={0.9}
                    depthWrite={false}
                />
            </mesh>

            {/* LEFT DOOR */}
            <group ref={leftDoorRef} position={[-doorWidth, doorCenterY, 0]}>
                {/* Custom Stickers to cover old tech stack stickers - LEFT DOOR */}
                <group position={[doorWidth / 2, 0.45, 0.091]}>
                    <mesh position={[0.01, -0.01, -0.002]}>
                        <planeGeometry args={[0.73, 0.38]} />
                        <meshBasicMaterial color="#311059" transparent opacity={0.7} />
                    </mesh>
                    <mesh position={[0, 0, -0.001]}>
                        <planeGeometry args={[0.7, 0.35]} />
                        <meshBasicMaterial color="#fcf3c6" />
                    </mesh>
                    <Text
                        position={[0, 0.02, 0.001]}
                        fontSize={0.075}
                        color="#311059"
                        anchorX="center"
                        anchorY="middle"
                        font="/fonts/CabinSketch-Bold.ttf"
                    >
                        AdSense 🪙
                    </Text>
                </group>

                <group position={[doorWidth / 2, -0.45, 0.091]}>
                    <mesh position={[0.01, -0.01, -0.002]}>
                        <planeGeometry args={[0.73, 0.38]} />
                        <meshBasicMaterial color="#311059" transparent opacity={0.7} />
                    </mesh>
                    <mesh position={[0, 0, -0.001]}>
                        <planeGeometry args={[0.7, 0.35]} />
                        <meshBasicMaterial color="#fcf3c6" />
                    </mesh>
                    <Text
                        position={[0, 0.02, 0.001]}
                        fontSize={0.07}
                        color="#311059"
                        anchorX="center"
                        anchorY="middle"
                        font="/fonts/CabinSketch-Bold.ttf"
                    >
                        vishvajeet
                    </Text>
                </group>

                {/* Solid 3D Door Body with edge texture */}
                <mesh
                    position={[doorWidth / 2, 0, 0.06]}
                    onClick={handleClick}
                    onPointerEnter={handlePointerEnter}
                    onPointerLeave={handlePointerLeave}
                >
                    <boxGeometry args={[doorWidth, doorHeight, 0.04]} />
                    <meshBasicMaterial color="#fcf3c6" map={edgeTexture} roughness={0.9} />
                </mesh>

                {/* Painted layer (behind sketch) - left door */}
                {!isMobile && (
                    <mesh position={[doorWidth / 2, 0, 0.088]}>
                        <planeGeometry args={[doorWidth, doorHeight]} />
                        <meshBasicMaterial color="#fcf3c6"
                            map={doorLeftPaintedTexture}
                            transparent={true}
                            alphaTest={0.5}
                            roughness={0.8}
                        />
                    </mesh>
                )}

                {/* Sketch overlay (front) - left door brush-stroke reveal */}
                <mesh position={[doorWidth / 2, 0, 0.09]}>
                    <planeGeometry args={[doorWidth, doorHeight]} />
                    <revealMaterial color="#fcf3c6"
                        ref={leftDoorMaterialRef}
                        map={doorLeftTexture}
                        transparent={true}
                        alphaTest={0.5}
                        roughness={0.8}
                        depthWrite={false}
                        uProgress={0.0}
                    />
                </mesh>

                {/* Back Texture Face (mirrored) */}
                <mesh position={[doorWidth / 2, 0, 0.03]} rotation={[0, Math.PI, 0]} scale={[-1, 1, 1]}>
                    <planeGeometry args={[doorWidth, doorHeight]} />
                    <meshBasicMaterial color="#fcf3c6"
                        map={doorBackTexture}
                        transparent={true}
                        alphaTest={0.5}
                        roughness={0.8}
                        side={2}
                    />
                </mesh>

                {/* Handle Layer (animated) - pivot at screw center (292,459 on 332x848 texture) */}
                <group ref={leftHandleRef} position={[doorWidth / 2 + 0.357, -0.099, 0.10]}>
                    {/* Painted handle (behind) - hidden until hover */}
                    {!isMobile && (
                        <mesh ref={leftHandlePaintedRef} position={[-0.357, 0.09, -0.001]} visible={false}>
                            <planeGeometry args={[doorWidth, doorHeight]} />
                            <meshBasicMaterial color="#fcf3c6"
                                map={handleLeftPaintedTexture}
                                transparent={true}
                                alphaTest={0.5}
                                depthWrite={false}
                            />
                        </mesh>
                    )}
                    {/* Sketch handle overlay (front) */}
                    <mesh position={[-0.357, 0.099, 0]}>
                        <planeGeometry args={[doorWidth, doorHeight]} />
                        <revealMaterial color="#fcf3c6"
                            ref={leftHandleMaterialRef}
                            map={handleLeftTexture}
                            transparent={true}
                            alphaTest={0.5}
                            depthWrite={false}
                            uProgress={0.0}
                        />
                    </mesh>
                </group>
            </group>

            {/* RIGHT DOOR */}
            <group ref={rightDoorRef} position={[doorWidth, doorCenterY, 0]}>
                {/* Custom Stickers to cover old tech stack stickers - RIGHT DOOR */}
                <group position={[-doorWidth / 2, 0.45, 0.091]}>
                    <mesh position={[0.01, -0.01, -0.002]}>
                        <planeGeometry args={[0.73, 0.38]} />
                        <meshBasicMaterial color="#311059" transparent opacity={0.7} />
                    </mesh>
                    <mesh position={[0, 0, -0.001]}>
                        <planeGeometry args={[0.7, 0.35]} />
                        <meshBasicMaterial color="#fcf3c6" />
                    </mesh>
                    <Text
                        position={[0, 0.02, 0.001]}
                        fontSize={0.075}
                        color="#311059"
                        anchorX="center"
                        anchorY="middle"
                        font="/fonts/CabinSketch-Bold.ttf"
                    >
                        AI Engineer
                    </Text>
                </group>

                <group position={[-doorWidth / 2, -0.45, 0.091]}>
                    <mesh position={[0.01, -0.01, -0.002]}>
                        <planeGeometry args={[0.73, 0.38]} />
                        <meshBasicMaterial color="#311059" transparent opacity={0.7} />
                    </mesh>
                    <mesh position={[0, 0, -0.001]}>
                        <planeGeometry args={[0.7, 0.35]} />
                        <meshBasicMaterial color="#fcf3c6" />
                    </mesh>
                    <Text
                        position={[0, 0.02, 0.001]}
                        fontSize={0.07}
                        color="#311059"
                        anchorX="center"
                        anchorY="middle"
                        font="/fonts/CabinSketch-Bold.ttf"
                    >
                        Web Dev 💻
                    </Text>
                </group>

                {/* Solid 3D Door Body with edge texture */}
                <mesh
                    position={[-doorWidth / 2, 0, 0.06]}
                    onClick={handleClick}
                    onPointerEnter={handlePointerEnter}
                    onPointerLeave={handlePointerLeave}
                >
                    <boxGeometry args={[doorWidth, doorHeight, 0.04]} />
                    <meshBasicMaterial color="#fcf3c6" map={edgeTexture} roughness={0.9} />
                </mesh>

                {/* Painted layer (behind sketch) - revealed when sketch fades out on hover */}
                {!isMobile && (
                    <mesh position={[-doorWidth / 2, 0, 0.088]}>
                        <planeGeometry args={[doorWidth, doorHeight]} />
                        <meshBasicMaterial color="#fcf3c6"
                            map={doorRightPaintedTexture}
                            transparent={true}
                            alphaTest={0.5}
                            roughness={0.8}
                        />
                    </mesh>
                )}

                {/* Sketch overlay (front) - brush-stroke discard reveals painted beneath */}
                <mesh position={[-doorWidth / 2, 0, 0.09]}>
                    <planeGeometry args={[doorWidth, doorHeight]} />
                    <revealMaterial color="#fcf3c6"
                        ref={rightDoorMaterialRef}
                        map={doorRightTexture}
                        transparent={true}
                        alphaTest={0.5}
                        roughness={0.8}
                        depthWrite={false}
                        uProgress={0.0}
                    />
                </mesh>

                {/* Back Texture Face */}
                <mesh position={[-doorWidth / 2, 0, 0.03]} rotation={[0, Math.PI, 0]}>
                    <planeGeometry args={[doorWidth, doorHeight]} />
                    <meshBasicMaterial color="#fcf3c6"
                        map={doorBackTexture}
                        transparent={true}
                        alphaTest={0.5}
                        roughness={0.8}
                    />
                </mesh>

                {/* Handle Layer (animated) - pivot at screw center (40,459 on 332x848 texture) */}
                <group ref={rightHandleRef} position={[-doorWidth / 2 - 0.357, -0.099, 0.10]}>
                    {/* Painted handle (behind) - hidden until hover */}
                    {!isMobile && (
                        <mesh ref={rightHandlePaintedRef} position={[0.357, 0.09, -0.001]} visible={false}>
                            <planeGeometry args={[doorWidth, doorHeight]} />
                            <meshBasicMaterial color="#fcf3c6"
                                map={handleRightPaintedTexture}
                                transparent={true}
                                alphaTest={0.5}
                                depthWrite={false}
                            />
                        </mesh>
                    )}
                    {/* Sketch handle overlay (front) */}
                    <mesh position={[0.357, 0.099, 0]}>
                        <planeGeometry args={[doorWidth, doorHeight]} />
                        <revealMaterial color="#fcf3c6"
                            ref={rightHandleMaterialRef}
                            map={handleRightTexture}
                            transparent={true}
                            alphaTest={0.5}
                            depthWrite={false}
                            uProgress={0.0}
                        />
                    </mesh>
                </group>
            </group>

            {/* Warm lighting - WYLACZONE */}
            {/* <pointLight
                position={[0, doorBottomY + doorHeight + 1, 1]}
                intensity={0.8}
                color="#fff8e8"
                distance={10}
            /> */}
            {/* AVATAR - separate from window group, behind bricks */}
            <mesh
                ref={windowAvatarRef}
                position={[3.5, 0, 0.04]}
                rotation={[0, 0, 0]}
            >
                <planeGeometry args={[1.5, 1.5]} />
                <meshBasicMaterial color="#fcf3c6"
                    map={avatarWindowTexture}
                    transparent={true}
                />
            </mesh>

            {/* WINDOW - positioned to the right of doors */}
            <group
                position={[2.5, 0, 0.1]}
                onPointerEnter={handleWindowEnter}
                onPointerLeave={handleWindowLeave}
            >
                {/* Window Frame Sketch - in front of bricks */}
                <mesh position={[0, 0, 0.2]}>
                    <planeGeometry args={[1.5, 1.5]} />
                    <meshBasicMaterial color="#fcf3c6"
                        map={windowSketchTexture}
                        transparent={true}
                    />
                </mesh>
            </group>

            {/* VINTAGE STREET LAMP (Left Side Foreground) */}
            <AnimatedStreetLamp position={[-3.8, floorY + 2.2, 0.8]} texture={lampTexture} />

            {/* DUCK POT (Right Side - Under Window) */}
            <group position={[2.5, floorY + 0.45, 0.4]}>
                {/* Pot texture */}
                <mesh>
                    <planeGeometry args={[3, 1.8]} />
                    <meshBasicMaterial color="white"
                        map={potTexture}
                        transparent={true}
                        alphaTest={0.01}
                        depthWrite={false}
                    />
                </mesh>

                {/* Invisible hitbox just for the duck (right side of pot) */}
                <mesh
                    position={[0.38, 0.1, 0.01]}
                    onClick={handleDuckClick}
                    onPointerEnter={() => { document.body.style.cursor = "pointer"; }}
                    onPointerLeave={() => { document.body.style.cursor = "auto"; }}
                >
                    <planeGeometry args={[0.6, 0.6]} />
                    <meshBasicMaterial color="#fcf3c6" transparent opacity={0} />
                </mesh>

                {/* Speech Bubble */}
                <group
                    ref={speechBubbleRef}
                    position={[0.9, 0.8, 0.1]}
                    scale={[0, 0, 0]}
                >
                    <mesh>
                        <planeGeometry args={[1.8, 1.2]} />
                        <meshBasicMaterial color="#fcf3c6"
                            map={speechBubbleTexture}
                            transparent={true}
                            alphaTest={0.01}
                            depthWrite={false}
                        />
                    </mesh>

                    {/* Quote Text */}
                    {/* ROZMIAR TEKSTU: fontSize - mniejsza = mniejszy tekst */}
                    {/* ZAWIJANIE: maxWidth - mniejsza = wcześniejsze zawijanie */}
                    <Text
                        position={[0, 0.1, 0.01]}
                        fontSize={0.07}
                        color="#1a1a1a"
                        anchorX="center"
                        anchorY="middle"
                        font={FONT_URL}
                        maxWidth={1.4}
                        textAlign="center"
                        visible={isDuckSpeaking} // Toggle visibility instead of mounting/unmounting
                    >
                        {duckQuote || " "}
                    </Text>
                </group>
            </group>

            {/* ANIMATED BUG (Right Side - Above Window) */}
            {!isBugClicked && (
                <mesh
                    ref={bugRef}
                    position={[2.5, floorY + 2.8, 0.16]}
                    onClick={handleBugClick}
                    onPointerEnter={() => { document.body.style.cursor = "pointer"; }}
                    onPointerLeave={() => { document.body.style.cursor = "auto"; }}
                >
                    <planeGeometry args={[0.4, 0.4]} />
                    <meshBasicMaterial color="#fcf3c6"
                        map={bugTexture}
                        transparent={true}
                        alphaTest={0.01}
                        depthWrite={false}
                    />
                </mesh>
            )}

            {/* INK SPLASH - always mounted to preload texture/shader */}
            <mesh
                ref={inkSplashRef}
                position={[2.5, floorY + 2.8, 0.17]}
                scale={[0, 0, 0]}
            // Removed conditional 'visible' to ensure GPU upload
            >
                <planeGeometry args={[2, 2]} />
                <meshBasicMaterial color="#fcf3c6"
                    map={inkSplashTexture}
                    transparent={true}
                    alphaTest={0.01}
                    depthWrite={false}
                />
            </mesh>

            {/* BUG FIXED! Text - always mounted to preload font */}
            <Text
                ref={bugFixedTextRef}
                position={[2.5, floorY + 2.8, 0.35]} // Default pos, updated on click
                fontSize={0.25} // Increased size slightly for CabinSketch
                color="#1a1a1a"
                anchorX="center"
                anchorY="middle"
                font="/fonts/CabinSketch-Bold.ttf"
                outlineWidth={0.015}
                outlineColor="#ffffff"
                clipRect={[-1, -0.5, -1 + (clipProgress * 2.5), 0.5]}
            >
                BUG FIXED!
            </Text>





            {/* Left Side Tree & Mouse have been removed */}

            {/* CAT SKETCH (Front Facing) */}
            <group position={[-1.5, floorY + 0.6, 0.8]} ref={catGroupRef}>
                {/* Body */}
                <mesh>
                    <planeGeometry args={[1.5, 1.5]} />
                    <meshBasicMaterial color="#b0b0b8"
                        map={catFrontBodyTexture}
                        transparent={true}
                        alphaTest={0.01}
                        depthWrite={false}
                    />
                </mesh>

                {/* Left Pupil */}
                <mesh
                    ref={leftPupilRef}
                    position={[-0.063, 0.27, -0.02]} // Behind cat
                >
                    <circleGeometry args={[0.020, 32]} />
                    <meshBasicMaterial color="#d4f067" />
                    {/* Oval Scale */}
                    <group scale={[0.8, 1.2, 1]} />
                </mesh>

                {/* Right Pupil */}
                <mesh
                    ref={rightPupilRef}
                    position={[0.0615, 0.27, -0.02]} // Behind cat
                >
                    <circleGeometry args={[0.020, 32]} />
                    <meshBasicMaterial color="#d4f067" />
                </mesh>
            </group>

        </group>
    );
};

/**
 * FallingPetals - Animated sakura petals gently drifting down
 * Purely decorative, no interaction
 */
const FallingPetals = ({ position, floorY }) => {
    const petalsRef = useRef();
    const petalCount = 40;
    const petals = useMemo(() => {
        const result = [];
        for (let i = 0; i < petalCount; i++) {
            result.push({
                x: -6 + Math.random() * 12,
                y: floorY + 1 + Math.random() * 7,
                z: 0.5 + Math.random() * 3,
                speed: 0.15 + Math.random() * 0.25,
                drift: (Math.random() - 0.5) * 0.4,
                rotSpeed: (Math.random() - 0.5) * 2.5,
                phase: Math.random() * Math.PI * 2,
                size: 0.03 + Math.random() * 0.05,
            });
        }
        return result;
    }, [floorY]);

    useFrame((state) => {
        if (!petalsRef.current) return;
        const time = state.clock.elapsedTime;
        petalsRef.current.children.forEach((child, i) => {
            const p = petals[i];
            if (!p) return;
            // Fall and drift
            let newY = p.y - ((time * p.speed) % 8);
            if (newY < floorY - 0.5) newY += 8;
            child.position.y = newY;
            child.position.x = p.x + Math.sin(time * 0.5 + p.phase) * p.drift;
            child.rotation.z = time * p.rotSpeed;
        });
    });

    return (
        <group ref={petalsRef}>
            {petals.map((p, i) => (
                <mesh key={i} position={[p.x, p.y, p.z]}>
                    <planeGeometry args={[p.size * 2, p.size]} />
                    <meshBasicMaterial
                        color={i % 3 === 0 ? "#f5b0c0" : i % 3 === 1 ? "#f0a0b5" : "#e8c0d0"}
                        transparent
                        opacity={0.7}
                        side={THREE.DoubleSide}
                    />
                </mesh>
            ))}
        </group>
    );
};

/**
 * AnimatedBirds - Birds sitting in the tree leaves with pecking/hopping animation
 */
const AnimatedBirds = ({ texture }) => {
    // Array of birds with initial positions relative to the tree group
    // Tree canopy positions:
    const birds = [
        { position: [0.3, 2.5, 0.05], scale: 0.35, offset: 0 },
        { position: [-1.2, 1.8, 0.05], scale: 0.3, offset: Math.PI / 2 },
        { position: [1.3, 1.2, 0.05], scale: 0.32, offset: Math.PI }
    ];

    return (
        <group>
            {birds.map((bird, i) => (
                <SingleBird key={i} {...bird} texture={texture} />
            ))}
        </group>
    );
};

const SingleBird = ({ position, scale, offset, texture }) => {
    const ref = useRef();
    useFrame((state) => {
        if (!ref.current) return;
        const time = state.clock.elapsedTime + offset;

        // Pecking animation: rotate slightly downward periodically
        const peck = Math.pow(Math.sin(time * 3), 10) * 0.5; // Sharp spikes

        // Bobbing/breathing animation
        const hop = Math.pow(Math.sin(time * 2), 2) * 0.03;

        ref.current.rotation.z = -peck * 0.4; // Tilt forward
        ref.current.position.y = position[1] + hop;
    });

    return (
        <mesh ref={ref} position={position} scale={[scale, scale, 1]}>
            <planeGeometry args={[1, 1]} />
            <meshBasicMaterial
                map={texture}
                transparent={true}
                depthWrite={false}
            />
        </mesh>
    );
};

/**
 * AnimatedStreetLamp - Vintage double-lantern street lamp
 */
const AnimatedStreetLamp = ({ position, texture }) => {
    const lampLight1Ref = useRef();
    const lampLight2Ref = useRef();

    useFrame((state) => {
        const t = state.clock.getElapsedTime();
        // Subtle flickering and breathing for realistic point lights
        const flicker = Math.random() * 0.05;
        const breath = Math.sin(t * 1.5) * 0.15;
        const intensity = 1.0 + breath + flicker;

        if (lampLight1Ref.current) lampLight1Ref.current.intensity = intensity * 1.4;
        if (lampLight2Ref.current) lampLight2Ref.current.intensity = intensity * 1.0;
    });

    return (
        <group position={position}>
            {/* The Lamp Post Mesh (Transparent Alpha Cutout) */}
            <mesh position={[0, 0, 0]} scale={[4.5, 4.5, 1]}>
                <planeGeometry args={[1, 1]} />
                <meshBasicMaterial
                    map={texture}
                    transparent={true}
                    alphaTest={0.01}
                    depthWrite={false}
                />
            </mesh>

            {/* Dynamic Point Lights illuminating the brick wall naturally */}
            <pointLight ref={lampLight1Ref} color="#ffaa33" distance={8} decay={2} intensity={1.4} position={[-0.22, 1.28, 0.5]} />
            <pointLight ref={lampLight2Ref} color="#ffbb44" distance={6} decay={2} intensity={1.0} position={[0.52, 0.38, 0.5]} />
        </group>
    );
};

export default EntranceDoors;
