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
float4 tempF1;
float4 tempF2;
float4 tempF3;

// Display resolution
#ifdef ENB100

// Compatibility mode with previous versions - size and scaley are still individual variables
float ScreenSize;
float ScreenScaleY;

#define ScreenWidth ScreenSize
#define ScreenWidthInv (1.0 / ScreenWidth)
#define ScreenScaleYInv (1.0 / ScreenScaleY)

#else

// Newer versions use a single vector
float4 ScreenSize;

#define ScreenWidth ScreenSize.x
#define ScreenWidthInv ScreenSize.y
#define ScreenScaleY ScreenSize.z
#define ScreenScaleYInv ScreenSize.w

#endif

// All versions: definitions for easier access

#define ScreenHeight (ScreenWidth / ScreenScaleY)
#define ScreenHeightInv (ScreenScaleY / ScreenWidth)
#define ScreenRect float2(ScreenWidth, ScreenHeight)

// Color of the screen with time dependent inertia
float4 ScreenBrightness;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Legacy externals
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// I don't know if these actually do anything, but I included them regardless

// (-10..10) For bloom it controls how much to dark in the night or when scene is dark (user defined constant factor)
float ScreenBrightnessAdaptation;

// (0..10) Actually used for bloom, but may be useful here (user defined constant factor)
float bloomPower;

// (0 or 1) If bloom enabled by user
float useBloom;

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
