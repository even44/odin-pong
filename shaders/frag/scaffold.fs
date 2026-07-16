#version 330

// 1. Inputs sent automatically by Raylib's internal engine
in vec2 fragTexCoord; // UV coordinates of the screen (0.0 to 1.0)
in vec4 fragColor;    // Base vertex color passed from Raylib

// 2. Uniforms (Variables we pass manually from Odin)
uniform sampler2D texture0; // The game texture (RenderTexture)
uniform float uTime;        // Elapsed time ticker

// 3. Output
out vec4 finalColor;

void main()
{
    // Sample the core game pixel color at the current UV position
    vec4 texelColor = texture2D(texture0, fragTexCoord);

    // --- YOUR CUSTOM EFFECTS GO HERE ---
    // Example: A pulsating red channel tint based on the uTime uniform
    float pulse = (sin(uTime * 3.0) + 1.0) / 2.0; // Oscillates between 0.0 and 1.0
    
    vec4 modifiedColor = texelColor;
    modifiedColor.r += pulse * 0.3; // Lightly inject red over time

    // Output final rendered pixel state multiplied by tint opacity
    finalColor = modifiedColor * fragColor;
}