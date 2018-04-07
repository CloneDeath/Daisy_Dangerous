shader_type canvas_item;

uniform float fade_level = 1.0;

float rand( vec2 co )
{
	return fract( sin( dot( co.xy , vec2(12.9898,78.233 ) ) ) * 43758.5453 );
}

void fragment()
{
    vec2 resolution = 8.0 * SCREEN_PIXEL_SIZE;
	vec2 fragCoord = UV * SCREEN_PIXEL_SIZE;
	vec2 lowresxy = vec2(
		floor( UV.x / resolution.x ),
		floor( UV.y / resolution.y ) );
	//lowresxy = UV / 0.4;
	
	
	
	//if( sin( fract( TIME * 1.0 * fade_in ) ) > rand( lowresxy ) )
	if( fade_level > rand( lowresxy ) )
	{
		COLOR = vec4( 0.0, 0.0, 0.0, 1.0 )
		//COLOR = vec4( UV, 0.5 + 0.5 * sin( 5.0 * fragCoord.x ), 1.0 );
		//COLOR = vec4( UV, 0.5 + 0.5 * sin( TIME * 250.0 * UV.x ), 1.0 );
        //fragColor = vec4(uv,0.5+0.5*sin(iTime * 5.0 * uv.x),1.0);
        //fragColor = vec4(uv,0.5+0.5*sin(iTime * 5.0 * uv.x * sin(uv.x * uv.y * iTime)),1.0);
        //fragColor = vec4(uv,0.5+0.5*sin(iTime * 5.0 * uv.x * sin(uv.x / uv.y * iTime / 500000.0)),1.0);
		//fragColor = vec4(uv,0.5+0.5*sin(iTime * 5.0 * uv.x * sin(uv.x * uv.y * iTime / 5000.0)),1.0);
		//fragColor = vec4(uv,0.5+0.5*sin(iTime * 500.0 * uv.x * sin(uv.y + iTime * 500.0)),1.0);
		//fragColor = vec4(uv,0.5+0.5*sin((uv.x + uv.y) * 500.0 * sin(iTime)),1.0);
	}
	else
	{
		COLOR = vec4(0.0,0.0,0.0,0.0);
    }
}