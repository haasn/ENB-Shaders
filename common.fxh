#ifndef COMMON
#define COMMON

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Textures and samplers
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

texture2D texColor;
sampler2D SamplerColor = sampler_state
{
	Texture       = <texColor>;
	MinFilter     = LINEAR;
	MagFilter     = LINEAR;
	MipFilter     = NONE;
	AddressU      = Clamp;
	AddressV      = Clamp;
	SRGBTexture   = FALSE;
	MaxMipLevel   = 0;
	MipMapLodBias = 0;
};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Structures
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

struct VS_OUTPUT_POST {
	float4 vpos    : POSITION;
	float2 txcoord : TEXCOORD0;
};

struct VS_INPUT_POST {
	float3 pos     : POSITION;
	float2 txcoord : TEXCOORD0;
};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Pass-through vertex shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

VS_OUTPUT_POST VS_Passthrough(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST OUT;
	OUT.vpos = float4(IN.pos, 1);
	OUT.txcoord = IN.txcoord;
	return OUT;
}
#endif
