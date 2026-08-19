/**
 * Global Audio Manager for section-based background music and ambient sounds
 */

const SECTION_TRACKS = {
    corridor: {
        src: '/sounds/cfl_turningpages-belem-breeze-487596.ogg',
        baseVolume: 0.35,
        loop: true
    },
    about: {
        src: '/sounds/szumwiatru.mp3',
        baseVolume: 0.5,
        loop: true
    },
    gallery: {
        src: '/sounds/szummiasta.mp3',
        baseVolume: 0.55,
        loop: true
    },
    contact: {
        src: '/sounds/szummorza.mp3',
        baseVolume: 0.6,
        loop: true
    },
    studio: null // No distorted buzzing sound for studio/nootturno section
};

const audioElements = {};
let currentSection = null;
let isMuted = false;
let globalMusicVolume = 0.5;
let audioUnlocked = false;
let autoUnlockAttached = false;

// Initialize all section audio elements
export const initAudio = () => {
    if (typeof window === 'undefined') return;

    const savedMuted = localStorage.getItem('audio_muted');
    isMuted = savedMuted === 'true';

    const savedVol = localStorage.getItem('audio_volume');
    if (savedVol !== null) {
        globalMusicVolume = parseFloat(savedVol);
    }

    // Pre-create Audio instances for each section
    Object.keys(SECTION_TRACKS).forEach((key) => {
        const config = SECTION_TRACKS[key];
        if (config && !audioElements[key]) {
            const audio = new Audio(config.src);
            audio.preload = 'auto';
            audio.loop = config.loop;
            audio.muted = isMuted;
            audio.volume = Math.max(0, Math.min(1, config.baseVolume * globalMusicVolume));
            audioElements[key] = audio;
        }
    });

    // Auto-unlock on any mobile touch, scroll, pointerdown, or visibility change
    if (!autoUnlockAttached && typeof window !== 'undefined') {
        autoUnlockAttached = true;
        const autoUnlockHandler = () => {
            unlockAudio();
        };
        window.addEventListener('touchstart', autoUnlockHandler, { passive: true });
        window.addEventListener('touchend', autoUnlockHandler, { passive: true });
        window.addEventListener('touchmove', autoUnlockHandler, { passive: true });
        window.addEventListener('pointerdown', autoUnlockHandler, { passive: true });
        window.addEventListener('scroll', autoUnlockHandler, { passive: true });
        window.addEventListener('click', autoUnlockHandler, { passive: true });
    }
};

/**
 * Switch music/ambience to the specified section ('about', 'gallery', 'contact', 'studio', or 'corridor'/null)
 */
export const switchSectionAudio = (section) => {
    initAudio();
    const targetKey = (section && SECTION_TRACKS[section]) ? section : (section === 'studio' ? 'studio' : 'corridor');

    if (currentSection === targetKey && audioElements[targetKey] && !audioElements[targetKey].paused) {
        return;
    }

    const prevSection = currentSection;
    currentSection = targetKey;

    // Pause previous section track
    if (prevSection && audioElements[prevSection] && prevSection !== targetKey) {
        const prevAudio = audioElements[prevSection];
        try {
            prevAudio.pause();
            prevAudio.currentTime = 0;
        } catch (e) {}
    }

    if (targetKey === 'studio') {
        // Quiet and clean for studio
        return;
    }

    // Play target section track
    const targetAudio = audioElements[targetKey];
    if (targetAudio) {
        targetAudio.muted = isMuted;
        const baseVol = SECTION_TRACKS[targetKey] ? SECTION_TRACKS[targetKey].baseVolume : 0.5;
        targetAudio.volume = Math.max(0, Math.min(1, baseVol * globalMusicVolume));

        const playPromise = targetAudio.play();
        if (playPromise !== undefined) {
            playPromise.then(() => {
                audioUnlocked = true;
            }).catch(() => {
                // Will auto-resume on first mobile touch/scroll
            });
        }
    }
};

/**
 * Unlock and start playing current section audio on mobile
 */
export const unlockAudio = () => {
    initAudio();
    audioUnlocked = true;
    const targetKey = currentSection || 'corridor';
    if (targetKey === 'studio') return;

    const targetAudio = audioElements[targetKey];
    if (targetAudio && targetAudio.paused && !isMuted) {
        targetAudio.play().catch(() => {});
    }
};

export const playBackgroundMusic = () => {
    switchSectionAudio(currentSection || 'corridor');
};

export const pauseBackgroundMusic = () => {
    if (currentSection && audioElements[currentSection]) {
        audioElements[currentSection].pause();
    }
};

export const toggleMute = () => {
    isMuted = !isMuted;
    localStorage.setItem('audio_muted', isMuted);
    Object.keys(audioElements).forEach((key) => {
        if (audioElements[key]) {
            audioElements[key].muted = isMuted;
        }
    });
    if (!isMuted) {
        unlockAudio();
    }
    return isMuted;
};

export const getIsMuted = () => isMuted;

export const setMusicVolume = (vol) => {
    globalMusicVolume = Math.max(0, Math.min(1, vol));
    localStorage.setItem('audio_volume', globalMusicVolume);

    if (vol > 0 && isMuted) {
        isMuted = false;
        localStorage.setItem('audio_muted', false);
    }

    Object.keys(audioElements).forEach((key) => {
        const audio = audioElements[key];
        if (audio) {
            audio.muted = isMuted;
            const baseVol = SECTION_TRACKS[key] ? SECTION_TRACKS[key].baseVolume : 0.5;
            audio.volume = Math.max(0, Math.min(1, baseVol * globalMusicVolume));
        }
    });

    if (vol > 0 && currentSection && audioElements[currentSection] && audioElements[currentSection].paused) {
        audioElements[currentSection].play().catch(() => {});
    }

    window.dispatchEvent(new CustomEvent('musicVolumeChanged', { detail: globalMusicVolume }));
};

export const getMusicVolume = () => globalMusicVolume;
