//===================================================================
// DOS game effect originally by Boris Vorontsov (http://enbdev.com)
//===================================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Configuration flags
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// DO NOT CHANGE THESE HERE, CHANGE THEM IN effect.txt

// The pixel size, larger = more pixelated. A value of 1 should be identical to the original game,
// but a bug in ENBSeries currently means some lines might still be blended vertically (AR bug)
#ifndef PIXELSIZE
#define PIXELSIZE 8
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 PS_DosGame(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
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
	xs=float2(ScreenSize, ScreenSize / 1.5) / PIXELSIZE;
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

#define SHADER PS_DosGame
#include "technique.fxh"
