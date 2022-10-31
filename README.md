# Texture Blend Shader (liltoon based)

A custom Shader which provides the ability to blend the textures at runtime.

## Install

[liltoon](https://github.com/lilxyzw/lilToon) is required.

### 1. Git

[Import](https://docs.unity3d.com/Manual/upm-ui-giturl.html) `https://github.com/mueru/TBS4liltoon.git`.

You can chose specific version by adding `#v[version]` at the end.

Ex. 1.0.0 -> `https://github.com/mueru/TBS4liltoon.git#v1.0.0`

### 2. unitypackage

Currently not planning to provide .unitypackage.

## How to Use

Select `BTS4liltoon/liltoon` shader, then configure `Texture Blend/Sub Color` and `Texture Blend/Blend Ratio Texture`.

`Actual_Color = Main_Color + Blend_Ratio_Texture(Sub_Color - Main_Color), 0 <= Blend_Ratio_Texture <= 1`

### Showing Sub Texture only to Friends/Myself (VRChat)

1. Add `Prefabs/FriendsOnly` or `Prefabs/LocalOnly` to your avatar.
1. Set `BlendRatioTex/BRTex` to `Blend Ratio Texture` Property

## Links

- liltoon: <https://github.com/lilxyzw/lilToon>
