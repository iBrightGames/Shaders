Shader "Custom/BounceShader"
{
    Properties
    {
        _BounceAmount ("Bounce Amount", Range(-1,1)) = 0
        _Elasticity ("Elasticity", Range(0,2)) = 1
        _BaseScaleY ("Base Y Scale", Range(0.5,2)) = 1
        _Color ("Color", Color) = (1,1,1,1)
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

            float _BounceAmount; // Anlık squash/stretch miktarı
            float _Elasticity;   // Yanlara yayılma katsayısı
            float _BaseScaleY;   // Normal Y ölçeği
            float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;

                // Esneklik parametreleriyle ölçek hesaplama
                float scaleY = _BaseScaleY + _BounceAmount;
                float scaleXZ = 1.0 - (_BounceAmount * 0.5 * _Elasticity);

                // Yeni vertex pozisyonu
                float3 newPos = float3(
                    v.vertex.x * scaleXZ,
                    v.vertex.y * scaleY,
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
