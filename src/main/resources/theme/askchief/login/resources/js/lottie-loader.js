// Simple Lottie animation loader for Keycloak
// Falls back to CSS animation if Lottie is not available

// IMMEDIATE DEBUG - this should always show
console.log('🔥 LOTTIE SCRIPT EXECUTING - IMMEDIATE');
console.log('🔥 Current URL:', window.location.href);
console.log('🔥 Document ready state:', document.readyState);

(function() {
    'use strict';
    
    console.log('🔥 Inside IIFE wrapper');
    
    // Function to check for lottie container (will be called after DOM loads)
    function findLottieContainer() {
        const lottieContainer = document.querySelector('.kc-lottie-player');
        console.log('🔥 Lottie container search result:', lottieContainer);
        
        if (!lottieContainer) {
            console.log('🔥 NO LOTTIE CONTAINER FOUND');
            // Let's see what containers DO exist
            const allDivs = document.querySelectorAll('div');
            console.log('🔥 All divs on page:', allDivs.length);
            console.log('🔥 Sample div classes:', Array.from(allDivs).slice(0, 5).map(d => d.className));
            return null;
        }
        
        console.log('✅ Lottie container found!');
        return lottieContainer;
    }
    
    // Try to load the actual Lottie file - adjust path for Keycloak resources
    const lottieUrl = (window.KC_RESOURCES_PATH || '') + '/img/Chief Demo v4 LOT.lottie';
    
    // Function to load Lottie via CDN if available
    function loadLottieAnimation() {
        console.log('🎭 Attempting to load Lottie animation...');
        const lottieContainer = findLottieContainer();
        
        if (!lottieContainer) {
            console.log('❌ Cannot load Lottie - container not found');
            return;
        }
        
        console.log('📍 Lottie container found:', lottieContainer);
        console.log('🔗 Lottie URL:', lottieUrl);
        
        // Load dotLottie player for .lottie files
        const script = document.createElement('script');
        script.src = 'https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs';
        script.type = 'module';
        script.onload = function() {
            console.log('✅ DotLottie player loaded successfully');
            try {
                console.log('🎬 Starting DotLottie animation load...');
                
                // Clear the container
                lottieContainer.innerHTML = '';
                
                // Create dotlottie-player element
                const player = document.createElement('dotlottie-player');
                player.setAttribute('src', lottieUrl);
                player.setAttribute('background', 'transparent');
                player.setAttribute('speed', '1');
                player.setAttribute('style', 'width: 150px; height: 150px;');
                player.setAttribute('loop', '');
                player.setAttribute('autoplay', '');
                
                // Add event listeners
                player.addEventListener('ready', function() {
                    console.log('🎉 DotLottie animation loaded successfully!');
                });
                
                player.addEventListener('error', function(e) {
                    console.log('❌ DotLottie animation error:', e);
                    console.log('🔄 Showing SVG fallback');
                    // Show SVG fallback by adding CSS class
                    const container = document.querySelector('.kc-lottie-container-header');
                    if (container) {
                        container.classList.add('kc-lottie-fallback');
                    }
                });
                
                // Add player to container
                lottieContainer.appendChild(player);
                
            } catch (e) {
                console.log('❌ DotLottie loading failed:', e);
                console.log('🔄 Showing SVG fallback');
                // Show SVG fallback by adding CSS class
                const container = document.querySelector('.kc-lottie-container-header');
                if (container) {
                    container.classList.add('kc-lottie-fallback');
                }
            }
        };
        script.onerror = function(e) {
            console.log('❌ DotLottie CDN failed to load:', e);
            console.log('🔄 Showing SVG fallback');
            // Show SVG fallback by adding CSS class
            const container = document.querySelector('.kc-lottie-container-header');
            if (container) {
                container.classList.add('kc-lottie-fallback');
            }
        };
        document.head.appendChild(script);
    }
    
    // Add some dynamic interaction to the SVG fallback
    function enhanceSVGAnimation() {
        const lottieContainer = findLottieContainer();
        if (!lottieContainer) {
            console.log('❌ Cannot enhance SVG - container not found');
            return;
        }
        
        const svg = lottieContainer.querySelector('svg');
        if (svg) {
            // Add click interaction
            svg.addEventListener('click', function() {
                svg.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    svg.style.transform = 'scale(1)';
                }, 150);
            });
            
            // Add random subtle movements
            setInterval(() => {
                if (Math.random() > 0.7) {
                    svg.style.transform = 'translateY(-2px) scale(1.01)';
                    setTimeout(() => {
                        svg.style.transform = 'translateY(0) scale(1)';
                    }, 300);
                }
            }, 3000);
        }
    }
    
    // Initialize when DOM is ready
    console.log('🚀 Lottie loader script started');
    console.log('📊 Document ready state:', document.readyState);
    
    if (document.readyState === 'loading') {
        console.log('⏳ Waiting for DOM to load...');
        document.addEventListener('DOMContentLoaded', function() {
            console.log('✅ DOM loaded, initializing...');
            enhanceSVGAnimation();
            // Try to load Lottie after a delay
            setTimeout(loadLottieAnimation, 500);
        });
    } else {
        console.log('✅ DOM already loaded, initializing immediately...');
        enhanceSVGAnimation();
        setTimeout(loadLottieAnimation, 500);
    }
})();