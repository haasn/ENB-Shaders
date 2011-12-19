//=============================================================
// Faux cell originally by Boris Vorontsov (http://enbdev.com)
//=============================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 PS_FauxCell(VS_OUTPUT_POST In) : COLOR
{		
	float4 color = tex2D(SamplerColor, In.txcoord);

	color.r = round(color.r*800.0)/900.0;
	color.g = round(color.g*800.0)/900.0;
	color.b = round(color.b*800.0)/900.0;
	
	const float threshold = 0.0545;

	const int NUM = 9;
	const float2 c[NUM] =
	{
		float2(-0.0078125, 0.0078125), 
		float2(-0.0078125, 0.0078125),
		float2( 0.0078125, 0.0078125),
		float2(-0.0078125, 0.00 ),
		float2( 0.0,       0.0),
		float2( 0.0078125, 0.007 ),
		float2(-0.0078125,-0.0078125),
		float2( 0.0078125,-0.0078125),
		float2( 0.0078125,-0.0078125),
	};	

	int i;
	float3 col[NUM];
	for (i=0; i < NUM; i++)
	{
		col[i] = tex2D(SamplerColor, In.txcoord.xy + 0.027512*c[i]);
	}
	
	float3 rgb2lum = float3(0.30, 0.59, 0.11);
	float lum[NUM];
	for (i = 0; i < NUM; i++)
	{
		lum[i] = dot(col[i].xyz, rgb2lum);
	}
	float x = lum[2]+2*lum[8]+2*lum[5]-lum[0]-2*lum[3]-2*lum[6];
	float y = lum[6]+2*lum[7]+2*lum[8]-lum[0]-2*lum[1]-2*lum[2];
	float edge =(x*x + y*y < threshold)? 1.20:0.35;
	
	color.rgb *= edge;

	return color;
}

#define SHADER PS_FauxCell
#include "technique.fxh"
