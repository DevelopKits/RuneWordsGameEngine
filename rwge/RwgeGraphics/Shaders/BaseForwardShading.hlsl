#include "Material.hlsli"
#include "Light.hlsli"
#include "BRDF.hlsli"
#include "SH.hlsli"

//////////////////////////////////////////////////////////////////////////////

// shared�ؼ�������ͨ��Effect Pool�ڲ�ͬ��shader�乲������
shared matrix	g_WVP;
shared float3	g_ViewOppositeDirection;				// ָ���������������ӵ㷢������������ķ�����

//////////////////////////////////////////////////////////////////////////////

half PhongApprox(half roughness, half reflectionDotLight)
{
	half a = roughness * roughness;		// 1��MUL���˷���ָ��
	half a2 = a * a;					// 1��MULָ��
	//float rcp_a2 = rcp(a2);			// 1��RCP��������ָ��(DX11,��ShaderModel 5.0��֧�����ָ��)
	float rcp_a2 = 1.0 / a2;

	// �����˹���̵Ľ���: pow( x, n ) ~= exp( (n + 0.775) * (x - 1) )
	// Phong����ģ��: n = 0.5 / a2 - 0.5
	// 0.5 / ln(2), 0.275 / ln(2)
	half c = 0.72134752 * rcp_a2 + 0.39674113;			// 1��MADָ��
	return rcp_a2 * exp2(c * reflectionDotLight - c);	// 2��MADָ�1��EXP2����ƽ����ָ�1��MULָ��
}

//////////////////////////////////////////////////////////////////////////////

struct VSOutput
{
	float4 position	: POSITION;
	float3 PsUsedPos: TEXCOORD1;
	float2 texCoord : TEXCOORD0;
	float3 tangent  : TANGENT;
	float3 binormal : BINORMAL;
	float3 normal	: NORMAL;
};

VSOutput BaseVS(float4 inPosition	: POSITION, 
				float2 inTexCoord	: TEXCOORD0,
				float3 inNormal		: NORMAL,
				float3 inBinormal	: BINORMAL,
				float3 inTangent	: TANGENT)
{
	VSOutput output = (VSOutput)0;

	output.position = inPosition;
	output.PsUsedPos = inPosition;
	output.texCoord = inTexCoord;
	output.normal = inNormal;
	output.binormal = inBinormal;
	output.tangent = inTangent;

	return output;
}

//////////////////////////////////////////////////////////////////////////////

half4 BasePS(	float3 inPosition	: TEXCOORD1,
				float2 inTexCoord	: TEXCOORD0,
				float3 inNormal		: NORMAL,
				float3 inBinormal	: BINORMAL,
				float3 inTangent	: TANGENT) : COLOR
{
	half3	baseColor		= GetBaseColor(inTexCoord);
	half3	emissiveColor	= GetEmissiveColor(inTexCoord);
	half	metallic		= GetMetallic(inTexCoord);
	half	specular		= GetSpecular(inTexCoord);
	half	roughness		= GetRoughness(inTexCoord);
	half	opacity			= GetOpacity(inTexCoord);

	// ������Ҫ�����߿ռ�ת��������ռ�
	float3	normal = GetNormal(inTexCoord);
	normal = normalize(mul(normal, float3x3(inNormal, inBinormal, inTangent)));

	// ============================= ������ʵ�������͸߹�ɫ =============================
#if MATERIAL_NONMETAL
	// ������ʽ�����Ϊ0�����Լ򻯼���
	half3 diffuseColor = baseColor;
	half  specularColor = 0.04;
#else
	half  dielectricSpecular = 0.08 * specular;
	half3 diffuseColor = baseColor - baseColor * metallic;		// 1��MAD���˼�����ָ�
	half3 specularColor = (dielectricSpecular - dielectricSpecular * metallic) + baseColor * metallic;	// 2��MAD
#endif

#if MATERIAL_FULLY_ROUGH
	// ������ʴֲڶ�Ϊ1�����Լ򻯼���
	diffuseColor += specular * 0.45;
	specularColor = 0;
#else
	half normalDotView = max(dot(normal, g_ViewOppositeDirection), 0);

#	if MATERIAL_NONMETAL
	specularColor = EnvBRDFApproxNonmetal(roughness, normalDotView);
#	else
	specularColor = EnvBRDFApprox(specularColor, roughness, normalDotView);
#	endif
#endif
	
	// ============================= ���㻷���⣨�Ƿ���⣩������ =============================
	half3 diffuseGI = max(half3(0, 0, 0), DotSH(g_OneBandSHCoefficients, normal));

	half  indirectIrradiance = dot(diffuseGI, half3(0.3, 0.59, 0.11));
	half3 color = diffuseColor * diffuseGI;

	// ============================= ��Ӱ���㣨�ԣ� =============================

	// ============================= ���㷽�������� =============================
#if MATERIAL_SHADING_MODE != SHADING_UNLIT
	half3 reflectionVector = -g_ViewOppositeDirection + normal * dot(normal, g_ViewOppositeDirection) * 2.0;
	half3 lightDirection = GetLightWorldDirection(inPosition);
	half  normalDotLight = max(0, dot(normal, lightDirection));
	half reflectionDotLight = max(0, dot(reflectionVector, lightDirection));

	color += GetLightDiffuseColor() * normalDotLight * (diffuseColor + specularColor * PhongApprox(roughness, reflectionDotLight));
#endif

	// ============================= ������ͼ���㣨�ԣ� =============================

	// ============================= �����Է�������� =============================
	color += emissiveColor;

	// ============================= ���㶥���������ԣ� =============================

	// ============================= �������ʻ��ģʽ =============================
#if MATERIAL_BLEND_MODE == BLENDING_ADDITIVE		
	half4 outColor = half4(color * opacity, 0.0f);
#else
	half4 outColor = half4(color, opacity);
#endif

	return outColor;
}

//////////////////////////////////////////////////////////////////////////////

technique BaseTechnique
{
	pass BasePass
	{
		// ���岻ͬ���ģʽ�µ���Ⱦ״̬
#if MATERIAL_BLEND_MODE == BLENDING_OPAQUE
		AlphaBlendEnable = FALSE;		// �Ƿ�����Alpha���

		AlphaTestEnable = FALSE;		// �Ƿ�����Alpha Test

		ZEnable = TRUE;					// �Ƿ�����Z Buffer
		ZFunc = LESSEQUAL;				// Z Test Function
		ZWriteEnable = TRUE;			// �����ص�Z Test�ɹ����Ƿ���дZ Buffer

#elif MATERIAL_BLEND_MODE == BLENDING_TRANSLUCENT
		AlphaBlendEnable = TRUE;		// �Ƿ�����Alpha���
		BlendOp = ADD;					// Alpha��Ϻ�����ResultColor = (InColor * SrcBlend) BlendOp (TragetColor * DestBlend)
		SrcBlend = SRCALPHA;			// �����ص���ɫ�Ļ������
		DestBlend = INVSRCALPHA;		// ��ɫ�Ļ������

		AlphaTestEnable = TRUE;			// �Ƿ�����Alpha Test
		AlphaFunc = GREATER;			// Alpha Test Fucntion
		AlphaRef = 0x00000001;			// Alpha Test�Ĳ���

		ZEnable = TRUE;					// �Ƿ�����Z Buffer��Z Test
		ZFunc = LESSEQUAL;				// Z Test Function
		ZWriteEnable = FALSE;			// �����ص�Z Test�ɹ����Ƿ���дZ Buffer

#elif MATERIAL_BLEND_MODE == BLENDING_ADDITIVE
		AlphaBlendEnable = TRUE;		// �Ƿ�����Alpha���
		BlendOp = ADD;					// Alpha��Ϻ�����ResultColor = (InColor * SrcBlend) BlendOp (TragetColor * DestBlend)
		SrcBlend = ONE;					// �����ص���ɫ�Ļ������
		DestBlend = ONE;				// ��ɫ�Ļ������

		AlphaTestEnable = FALSE;		// �Ƿ�����Alpha Test

		ZEnable = TRUE;					// �Ƿ�����Z Buffer��Z Test
		ZFunc = LESSEQUAL;				// Z Test Function
		ZWriteEnable = FALSE;			// �����ص�Z Test�ɹ����Ƿ���дZ Buffer

#elif MATERIAL_BLEND_MODE == BLENDING_MODULATE
		AlphaBlendEnable = TRUE;		// �Ƿ�����Alpha���
		BlendOp = MAX;					// Alpha��Ϻ�����ResultColor = (InColor * SrcBlend) BlendOp (TragetColor * DestBlend)
		SrcBlend = DESTCOLOR;			// �����ص���ɫ�Ļ������
		DestBlend = ZERO;				// ��ɫ�Ļ������

		AlphaTestEnable = FALSE;		// �Ƿ�����Alpha Test

		ZEnable = TRUE;					// �Ƿ�����Z Buffer��Z Test
		ZFunc = LESSEQUAL;				// Z Test Function
		ZWriteEnable = FALSE;			// �����ص�Z Test�ɹ����Ƿ���дZ Buffer

#elif MATERIAL_BLEND_MODE == BLENDING_MASKED
		AlphaBlendEnable = FALSE;		// �Ƿ�����Alpha���

		AlphaTestEnable = TRUE;			// �Ƿ�����Alpha Test
		AlphaFunc = GREATER;			// Alpha Test Fucntion
		//AlphaRef = 0x00000001;		// Alpha Test�Ĳ�����������Ҫ�ɲ��ʲ�������

		ZEnable = TRUE;					// �Ƿ�����Z Buffer��Z Test
		ZFunc = LESSEQUAL;				// Z Test Function
		ZWriteEnable = FALSE;			// �����ص�Z Test�ɹ����Ƿ���дZ Buffer
#endif

		// ˫������
#if MATERIAL_TWO_SIDED
		CullMode = NONE;
#else
		CullMode = CCW;
#endif

		VertexShader = compile vs_3_0 BaseVS();
		PixelShader = compile ps_3_0 BasePS();
	}
}