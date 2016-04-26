#pragma once

#include "RwgeColor.h"
#include "RwgeSceneNode.h"
#include <d3dx9.h>

enum ELightType
{
	LT_NoLight,
	LT_Directional,
	LT_Point,

	LightType_MAX
};

class Light
{
	friend class RShaderManager;

public:
	Light();
	virtual ~Light();

	virtual ELightType GetLightType() const = 0;
	virtual void UpdateConstantBuffer() const = 0;
	virtual void GetConstantBuffer(void*& pBuffer, unsigned char& uSize) const = 0;

	void SetAmbietnColor(const FColorRGB& color);
	void SetDiffuseColor(const FColorRGB& color);
	const FColorRGB& GetAmbientColor() const;
	const FColorRGB& GetDiffuseColor() const;

protected:
	FColorRGB	m_AmbientColor;
	FColorRGB	m_DiffuseColor;

	mutable bool m_bConstantBufferOutOfDate;
};

// 方向光不具备场景节点的属性
class DirectionalLight : public Light
{
public:
	DirectionalLight();
	~DirectionalLight();

	ELightType GetLightType() const override { return LT_Directional; }
	void UpdateConstantBuffer() const override;
	void GetConstantBuffer(void*& pBuffer, unsigned char& uSize) const override;

	void SetWorldDirection(const D3DXVECTOR3& direction);
	const D3DXVECTOR3& GetWorldDirection() const;

private:
	D3DXVECTOR3 m_WorldDirection;

	mutable unsigned char m_ConstantBuffer[36];
};

// 点光源具备场景节点的属性
class PointLight : public Light, public SceneNode
{
public:
	PointLight();
	~PointLight();

	ELightType GetLightType() const override { return LT_Point; }
	void UpdateConstantBuffer() const override;
	void GetConstantBuffer(void*& pBuffer, unsigned char& uSize) const override;
	void UpdateWorldTransform() const override;

private:
	struct PointLightConstantBuffer
	{
		FColorRGB ambientColor;
		FColorRGB diffuseColor;
		D3DXVECTOR3 position;
	};

	mutable PointLightConstantBuffer m_ConstantBuffer;
};