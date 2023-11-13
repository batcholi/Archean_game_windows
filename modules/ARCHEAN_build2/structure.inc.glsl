// ALSO INCLUDED IN GLSL

#define STRUCTURE_GRID_SCALE 0.25f

#include "xenon/graphics/interface.inc.glsl"
#ifdef __cplusplus
	#pragma once
	using namespace glm;
#endif

BUFFER_REFERENCE_STRUCT_READONLY(4) StructureMaterial {
	aligned_uint8_t r;
	aligned_uint8_t g;
	aligned_uint8_t b;
	#ifdef __cplusplus
		uint8_t opacity : 4;
		uint8_t roughness : 3;
		uint8_t metallic : 1;
	#else
		aligned_uint8_t a;
		// opacity = (float(a & 0xf) + 1) / 16.0
		// roughness = float((a >> 4) & 0x7) / 7.0
		// metallic = float(a >> 7)
	#endif
};
STATIC_ASSERT_SIZE(StructureMaterial, 4)
