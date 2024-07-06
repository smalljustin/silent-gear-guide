const int ARR_LENGTH = 15;
const int TOL = 3;

class GearVisualizer {
    
    float calculatedOpacity = 0;

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
    array<float> slipLeftArr(ARR_LENGTH);

    int idx;

    void decreaseOpacity() {
        calculatedOpacity = Math::Max(0, calculatedOpacity - COLOR_DX);
    }

    void increaseOpacity() {
        calculatedOpacity = Math::Min(1, calculatedOpacity + COLOR_DX);
    }

    void update(CSceneVehicleVisState @ visState) {
        if (visState is null) {
            return;
        }

        curGear = visState.CurGear;
        curEngineRpm = VehicleState::GetRPM(visState);

        if (curGear != prevGear) {
            duringGearChange = true;
            timeoutIdx = ARR_LENGTH;
        }

        // we do not give a shit about gear 5, gear 5 is fucking dumb and bad
        if (curGear == 5 && curEngineRpm > Math::Lerp(RPM_MIN, RPM_MAX, 0.5)) {
            decreaseOpacity();
            return;
        } else {
            increaseOpacity();
        }

        engineRpmArr[idx % ARR_LENGTH] = curEngineRpm;
        velArr[idx % ARR_LENGTH] = visState.WorldVel.LengthSquared();
        slipLeftArr[idx % ARR_LENGTH] = Math::Angle(visState.WorldVel, visState.Left);
        prevGear = curGear;

        if (timeoutIdx > 0) {
            timeoutIdx -= 1;
        } else {
            if (duringGearChange) {
                bool increasing = true;
                float prevRpm, curRpm, prevVel, curVel;
                for (int i = 0; i < (ARR_LENGTH - 1); i++) {
                    int curIdx = (idx + ARR_LENGTH - i) % ARR_LENGTH;
                    int prevIdx = (idx + ARR_LENGTH - (i + 1)) % ARR_LENGTH;
                    curRpm = engineRpmArr[curIdx];
                    prevRpm = engineRpmArr[prevIdx];
                    curVel = velArr[curIdx];
                    prevVel = velArr[prevIdx];
                    float rpmDiff = curRpm - prevRpm;
                    float velDiff = curVel - prevVel;
                    if (rpmDiff < 0 && velDiff < 0) {
                        increasing = false;
                    }
                }
                if (increasing) {
                    duringGearChange = false;
                }
            }
        }
        idx += 1;
    }

    void doStandardRender(CSceneVehicleVisState @ visState, int side) {
        if (visState is null) {
            return;
        }
        vec3 startPoint = visState.Position;
        vec3 endPoint = visState.Position;

        vec3 direction = visState.Dir;

        startPoint += visState.Left * CAR_X_OFFSET * side;
        endPoint += visState.Left * CAR_X_OFFSET * side;

        startPoint += direction * CAR_Y_OFFSET;
        endPoint += direction * CAR_Y_OFFSET;
        endPoint += direction * LINE_LENGTH;

        startPoint += visState.Up * CAR_Z_OFFSET;
        endPoint += visState.Up * CAR_Z_OFFSET;

        if (Camera::IsBehind(startPoint) || Camera::IsBehind(endPoint)) {
            return;
        }

        nvg::BeginPath();
        nvg::MoveTo(Camera::ToScreenSpace(startPoint));
        nvg::LineTo(Camera::ToScreenSpace(endPoint));
        nvg::StrokeWidth(5);
        nvg::StrokeColor(ApplyOpacityToColor(BASE_COLOR, calculatedOpacity));
        nvg::Stroke();
        nvg::ClosePath();

        float curEngineRpm = VehicleState::GetRPM(visState);
        float curEngineFrac = Math::Max(0.1, Math::InvLerp(RPM_MIN, RPM_MAX, curEngineRpm));

        vec3 gearIndicatorEndPoint = startPoint;
        gearIndicatorEndPoint += direction * LINE_LENGTH * curEngineFrac;
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
        nvg::StrokeColor(ApplyOpacityToColor(finalColor, calculatedOpacity));
        nvg::Stroke();
        nvg::ClosePath();
    }
    void Render(CSceneVehicleVisState @ visState) {
        if (visState is null) {
            return;
        }
        if (isCam3(visState) == 0) {
            bool renderLeft = false;
            bool renderRight = false;

            if (SIDE_LEFT) {
                renderLeft = true;
            }
            if (SIDE_RIGHT) {
                renderRight = true;
            }


            float slipLeftSum = 0;
            for (int i = 0; i < ARR_LENGTH; i++) {
                slipLeftSum += slipLeftArr[i];
            }

            float slipLeftAvg = slipLeftSum / ARR_LENGTH;
            if (slipLeftAvg > Math::PI / 2 || (Math::Abs(slipLeftAvg - Math::PI / 2) < 0.1)) {
                if (SIDE_INNER) {
                    renderLeft = true;
                }
                if (SIDE_OUTER) {
                    renderRight = true;
                }
            } else {
                if (SIDE_OUTER) {
                    renderLeft = true;
                }
                if (SIDE_INNER) {
                    renderRight = true;
                }
            }
            if (renderLeft) {
                doStandardRender(visState, 1);
            } 
            if (renderRight) {
                doStandardRender(visState, -1);
            }
        }

    }
}