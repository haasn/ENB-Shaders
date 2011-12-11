//===================================================================
// Sin city effect originally by Boris Vorontsov (http://enbdev.com)
//===================================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 PS_SinCity(VS_OUTPUT_POST In) : COLOR
{
/*
float	tempF1=1.0;
float	tempF2=1.0;
float	tempF3=1.0;
float	tempF4=1.0;
float	tempF5=1.3;
float	tempF6=4.35;
float	tempF7=1.12;
float	tempF8=1.2;
float	tempF9=3.17;
float	tempF0=1.4;
*/
//START TO MAKE YOUR CHANGES FROM HERE
	float4 res;
	float4 uvsrc=0;
	uvsrc.xy=In.txcoord;

	res=0.0;
	float4 coord=0.0;
	coord.xy=In.txcoord.xy;
	float4 origcolor=tex2D(SamplerColor, coord.xy);
	float origgray=max(origcolor.r, max(origcolor.g, origcolor.b));


float2 dir=0.0;

	float4 color=origcolor;



/*
dir.xy=1.7*pow(origgray,0.3)/ScreenSize;//tempF9*
//dir.xy=2.0*pow(origgray,0.5) * float2(tempF9, tempF9)/ScreenSize;

coord.xy=In.txcoord+dir.xy*1.0;
color.r=tex2D(SamplerColor, coord.xy).r;

coord.xy=In.txcoord+dir.xy*0.5;
color.g=tex2D(SamplerColor, coord.xy).g;

coord.xy=In.txcoord+dir.xy*0.3;
color.b=tex2D(SamplerColor, coord.xy).b;
*/

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
//apply reverse pink filter
float3	revpink=float3(0.87, 1.0, 0.94); //TODO change this color RGB
float	graymax=max(color.x, max(color.y, color.z));
graymax=pow(graymax, 0.5);
color.xyz=lerp(color.xyz, color.xyz*revpink.xyz, graymax);
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////




res.xyz=color.xyz;


/*
dir.xy=tempF9*1.0*pow(origgray,0.5)/ScreenSize;
//dir.xy=2.0*pow(origgray,0.5) * float2(tempF9, tempF9)/ScreenSize;

coord.xy=In.txcoord-dir.xy*1.0;
color.r=tex2D(SamplerColor, coord.xy).r;

coord.xy=In.txcoord;//+dir.xy*0.6;
color.g=tex2D(SamplerColor, coord.xy).g;

coord.xy=In.txcoord+dir.xy*1.0;
color.b=tex2D(SamplerColor, coord.xy).b;

res.xyz=max(color.xyz, origcolor.xyz);

*/
	res.xyz=saturate(res.xyz); //if palette is black, then keep black.
	//if palette is white, then keep white.
	//if palette is gray, then output red.
	float3 whitecolor=float3(1.0, 1.0, 1.0);
	float3 blackcolor=float3(0.0, 0.0, 0.0);
	float3 redcolor=float3(1.0, 0.0, 0.0);
	//use max from all color channels as gray source 
	float grayresmax=max(res.x, max(res.y, res.z)); //simplified to understanding math, hard cut of color ranges 
	res.xyz=redcolor; if (grayresmax > 0.9) res.xyz=whitecolor; //0.9 is 230 in 0..255 space, decrease if needed if (grayresmax < 0.3) 	res.xyz=blackcolor; //increase 0.1 if not enough black //ok, now walkaround trick is applied
	res.a=1.0;
	return  res;
}

#define SHADER PS_SinCity
#include "technique.fxh"
