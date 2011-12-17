/*------------------------------------------------------------------------------
						TONEMAP
------------------------------------------------------------------------------*/

float4 TonemapPass( float4 colorInput, float2 tex )
{
	float4 color = colorInput;
	#define BlueShift 0.00
	#define FogColor float4(0.00, 0.00, 0.00, 0.0)
	color = max(0, color - Defog * FogColor);
	color *= pow(2.0f, Exposure);
	color = pow(color, Gamma);
	float4 d = color * float4(1.05f, 0.97f, 1.27f, color.a);
	color = lerp(color, d, BlueShift);
	float3 lumCoeff = float3(0.299, 0.587, 0.114);
	float lum = dot (lumCoeff, color.rgb);
	float3 blend = lum.rrr;
	float L = min(1, max (0, 10 * (lum - 0.45)));
	float3 result1 = 2.0f * color.rgb * blend;
	float3 result2 = 1.0f - 2.0f * (1.0f - blend) * (1.0f - color.rgb);
	float3 newColor = lerp(result1, result2, L);
	float A2 = Bleach * color.rgb;
	float3 mixRGB = A2 * newColor;
	color.rgb += ((1.0f - A2) * mixRGB);
	float4 middlegray = float(color.r + color.g + color.b) /3;
	float4 diffcolor = color - middlegray;
	color = (color + diffcolor * Saturation)/(1+(diffcolor*Saturation));
	return color;
}