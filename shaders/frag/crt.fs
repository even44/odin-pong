#version 330
// Shader generated using AI
// 1. Raylib's automatic canvas input attributes
in vec2 fragTexCoord; 
in vec4 fragColor;    

// 2. Uniform structures linked from Odin
uniform sampler2D texture0; 
uniform float uTime;        

// 3. Final render pipeline output channel
out vec4 finalColor;

// Configuration values
float warp = 0.75; 
float scan = 0.75; 
float zoom = 1.0; // Controls zoom depth to push black edges out (Try 1.1 to 1.2)

void main()
{
    // 1. Scale UV coordinates outward from the 0.5 center point to zoom in
    vec2 uv = (fragTexCoord - 0.5) / zoom + 0.5;
    
    // 2. Calculate distance layout metrics relative to texture center
    vec2 dc = abs(0.5 - uv);
    dc *= dc;
    
    // 3. Warp the fragment coordinate layout arrays
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // --- NOTICE: Black boundary safety checks are gone! ---
    // Because we zoomed in, the screen graphics naturally bleed over the edges.
    
    // 4. Calculate vertical positions to anchor scanlines
    float scanline_frequency = 800.0; 
    float apply = abs(sin(uv.y * scanline_frequency) * 0.5 * scan);
    
    // 5. Sample texture0 pixel colors across calculated warped layout
    // Use clamp-to-edge sampling logic to fill any remaining tiny corner pixels nicely
    vec3 sampled_rgb = texture(texture0, clamp(uv, 0.0, 1.0)).rgb;
    
    // 6. Mix the color with black based on scanline intensity
    vec3 final_rgb = mix(sampled_rgb, vec3(0.0), apply);
    
    // Output final structural pixel multiplied by default raylib parameters
    finalColor = vec4(final_rgb, 1.0) * fragColor;
}
