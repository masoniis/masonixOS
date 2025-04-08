#define LINE_WIDTH 0.05
#define AXIS_SIZE vec2(5,5)
#define FUNCTION sin(3.*x + 5.*(iTime*iTime))*(sin(iTime) + 0.1)

// Graph function by returning color to mask
vec4 f(float x, float y) {
    float fy = FUNCTION;
    if (abs(fy - y) > LINE_WIDTH) {
        return vec4(0, 0, 0, 0); // transparent background
    }
    return vec4(1.0, 1.0, 1.0, 1.0); // white line
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 termColor = texture(iChannel0, fragCoord / iResolution.xy); // existing terminal content

    vec2 uv = fragCoord / iResolution.xy; // normalized UV coordinates [0, 1]
    uv -= 0.5;
    uv.x *= iResolution.x / iResolution.y; // maintain aspect ratio
    uv *= AXIS_SIZE; // scale to axis size

    // Light source position (bottom right corner in normalized space)
    vec2 lightPos = vec2(0.5, -0.5) * AXIS_SIZE;

    // Ray tracing: calculate light intensity
    vec4 funcColor = f(uv.x, uv.y); // color of the graph
    if (funcColor.a > 0.0) {
        vec2 lightDir = normalize(lightPos - uv); // direction of light
        float distance = length(lightPos - uv); // distance to light source
        float attenuation = 1.0 / (1.0 + distance * distance); // light falloff
        vec3 lightColor = vec3(1.0, 1.0, 0.8) * attenuation; // warm light

        // Combine light with graph color
        funcColor.rgb *= lightColor;
    }

    // Blend graph color and terminal content
    fragColor = mix(termColor, funcColor, funcColor.a);
}

