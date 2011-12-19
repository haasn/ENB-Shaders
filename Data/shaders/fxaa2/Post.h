/*======================================================================================
                             POST FXAA RENDERING PASSES
======================================================================================*/

#define s0 lumaSampler
#define width BUFFER_WIDTH
#define height BUFFER_HEIGHT
#define px BUFFER_RCP_WIDTH
#define py BUFFER_RCP_HEIGHT
#define dx ((AverageBlur * 0.05)*px)
#define dy ((AverageBlur * 0.05)*py)

/*------------------------------------------------------------------------------
						FILTER TO USE CHECK
------------------------------------------------------------------------------*/
#if (USE_PRE_SHARPEN == 1)
#include "Data\shaders\fxaa2\PreSharpen.h"
#endif
#if (USE_BLOOM == 1)
#include "Data\shaders\fxaa2\Bloom.h"
#endif
#if (USE_TECHNICOLOR == 1)
#include "Data\shaders\fxaa2\Technicolor.h"
#endif
#if (USE_TONEMAP == 1)
#include "Data\shaders\fxaa2\Tonemap.h"
#endif
#if (USE_SEPIA == 1)
#include "Data\shaders\fxaa2\Sepia.h"
#endif
#if (USE_POST_SHARPEN == 1)
#include "Data\shaders\fxaa2\PostSharpen.h"
#endif

/*------------------------------------------------------------------------------
						RENDERING PASSES
------------------------------------------------------------------------------*/

float4 main( float2 tex)
{
	// PreSharpenPass (has to be the first pass because it samples multiple texels)
	#if (USE_PRE_SHARPEN == 1)
		float4 pass1 = SharpenPass(tex);
	#else
		float4 pass1 = tex2D(s0,tex);
	#endif
	// BloomPass
	#if (USE_BLOOM == 1)
		float4 pass2 = BloomPass (pass1,tex);
	#else
		float4 pass2 = pass1;
	#endif
	// Technicolor
	#if (USE_TECHNICOLOR == 1)
		float4 pass3 = TechnicolorPass( pass2, tex);
	#else
		float4 pass3 = pass2;
	#endif
	// TonemapPass
	#if (USE_TONEMAP == 1)
		float4 pass4 = TonemapPass( pass3, tex);
	#else
		float4 pass4 = pass3;
	#endif
	// SepiaPass
	#if (USE_SEPIA == 1)
		float4 pass5 = SepiaPass (pass4,tex);
	#else
		float4 pass5 = pass4;
	#endif
	// PostSharpenPass
	#if (USE_POST_SHARPEN == 1)
		float4 pass6 = PostSharpenPass (pass5,tex);
	#else
		float4 pass6 = pass5;
	#endif
	// ReturnFinalColor
	return pass6;
}