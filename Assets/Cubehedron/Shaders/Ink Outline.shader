﻿Shader "Custom/Ink Outline" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range (.002, 0.03)) = .005

		_MainTex ("Base (RGB)", 2D) = "white" {}
		_InkColor ("Ink Color", Color) = (0,0,0,0)
		_InkCutoff ("Ink Cutoff", Float) = 0.5
		_ShadowCutoff ("Shadow Cutoff", Float) = 0.5
		_InkRamp ("Ink Ramp", 2D) = "black"
		_EdgeWobbleFactor ("Edge Wobble Factor", Float) = 0.1
		_TurbulenceTex ("Turbulence", 2D) = "white"
		_TurbulenceFactor ("Turbulence Factor", Float) = 0.1
		_PigmentDispertionFactor ("Pigment Dispersion Factor", Float) = 0.1
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	struct appdata {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};

	struct v2f {
		float4 pos : POSITION;
		float4 color : COLOR;
	};

	uniform float _Outline;
	uniform float4 _OutlineColor;

	v2f vert(appdata v) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

		float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
		float2 offset = TransformViewToProjection(norm.xy);

		o.pos.xy += offset * o.pos.z * _Outline;
		o.color = _OutlineColor;
		return o;
	}
	ENDCG

	SubShader {
		Tags { "RenderType"="Opaque" }
		UsePass "Custom/Ink/FORWARD"
		Pass {
			Name "OUTLINE"
			Tags { "LightMode" = "Always" }
			Cull Front
			ZWrite On
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			half4 frag(v2f i) :COLOR { return i.color; }
			ENDCG
		}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		UsePass "Custom/Ink/FORWARD"
		Pass {
			Name "OUTLINE"
			Tags { "LightMode" = "Always" }
			Cull Front
			ZWrite On
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma exclude_renderers shaderonly
			ENDCG
			SetTexture [_MainTex] { combine primary }
		}
	}

	Fallback "Custom/Ink"
}
