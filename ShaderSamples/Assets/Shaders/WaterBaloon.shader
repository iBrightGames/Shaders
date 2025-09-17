
Shader "Custom/WaterBalloonShader"
{
    Properties
    {
        _BounceAmount ("Bounce Amount", Range(-1,1)) = 0
        _Elasticity ("Elasticity", Range(0,2)) = 1
        _WaveStrength ("Wave Strength", Range(0,0.1)) = 0.02
        _Color ("Color", Color) = (0.2,0.5,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _BounceAmount;
            float _Elasticity;
            float _WaveStrength;
            float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;

                // Vertex Y konumunu normalize et (0 = alt, 1 = üst)
                float yNorm = saturate(v.vertex.y);

                // Alt vertexler daha çok sıkışır, üstler daha az
                float scaleY = 1.0 + _BounceAmount * (1.0 - yNorm);
                float scaleXZ = 1.0 - _BounceAmount * 0.5 * _Elasticity * (1.0 - yNorm);

                // Dalgalanma / titreşim
                float wave = sin(_Time.y * 10.0 + v.vertex.x * 5.0 + v.vertex.z * 5.0) * _WaveStrength * yNorm;

                float3 newPos = float3(
                    v.vertex.x * scaleXZ,
                    v.vertex.y * scaleY + wave,
                    v.vertex.z * scaleXZ
                );

                o.pos = UnityObjectToClipPos(float4(newPos,1.0));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
