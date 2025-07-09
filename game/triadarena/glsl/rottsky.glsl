!!ver 130 460

!!samps 2

#include "sys/defs.h"

#ifdef VERTEX_SHADER

	void main()
	{
		gl_Position = ftetransform();
	}

#endif

#ifdef FRAGMENT_SHADER

	void main()
	{
		vec3 angles = w_user[0].xyz;

		vec2 screensize = textureSize(s_t0, 0);

		screensize.y *= 2;

		vec2 txc = gl_FragCoord.xy / screensize;
		txc.y *= -1;
		txc.y -= 0.25;
		txc.y += angles.x / 360;
		txc.x -= angles.y / 180;

		vec4 diffuse = texture2D(s_t1, fract(txc));
		gl_FragColor = diffuse;
	}

#endif
