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