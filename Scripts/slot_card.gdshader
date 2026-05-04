shader_type canvas_item;

void fragment() {
	vec2 uv = UV;

	// Fond très sombre
	vec3 base = vec3(0.03, 0.04, 0.04);
	float alpha = 0.92;

	// Bordure lumineuse fine
	float border_x = min(uv.x, 1.0 - uv.x);
	float border_y = min(uv.y, 1.0 - uv.y);
	float bmin = min(border_x, border_y);

	// Ligne de bordure fine et brillante
	float border = 1.0 - smoothstep(0.0, 0.010, bmin);
	base += vec3(0.2, 1.0, 0.35) * border * 5.0;

	// Halo intérieur doux
	float halo = 1.0 - smoothstep(0.010, 0.045, bmin);
	base += vec3(0.1, 0.7, 0.2) * halo * 0.35;

	// Glow concentré en bas au centre (comme la photo)
	float bottom_glow_x = 1.0 - abs(uv.x - 0.5) * 2.5;
	bottom_glow_x = clamp(bottom_glow_x, 0.0, 1.0);
	float bottom_glow_y = pow(uv.y, 4.0);
	float bottom_glow = bottom_glow_x * bottom_glow_y;
	base += vec3(0.15, 1.0, 0.3) * bottom_glow * 0.9;

	// Reflet très subtil en haut
	float top_shine = pow(1.0 - uv.y, 4.0) * 0.08;
	base += vec3(0.3, 1.0, 0.4) * top_shine;

	// Croix + au centre
	vec2 center = uv - vec2(0.5, 0.5);
	float cross_h = smoothstep(0.018, 0.010, abs(center.y)) * smoothstep(0.12, 0.10, abs(center.x));
	float cross_v = smoothstep(0.018, 0.010, abs(center.x)) * smoothstep(0.12, 0.10, abs(center.y));
	float cross_val = clamp(cross_h + cross_v, 0.0, 1.0);
	base += vec3(0.4, 0.5, 0.4) * cross_val * 0.6;

	COLOR = vec4(base, alpha);
}