/* sturq's dwl config.h — Windows-key MODKEY + Windows-native hotkeys.
 * dwl 0.8 format. Suckless-Wayland stack: foot, wmenu, swaylock, grim. */

#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8)  & 0xFF) / 255.0f, \
                        (hex         & 0xFF) / 255.0f }

/* appearance */
static const int sloppyfocus               = 1;
static const int bypass_surface_visibility = 0;
static const unsigned int borderpx         = 1;
static const float rootcolor[]             = COLOR(0x111111ff);
static const float bordercolor[]           = COLOR(0x444444ff);
static const float focuscolor[]            = COLOR(0x3584e4ff);
static const float urgentcolor[]           = COLOR(0xff0000ff);
static const float fullscreen_bg[]         = {0.0f, 0.0f, 0.0f, 1.0f};

/* tagging */
#define TAGCOUNT (9)

/* logging */
static int log_level = WLR_ERROR;

/* Rules — at least one required */
static const Rule rules[] = {
    /* app_id      title       tags mask    isfloating   monitor */
    { "fuzzel",    NULL,       0,           1,           -1 },
};

/* layout(s) */
static const Layout layouts[] = {
    { "[]=",      tile },
    { "><>",      NULL },     /* floating */
    { "[M]",      monocle },
};

/* monitors */
static const MonitorRule monrules[] = {
    { NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
    .layout = "de",
    .options = NULL,
};
static const int repeat_rate  = 50;
static const int repeat_delay = 300;

/* Trackpad */
static const int tap_to_click           = 1;
static const int tap_and_drag           = 1;
static const int drag_lock              = 1;
static const int natural_scrolling      = 1;
static const int disable_while_typing   = 1;
static const int left_handed            = 0;
static const int middle_button_emulation = 0;
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* MODKEY = Windows-key (Super/Logo) */
#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,SKEY,TAG) \
    { MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
    { MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
    { MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }, \
    { MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *termcmd[]  = { "foot", NULL };
static const char *menucmd[]  = { "wmenu-run", NULL };
static const char *filecmd[]  = { "foot", "-e", "yazi", NULL };
static const char *lockcmd[]  = { "swaylock", "-f", NULL };

static const Key keys[] = {
    /* ===== Windows-native shortcuts ===== */
    { MODKEY,                    XKB_KEY_Return,     spawn,          {.v = termcmd} },  /* Win+Enter → terminal */
    { MODKEY,                    XKB_KEY_r,          spawn,          {.v = menucmd} },  /* Win+R → run */
    { MODKEY,                    XKB_KEY_e,          spawn,          {.v = filecmd} },  /* Win+E → files (yazi) */
    { MODKEY,                    XKB_KEY_l,          spawn,          {.v = lockcmd} },  /* Win+L → lock */

    /* Screenshots — Windows-like */
    { 0,                         XKB_KEY_Print,                  spawn, SHCMD("grim ~/Pictures/screen-$(date +%s).png") },               /* PrtSc → full */
    { WLR_MODIFIER_SHIFT,        XKB_KEY_Print,                  spawn, SHCMD("grim -g \"$(slurp)\" ~/Pictures/screen-$(date +%s).png") }, /* Shift+PrtSc → region */
    { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_S,                      spawn, SHCMD("grim -g \"$(slurp)\" - | wl-copy") },                     /* Win+Shift+S → region to clipboard (Win10 style) */

    /* Volume / brightness — XF86 media keys */
    { 0, XKB_KEY_XF86AudioRaiseVolume, spawn, SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") },
    { 0, XKB_KEY_XF86AudioLowerVolume, spawn, SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") },
    { 0, XKB_KEY_XF86AudioMute,        spawn, SHCMD("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") },
    { 0, XKB_KEY_XF86AudioMicMute,     spawn, SHCMD("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") },
    { 0, XKB_KEY_XF86MonBrightnessUp,   spawn, SHCMD("brightnessctl set +5%") },
    { 0, XKB_KEY_XF86MonBrightnessDown, spawn, SHCMD("brightnessctl set 5%-") },

    /* Window management */
    { MODKEY,                    XKB_KEY_q,          killclient,     {0} },                       /* Win+Q → close */
    { WLR_MODIFIER_ALT,          XKB_KEY_F4,         killclient,     {0} },                       /* Alt+F4 → close (Windows) */
    { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Q,          quit,           {0} },                       /* Win+Shift+Q → logout dwl */
    { MODKEY,                    XKB_KEY_Tab,        focusstack,     {.i = +1} },                 /* Win+Tab → next window */
    { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Tab,        focusstack,     {.i = -1} },                 /* Win+Shift+Tab → prev */
    { WLR_MODIFIER_ALT,          XKB_KEY_Tab,        focusstack,     {.i = +1} },                 /* Alt+Tab → also next */

    /* Layouts */
    { MODKEY,                    XKB_KEY_d,          setlayout,      {.v = &layouts[0]} },         /* Win+D → tiling (default) */
    { MODKEY,                    XKB_KEY_t,          setlayout,      {.v = &layouts[0]} },         /* Win+T → tile (alias) */
    { MODKEY,                    XKB_KEY_f,          setlayout,      {.v = &layouts[1]} },         /* Win+F → floating */
    { MODKEY,                    XKB_KEY_m,          setlayout,      {.v = &layouts[2]} },         /* Win+M → monocle */
    { MODKEY,                    XKB_KEY_Up,         setlayout,      {.v = &layouts[2]} },         /* Win+Up → maximize */
    { MODKEY,                    XKB_KEY_space,      togglefloating, {0} },                       /* Win+Space → toggle float */

    /* Resize master split (Windows snap-ish) */
    { MODKEY,                    XKB_KEY_Left,       setmfact,       {.f = -0.05f} },              /* Win+Left → shrink master */
    { MODKEY,                    XKB_KEY_Right,      setmfact,       {.f = +0.05f} },              /* Win+Right → grow master */

    /* vi-style navigation (kept from suckless tradition) */
    { MODKEY,                    XKB_KEY_j,          focusstack,     {.i = +1} },
    { MODKEY,                    XKB_KEY_k,          focusstack,     {.i = -1} },
    { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Return,     zoom,           {0} },                       /* Win+Shift+Enter → zoom (swap with master) */

    /* Virtual desktops (Windows-style: Win+1..9 switches) */
    TAGKEYS(          XKB_KEY_1, XKB_KEY_exclam,                     0),
    TAGKEYS(          XKB_KEY_2, XKB_KEY_at,                         1),
    TAGKEYS(          XKB_KEY_3, XKB_KEY_numbersign,                 2),
    TAGKEYS(          XKB_KEY_4, XKB_KEY_dollar,                     3),
    TAGKEYS(          XKB_KEY_5, XKB_KEY_percent,                    4),
    TAGKEYS(          XKB_KEY_6, XKB_KEY_asciicircum,                5),
    TAGKEYS(          XKB_KEY_7, XKB_KEY_ampersand,                  6),
    TAGKEYS(          XKB_KEY_8, XKB_KEY_asterisk,                   7),
    TAGKEYS(          XKB_KEY_9, XKB_KEY_parenleft,                  8),
};

static const Button buttons[] = {
    { MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
    { MODKEY, BTN_MIDDLE, togglefloating, {0} },
    { MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
