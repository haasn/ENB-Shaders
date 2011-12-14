//===============================================
// FXAA Injector wrapper, original code by:
//  - [some_dude]
//  - BeetleatWar1977
//  - [DKT70]
//  - Violator
//  - fpedace
//===============================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Configuration flags
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// DO NOT CHANGE THESE HERE, COPY THEM TO effect.txt

/*

// FXAA Injector v2 default settings

#define USE_ANTI_ALIASING 0
#define USE_PRE_SHARPEN 0
#define USE_BLOOM 1
#define USE_TECHNICOLOR 1
#define USE_TONEMAP 1
#define USE_SEPIA 1
#define USE_POST_SHARPEN 1
#define FXAA_QUALITY__PRESET 6
float fxaaQualitySubpix = 0.3885;
float fxaaQualityEdgeThreshold = 0.1315;
float fxaaQualityEdgeThresholdMin = 0.0545;
bool highQualitySharpen = 0;
float AverageBlur = 0.45;
float CoefficientsBlur = 1.3333;
float CoefficientsOriginal = 2.3333;
float SharpenEdge = 0.205;
float SharpenContour = 0.055;
float BloomThreshold = 18.5;
float BloomPower = 1.892;
float BloomWidth = 0.0284;
#define TechniAmount 0.33
#define TechniPower 4
#define redNegativeAmount 0.99
#define greenNegativeAmount 0.99
#define blueNegativeAmount 0.99
#define Gamma 1.05
#define Exposure 0.15
#define Saturation 1.125
#define Bleach 0.25
#define Defog 0
#define ColorTone float3(1.30, 1.02, 0.68)
float SepiaPower = 0.11;
float GreyPower = 0.22;
float Sharpen = 0.07;

*/

// Defines the API to use it with
#define FXAA_HLSL_3 1
// NOTE: This version uses a modified FXAA_GREEN_AS_LUMA 1
#define FXAA_GREEN_AS_LUMA 1
// Includes the Main shader, FXAA 3.11
#include "injFX_Shaders\Fxaa3_11.h"

// Screen width and height
#define BUFFER_WIDTH ScreenSize
#define BUFFER_HEIGHT (BUFFER_WIDTH * 9/16) // assume 16:9 until boris gets his code fixed
#define BUFFER_RCP_WIDTH  (1.0 / 1920)
#define BUFFER_RCP_HEIGHT (1.0 / 1200)

// Compatibility
#define COLOR0 COLOR
#define screenSampler SamplerColor
#define lumaSampler SamplerColor

// Includes additional shaders, like Sharpen, Bloom, Tonemap etc.
#include "injFX_Shaders\Post.h"

// FXAA Shader Function
float4 FXAA_LumaShader( float2 Tex : TEXCOORD0 ) : COLOR0
{
#if(USE_ANTI_ALIASING == 1)
    float4 c0 = FxaaPixelShader(
		// pos, Output color texture
		Tex,
		// tex, Input color texture
		screenSampler,
		// fxaaQualityRcpFrame, gets coordinates for screen width and height, xy
		float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT),
		//fxaaConsoleRcpFrameOpt2, gets coordinates for screen width and height, xyzw
		float4(-2.0*BUFFER_RCP_WIDTH,-2.0*BUFFER_RCP_HEIGHT,2.0*BUFFER_RCP_WIDTH,2.0*BUFFER_RCP_HEIGHT),
		// Choose the amount of sub-pixel aliasing removal
		fxaaQualitySubpix,
		// The minimum amount of local contrast required to apply algorithm
		fxaaQualityEdgeThreshold,
		// Trims the algorithm from processing darks
		fxaaQualityEdgeThresholdMin
	);
#else
	float4 c0 = tex2D(screenSampler,Tex);
#endif
    return c0;
}

float4 FXAA_MyShader( float2 Tex : TEXCOORD0 ) : COLOR0
{
	float4 c0 = main(Tex);
	c0.w = 1;
    return saturate(c0);
}

#define SHADER FXAA_LumaShader
#include "technique.fxh"

#define SHADER FXAA_MyShader
#include "technique.fxh"
