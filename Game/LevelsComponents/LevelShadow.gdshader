shader_type canvas_item;

uniform int NumberOfLightSource = 0;
uniform vec2 CircleCentre[10];
uniform float CircleRadius[10];
uniform float CircleBlur[10];
uniform float FlickerStrength[10];
uniform vec4 Foreground: source_color = vec4(0.0, 0.0, 0.0, 0.85);


float RenderLightSource(int i, vec2 coord){
    if(i > NumberOfLightSource)
        return 0.0;
    
    float circle_blur = clamp( 0.0, 1.0, CircleBlur[i] );
    float circle_dist = distance( CircleCentre[i],  coord);
    float radius = CircleRadius[i] + sin(TIME) * FlickerStrength[i];
    float circle_signal = 1.0 - smoothstep( radius, radius*(1.0-circle_blur), circle_dist );    
    return circle_signal * Foreground.a;
}

void fragment() 
{
    COLOR = Foreground;
    for(int i = 0; i<NumberOfLightSource; i++){
        float a = RenderLightSource(i, FRAGCOORD.xy);
         COLOR.a = min(COLOR.a, a);
    }
}
