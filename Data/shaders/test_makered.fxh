#include "common.fxh"

float4 PS_MakeRed(float2 coord : TEXCOORD0) : COLOR
{
	return float4(1, tex2D(SamplerColor, coord).gb, 1);
}

#define SHADER PS_MakeRed
#include "technique.fxh"
