#include "Application.h"

#include "AppConfig.h"
#include "AppDelegate.h"
#include "Graphics.h"
#include "InputManager.h"
#include "LogUtil.h"

Application::Application() {
	m_hInstance = GetModuleHandle(0);
	m_MinIntervalTime = 1.0f / AppConfig::maxFPS;
}


Application::~Application() {

}

void Application::SetDelegate(AppDelegate* pDelegate) {
	m_pDelegate = pDelegate;
}

void Application::Run() {
	// 初始化应用程序
	Initialize();

	// 启动主循环
	MSG msg = { 0 };
	while (WM_QUIT != msg.message) {
		if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else {
			Update();
		}
	}

	// 清理应用程序
	Cleanup();
}

HINSTANCE Application::GetHandle() {
	return m_hInstance;
}

LRESULT CALLBACK Application::AppWndProc(HWND hwnd, UINT umessage, WPARAM wparam, LPARAM lparam) {
	return InputManager::GetInstance()->MessageHandler(hwnd, umessage, wparam, lparam);
}

void Application::Initialize() {
	QueryPerformanceFrequency(&m_Frequency);	// 获取系统时钟频率（每秒运行次数）
	QueryPerformanceCounter(&m_LastCount);		// 获取当前系统时钟计数

	// Register class
	WNDCLASSEX wcex;
	wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = AppWndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = m_hInstance;
	wcex.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = "MainWindow";
	wcex.hIconSm = LoadIcon(NULL, IDI_APPLICATION);
	RegisterClassEx(&wcex);

	m_pGraphics = Graphics::GetInstance();
	m_pGraphics->Initialize();

	m_pInputManager = InputManager::GetInstance();
	
	m_pDelegate->Initialize();
}

void Application::Update() {
	// 计算上一次本函数被调用的时刻到现在所过去的时间
	QueryPerformanceCounter(&m_CurrentCount);		// 获取当前系统时钟计数
	m_DeltaTime = (float)(m_CurrentCount.QuadPart - m_LastCount.QuadPart) / m_Frequency.QuadPart;
	m_LastCount = m_CurrentCount;

	// 记录开始更新时的系统时钟计数
	QueryPerformanceCounter(&m_StartUpdateCount);

	// 更新各个子模块
	m_pGraphics->Update(m_DeltaTime);
	m_pInputManager->Update(m_DeltaTime);
	m_pDelegate->Update(m_DeltaTime);

	// 记录结束更新时的系统时钟计数
	QueryPerformanceCounter(&m_EndUpdateCount);

	if (AppConfig::lockFPS) {
		// 计算更新使用的时间
		m_UpdateTime = (float)(m_EndUpdateCount.QuadPart - m_StartUpdateCount.QuadPart) / m_Frequency.QuadPart;
		if (m_MinIntervalTime > m_UpdateTime) {
			Sleep((int)(m_MinIntervalTime - m_UpdateTime) * 1000);
		}
	}

	LOG("FPS = %d", (int)(1.0f / m_DeltaTime));
}

void Application::Cleanup() {
	LogUtil::GetInstance()->Cleanup();
}
