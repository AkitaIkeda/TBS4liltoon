//----------------------------------------------------------------------------------------------------------------------
// Macro

// Custom variables
#define LIL_CUSTOM_PROPERTIES \
    float4 _SubColor; \
    float4 _SubTexHSVG; \
    float _SubGradationStrength;

// Custom textures
#define LIL_CUSTOM_TEXTURES \
    TEXTURE2D(_BlendRatioTex); \
    TEXTURE2D(_SubTex); \
    TEXTURE2D(_SubGradationTex); \
    TEXTURE2D(_SubColorAdjustMask); \
    SAMPLER(sampler_BlendRatioTex); \
    SAMPLER(sampler_SubTex); 

// Add vertex shader input
//#define LIL_REQUIRE_APP_POSITION
//#define LIL_REQUIRE_APP_TEXCOORD0
//#define LIL_REQUIRE_APP_TEXCOORD1
//#define LIL_REQUIRE_APP_TEXCOORD2
//#define LIL_REQUIRE_APP_TEXCOORD3
//#define LIL_REQUIRE_APP_TEXCOORD4
//#define LIL_REQUIRE_APP_TEXCOORD5
//#define LIL_REQUIRE_APP_TEXCOORD6
//#define LIL_REQUIRE_APP_TEXCOORD7
//#define LIL_REQUIRE_APP_COLOR
//#define LIL_REQUIRE_APP_NORMAL
//#define LIL_REQUIRE_APP_TANGENT
//#define LIL_REQUIRE_APP_VERTEXID

// Add vertex shader output
//#define LIL_V2F_FORCE_TEXCOORD0
//#define LIL_V2F_FORCE_TEXCOORD1
//#define LIL_V2F_FORCE_POSITION_OS
//#define LIL_V2F_FORCE_POSITION_WS
//#define LIL_V2F_FORCE_POSITION_SS
//#define LIL_V2F_FORCE_NORMAL
//#define LIL_V2F_FORCE_TANGENT
//#define LIL_V2F_FORCE_BITANGENT
//#define LIL_CUSTOM_V2F_MEMBER(id0,id1,id2,id3,id4,id5,id6,id7)

// Add vertex copy
#define LIL_CUSTOM_VERT_COPY

// Inserting a process into the vertex shader
//#define LIL_CUSTOM_VERTEX_OS
//#define LIL_CUSTOM_VERTEX_WS

// Inserting a process into pixel shader
//#define BEFORE_xx

#if defined(LIL_PASS_FORWARD_NORMAL_INCLUDED)
    #define TBS_GET_MAIN_TEX \
        float4 main = LIL_SAMPLE_2D_POM(_MainTex, sampler_MainTex, fd.uvMain, fd.ddxMain, fd.ddyMain); \
        float4 sub = LIL_SAMPLE_2D_POM(_SubTex, sampler_SubTex, fd.uvMain, fd.ddxMain, fd.ddyMain); \
        float ratio = LIL_SAMPLE_2D_POM(_BlendRatioTex, sampler_BlendRatioTex, fd.uvMain, fd.ddxMain, fd.ddyMain).r;

    // Tone correction
    #if defined(LIL_FEATURE_MAIN_TONE_CORRECTION)
        #define TBS_MAIN_TONECORRECTION \
            main.rgb = lilToneCorrection(main.rgb, _MainTexHSVG); \
            sub.rgb = lilToneCorrection(sub.rgb, _SubTexHSVG);
    #else
        #define TBS_MAIN_TONECORRECTION
    #endif

    // Gradation map
    #if defined(LIL_FEATURE_MAIN_GRADATION_MAP) && defined(LIL_FEATURE_MainGradationTex)
        #define TBS_MAIN_GRADATION_MAP \
            main.rgb = lilGradationMap(main.rgb, _MainGradationTex, _MainGradationStrength); \
            sub.rgb = lilGradationMap(sub.rgb, _SubGradationTex, _SubGradationStrength);
    #else
        #define TBS_MAIN_GRADATION_MAP
    #endif

    #if defined(LIL_FEATURE_MainColorAdjustMask)
        #define TBS_SAMPLE_MainColorAdjustMask \
            mainColorAdjustMask = LIL_SAMPLE_2D(_MainColorAdjustMask, sampler_MainTex, fd.uvMain).r; \
            subColorAdjustMask = LIL_SAMPLE_2D(_SubColorAdjustMask, sampler_SubTex, fd.uvMain).r;
    #else
        #define TBS_SAMPLE_MainColorAdjustMask
    #endif

    #if defined(LIL_FEATURE_MAIN_TONE_CORRECTION) || defined(LIL_FEATURE_MAIN_GRADATION_MAP)
        #define TBS_APPLY_MAIN_TONECORRECTION \
            float3 mainBeforeToneCorrectionColor = main.rgb; \
            float3 subBeforeToneCorrectionColor = sub.rgb; \
            float subColorAdjustMask = 1.0; \
            float mainColorAdjustMask = 1.0; \
            TBS_SAMPLE_MainColorAdjustMask \
            TBS_MAIN_TONECORRECTION \
            TBS_MAIN_GRADATION_MAP \
            main.rgb = lerp(mainBeforeToneCorrectionColor, main.rgb, mainColorAdjustMask);
            sub.rgb = lerp(subBeforeToneCorrectionColor, sub.rgb, subColorAdjustMask);
    #else
        #define TBS_APPLY_MAIN_TONECORRECTION
    #endif
#else
    #define TBS_GET_MAIN_TEX \
        float4 main = LIL_SAMPLE_2D(_MainTex, sampler_MainTex, fd.uvMain); \
        float4 sub = LIL_SAMPLE_2D(_SubTex, sampler_SubTex, fd.uvMain); \
        float ratio = LIL_SAMPLE_2D(_BlendRatioTex, sampler_BlendRatioTex, fd.uvMain).r;
    #define TBS_APPLY_MAIN_TONECORRECTION
#endif

#define OVERRIDE_MAIN \
    TBS_GET_MAIN_TEX \
    TBS_APPLY_MAIN_TONECORRECTION \
    main *= _Color; \
    sub *= _SubColor; \
    fd.col = lerp(main, sub, ratio); \

//----------------------------------------------------------------------------------------------------------------------
// Information about variables
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
// Vertex shader inputs (appdata structure)
//
// Type     Name                    Description
// -------- ----------------------- --------------------------------------------------------------------
// float4   input.positionOS        POSITION
// float2   input.uv0               TEXCOORD0
// float2   input.uv1               TEXCOORD1
// float2   input.uv2               TEXCOORD2
// float2   input.uv3               TEXCOORD3
// float2   input.uv4               TEXCOORD4
// float2   input.uv5               TEXCOORD5
// float2   input.uv6               TEXCOORD6
// float2   input.uv7               TEXCOORD7
// float4   input.color             COLOR
// float3   input.normalOS          NORMAL
// float4   input.tangentOS         TANGENT
// uint     vertexID                SV_VertexID

//----------------------------------------------------------------------------------------------------------------------
// Vertex shader outputs or pixel shader inputs (v2f structure)
//
// The structure depends on the pass.
// Please check lil_pass_xx.hlsl for details.
//
// Type     Name                    Description
// -------- ----------------------- --------------------------------------------------------------------
// float4   output.positionCS       SV_POSITION
// float2   output.uv01             TEXCOORD0 TEXCOORD1
// float2   output.uv23             TEXCOORD2 TEXCOORD3
// float3   output.positionOS       object space position
// float3   output.positionWS       world space position
// float3   output.normalWS         world space normal
// float4   output.tangentWS        world space tangent

//----------------------------------------------------------------------------------------------------------------------
// Variables commonly used in the forward pass
//
// These are members of `lilFragData fd`
//
// Type     Name                    Description
// -------- ----------------------- --------------------------------------------------------------------
// float4   col                     lit color
// float3   albedo                  unlit color
// float3   emissionColor           color of emission
// -------- ----------------------- --------------------------------------------------------------------
// float3   lightColor              color of light
// float3   indLightColor           color of indirectional light
// float3   addLightColor           color of additional light
// float    attenuation             attenuation of light
// float3   invLighting             saturate((1.0 - lightColor) * sqrt(lightColor));
// -------- ----------------------- --------------------------------------------------------------------
// float2   uv0                     TEXCOORD0
// float2   uv1                     TEXCOORD1
// float2   uv2                     TEXCOORD2
// float2   uv3                     TEXCOORD3
// float2   uvMain                  Main UV
// float2   uvMat                   MatCap UV
// float2   uvRim                   Rim Light UV
// float2   uvPanorama              Panorama UV
// float2   uvScn                   Screen UV
// bool     isRightHand             input.tangentWS.w > 0.0;
// -------- ----------------------- --------------------------------------------------------------------
// float3   positionOS              object space position
// float3   positionWS              world space position
// float4   positionCS              clip space position
// float4   positionSS              screen space position
// float    depth                   distance from camera
// -------- ----------------------- --------------------------------------------------------------------
// float3x3 TBN                     tangent / bitangent / normal matrix
// float3   T                       tangent direction
// float3   B                       bitangent direction
// float3   N                       normal direction
// float3   V                       view direction
// float3   L                       light direction
// float3   origN                   normal direction without normal map
// float3   origL                   light direction without sh light
// float3   headV                   middle view direction of 2 cameras
// float3   reflectionN             normal direction for reflection
// float3   matcapN                 normal direction for reflection for MatCap
// float3   matcap2ndN              normal direction for reflection for MatCap 2nd
// float    facing                  VFACE
// -------- ----------------------- --------------------------------------------------------------------
// float    vl                      dot(viewDirection, lightDirection);
// float    hl                      dot(headDirection, lightDirection);
// float    ln                      dot(lightDirection, normalDirection);
// float    nv                      saturate(dot(normalDirection, viewDirection));
// float    nvabs                   abs(dot(normalDirection, viewDirection));
// -------- ----------------------- --------------------------------------------------------------------
// float4   triMask                 TriMask (for lite version)
// float3   parallaxViewDirection   mul(tbnWS, viewDirection);
// float2   parallaxOffset          parallaxViewDirection.xy / (parallaxViewDirection.z+0.5);
// float    anisotropy              strength of anisotropy
// float    smoothness              smoothness
// float    roughness               roughness
// float    perceptualRoughness     perceptual roughness
// float    shadowmix               this variable is 0 in the shadow area
// float    audioLinkValue          volume acquired by AudioLink
// -------- ----------------------- --------------------------------------------------------------------
// uint     renderingLayers         light layer of object (for URP / HDRP)
// uint     featureFlags            feature flags (for HDRP)
// uint2    tileIndex               tile index (for HDRP)