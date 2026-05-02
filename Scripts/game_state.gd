extends Node

# ── GÉNÉRAL ───────────────────────────────────────────────────────────────────
var language:               String = "fr"
var sound_on:               bool   = true
var notifications_enabled:  bool   = true
var diamonds:               int    = 0
var manager_name:           String = ""
var team_name:              String = ""
var team_logo_index:        int    = 0
var previous_scene:         String = ""
var selected_country:       String = ""
var selected_deco_index:    int    = 0
var collection_slot_target: int    = -1
var collection_country:     String = ""
var collection_card_to_add: String = ""

# ── CARTE SÉLECTIONNÉE ────────────────────────────────────────────────────────
var selected_note:                int    = 0
var selected_color:               String = ""
var selected_position1:           String = ""
var selected_position2:           String = ""
var selected_position2_unlocked:  int    = 0
var selected_age:                 int    = 0
var selected_height:              int    = 0
var selected_weight:              int    = 0
var selected_nationality:         String = ""
var selected_specialty1:          String = ""
var selected_specialty2:          String = ""
var selected_firstname:           String = ""
var selected_lastname:            String = ""
var selected_ball_color:          String = ""
var selected_card_id:             String = ""
var selected_strength:            int    = 0
var selected_speed:               int    = 0
var selected_aggression:          int    = 0
var selected_positioning:         int    = 0
var selected_stamina:             int    = 0
var selected_creativity:          int    = 0
var selected_concentration:       int    = 0
var selected_motivation:          int    = 0
var selected_anticipation:        int    = 0
var selected_communication:       int    = 0

# ── CARTE DÉCO 1 ──────────────────────────────────────────────────────────────
var deco1_note:                int    = 0
var deco1_color:               String = ""
var deco1_position1:           String = ""
var deco1_position2:           String = ""
var deco1_position2_unlocked:  int    = 0
var deco1_age:                 int    = 0
var deco1_height:              int    = 0
var deco1_weight:              int    = 0
var deco1_nationality:         String = ""
var deco1_specialty1:          String = ""
var deco1_specialty2:          String = ""
var deco1_firstname:           String = ""
var deco1_lastname:            String = ""
var deco1_ball_color:          String = ""
var deco1_strength:            int    = 0
var deco1_speed:               int    = 0
var deco1_aggression:          int    = 0
var deco1_positioning:         int    = 0
var deco1_stamina:             int    = 0
var deco1_creativity:          int    = 0
var deco1_concentration:       int    = 0
var deco1_motivation:          int    = 0
var deco1_anticipation:        int    = 0
var deco1_communication:       int    = 0

# ── CARTE DÉCO 2 ──────────────────────────────────────────────────────────────
var deco2_note:                int    = 0
var deco2_color:               String = ""
var deco2_position1:           String = ""
var deco2_position2:           String = ""
var deco2_position2_unlocked:  int    = 0
var deco2_age:                 int    = 0
var deco2_height:              int    = 0
var deco2_weight:              int    = 0
var deco2_nationality:         String = ""
var deco2_specialty1:          String = ""
var deco2_specialty2:          String = ""
var deco2_firstname:           String = ""
var deco2_lastname:            String = ""
var deco2_ball_color:          String = ""
var deco2_strength:            int    = 0
var deco2_speed:               int    = 0
var deco2_aggression:          int    = 0
var deco2_positioning:         int    = 0
var deco2_stamina:             int    = 0
var deco2_creativity:          int    = 0
var deco2_concentration:       int    = 0
var deco2_motivation:          int    = 0
var deco2_anticipation:        int    = 0
var deco2_communication:       int    = 0

# ── EFFECTIF ──────────────────────────────────────────────────────────────────
var cards_yellow:  Array = []
var cards_orange:  Array = []
var cards_red:     Array = []
var cards_magenta: Array = []
var cards_blue:    Array = []
var cards_white:   Array = []
var cards_special: Array = []
var cards_loaded:  bool  = false
