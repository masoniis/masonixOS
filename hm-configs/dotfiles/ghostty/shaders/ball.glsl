// 11.8, 11.8, 18
float radius = .15; // radius of ball

float speed = 5.7; // total speed scale, higher is slower

float xSpeed = 1.1; // horizontal speed scaled to aspect ratio, higher is slower
float ySpeed = 1.01; // vertical speed, higher is slower

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    float xWidth = iResolution.x / iResolution.y;
    float yWidth = 1.;

    uv.x *= xWidth; // multiply x by aspect ratio

    float positionY = radius + (abs(fract(iTime / (speed * ySpeed)) - 0.5) * 2.0 * (yWidth - 2.0 * radius));
    float positionX = radius + (abs(fract(iTime / (speed * xSpeed)) - 0.5) * 2.0 * (xWidth - 2.0 * radius));

    uv.x -= positionX;
    uv.y -= positionY;

    float d = length(uv);

    // draw ball
    vec3 color;
    if (d >= radius && d <= 12.) {
        color = vec3(0.2, 0.2, 0.2);
    } else {
        color = 0.5 + 0.5 * sin(iTime + uv.xyx + vec3(0, 2, 4));
        ;
    }

    fragColor = vec4(vec3(color), .5);
}
