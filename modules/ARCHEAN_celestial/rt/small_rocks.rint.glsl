#define SHADER_RINT
#include "small_rocks.common.inc.glsl"

ivec2 screenSize = ivec2(xenonRendererData.config.screenSize);

float GetFixedBoundingSizeInScreenPixels(float distance, float size) {
	float solidAngle;
	if (distance == 0) solidAngle = PI;
	else solidAngle = size / distance / radians(float(xenonRendererData.config.smoothFov));
	return min(solidAngle, PI) * 2.0 * ((screenSize.x + screenSize.y) * 0.5);
}

void main() {
	if (renderer.terrain_clutter_detail > 0 && AABB.data > 1 && approxDistanceFromCamera < maxDrawDistance && GetFixedBoundingSizeInScreenPixels(approxDistanceFromCamera, rockBoundingSize) > 3) {
		float detailSize = GetDetailSize();
		const int MAX_STEPS = 100;
		float depth = gl_RayTminEXT;
		float lastDist = 1e100;
		for (int i = 0; i < MAX_STEPS; ++i) {
			vec3 pos = gl_ObjectRayOriginEXT + gl_ObjectRayDirectionEXT * depth - rockPos;
			float dist = Sdf(pos, detailSize, detailOctavesMediumRes);
			depth += dist;
			if (dist < epsilon*0.01) {
				reportIntersectionEXT(max(gl_RayTminEXT, depth), 0);
				break;
			}
			if (dist > lastDist + maxDetailSize*2) break;
			if (depth > gl_RayTmaxEXT) break;
			lastDist = dist;
		}
	}
}
