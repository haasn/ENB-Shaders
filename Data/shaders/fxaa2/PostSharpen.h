/*------------------------------------------------------------------------------
						POST_SHARPEN
------------------------------------------------------------------------------*/

float4 PostSharpenPass( float4 orig,float2 tex ) 
{
 float4 color;
	color = 9.0 * orig;
	color -= tex2D( s0, tex.xy + float2(px, py));
	color -= tex2D( s0, tex.xy + float2(0, py));
	color -= tex2D( s0, tex.xy + float2(-px, py));
	color -= tex2D( s0, tex.xy + float2(-px, 0));
	color -= tex2D( s0, tex.xy + float2(-px, -py));
	color -= tex2D( s0, tex.xy + float2(0, -py));
	color -= tex2D( s0, tex.xy + float2(px, -py));
	color -= tex2D( s0, tex.xy + float2(px, 0));
	color = color * Sharpen + (1.0 - Sharpen) * orig;
	color.a = orig.a;
	return color;
}