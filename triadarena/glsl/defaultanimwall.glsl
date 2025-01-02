!!ver 130 460

!!permu FULLBRIGHT
!!permu FOG
!!permu LIGHTSTYLED

!!samps 1

varying vec2 txc;

#include "sys/defs.h"
#include "sys/fog.h"

#ifdef VERTEX_SHADER

	void main()
	{
		txc = v_texcoord;

		gl_Position = ftetransform();
	}

#endif

#ifdef FRAGMENT_SHADER

	void main()
	{
		vec4 diffuse = texture2D(s_t0, fract(txc));

		if (diffuse.a < 0.1) discard;

		gl_FragColor = fog4(diffuse * e_colourident);
	}

#endif
