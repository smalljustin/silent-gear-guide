[Setting category="General" name="Enable gear guide"]
bool g_visible = true;

bool Setting_General_HideWhenNotPlaying = true;

[Setting category="Player View" name="Use currently viewed player"]
bool UseCurrentlyViewedPlayer = true;

[Setting category="Player View" name="Player index to grab" drag min=0 max=100]
int player_index = 0;

[Setting category="Display config" name="Always show? (Otherwise, hide when driving very fast in gear 5)"]
bool ALWAYS_SHOW = false;

[Setting category="Display config" name="Always show on left side"]
bool SIDE_LEFT = true;

[Setting category="Display config" name="Always show on right side"]
bool SIDE_RIGHT = false;

[Setting category="Display config" name="Always show on inner side"]
bool SIDE_INNER = false;

[Setting category="Display config" name="Always show on outer side"]
bool SIDE_OUTER = false;

[Setting category="Display config" name="Car X offset" drag min=0.1 max=2]
float CAR_X_OFFSET = 1.665;

[Setting category="Display config" name="Car Y offset" drag min=-2 max=2]
float CAR_Y_OFFSET = -1.295;

[Setting category="Display config" name="Line Length" drag min=0.1 max=3]
float LINE_LENGTH = 3;

[Setting category="Display config" name="Car Z offset" drag min=0.0 max=1]
float CAR_Z_OFFSET = 0.1;

[Setting category="Colors" name="Base color" color]
vec4 BASE_COLOR = vec4(255, 255, 255, 255) / 255;

[Setting category="Colors" name="RPM Indicator Color" color]
vec4 GEAR_COLOR = vec4(35, 100, 183, 255) / 255;

[Setting category="Colors" name="Gear Change Color" color]
vec4 WARN_COLOR = vec4(255, 85, 48, 255) / 255; 

[Setting category="Colors" name="Color rate of change" drag min=0.001 max=0.1]
float COLOR_DX = 0.01;