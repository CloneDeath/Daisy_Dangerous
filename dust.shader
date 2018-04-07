shader_type canvas_item;

uniform int SnowflakeAmount = 50;
uniform float BlizardFactor = 0.0;


float rnd(float x)
{
    return fract(sin(dot(vec2(x+47.49,38.2467/(x+2.3)), vec2(12.9898, 78.233)))* (43758.5453));
}

float drawCircle(vec2 center, float radius, vec2 uv)
{
    //return 1.0 - smoothstep(0.0, radius, length(uv - center) );
	return 1.0 - smoothstep(0.0, radius, length(uv - center) );
}


void fragment()
{
    vec2 uv = UV;
	float r = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	uv.x *= r;
    
    COLOR = vec4(0.808, 0.89, 0.918, 0.0 );
    float j;
    
	float a = 0.0;
    for(int i=0; i<SnowflakeAmount; i++)
    {
        j = float(i);
        float speed = 0.3+rnd(cos(j))*(0.7+0.5*cos(j/(float(SnowflakeAmount)*0.25)));
        //vec2 center = vec2( ( 0.25 - uv.y ) * BlizardFactor + rnd( j ) + 0.1 * cos( TIME + sin( j ) ),
		//		mod( sin( j ) - speed * ( TIME * 1.5 * ( 0.1 + BlizardFactor ) ), 0.65 ) );
		vec2 center = vec2( mod( sin( j ) - speed * ( TIME * 1.5 * 0.1 ), 1.0 * r ),
				rnd( j ) + 0.1 * cos( TIME + sin( j ) ) );
        a += drawCircle( center, ( 0.001 + speed * 0.012 ) * 0.2, uv ) / 0.5;
    }
	COLOR = vec4( 0.0, 0.0, 0.0, a );
}