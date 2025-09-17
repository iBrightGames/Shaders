

Shader "Custom/SmoothGridWater"
{
    Properties
    {
        _WaveHeight("Wave Height", Range(0,1)) = 0.1
        _WaveSpeed("Wave Speed", Range(0,5)) = 1
        _ColorShallow("Shallow Color", Color) = (0.3,0.6,1,1)
        _ColorDeep("Deep Color", Color) = (0.0,0.1,0.3,1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _WaveHeight;
            float _WaveSpeed;
            float4 _ColorShallow;
            float4 _ColorDeep;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float height : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                // Her vertex kendi fazında yukarı-aşağı hareket eder (dama tahtası)
                float rawWave = sin(_Time.y * _WaveSpeed + v.vertex.x * 3.1415)
                              + cos(_Time.y * _WaveSpeed + v.vertex.z * 3.1415);

                // -2..2 -> 0..1 normalize
                float t = (rawWave + 2.0) / 4.0;

                // Vertex hareketini smooth / kavisli yap
                t = sin(t * 3.1415 * 0.5); // 0..1 arası kavis

                float yOffset = t * _WaveHeight * 2.0 - _WaveHeight;

                float3 newPos = v.vertex.xyz + float3(0, yOffset, 0);

                o.pos = UnityObjectToClipPos(float4(newPos,1.0));
                o.height = yOffset;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Vertex yüksekliğine göre renk geçişi
                float t = (i.height + _WaveHeight) / (_WaveHeight*2);
                t = smoothstep(0.0, 1.0, t);
                return lerp(_ColorDeep, _ColorShallow, t);
            }
            ENDCG
        }
    }
}
