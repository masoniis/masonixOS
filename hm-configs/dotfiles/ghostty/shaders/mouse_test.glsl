// Testing if Ghostty shader supports mouse position.
// As of writing, 12/26/24 it appears to not support position at all.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 termColor = texture(iChannel0, fragCoord / iResolution.xy);

    vec2 uv = fragCoord / iResolution.xy - 0.5;
    uv.x *= iResolution.x / iResolution.y;
    vec2 mouseNorm = iMouse.xy / iResolution.xy - 0.5;
    mouseNorm.x *= iResolution.x / iResolution.y;

    float d = length(uv - mouseNorm.xy);
    if (d >= 0.25) {
        vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
        vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
        fragColor = mix(termColor, white, 0.5);
    } else {
        fragColor = mix(termColor, termColor, 0.3);
    }
}
