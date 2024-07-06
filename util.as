vec4 ApplyOpacityToColor(vec4 inColor, float opacity) {
  if (Math::IsInf(opacity) || Math::IsNaN(opacity)) {
    return vec4(0);
  }

  if (Math::IsInf(inColor.x) || Math::IsNaN(inColor.x)) {
    return vec4(0);
  }

  vec4 outColor = inColor;
  outColor.w = Math::Min(opacity, outColor.w);
  outColor.w = Math::Max(outColor.w, 0);

  return outColor;
}

/** 
  * Return codes:
  * 0: Not cam 3. 
  * 1: Cam 3 in-car. 
  * 2: Cam three full. 
  */
int isCam3(CSceneVehicleVisState @ visState) {
    vec3 pos = visState.Position;
    vec3 cameraPos = Camera::GetCurrentPosition();
    vec3 pos_offset_forward = visState.Position + visState.Dir;

    float v1 = (cameraPos - pos_offset_forward).LengthSquared();
    float v2 = (cameraPos - pos).LengthSquared();

    if (v1 > 1.9 && v1 < 2 && v2 > 0.85 && v2 < 0.9) {
        return 1;
    } else if (v1 > 2.3 && v1 < 2.4 && v2 > 2.7 && v2 < 2.8) {
        return 2;
    } else {
        return 0;
    }
}
