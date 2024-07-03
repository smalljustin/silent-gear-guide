[Setting category="General" name="Enable hats"]
bool g_visible = true;

bool Setting_General_HideWhenNotPlaying = true;

[Setting category="Player View" name="Use currently viewed player"]
bool UseCurrentlyViewedPlayer = true;

[Setting category="Player View" name="Player index to grab" drag min=0 max=100]
int player_index = 0;

[Setting category="Display config" name="Car X offset" drag min=0.1 max=2]
float CAR_X_OFFSET = 0.5;

[Setting category="Display config" name="Car Y offset" drag min=-2 max=2]
float CAR_Y_OFFSET = 0.5;

[Setting category="Display config" name="Line Length" drag min=0.1 max=3]
float LINE_LENGTH = 1;

[Setting category="Display config" name="Car Z offset" drag min=0.1 max=1]
float CAR_Z_OFFSET = 0.5;

[Setting category="Colors" name="Base color" color]
vec4 BASE_COLOR = vec4(1, 1, 1, 1);

[Setting category="Colors" name="Gear color" color]
vec4 GEAR_COLOR = vec4(0, 1, 0, 1);

[Setting category="Colors" name="Warn color" color]
vec4 WARN_COLOR = vec4(0, 0, 1, 1);

[Setting category="Colors" name="Error color" color]
vec4 ERROR_COLOR = vec4(1, 0, 0, 1);

[Setting category="Colors" name="Color rate of change" drag min=0.001 max=0.1]
float COLOR_DX = 0.01;