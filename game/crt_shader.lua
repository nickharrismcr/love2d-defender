local pixelcode = [[
	# pragma language glsl3

	vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
	{
		float blur_radius=2/love_ScreenSize.x;
		vec2 offx = vec2(blur_radius, 0.0);
		vec2 offy = vec2(0.0, blur_radius);

		vec4 texcolor = Texel(tex, texture_coords);


		vec4 pixel = Texel(tex,texture_coords - offx) * 3.0 +
					 Texel(tex,texture_coords + offx)* 3.0 +
					 Texel(tex,texture_coords - offy) * 3.0 +
					 Texel(tex,texture_coords + offy) * 3.0 +
					 Texel(tex,texture_coords - offx - offy)  +
					 Texel(tex,texture_coords - offx + offy)  +
					 Texel(tex,texture_coords + offx - offy)  +
					 Texel(tex,texture_coords + offx + offy) ;

		texcolor=mix(texcolor,pixel,0.05);
		texcolor *= 0.6+0.4*sin( screen_coords.y*4);
		
		return color * texcolor;
	}
]]
 
local vertexcode = [[
	vec4 position( mat4 transform_projection, vec4 vertex_position )
	{
		return transform_projection * vertex_position;
	}
]]
 
return love.graphics.newShader(pixelcode, vertexcode)
