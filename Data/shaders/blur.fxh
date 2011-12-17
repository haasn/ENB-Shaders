//================================================================
// Shift effect originally by Boris Vorontsov (http://enbdev.com)
//================================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Configuration flags
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// DO NOT CHANGE THESE HERE, CHANGE THEM IN effect.txt


#ifndef BlurSamplingRange
#define BlurSamplingRange 0.6
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
float4 PS_ProcessBlur(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
	float4 res;
	float4 coord=0.0;

	coord.xy=IN.txcoord.xy;
	float4 origcolor;

	coord.w=0.0;


	origcolor=tex2Dlod(SamplerColor, coord);

	// coord.x=IN.txcoord.x-(1.5/ScreenSize);
	// float4 lshift=tex2Dlod(SamplerColor, coord);
	// coord.x=IN.txcoord.x+(1.5/ScreenSize);
	// float4 rshift=tex2Dlod(SamplerColor, coord);


	float2 offset[16]=
	{
	 float2(1.0, 1.0),
	 float2(-1.0, -1.0),
	 float2(-1.0, 1.0),
	 float2(1.0, -1.0),

	 float2(1.0, 0.0),
	 float2(-1.0, 0.0),
	 float2(0.0, 1.0),
	 float2(0.0, -1.0),

	 float2(1.41, 0.0),
	 float2(-1.41, 0.0),
	 float2(0.0, 1.41),
	 float2(0.0, -1.41),

	 float2(1.41, 1.41),
	 float2(-1.41, -1.41),
	 float2(-1.41, 1.41),
	 float2(1.41, -1.41)
	};
	int i=0;

	float4 tcol=origcolor;
	float2 invscreensize=1.0/ScreenSize;
	invscreensize.y=invscreensize.y/ScreenScaleY;
	//for (i=0; i<8; i++) //higher quality
	//for (i=0; i<4; i++)
	for (i=0; i<16; i++)
	{
	 float2 tdir=offset[i].xy;
	 coord.xy=IN.txcoord.xy+tdir.xy*invscreensize*BlurSamplingRange;//*1.0;
	 float4 ct=tex2Dlod(SamplerColor, coord);

	 tcol+=ct;
	}
	//tcol*=0.2; // 1.0/(4+1)
	//tcol*=0.111; // 1.0/(8+1)  //higher quality
	tcol*=0.05882353;

res.xyz=tcol.xyz;

	res.w=1.0;
	return res;
}


#define SHADER PS_ProcessBlur
#include "technique.fxh"
