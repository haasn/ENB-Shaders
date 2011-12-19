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

// Legacy
texture2D texBloom;
sampler2D SamplerBloom = sampler_state
{
	Texture     = <texBloom>;
	MinFilter   = LINEAR;
	MagFilter   = LINEAR;
	MipFilter   = LINEAR;
	AddressU    = Clamp;
	AddressV    = Clamp;
	SRGBTexture = FALSE;
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

// Temporary bug fix
#define ScreenScaleY (16/9.0)

// Definitions for easier access
#define ScreenWidth ScreenSize
#define ScreenHeight (ScreenSize / ScreenScaleY)
#define ScreenRect float2(ScreenWidth, ScreenHeight)

// Color of the screen with time dependent inertia
float4	ScreenBrightness;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Legacy externals
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// I don't know if these actually do anything, but I included them regardless

// (-10..10) For bloom it controls how much to dark in the night or when scene is dark (user defined constant factor)
float	ScreenBrightnessAdaptation;

// (0..10) Actually used for bloom, but may be useful here (user defined constant factor)
float	bloomPower;

// (0 or 1) If bloom enabled by user
float	useBloom;

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
