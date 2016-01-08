#pragma once

#include <d3d9.h>

#define RWGE_SHADER_ENABLED		// ʹ��RWGE��ɫ��
#define SHADER_ANIMATION		// ʹ����ɫ������ģ�Ͷ���

namespace AppConfig {
	// ���ڲ���
	const int winX = 100;
	const int winY = 100;
	const int winWidth = 800;
	const int winHeight = 600;
	const bool lockFPS = false;
	const float maxFPS = 60.0f;
	const bool fullScreen = false;
	const char winName[] = "RwgeSample";

	// D3D9����
	const D3DDEVTYPE deviceType = D3DDEVTYPE_HAL;
	const D3DFORMAT backBufferFormat = D3DFMT_A8R8G8B8;
	const unsigned int backBufferCount = 1;
	const D3DMULTISAMPLE_TYPE multiSampleType = D3DMULTISAMPLE_NONE;
	const DWORD multiSampleQuality = 0;
	const D3DSWAPEFFECT swapEffect = D3DSWAPEFFECT_DISCARD;
	const bool enableAutoDepthStencil = true;
	const D3DFORMAT autoDepthStencilFormat = D3DFMT_D24S8;
	const D3DFORMAT autoDepthStencilFormat2 = D3DFMT_D16;
	const DWORD flags = 0;
	const unsigned int fullScreenRefreshRateInHz = D3DPRESENT_RATE_DEFAULT;
	const unsigned int presentationInterval = D3DPRESENT_INTERVAL_IMMEDIATE;	// ��ֱͬ��ѡ�������D3DPRESENT_INTERVAL_ONE���رգ�D3DPRESENT_INTERVAL_IMMEDIATE

	// ���������
	const float cameraPosX = 0.0f;
	const float cameraPosY = 80.0f;
	const float cameraPosZ = -200.0f;
	const float cameraRightAxisX = 1.0f;
	const float cameraRightAxisY = 0.0f;
	const float cameraRightAxisZ = 0.0f;
	const float cameraUpAxisX = 0.0f;
	const float cameraUpAxisY = 1.0f;
	const float cameraUpAxisZ = 0.0f;
	const float cameraLookAxisX = 0.0f;
	const float cameraLookAxisY = 0.0f;
	const float cameraLookAxisZ = 1.0f;
	const float cameraMoveSpeed = 100.0f;
	const float cameraRotateSpeed = 2.0f;
	const float cameraFovy = 3.141592654f * 0.25f;
	const float cameraAspect = static_cast<float>(winWidth) / winHeight;
	const float cameraLookNear = 20.0f;
	const float cameraLookFar = 5000.0f;

	// ��������
	const float animationFrameInterval = 2.0f / 60.0f;

	// ��ɫ��
#ifdef SHADER_ANIMATION
	const char defaultVertexShaderPath[] = "../RwgeGraphics/DefualtWithAnimationCalculation.vs";
#else
	const char defaultVertexShaderPath[] = "../RwgeGraphics/Default.vs";
#endif
	const char defaultVertexShaderEntryFuncName[] = "Main";
	const unsigned int defaultVertexShaderTarget = 1;
	const char defaultPixelShaderPath[] = "../RwgeGraphics/Default.ps";
	const char defaultPixelShaderEntryFuncName[] = "Main";
	const unsigned int defaultPixelShaderTarget = 1;
};