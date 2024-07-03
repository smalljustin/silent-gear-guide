GearVisualizer @ gearVisualizer;
float g_dt = 0;
float HALF_PI = 1.57079632679;


void Update(float dt) {
  g_dt = dt; 

  if (gearVisualizer!is null) {
    auto app = GetApp();
    if (Setting_General_HideWhenNotPlaying) {
      if (app.CurrentPlayground!is null && (app.CurrentPlayground.UIConfigs.Length > 0)) {
        if (app.CurrentPlayground.UIConfigs[0].UISequence == CGamePlaygroundUIConfig::EUISequence::Intro) {
          return;
        }
      }
    }

    if (app!is null && app.GameScene!is null) {
      CSceneVehicleVis @[] allStates = VehicleState::GetAllVis(app.GameScene);
      if (UseCurrentlyViewedPlayer) {
        gearVisualizer.update(VehicleState::ViewingPlayerState());
      }
      if (allStates.Length > 0) {
        if (!UseCurrentlyViewedPlayer && (player_index < 0 || (allStates!is null && allStates.Length > player_index))) {
          gearVisualizer.update(allStates[player_index].AsyncState);
        }
      }
    }
  }
}

string getMapUid() {
  auto app = cast < CTrackMania > (GetApp());
  if (app != null) {
    if (app.RootMap != null) {
      if (app.RootMap.MapInfo != null) {
        return app.RootMap.MapInfo.MapUid;
      }
    }
  }
  return "";
}


void Render() {
  if (!g_visible) {
    return;
  }

  if (gearVisualizer!is null) {
    auto app = GetApp();
    if (Setting_General_HideWhenNotPlaying) {
      if (app.CurrentPlayground!is null && (app.CurrentPlayground.UIConfigs.Length > 0)) {
        if (app.CurrentPlayground.UIConfigs[0].UISequence == CGamePlaygroundUIConfig::EUISequence::Intro) {
          return;
        }
      }
    }

    if (app!is null && app.GameScene!is null) {
      if (UseCurrentlyViewedPlayer) {
        gearVisualizer.Render(VehicleState::ViewingPlayerState());
      } else {
        CSceneVehicleVis @[] allStates = VehicleState::GetAllVis(app.GameScene);
        if (allStates.Length > 0) {
          if (player_index < 0 || (allStates!is null && allStates.Length > player_index)) {
            gearVisualizer.Render(allStates[player_index].AsyncState);
          } else {
            UI::SetNextWindowContentSize(400, 150);
            UI::Begin("\\$f33Invalid player index!");
            UI::Text("No player found within player states at index " + tostring(player_index));
            UI::Text("");
            UI::End();
          }
        }
      }
    }
  }
}

void Main() {
  @gearVisualizer = GearVisualizer();
}

void OnSettingsChanged() {
}