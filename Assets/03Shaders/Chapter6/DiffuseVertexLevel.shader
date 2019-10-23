﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter6/DiffuseVertexLevel"
{
	Properties{
		_Diffuse("Diffuse",Color)=(1.0,1.0,1.0,1.0)
	}

	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"} //光照模式

			CGPROGRAM
				 #pragma vertex vert
				 #pragma fragment frag
				 //Unity内置数据
				 #include "Lighting.cginc"	

				 fixed4 _Diffuse;

				 //定义顶点着色器的输入
				 struct a2v{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				 };

				 //定义顶点着色器的输出
				 struct v2f{
					  float4 pos : SV_POSITION;
					  fixed3 color : COLOR;
				 };

				 //逐顶点着色--漫反射
				 v2f vert(a2v v){
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);

					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

					fixed3 worldNoraml = normalize(mul(v.normal,(float3x3)unity_WorldToObject));

					fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

					fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNoraml,worldLight));

					o.color = ambient + diffuse;

					return o;
				 }

				 fixed4 frag(v2f i) : SV_Target{
					return fixed4(i.color,1.0);
				 }			 
			ENDCG
		}	
	}
	FallBack "Diffuse"
}
