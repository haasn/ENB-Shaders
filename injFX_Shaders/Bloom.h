/*------------------------------------------------------------------------------
						BLOOM
------------------------------------------------------------------------------*/

float4 BloomPass( float4 ColorInput2,float2 Tex  )
{
	float4 BlurColor2 =  0;
	float MaxDistance = sqrt(8*BloomWidth);
	float CurDistance = 0;
	float4 Blurtemp = 0;
	float Samplecount = 0;
	for(float Samplex = (- 2); Samplex < 2; Samplex = Samplex + 1)
	{
		for(float Sampley = (- 2); Sampley < 2; Sampley = Sampley + 1)
		{
			CurDistance = sqrt (((Samplex * Samplex) + (Sampley*Sampley))*BloomWidth);
			Blurtemp.rgb = tex2D(s0, float2(Tex.x +(Tex.x*Samplex*px*BloomWidth),Tex.y +(Tex.y*Sampley*py*BloomWidth)));
			BlurColor2.rgb += lerp(Blurtemp.rgb,ColorInput2.rgb, 1 - ((MaxDistance - CurDistance)/MaxDistance));
			Samplecount = Samplecount + 1;
		}
	}
	BlurColor2.rgb = (BlurColor2.rgb / (Samplecount - (BloomPower - BloomThreshold*5)));
	float Bloomamount = (dot(ColorInput2.xyz,float3(0.299f, 0.587f, 0.114f))) ;
	float4	BlurColor = BlurColor2 * (BloomPower + 3);
	BlurColor2.rgb =lerp(ColorInput2,BlurColor, Bloomamount).rgb ;	
	BlurColor2.a = ColorInput2.a;
	return  BlurColor2;
}