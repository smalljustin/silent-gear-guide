const int ARR_LENGTH = 15;
const int TOL = 3;

class GearVisualizer {
    
    float baseOpacity = 0;

    float slipLeft = 0;
    GearVisualizer() {}

    float RPM_MIN = 4000;
    float RPM_MAX = 11000;
    
    bool duringGearChange;
    float prevGear, curGear; 
    float curEngineRpm;

    int timeoutIdx = 0;
    
    array<float> engineRpmArr(ARR_LENGTH);
    array<float> velArr(ARR_LENGTH);

    int idx;

    void update(CSceneVehicleVisState @ visState) {
        if (visState is null) {
            return;
        }

        curGear = visState.CurGear;
        curEngineRpm = VehicleState::GetRPM(visState);

        if (curGear != prevGear) {
            print("GEAR CHANGE");
            duringGearChange = true;
            timeoutIdx = ARR_LENGTH;
        }

        engineRpmArr[idx % ARR_LENGTH] = curEngineRpm;
        velArr[idx % ARR_LENGTH] = visState.WorldVel.LengthSquared();
        prevGear = curGear;

        if (timeoutIdx > 0) {
            timeoutIdx -= 1;
        } else {
            if (visState.InputIsBraking || (visState.InputSteer == 0)) {
                baseOpacity = Math::Max(0, baseOpacity - COLOR_DX);
            } else {
                baseOpacity = Math::Min(1, baseOpacity + COLOR_DX);
            }
            if (duringGearChange) {
                bool increasing = true;
                float prevRpm, curRpm, prevVel, curVel;
                print("START - 49");
                for (int i = 0; i < (ARR_LENGTH - 1); i++) {
                    int curIdx = (idx + ARR_LENGTH - i) % ARR_LENGTH;
                    int prevIdx = (idx + ARR_LENGTH - (i + 1)) % ARR_LENGTH;
                    curRpm = engineRpmArr[curIdx];
                    prevRpm = engineRpmArr[prevIdx];
                    curVel = velArr[curIdx];
                    prevVel = velArr[prevIdx];

                    float rpmDiff = curRpm - prevRpm;
                    float velDiff = curVel - prevVel;

                    float totalDiff = (rpmDiff + velDiff);

                    if (rpmDiff < 0 && velDiff < 0) {
                        increasing = false;
                    }

                    print(tostring(curIdx) + "\t" + tostring(prevIdx));
                    print(tostring(curRpm) + "\t" + tostring(prevRpm));
                    print(tostring(curVel) + "\t" + tostring(prevVel));
                    print(tostring(totalDiff) + "\t" + tostring(rpmDiff) + "\t" + tostring(velDiff));
                }
                if (increasing) {
                    duringGearChange = false;
                    print("gear change over; both velocity and rpm increasing");
                }
            }
        }
        idx += 1;


    }
    void Render(CSceneVehicleVisState @ visState) {
        if (visState is null) {
            return;
        }

        // Getting start point

        vec3 startPoint = visState.Position;
        vec3 endPoint = visState.Position;

        vec3 direction = visState.Dir;
        
        float slipLeft = Math::Angle(visState.WorldVel, visState.Left);

        startPoint += visState.Left * CAR_X_OFFSET * (slipLeft > 0 ? -1 : 1);
        endPoint += visState.Left * CAR_X_OFFSET * (slipLeft > 0 ? -1 : 1);

        startPoint += direction * CAR_Y_OFFSET;
        endPoint += direction * CAR_Y_OFFSET;
        endPoint += direction * LINE_LENGTH;

        startPoint += visState.Up * CAR_Z_OFFSET;
        endPoint += visState.Up * CAR_Z_OFFSET;

        nvg::BeginPath();
        nvg::MoveTo(Camera::ToScreenSpace(startPoint));
        nvg::LineTo(Camera::ToScreenSpace(endPoint));
        nvg::StrokeWidth(5);
        nvg::StrokeColor(ApplyOpacityToColor(BASE_COLOR, baseOpacity));
        nvg::Stroke();
        nvg::ClosePath();

        float curEngineRpm = VehicleState::GetRPM(visState);
        float curEngineFrac = Math::Max(0.1, Math::InvLerp(RPM_MIN, RPM_MAX, curEngineRpm));

        vec3 gearIndicatorEndPoint = startPoint;
        gearIndicatorEndPoint += direction * LINE_LENGTH * curEngineFrac;

        // if we are not changing gears, "good" state
        // if we are changing gears, but not doing it badly, "warning" state
        // if we are changing gears and fucking it up, "bad" state

        vec4 finalColor;

        if (!duringGearChange) {
            finalColor = GEAR_COLOR;
        } else {
            finalColor = WARN_COLOR;
        }
        nvg::BeginPath();
        nvg::MoveTo(Camera::ToScreenSpace(startPoint));
        nvg::LineTo(Camera::ToScreenSpace(gearIndicatorEndPoint));
        nvg::StrokeWidth(5);
        nvg::StrokeColor(ApplyOpacityToColor(finalColor, baseOpacity));
        nvg::Stroke();
        nvg::ClosePath();
        
    }
}