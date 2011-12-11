//===================================================================
// DOS game effect originally by Boris Vorontsov (http://enbdev.com)
//===================================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 PS_ProcessDos(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
	float4 res;
	float4 coord=0.0;

	coord.xy=IN.txcoord.xy;
	float4 origcolor;

	coord.w=0.0;

	float2	xs;
	xs.x=ScreenSize;
	xs.y=ScreenSize/ScreenScaleY;
	//v1
	//xs*=0.25;
	//v2
	xs=float2(320.0, 240.0);
	float	EColorsCount=16.0001;

	coord.xy=floor(IN.txcoord.xy * xs)/xs;

	origcolor=tex2Dlod(SamplerColor, coord);

	origcolor+=0.0001;
//	origcolor=lerp(origcolor, normalize(origcolor), 0.5);

	float	graymax=max(origcolor.x, max(origcolor.y, origcolor.z));
	float3	ncolor=origcolor.xyz/graymax;
	graymax=floor(graymax * EColorsCount)/EColorsCount;
	origcolor.xyz*=graymax;
//	origcolor=floor(origcolor * EColorsCount)/EColorsCount;

	res.xyz=origcolor.xyz;

	res.w=1.0;
	return res;
}

#define SHADER PS_ProcessDos
#include "technique.fxh"
