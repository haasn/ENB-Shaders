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

texture2D texNoise;
sampler2D SamplerNoise = sampler_state
{
	Texture       = <texNoise>;
	MinFilter     = POINT;
	MagFilter     = POINT;
	MipFilter     = NONE;
	AddressU      = Wrap;
	AddressV      = Wrap;
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
// Externals
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Keyboard controlled variables
float tempF1;
float tempF2;
float tempF3;
float tempF4;
float tempF5;
float tempF6;
float tempF7;
float tempF8;
float tempF9;
float tempF0;

// Width of the display resolution (eg. 1920)
float ScreenSize;

// Screen aspect ratio (width / height)
float ScreenScaleY;

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
