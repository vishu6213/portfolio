import React from 'react';
import './GalleryVideoBackground.scss';

const GalleryVideoBackground = () => {
    return (
        <div className="gallery-video-container">
            <video
                className="gallery-video"
                src="https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260606_154941_df1a96e1-a06f-450c-bd02-d863414cc1a0.mp4"
                autoPlay
                muted
                loop
                playsInline
                crossOrigin="anonymous"
            />
            {/* Dark overlay if needed to make gallery content visible, but since user said "just add video" we will leave it clean */}
            <div className="gallery-video-overlay" />
        </div>
    );
};

export default GalleryVideoBackground;
