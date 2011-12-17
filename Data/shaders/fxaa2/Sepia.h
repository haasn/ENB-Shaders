/*------------------------------------------------------------------------------
						SEPIA
------------------------------------------------------------------------------*/

float4 SepiaPass( float4 colorInput, float2 tex )
{
	float4 sepia = colorInput;
	// Calculating amounts of input, grey and sepia colors to blend and combine
	float grey = dot(sepia.rgb, float4(0.3, 0.59, 0.11, 0));
	sepia.rgb = float4(sepia.rgb * ColorTone , 1);
	float4 grey2 = grey * (GreyPower);
	float4 color2 = colorInput / (GreyPower + 1);
	float4 blend2 = grey2 + color2;
	sepia.rgb = lerp(blend2, sepia.rgb, SepiaPower);
	// returning the final color
	return sepia;
}