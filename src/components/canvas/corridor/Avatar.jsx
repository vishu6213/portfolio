import { useRef, useEffect } from 'react';
import { useFrame, useThree } from '@react-three/fiber';
import { useTexture } from '@react-three/drei';
import * as THREE from 'three';

/**
 * Avatar Component - Yuta Okkotsu Manga/Sketch Character
 * 
 * Full-body manga/sketch Yuta Okkotsu:
 * - Positioned in center hero section, standing in front of VISHVAJEET TIWARI text
 * - Interactive cursor parallax, subtle body tilt, and katana/clothing breathing movement
 * - Subtle anime aura presence effect when mouse gets close
 */
const Avatar = ({ position = [0, -0.61, -0.3] }) => {
    const meshRef = useRef();
    const groupRef = useRef();
    const { camera, pointer } = useThree();

    // Dodge & Parallax state
    const dodgeX = useRef(0);
    const targetDodgeX = useRef(0);
    const worldPosVec = useRef(new THREE.Vector3());

    // Mouse lerp ref for smooth motion
    const mouseLerp = useRef({ x: 0, y: 0 });

    // Load Yuta character texture
    const texture = useTexture('/textures/corridor/yuta_avatar.png');

    useEffect(() => {
        if (texture) {
            texture.colorSpace = THREE.SRGBColorSpace;
        }
    }, [texture]);

    const baseHeight = 2.5;
    const aspectRatio = 237 / 600;
    const dimensions = {
        width: baseHeight * aspectRatio,
        height: baseHeight
    };

    useFrame((state) => {
        if (!groupRef.current || !meshRef.current) return;

        const time = state.clock.elapsedTime;

        // === DODGE LOGIC (when camera flies past in corridor) ===
        groupRef.current.getWorldPosition(worldPosVec.current);
        const distance = camera.position.z - worldPosVec.current.z;

        const DODGE_START = 3;
        const DODGE_PEAK = 0;
        const DODGE_END = -2;
        const DODGE_AMOUNT = -1.5;

        if (distance > DODGE_PEAK && distance < DODGE_START) {
            const t = (DODGE_START - distance) / (DODGE_START - DODGE_PEAK);
            targetDodgeX.current = DODGE_AMOUNT * easeOutQuad(t);
        } else if (distance <= DODGE_PEAK && distance > DODGE_END) {
            const t = (distance - DODGE_END) / (DODGE_PEAK - DODGE_END);
            targetDodgeX.current = DODGE_AMOUNT * easeOutQuad(t);
        } else {
            targetDodgeX.current = 0;
        }

        dodgeX.current = THREE.MathUtils.lerp(dodgeX.current, targetDodgeX.current, 0.08);

        // === CURSOR PARALLAX & TILT LOGIC ===
        mouseLerp.current.x = THREE.MathUtils.lerp(mouseLerp.current.x, pointer.x, 0.06);
        mouseLerp.current.y = THREE.MathUtils.lerp(mouseLerp.current.y, pointer.y, 0.06);

        // Idle breathing & subtle clothing/katana motion
        const breathY = Math.sin(time * 1.8) * 0.02;
        const breathRotZ = Math.sin(time * 1.2) * 0.008;

        // Cursor parallax movement
        const parallaxX = mouseLerp.current.x * 0.14;
        const parallaxY = mouseLerp.current.y * 0.08;

        // Subtle body & katana tilt toward cursor
        const tiltZ = -mouseLerp.current.x * 0.04 + breathRotZ;
        const tiltX = mouseLerp.current.y * 0.025;

        // Update group position
        groupRef.current.position.x = position[0] + dodgeX.current + parallaxX;
        groupRef.current.position.y = position[1] + breathY + parallaxY;

        // Update mesh rotation smoothly
        meshRef.current.rotation.z = THREE.MathUtils.lerp(meshRef.current.rotation.z, tiltZ, 0.1);
        meshRef.current.rotation.x = THREE.MathUtils.lerp(meshRef.current.rotation.x, tiltX, 0.1);

        // === HOVER PROXIMITY EFFECT ===
        const mouseDist = Math.sqrt(pointer.x * pointer.x + pointer.y * pointer.y);
        const targetScale = mouseDist < 0.45 ? 1.018 : 1.0;
        meshRef.current.scale.setScalar(THREE.MathUtils.lerp(meshRef.current.scale.x, targetScale, 0.1));
    });

    return (
        <group ref={groupRef} position={position}>
            {/* Yuta Okkotsu Character Mesh */}
            <mesh ref={meshRef} position={[0, 0.365, 0]}>
                <planeGeometry args={[dimensions.width, dimensions.height]} />
                <meshBasicMaterial
                    map={texture}
                    transparent={true}
                    side={THREE.DoubleSide}
                    depthWrite={false}
                />
            </mesh>
        </group>
    );
};

// Easing function
const easeOutQuad = (t) => t * (2 - t);

export default Avatar;
