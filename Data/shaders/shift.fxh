//================================================================
// Shift effect originally by Boris Vorontsov (http://enbdev.com)
//================================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Configuration flags
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// DO NOT CHANGE THESE HERE, CHANGE THEM IN effect.txt


#ifndef ShiftSamplingRange
#define ShiftSamplingRange 0.75
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
float4 PS_ProcessShift(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
	float2 offset[8]=
	{
	 float2(1.0, 1.0),
	 float2(-1.0, -1.0),
	 float2(-1.0, 1.0),
	 float2(1.0, -1.0),

	 float2(1.41, 0.0),
	 float2(-1.41, 0.0),
	 float2(0.0, 1.41),
	 float2(0.0, -1.41)
	};
	
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
	
	int i=0;

	float4 tcol=origcolor;
	float2 invscreensize=1.0/ScreenSize;
	invscreensize.y=invscreensize.y/ScreenScaleY;
	//for (i=0; i<8; i++) //higher quality
/*	for (i=0; i<4; i++)
	{
	 float2 tdir=offset[i].xy;
	 coord.xy=IN.txcoord.xy+tdir.xy*invscreensize*SamplingRange;//*1.0;
	 float4 ct=tex2Dlod(SamplerColor, coord);

	 tcol+=ct;
	}
	tcol*=0.2; // 1.0/(4+1)
	//tcol*=0.111; // 1.0/(8+1)  //higher quality
*/

	coord.xy=IN.txcoord.xy;
	origcolor=tex2Dlod(SamplerColor, coord);
res.y=origcolor.y;

	coord.xy=IN.txcoord.xy;
	coord.y-=invscreensize*ShiftSamplingRange;
	origcolor=tex2Dlod(SamplerColor, coord);
res.x=origcolor.x;

	coord.xy=IN.txcoord.xy;
	coord.y+=invscreensize*ShiftSamplingRange;
	origcolor=tex2Dlod(SamplerColor, coord);
res.z=origcolor.z;


	res.w=1.0;
	return res;
}


#define SHADER PS_ProcessShift
#include "technique.fxh"
