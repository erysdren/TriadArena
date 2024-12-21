!!ver 130 460

!!samps diffuse

varying vec3 pos;

#include "sys/defs.h"

#ifdef VERTEX_SHADER

	void main()
	{
		pos = v_position.xyz - e_eyepos;
		gl_Position = ftetransform();
	}

#endif

#ifdef FRAGMENT_SHADER

	void main()
	{
		vec3 dir = -normalize(pos);

		#define PI 3.1415926535897932384626433832795
		vec2 txc = vec2(0.5 + atan(dir.z, dir.x) / (2.0 * PI), dir.y);

		vec4 diffuse = texture2D(s_diffuse, txc);
		gl_FragColor = diffuse;
	}

#endif
