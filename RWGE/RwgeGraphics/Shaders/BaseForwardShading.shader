	��0             4                   D                      T                      h                       t                       �                       �                       �                       �                                                                           g_Material  
   baseColor      emissiveColor      normal r	   metallic    	   specular    
   roughness      opacity    opacityMask        P                   d                      x                      �                                                       g_PointLight TYP   ambientColor       diffuseColor       worldPosition          <                   X                      `                      h                                                                   g_OneBandSHCoefficients    R      G      B         �                                                                                   g_WVP                                         g_ViewOppositeDirection                                                                                                                                                                                                               	   BasePass       BaseTechnique                  �           �  ,         �            p  �         �  �                                              @  <          `  \  	       �  |         �  �         �  �  �       �  �  �       �  �                 ����       P   �����DBUG(   �         �   +   �      d    E:\Projects\GitHub\RuneWordsGameEngine\RWGE\RwgeGraphics\Shaders\BaseForwardShading.hlsl BRDF.hlsli Light.hlsli SH.hlsli ���(   �   �   �     ���    ���    ���    ���    ���    ���  J   �  J     J     J   0  \   <  \   L    \  o   l    |  o   �  o   �  >  �    �  r   �    �    �  r   �             (    <     L    X     l  q   |  t   �  q   �    �  t   �    �    �    �  t   �  f     t     z   0  z   @  BasePS �           )       ��*   ������ EnvBRDFApprox ��                  ��GetLightWorldDirection �       ��PhongApprox                ������  g_ViewOppositeDirection        ��color ��(       ��diffuseGI ��'       ��inBinormal �       ��inNormal ���       ��inPosition �       ��inTangent ��       ��normal �	       ��normalDotLight �    ������  normalDotView ��   ������  reflectionDotLight �   ������  reflectionVector ���       ��DotSH result ���#     ������$   �� ����%   ���� ��AB �                 ����   ������ a004 ���   ��  ����           $      <  L     \      h  L     �      �  �     �      �  L     �    �  L     �    �  L     �      L           L     (    4  L     @    L  L     X    d  L     l    x  �     �    �  �     �    �  �     �    �  L     �  �  �  L        <  $  (     8  <  P  �     X  Microsoft (R) D3DX9 Shader Compiler 9.15.779.0000 ����� CTAB   �   ��         �  l    	    ,  <  �           D       �    �       �   �  g_Material baseColor ���           emissiveColor normal metallic ��            specular roughness opacity opacityMask �w   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �          �                                                                                                                                   g_OneBandSHCoefficients R ��           G B �  �  �  �  �  �         �                                                  g_PointLight ambientColor diffuseColor worldPosition ���Q  �   ^  �   k  �       	   |  g_ViewOppositeDirection                 ps_3_0 Microsoft (R) D3DX9 Shader Compiler 9.15.779.0000 ������PRESXF��o CTAB   �  XF        �  0         �      g_Material baseColor ���           emissiveColor normal metallic ��            specular roughness opacity opacityMask �;   H   X   H   f   H   m   x   �   x   �   x   �   x   �   x          �                                                                                                                                   tx Microsoft (R) D3DX9 Shader Compiler 9.15.779.0000 ����� PRSI            	                  	           ��R CLIT(                                                                                                                                                                                                         �)\���(�������M⿺I+��?      �?��(\�¥?�p=
ף�?{�G�z��{�G�z�?      I@              �/l�dG�?V���4d�?                ��FXLC    P�                                                            @                                     P�                                  @                                    P�                                     P�                                   P�                                                          @�                                  @�                                  P�                    !                                        0                              "              @�                    #               0                                            P�                                  P�                                  0                        P�                    $                                        @�                    %                                                                                         ������  Q   �    �z������?Q   �  �?   @           �  �    � �    � �    � �    � � U�    �  � �  �   � �� �  �$    '� �   �  � �    (� ��  �    (�  �� U�   �  � ��   (�  ��   � �   '� U� � �   '�  � �
    (� ��   �   (� � �   �  �   "�  �� ��  �    (� ��  �   � �   #� U� � �    (�  �  ��  �   (� U�  �    (�  ��   '� �  � ��   (�  ��  �    �  � �   '� � �� �   (�  ��  �    (�  �   '� �� �	   !� �  �	   "� �  �	   $� �  �   '� � �    '� �  �    '� �  � �   '�  �
 �   (�  ���          ����       �   ����� DBUG(             �      �      �    E:\Projects\GitHub\RuneWordsGameEngine\RWGE\RwgeGraphics\Shaders\BaseForwardShading.hlsl ���(     ���    ���    ���    ���    ���    ���    ���    ��    ��    ��     ��,    ��8  0   D  0   P  1   \  4   h  3   t  2   �  BaseVS position            PsUsedPos ��           texCoord ���           tangent binormal normal   (  8  D  T  `  p  D  x  D  �  D         �                ��     ����   	 
  ��      ��      ��inBinormal �       ��inNormal ���       ��inPosition �        inTangent ��       ��inTexCoord �      ����      �     �      D         (  D     4    @  (     L    X  D     d    p  `     |  Microsoft (R) D3DX9 Shader Compiler 9.15.779.0000 ���� CTAB   #    ��              vs_3_0 Microsoft (R) D3DX9 Shader Compiler 9.15.779.0000 ����� PRESQ    �                     �  �    � �    � �    � �    � �     �  �   � �    � �    � �    � �    � �    �  �   �   �   � �   � �   � �   � ���  