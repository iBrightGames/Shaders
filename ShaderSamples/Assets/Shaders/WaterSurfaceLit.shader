// // Shader "Custom/URPWater_UnlitWorking"
// // {
// //     Properties
// //     {
// //         _WaveHeight("Wave Height", Range(0,1)) = 0.1
// //         _WaveSpeed("Wave Speed", Range(0,5)) = 1
// //         _ColorShallow("Shallow Color", Color) = (0.3,0.6,1,1)
// //         _ColorDeep("Deep Color", Color) = (0.0,0.1,0.3,1)
// //     }

// //     SubShader
// //     {
// //         Tags { "RenderType"="Opaque" }
// //         LOD 200

// //         Pass
// //         {
// //             HLSLPROGRAM
// //             #pragma vertex vert
// //             #pragma fragment frag
// //             #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

// //             float _WaveHeight;
// //             float _WaveSpeed;
// //             float4 _ColorShallow;
// //             float4 _ColorDeep;

// //             struct Attributes
// //             {
// //                 float4 positionOS : POSITION;
// //             };

// //             struct Varyings
// //             {
// //                 float4 posCS : SV_POSITION;
// //                 float height : TEXCOORD0;
// //             };

// //             Varyings vert(Attributes IN)
// //             {
// //                 Varyings OUT;

// //                 // Dama tahtası dalga hareketi
// //                 float rawWave = sin(_Time.y * _WaveSpeed + IN.positionOS.x * 3.1415)
// //                               + cos(_Time.y * _WaveSpeed + IN.positionOS.z * 3.1415);

// //                 float t = (rawWave + 2.0) / 4.0;
// //                 t = sin(t * 3.1415 * 0.5);

// //                 float yOffset = t * _WaveHeight * 2.0 - _WaveHeight;
// //                 float3 newPos = IN.positionOS.xyz + float3(0, yOffset, 0);

// //                 OUT.posCS = TransformObjectToHClip(float4(newPos,1.0));
// //                 OUT.height = yOffset;
// //                 return OUT;
// //             }

// //             half4 frag(Varyings IN) : SV_Target
// //             {
// //                 // Yükseklik bazlı renk geçişi
// //                 float t = saturate((IN.height + _WaveHeight)/(_WaveHeight*2));
// //                 return lerp(_ColorDeep, _ColorShallow, t);
// //             }

// //             ENDHLSL
// //         }
// //     }
// // }
// Shader "Custom/URPWaterLit"
// {
//     Properties
//     {
//         _WaveHeight("Wave Height", Range(0,1)) = 0.1
//         _WaveSpeed("Wave Speed", Range(0,5)) = 1
//         _ColorShallow("Shallow Color", Color) = (0.3,0.6,1,1)
//         _ColorDeep("Deep Color", Color) = (0.0,0.1,0.3,1)
//         _Smoothness("Smoothness", Range(0,1)) = 0.5
//         _SpecularStrength("Specular Strength", Range(0,1)) = 0.3
//     }

//     SubShader
//     {
//         Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }
//         LOD 200

//         Pass
//         {
//             Name "ForwardLit"
//             Tags { "LightMode" = "UniversalForward" }

//             HLSLPROGRAM
//             #pragma vertex vert
//             #pragma fragment frag
//             #pragma multi_compile_fog
//             #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
//             #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

//             struct Attributes
//             {
//                 float4 positionOS : POSITION;
//                 float3 normalOS : NORMAL;
//             };

//             struct Varyings
//             {
//                 float4 posCS : SV_POSITION;
//                 float3 posWS : TEXCOORD0;
//                 float3 normalWS : TEXCOORD1;
//                 float height : TEXCOORD2;
//             };

//             float _WaveHeight;
//             float _WaveSpeed;
//             float4 _ColorShallow;
//             float4 _ColorDeep;
//             float _Smoothness;
//             float _SpecularStrength;

//             // Vertex dalga fonksiyonu
//             float GetWave(float3 pos)
//             {
//                 float raw = sin(_Time.y * _WaveSpeed + pos.x * 3.1415)
//                           + cos(_Time.y * _WaveSpeed + pos.z * 3.1415);
//                 float t = (raw + 2.0)/4.0;
//                 t = sin(t * 3.1415 * 0.5);
//                 return t * _WaveHeight * 2.0 - _WaveHeight;
//             }

//             Varyings vert(Attributes IN)
//             {
//                 Varyings OUT;
//                 float3 pos = IN.positionOS.xyz;
//                 float yOffset = GetWave(pos);
//                 pos.y += yOffset;

//                 OUT.posWS = TransformObjectToWorld(pos);
//                 OUT.posCS = TransformWorldToHClip(OUT.posWS);
//                 OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));
//                 OUT.height = yOffset;

//                 return OUT;
//             }

//             half4 frag(Varyings IN) : SV_Target
//             {
//                 // Base Color
//                 float t = saturate((IN.height + _WaveHeight)/(_WaveHeight*2));
//                 float3 baseColor = lerp(_ColorDeep.rgb, _ColorShallow.rgb, t);

//                 // URP ForwardLit ışık hesaplaması
//                 Light mainLight = GetMainLight(); // yön ve renk
//                 float3 lightDir = normalize(mainLight.direction);
//                 float3 lightColor = mainLight.color;

//                 float NdotL = saturate(dot(IN.normalWS, lightDir));
//                 float3 diffuse = baseColor * NdotL * lightColor;

//                 float3 viewDir = normalize(_WorldSpaceCameraPos - IN.posWS);
//                 float3 halfDir = normalize(lightDir + viewDir);
//                 float spec = pow(saturate(dot(IN.normalWS, halfDir)), 16) * _SpecularStrength;

//                 float3 finalColor = diffuse + spec;

//                 return float4(finalColor, 1);
//             }

//             ENDHLSL
//         }
//     }
// }
Shader "Custom/URPWaterLit_WavesNormal"
{
    Properties
    {
        _WaveHeight("Wave Height", Range(0,1)) = 0.1
        _WaveSpeed("Wave Speed", Range(0,5)) = 1
        _ColorShallow("Shallow Color", Color) = (0.3,0.6,1,1)
        _ColorDeep("Deep Color", Color) = (0.0,0.1,0.3,1)
        _Smoothness("Smoothness", Range(0,1)) = 0.5
        _SpecularStrength("Specular Strength", Range(0,1)) = 0.3
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }
        LOD 200

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 posCS : SV_POSITION;
                float3 posWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float height : TEXCOORD2;
            };

            float _WaveHeight;
            float _WaveSpeed;
            float4 _ColorShallow;
            float4 _ColorDeep;
            float _Smoothness;
            float _SpecularStrength;

            // Dalga yüksekliği
            float GetWave(float3 pos)
            {
                float raw = sin(_Time.y * _WaveSpeed + pos.x * 3.1415)
                          + cos(_Time.y * _WaveSpeed + pos.z * 3.1415);
                float t = (raw + 2.0)/4.0;
                t = sin(t * 3.1415 * 0.5);
                return t * _WaveHeight * 2.0 - _WaveHeight;
            }

            // Dalga normalini hesapla
            float3 GetWaveNormal(float3 pos)
            {
                float eps = 0.01;
                float hL = GetWave(pos + float3(-eps,0,0));
                float hR = GetWave(pos + float3( eps,0,0));
                float hD = GetWave(pos + float3(0,0,-eps));
                float hU = GetWave(pos + float3(0,0, eps));

                float3 n = normalize(float3(hL - hR, 2*eps, hD - hU));
                return n;
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                float3 pos = IN.positionOS.xyz;
                float yOffset = GetWave(pos);
                pos.y += yOffset;

                OUT.posWS = TransformObjectToWorld(pos);
                OUT.posCS = TransformWorldToHClip(OUT.posWS);
                OUT.normalWS = GetWaveNormal(pos);
                OUT.height = yOffset;

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // Base Color
                float t = saturate((IN.height + _WaveHeight)/(_WaveHeight*2));
                float3 baseColor = lerp(_ColorDeep.rgb, _ColorShallow.rgb, t);

                // URP ForwardLit ana ışık
                Light mainLight = GetMainLight();
                float3 lightDir = normalize(mainLight.direction);
                float3 lightColor = mainLight.color;

                float NdotL = saturate(dot(IN.normalWS, lightDir));
                float3 diffuse = baseColor * NdotL * lightColor;

                float3 viewDir = normalize(_WorldSpaceCameraPos - IN.posWS);
                float3 halfDir = normalize(lightDir + viewDir);
                float spec = pow(saturate(dot(IN.normalWS, halfDir)), 16) * _SpecularStrength;

                float3 finalColor = diffuse + spec;

                return float4(finalColor, 1);
            }

            ENDHLSL
        }
    }
}
