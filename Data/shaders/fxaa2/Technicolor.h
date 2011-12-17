/*------------------------------------------------------------------------------
						TECHNICOLOR
------------------------------------------------------------------------------*/

#define greenfilter float4(0.30, 1.0, 0.0, 1.0)
#define redorangefilter float4(1.05, 0.620, 0.0, 1.0)
#define cyanfilter float4(0.0, 1.30, 1.0, 1.0)
#define magentafilter float4(1.0, 0.0, 1.05, 1.05)
#define yellowfilter float4(1.6, 1.6, 0.05, 1.0)

float4 TechnicolorPass( float4 colorInput, float2 tex )
{
	float4 tcol = colorInput;
	float4 filtgreen = tcol * greenfilter;
	float4 filtblue = tcol * magentafilter;
	float4 filtred = tcol * redorangefilter;
	float4 rednegative = float((filtred.r + filtred.g + filtred.b)/(redNegativeAmount * TechniPower));
	float4 greennegative = float((filtgreen.r + filtgreen.g + filtgreen.b)/(greenNegativeAmount* TechniPower));
	float4 bluenegative = float((filtblue.r+ filtblue.g + filtblue.b)/(blueNegativeAmount* TechniPower));
	float4 redoutput = rednegative + cyanfilter;
	float4 greenoutput = greennegative + magentafilter;
	float4 blueoutput = bluenegative + yellowfilter;
	float4 result = redoutput * greenoutput * blueoutput;
	return lerp(tcol, result, TechniAmount);
}