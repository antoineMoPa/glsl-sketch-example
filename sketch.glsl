#version 300 es
//PASSES=3
precision highp float;

in vec2 UV;
out vec4 out_color;
in vec2 lastUV;
uniform float time;
uniform int pass;
uniform sampler2D lastPass;
uniform float ratio;

#define PI 3.14159265359
#define PI2 6.28318

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec2 p = vec2(x, y);
    
    vec4 col = vec4(0.0);

    if(pass == 1){
        // Original pass: a simple circle
        vec2 center = vec2(0.5,0.5);
        p=fract(p*2.0);
        float d = distance(p, center);
        col.rgba = 
            vec4(0.8 + 0.3* cos(time * 6.28+1.), 0.5, 0.2+0.1*cos(time * 6.28), 1.0) * 
            clamp(1.0-abs(d-0.1 + 0.03 * cos(time * 6.28 * 2.0))/0.008, 0.0, 1.0);
        col += texture(lastPass, lastUV);
    } else if (pass == 2){
        col = texture(lastPass, lastUV);
        float x = 0.01 * cos(time * 6.2832)+0.005;
        col += texture(lastPass, lastUV + vec2(-x, 0.004+x))-col;
    } else if (pass == 3){
        col = texture(lastPass, lastUV);
    }

    col.a = 1.0;
    
    out_color = col;
}
