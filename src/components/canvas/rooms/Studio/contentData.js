/**
 * Studio Content Data
 * 
 * Custom content for Mariya Ansari's monitor towers.
 */

export const PLATFORM_CONFIG = {
    youtube: {
        color: '#FF0000',
        accentColor: '#cc0000',
        icon: '▶',
        label: 'Tech Video',
        shape: 'tv', // Wide CRT style
    },
    blog: {
        color: '#eab308',
        accentColor: '#ca8a04',
        icon: '📝',
        label: 'Case Study',
        shape: 'monitor', // Thin desktop monitor
    },
    tiktok: {
        color: '#00F2EA',
        accentColor: '#FF0050',
        icon: '📱',
        label: 'Micro Log',
        shape: 'phone', // Vertical phone
    },
    linkedin: {
        color: '#0077B5',
        accentColor: '#005E93',
        icon: 'in',
        label: 'Milestone',
        shape: 'monitor',
    },
    codrops: {
        color: '#0099FF',
        accentColor: '#0077CC',
        icon: '💧',
        label: 'Featured',
        shape: 'monitor',
    },
};

const RAW_CONTENT_DATA = [
    // ============ Case Studies / Projects ============
    {
        id: 'studio-mariyanology',
        platform: 'blog',
        title: 'Mariyanology: Custom WordPress & Audience Building',
        description: 'Building a personal brand and publishing technical guides on advanced WordPress theme edits, responsive layout systems, and user engagement strategies.',
        frontTexture: '/textures/studio/monitorfront_postnafbdoublewinner.webp',
        paintedFrontTexture: '/textures/studio/monitorfront_postnafbdoublewinner_painted.webp',
        thumbnail: null,
        url: '#',
        date: '2026-03-24',
        readTime: '6 min',
    },
    {
        id: 'studio-dailydeeper',
        platform: 'blog',
        title: 'DailyDeeper: Designing a Habit Journal App',
        description: 'Crafted a clean, client-side web application for mindfulness logging and habit tracking. Optimized for quick load times and offline accessibility.',
        frontTexture: '/textures/studio/tvfront_filmikprojektdlamultiego.webp',
        paintedFrontTexture: '/textures/studio/tvfront_filmikprojektdlamultiego_painted.webp',
        thumbnail: null,
        url: '#',
        date: '2026-02-15',
        readTime: '8 min',
    },
    {
        id: 'studio-nsew',
        platform: 'blog',
        title: 'NS Engineering Works: B2B Industrial Portal',
        description: 'Developed an industrial machinery catalogue and quote calculator. Optimized search index coverage, boosting B2B inquiries by 150%.',
        frontTexture: '/textures/studio/tvfront_filmikedytowaniezdjec.webp',
        paintedFrontTexture: '/textures/studio/tvfront_filmikedytowaniezdjec_painted.webp',
        thumbnail: null,
        url: '#',
        date: '2026-01-10',
        readTime: '10 min',
    },
    {
        id: 'studio-seo',
        platform: 'linkedin',
        title: 'Technical SEO Case Study: Scaling Traffic by 210%',
        description: 'Detailed analysis of database optimization, advanced asset compression, and structural markup that led to a double-digit organic growth rate within 90 days.',
        thumbnail: null,
        url: '#',
        date: '2025-12-18',
        readTime: '5 min',
    },
    {
        id: 'studio-gutenberg',
        platform: 'blog',
        title: 'Building Custom React Gutenberg Blocks',
        description: 'How to build high-performance, customized edit panels in the WordPress block editor using custom fields and React control panels.',
        thumbnail: null,
        url: '#',
        date: '2025-11-28',
        readTime: '7 min',
    },
    {
        id: 'studio-micro-interaction',
        platform: 'tiktok',
        title: 'Designing smooth hover states in CSS',
        description: 'Micro-interactions POV: Making static buttons feel alive and dynamic using CSS custom properties and spring transition curves.',
        frontTexture: '/textures/studio/phonefront_followmeontiktok.webp',
        paintedFrontTexture: '/textures/studio/phonefront_followmeontiktok_painted.webp',
        thumbnail: null,
        url: '#',
        date: '2026-03-01',
        views: '3.4K',
        likes: '482',
    },
    {
        id: 'studio-perf',
        platform: 'blog',
        title: 'Core Web Vitals Optimization Checklist',
        description: 'Step-by-step checklist to hit a 100/100 Lighthouse score on image-heavy portfolio sites using WebP layouts, local fonts, and deferred scripting.',
        thumbnail: null,
        url: '#',
        date: '2025-10-15',
        readTime: '11 min',
    },
];

const ytTextures = ['/textures/studio/tvfront_filmikprojektdlamultiego.webp', '/textures/studio/tvfront_filmikedytowaniezdjec.webp'];
const ytPaintedTextures = ['/textures/studio/tvfront_filmikprojektdlamultiego_painted.webp', '/textures/studio/tvfront_filmikedytowaniezdjec_painted.webp'];
const blogTextures = ['/textures/studio/monitorfront_postnafbdoublewinner.webp'];
const blogPaintedTextures = ['/textures/studio/monitorfront_postnafbdoublewinner_painted.webp'];
const ttTextures = ['/textures/studio/phonefront_followmeontiktok.webp'];
const ttPaintedTextures = ['/textures/studio/phonefront_followmeontiktok_painted.webp'];

let ytIdx = 0, blogIdx = 0, ttIdx = 0;
let ytPIdx = 0, blogPIdx = 0, ttPIdx = 0;

export const CONTENT_DATA = RAW_CONTENT_DATA.map((item) => {
    return {
        ...item,
        frontTexture: item.frontTexture || (
            item.platform === 'youtube' ? ytTextures[ytIdx++ % ytTextures.length] :
                item.platform === 'blog' ? blogTextures[blogIdx++ % blogTextures.length] :
                    ttTextures[ttIdx++ % ttTextures.length]
        ),
        paintedFrontTexture: item.paintedFrontTexture || (
            item.platform === 'youtube' ? ytPaintedTextures[ytPIdx++ % ytPaintedTextures.length] :
                item.platform === 'blog' ? blogPaintedTextures[blogPIdx++ % blogPaintedTextures.length] :
                    ttPaintedTextures[ttPIdx++ % ttPaintedTextures.length]
        )
    };
});

export const getContentByPlatform = (platform) => {
    if (platform === 'all') return CONTENT_DATA;
    return CONTENT_DATA.filter(item => item.platform === platform);
};

export const getLatestContent = () => {
    return [...CONTENT_DATA].sort((a, b) => new Date(b.date) - new Date(a.date))[0];
};
