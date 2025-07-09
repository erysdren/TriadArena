!!ver 130 460

!!permu FULLBRIGHT
!!permu FOG
!!permu LIGHTSTYLED

!!samps diffuse lightmap fullbright

varying vec2 txc;
varying vec2 lmc;

#include "sys/defs.h"
#include "sys/fog.h"

#ifdef VERTEX_SHADER

	void main()
	{
		txc = v_texcoord;
		lmc = v_lmcoord;

		gl_Position = ftetransform();
	}

#endif

#ifdef FRAGMENT_SHADER

	void main()
	{
		// diffuse sampler
		vec4 diffuse = texture2D(s_diffuse, fract(txc));

		// apply lightmap
		#if !defined(UNLIT) && !defined(VERTEXLIT)
			vec2 lmsize = vec2(textureSize(s_lightmap, 0));
			vec2 nlmc = floor(lmc * lmsize * 16) / (lmsize * 16);
			vec3 lightmaps = (texture2D(s_lightmap, nlmc) * e_lmscale).rgb;
			diffuse.rgb *= lightmaps.rgb;
		#endif

		// apply brightmap
		#if !defined(UNLIT) && defined(FULLBRIGHT)
			vec4 brightmap = texture2D(s_fullbright, tc);
			diffuse = brightmap * brightmap.a + diffuse * (1.0 - brightmap.a);
		#endif

		// alpha
		if (diffuse.a < 0.1) discard;

		// final
		gl_FragColor = fog4(diffuse * e_colourident);
	}

#endif
