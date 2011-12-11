//==================================================================
// Sharpen filter originally by Boris Vorontsov (http://enbdev.com)
//==================================================================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Configuration flags
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*

= Configuration suggestions =

Default:

#define ESHARPENING
#define ESHARPENINGCOLOR
#define ENOISE


Sharper:

#define ESHARPENING
#define ESHARPENINGCOLOR
#define ENOISE
#define SamplingRange 0.5
#define SharpeningAmount 4.5


Ultra high quality:

#define ESHARPENING
#define ESHARPENINGCOLOR
#define ENOISE
#define SamplingRange 0.5
#define SharpeningAmount 1.5
#define ScanLineRepeat 0.5


Ultra high quality (sharper):

#define ESHARPENING
#define ESHARPENINGCOLOR
#define ENOISE
#define SamplingRange 0.5
#define SharpeningAmount 4.5
#define ScanLineRepeat 0.5


*/



// DO NOT CHANGE THESE HERE, CHANGE THEM IN effect.txt

// Enable blurring, useless, never enable
// #define EBLURRING

// Enable sharpening
// #define ESHARPENING

// If defined, color sharpen, otherwise sharp by gray
// #define ESHARPENINGCOLOR

// Enable noise in dark areas
// #define ENOISE


// Sharpen constants:

// Sharpening or blurring range
#ifndef SamplingRange
#define SamplingRange 0.4
#endif

#ifndef SharpeningAmount
#define SharpeningAmount 2.5
#endif

#ifndef ScanLineAmount
#define ScanLineAmount 0.0
#endif

#ifndef ScanLineRepeat
#define ScanLineRepeat 1.0
#endif

#ifndef NoiseAmount
#define NoiseAmount 0.1
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 PS_Sharpen(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
float4 res;
float4 coord=0.0;

coord.xy=IN.txcoord.xy;
float4 origcolor;

coord.w=0.0;


origcolor=tex2Dlod(SamplerColor, coord);

// coord.x=IN.txcoord.x-(1.5/ScreenSize);
// float4 lshift=tex2Dlod(SamplerColor, coord);
// coord.x=IN.txcoord.x+(1.5/ScreenSize);
// float4 rshift=tex2Dlod(SamplerColor, coord);


float2 offset[8]=
{
 float2(1.0, 1.0),
 float2(-1.0, -1.0),
 float2(-1.0, 1.0),
 float2(1.0, -1.0),

 float2(1.41, 0.0),
 float2(-1.41, 0.0),
 float2(0.0, 1.41),
 float2(0.0, -1.41)
};
int i=0;

float4 tcol=origcolor;
float invscreensize=1.0/ScreenSize;
//for (i=0; i<8; i++) //higher quality
for (i=0; i<4; i++)
{
 float2 tdir=offset[i].xy;
 coord.xy=IN.txcoord.xy+tdir.xy*invscreensize*SamplingRange;//*1.0;
 float4 ct=tex2Dlod(SamplerColor, coord);

 tcol+=ct;
}
tcol*=0.2; // 1.0/(4+1)
//tcol*=0.111; // 1.0/(8+1)  //higher quality


/*
//not interesting
#ifdef EBLURRING
//blur
res=tcol;
#endif
*/

//sharp
#ifdef ESHARPENING

#ifdef ESHARPENINGCOLOR
//color
res=origcolor*(1.0+((origcolor-tcol)*SharpeningAmount));
#else
 //non color
float difffact=dot((origcolor.xyz-tcol.xyz), 0.333);
res=origcolor*(1.0+difffact*SharpeningAmount);
#endif

//less sharpening for bright pixels
float rgray=origcolor.z; //blue fit well
//float rgray=max(origcolor.x, max(origcolor.y, origcolor.z));
rgray=pow(rgray, 3.0);
res=lerp(res, origcolor, saturate(rgray));

#endif




//grain noise
#ifdef ENOISE
float origgray=max(res.x, res.y);//dot(res.xyz, 0.333);
origgray=max(origgray, res.z);
coord.xy=IN.txcoord.xy*16.0 + origgray;
float4 cnoi=tex2Dlod(SamplerNoise, coord);
res=lerp(res, (cnoi.x+0.5)*res, NoiseAmount*saturate(1.0-origgray*1.8));
#endif


res.w=1.0;
return res;
}

#define SHADER PS_Sharpen
#include "technique.fxh"
