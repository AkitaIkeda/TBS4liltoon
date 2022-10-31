
# Texture Blend Shader (liltoon based)

使用するテクスチャをブレンドする機能を提供するカスタムシェーダー

## インストール

### 1. Git

UnityPackageManagerから `https://github.com/mueru/TBS4liltoon.git` を[インポート](https://docs.unity3d.com/ja/2021.3/Manual/upm-ui-giturl.html)してください。

末尾に `#v[version]` を追加することでバージョンの指定ができます。

例: 1.0.0 -> `https://github.com/mueru/TBS4liltoon.git#v1.0.0`

### 2. unitypackage

提供予定なし

## 使用方法

`BTS4liltoon/liltoon`シェーダーを使用し、インスペクター上で`Texture Blend/Sub Color`と`Texture Blend/Blend Ratio Texture`を設定してください。

`Actual_Color = Main_Color + Blend_Ratio_Texture(Sub_Color - Main_Color), 0 <= Blend_Ratio_Texture <= 1`

### 自分もしくはフレンドにのみサブテクスチャを表示する (VRChat)

1. フレンドのみに表示したい場合は`Prefabs/FriendsOnly`を、自分にのみ表示したい場合`Prefabs/LocalOnly`を、アバターの任意の場所に含めます。
1. マテリアルの`Blend Ratio Texture`プロパティに`BlendRatioTex/BRTex`を設定します。

## links

- liltoon: <https://github.com/lilxyzw/lilToon>
