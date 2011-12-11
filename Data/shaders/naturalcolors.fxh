//=======================
// Natural Colors shader
//=======================

#include "common.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Configuration flags
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// DO NOT CHANGE THESE HERE, CHANGE THEM IN effect.txt

// To enable chromatic adaptation: (makes all tones more neutral)
// #define EADAPTATION

// The target white point (0-10, higher = more blue)
#ifndef WHITEPOINT
#define WHITEPOINT 5
#endif
// If default is too blue, try 4, if it's too red, try 6

// To enable saturation controls:
// #define SATURATION 1.0
// 0 is grayscale, 1 is normal, higher values = more saturated

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Matrices and constants
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// sRGB to XYZ
float3x3 M2XYZ = float3x3(0.4124564, 0.3575761, 0.1804375, 0.2126729, 0.7151522, 0.0721750, 0.0193339, 0.1191920, 0.9503041);

// Scaling matrix
float3x3 Bradford = float3x3(0.8951, 0.2664, -0.1614, -0.7502, 1.7135, 0.0367, 0.0389, -0.0685, 1.0296);
float3x3 Backford = float3x3(0.986992905466712, -0.14705425642099, 0.159962651663731, 0.432305269723395, 0.518360271536777, 0.0492912282128556, -0.00852866457517733, 0.0400428216540849, 0.96848669578755);

// XYZ to sRGB
float3x3 M2RGB = float3x3(3.2404542, -1.5371385, -0.4985314, -0.9692660, 1.8760108, 0.0415560, 0.0556434, -0.2040259, 1.0572252);

// The Skyrim constant (measured white point ingame as XYZ)
float3 skyWP = float3(157, 172.6, 181.2);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Color temperature conversion function
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float3 FromTemperature(float T)
{
	float x;
	
    if (4000 <= T && T <= 7000) {
        x = -4.6070E9 / (T*T*T) + 2.9678E6 / (T*T) + 9.911E1 / T + 0.244063;
    } else if (7000 < T && T <= 25000) {
        x = -2.0064E9 / (T*T*T) + 1.9018E6 / (T*T) + 2.4748E2 / T + 0.237040;
    } else {
        x = 0;
    }
	
	float y = -3 * x * x + 2.87 * x - 0.275;
	
	// Convert to XYZ
	return float3(x/y, 1, (1-x-y)/y);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Post-processing pixel shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#define f(t) (t>pow(6/29.,3)?pow(t,1/3.):pow(29/6.,2)/3*t+4/29.)
#define f_(t) (t>6/29.?pow(t,3):pow(6/29.,2)*3*(t-4/29.))

float4 PS_NaturalColors(float2 coord : TEXCOORD0) : COLOR
{
	// Preshader optimization
	#ifdef EADAPTATION
	float3 dstWP = FromTemperature(WHITEPOINT * 600 + 4000);
	float3 srcWP = mul(M2XYZ, pow(skyWP / 255, 2.2)); // Our whitepoint is sRGB so decode it first
	srcWP /= srcWP.y; // Normalize it to Y=1
	float3 CS = mul(Bradford, srcWP);
	float3 CD = mul(Bradford, dstWP);
	float3x3 CA = mul(mul(Backford, float3x3(CD.x / CS.x, 0, 0, 0, CD.y / CS.y, 0, 0, 0, CD.z / CS.z)), Bradford);
	#endif
	
	// Sample
	float3 inp = tex2D(SamplerColor, coord).xyz;
	
	// SMAA already lifts the gamma but FXAA and ENB do not
	#ifndef SMAA
	inp = pow(inp, 2.2);
	#endif
	
	// Convert from sRGB primaries to XYZ
	float3 col = mul(M2XYZ, inp.xyz);

	// Chromatic adaptation matrix - simply multiply
	#ifdef EADAPTATION	
	col = mul(CA, col);
	#endif

	// Saturation controls in LC*h light linear space
	#ifdef SATURATION
	col.xyz = float3(116*f(col.y)-16,500*(f(col.x/0.95047)-f(col.y)),200*(f(col.y)-f(col.z/1.08883)));
	col.yz = float2(sqrt(col.y*col.y+col.z*col.z)*SATURATION,atan2(col.z,col.y));
	col.xyz = float3((col.x+16)/116,cos(col.z)*col.y,sin(col.z)*col.y);
	col.yzx = float3(f_(col.x),1.08883*f_(col.x-col.z/200),0.95047*f_(col.x+col.y/500));
	#endif

	// Convert from XYZ back to sRGB primaries and clip levels
	col = saturate(mul(M2RGB, col));
	
	#ifndef SMAA
	col = pow(col, 1/2.2); // Encode into gamma space again
	#endif
	
	return float4(col, 1);
}

// Load the technique itself
#define SHADER PS_NaturalColors
#include "technique.fxh"
