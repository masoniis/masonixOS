#define WALKSAMPLES 20000 // Maximum steps, though typically not needed with correct Bresenham implementation

bool obstruction(vec2 lightPixel, vec2 coordPixel, vec4 bgColor, vec2 iResolution) {
    // Convert to integer coordinates for Bresenham's algorithm
    ivec2 start = ivec2(round(lightPixel));
    ivec2 end = ivec2(round(coordPixel));

    ivec2 delta = end - start;
    ivec2 absDelta = abs(delta);

    ivec2 step = ivec2(sign(vec2(delta)));

    bool steep = absDelta.y > absDelta.x;
    int longest = max(absDelta.x, absDelta.y);
    int shortest = min(absDelta.x, absDelta.y);

    int error = longest / 2;
    ivec2 current = start;

    for (int i = 0; i < longest; i++) {
        // Convert current pixel to normalized texture coordinates
        vec2 uv = (vec2(current) + 0.5) / iResolution; // Sample center of the pixel

        if (texture(iChannel0, uv) != bgColor) {
            return true;
        }

        // Bresenham's error adjustment
        if (steep) {
            current.y += step.y;
            error -= shortest;
            if (error < 0) {
                current.x += step.x;
                error += longest;
            }
        } else {
            current.x += step.x;
            error -= shortest;
            if (error < 0) {
                current.y += step.y;
                error += longest;
            }
        }
    }

    return false;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 texInOut = texture(iChannel0, uv);

    vec2 lightPosNormalized = vec2(0.5, 0.5);
    vec2 lightPixel = lightPosNormalized * iResolution.xy;
    vec2 coordPixel = fragCoord; // fragCoord is already in pixel coordinates

    vec4 bgColor = texture(iChannel0, lightPosNormalized);

    if (!obstruction(lightPixel, coordPixel, bgColor, iResolution.xy)) {
        // Apply light effect if not obstructed
        float dist = length(lightPosNormalized - uv);
        texInOut.rgb += (1.0 - dist) * 0.5;
    }

    fragColor = texInOut;
}

