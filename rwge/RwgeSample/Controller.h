#pragma once

#include <InputListener.h>
#include <Sprite.h>
#include <Light.h>
#include <Camera.h>
#include <InputManager.h>
#include <SceneNode.h>

#define ANIMATION_STAND					0
#define ANIMATION_STAND_WEAPON			1
#define ANIMATION_SPECIAL_STAND			2
#define ANIMATION_SPECTAL_STAND_WEAPON	3
#define ANIMATION_RUN					4
#define ANIMATION_RUN_WEAPON			5
#define ANIMATION_HIT					6
#define ANIMATION_HIT_WEAPON			7
#define ANIMATION_ATTACK				8
#define ANIMATION_ATTACK_WEAPON			9
#define ANIMATION_DEAD					10
#define ANIMATION_SKILL_FNYJ01			11
#define ANIMATION_SKILL_FNYJ02			12
#define ANIMATION_SKILL_FNYJ03			13
#define ANIMATION_SKILL_FKYJ			14
#define ANIMATION_SKILL_FYJT			15
#define ANIMATION_SKILL_FRLW			16
#define ANIMATION_STAND_ATTACK			17
#define ANIMATION_SKILL_JS				18
#define ANIMATION_SKILL_HYCJ			19

#define ANIMATION_NUM					20

class Controller : public InputListener {
public:
	Controller(Sprite* pSprite, Light* pPointLight, Light* pDirectionalLight, Light* pSpotLight);
	~Controller();

	void OnKeyUp(unsigned int key);
	void OnKeyDown(unsigned int key);

	void Update(float deltaTime);

private:
	void OnWalkKeyDown(unsigned int direction);
	void OnWalkKeyUp(unsigned int direction);

	void OnWeaponKeyDown();
	void OnLightKeyDown();
	void OnAttackKeyDown();
	void OnSkillKeyDown(unsigned int skillID);


private:
	InputManager* m_pInputManager;

	Sprite* m_pSprite;
	unsigned short m_ActionState;
	bool m_UseWeapon;

	Light* m_pPointLight;
	Light* m_pDirectionalLight;
	Light* m_pSpotLight;
	unsigned short m_LightType;

	Camera* m_pCamera;
	SceneNode* m_pCameraYawPivot;
	SceneNode* m_pCameraPitchPivot;
	float m_CameraDistance;
	float m_CameraMinDistance;
	float m_CameraMaxDistance;
};

