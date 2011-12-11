// Each sucessive technique has an increasing name
#ifndef TECH
#define TECH(n) PostProcess##n
#define NEXT 1
#endif

// The technique itself, relies on pre-set SHADER macro
#if NEXT == 1
technique PostProcess
#else
technique TECH(NEXT)
#endif
{
	pass p1
	{
		VertexShader = compile vs_3_0 VS_Passthrough();
		PixelShader = compile ps_3_0 SHADER();

		DitherEnable = FALSE;
		ZEnable = FALSE;
		CullMode = NONE;
		ALPHATESTENABLE = FALSE;
		SEPARATEALPHABLENDENABLE = FALSE;
		AlphaBlendEnable = FALSE;
		StencilEnable = FALSE;
		FogEnable = FALSE;
		SRGBWRITEENABLE = FALSE;
	}
}

// Increase the NEXT as needed (very clunky macro method)
#if NEXT == 1
	#define NEXT 2
#elif NEXT == 2
	#define NEXT 3
#elif NEXT == 3
	#define NEXT 4
#elif NEXT == 4
	#define NEXT 5
#elif NEXT == 5
	#define NEXT 6
#elif NEXT == 6
	#define NEXT 7
#elif NEXT == 7
	#define NEXT 8
#elif NEXT == 8
	#define NEXT 9
#elif NEXT == 9
	#define NEXT 10
#elif NEXT == 10
	#define NEXT 11
#elif NEXT == 11
	#define NEXT 12
#elif NEXT == 12
	#define NEXT 13
#elif NEXT == 13
	#define NEXT 14
#elif NEXT == 14
	#define NEXT 15
#elif NEXT == 15
	#define NEXT 16
#elif NEXT == 16
	#define NEXT 17
#elif NEXT == 17
	#define NEXT 18
#elif NEXT == 18
	#define NEXT 19
#elif NEXT == 19
	#define NEXT 20
#elif NEXT == 20
	#define NEXT 21
#elif NEXT == 21
	#define NEXT 22
#elif NEXT == 12
	#define NEXT 23
#endif
