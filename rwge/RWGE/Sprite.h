#pragma once

#include "RwgeClasses.h"
#include "SceneNode.h"
#include "MaxModel.h"

class Sprite : public SceneNode {
	friend class Mesh;

public:
	Sprite();
	~Sprite();

	static Sprite* Load(const char* filePath);

	Mesh* GetMeshes();
	int GetMeshNum();
	float* GetBoneData();
	int GetBoneNum();
	int GetFrameNum();

	void Initialize();
	void Update(float deltaTime);
	void Cleanup();
	void Draw();

	int GetAnimationNum();
	void SetAnimation(int animationID);
	void PlayAnimation(int animationID, bool loop = false);
	bool IsCurrentAnimationPlaying();

//private:
	//void InitAnimation();

private:
	Mesh* m_Meshes;
	Animation* m_Animations;
	int m_AnimationID;
	unsigned int m_AnimationNum;

	// 用于从model文件中加载数据
	MaxModelHead m_ModelHead;
	float* m_BoneData;
};