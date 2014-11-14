uniform sampler2D colorSampler;//inputImageTexture
varying vec2 uv;//textureCoordinate

highp vec2 LensCenter = vec2(0.5,0.5);
highp vec2 ScreenCenter = vec2(0.5,0.5);
highp vec2 Scale = vec2(0.35,0.35);
highp vec2 ScaleIn = vec2(2.0,2.0);
highp vec4 HmdWarpParam = vec4(1.0,0.22,0.24,0.0);

vec2 HmdWarp(vec2 in01)
{
    vec2 theta = (in01 - LensCenter) * ScaleIn; // Scales to [-1, 1]
    float rSq = theta.x * theta.x + theta.y * theta.y;
    vec2  theta1 = theta * (HmdWarpParam.x + HmdWarpParam.y * rSq + HmdWarpParam.z * rSq * rSq + HmdWarpParam.w * rSq * rSq * rSq);
    //     return LensCenter + Scale * theta1;
    return ScreenCenter + Scale * theta1;
}

void main()
{    
    vec2 tc = HmdWarp(uv);
    if (!all(equal(clamp(tc, ScreenCenter-vec2(0.5,0.5), ScreenCenter+vec2(0.5,0.5)), tc)))
        gl_FragColor = vec4(0);
    else
        gl_FragColor = texture2D(colorSampler, tc);
}
