import { useEffect, useRef } from 'react';
import { useScene } from '../context/SceneContext';

/**
 * useDocumentMeta — Dynamic Meta Tags & Virtual Routing (History API)
 */

const ROOM_META = {
    null: {
        path: '/',
        title: 'Vishvajeet Tiwari — Developer, Creator & Digital Builder',
        description: 'Portfolio of Vishvajeet Tiwari, a developer and digital creator building modern websites, digital products and interactive web experiences.',
    },
    about: {
        path: '/about',
        title: 'About Me — Vishvajeet Tiwari Portfolio',
        description: 'Learn about Vishvajeet Tiwari — a developer and digital creator focused on building useful, visually distinctive web experiences.',
    },
    gallery: {
        path: '/gallery',
        title: 'Gallery & Projects — Vishvajeet Tiwari Portfolio',
        description: 'Browse the interactive 3D gallery of web development projects by Vishvajeet Tiwari. Each project is displayed as a hand-drawn card you can flip and explore.',
    },
    studio: {
        path: '/studio',
        title: 'The Studio — Vishvajeet Tiwari Portfolio',
        description: 'Explore Vishvajeet Tiwari\'s content studio — projects, blog posts, and tools displayed on floating monitors in an immersive 3D space.',
    },
    contact: {
        path: '/contact',
        title: 'Contact — Vishvajeet Tiwari Portfolio',
        description: 'Get in touch with Vishvajeet Tiwari. Find social media links and contact forms in this interactive 3D contact room.',
    },
};

// Map URL paths back to room IDs for deep linking
const PATH_TO_ROOM = {
    '/': null,
    '/about': 'about',
    '/gallery': 'gallery',
    '/studio': 'studio',
    '/contact': 'contact',
};

export function getInitialRoomFromUrl() {
    const path = window.location.pathname.replace(/\/+$/, '') || '/';
    return PATH_TO_ROOM[path] !== undefined ? PATH_TO_ROOM[path] : null;
}

export function useDocumentMeta() {
    const { currentRoom, teleportTo, hasEntered } = useScene();
    const isHandlingPopState = useRef(false);
    const lastPushedRoom = useRef(undefined); // Track what we last pushed to avoid duplicates

    // Update document meta and URL when room changes
    useEffect(() => {
        const roomKey = currentRoom === null ? 'null' : currentRoom;
        const meta = ROOM_META[roomKey] || ROOM_META['null'];

        // Update the page title
        document.title = meta.title;

        // Update meta description
        const descTag = document.querySelector('meta[name="description"]');
        if (descTag) {
            descTag.setAttribute('content', meta.description);
        }

        // Update OG meta tags
        const ogTitle = document.querySelector('meta[property="og:title"]');
        if (ogTitle) ogTitle.setAttribute('content', meta.title);

        const ogDesc = document.querySelector('meta[property="og:description"]');
        if (ogDesc) ogDesc.setAttribute('content', meta.description);

        const ogUrl = document.querySelector('meta[property="og:url"]');
        if (ogUrl) ogUrl.setAttribute('content', `https://vishvajeet.com${meta.path}`);

        // Update canonical link
        const canonicalTag = document.querySelector('link[rel="canonical"]');
        if (canonicalTag) {
            canonicalTag.setAttribute('href', `https://vishvajeet.com${meta.path}`);
        }

        // Push to browser history
        if (!isHandlingPopState.current && lastPushedRoom.current !== currentRoom) {
            if (lastPushedRoom.current === undefined) {
                window.history.replaceState({ room: currentRoom }, '', meta.path);
            } else {
                window.history.pushState({ room: currentRoom }, '', meta.path);
            }
            lastPushedRoom.current = currentRoom;
        }
        isHandlingPopState.current = false;
    }, [currentRoom]);

    // Handle browser back/forward buttons
    useEffect(() => {
        const handlePopState = (e) => {
            const room = e.state ? e.state.room : null;
            if (room !== undefined) {
                isHandlingPopState.current = true;
                lastPushedRoom.current = room;
                teleportTo(room);
            }
        };

        window.addEventListener('popstate', handlePopState);
        return () => window.removeEventListener('popstate', handlePopState);
    }, [teleportTo]);
}
