shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	float t = TIME;

	vec3 base = vec3(0.04, 0.09, 0.05);

	float pulse = sin(t * 1.8) * 0.5 + 0.5;

	vec2 grid = fract(uv * 8.0);
	float dot_val = smoothstep(0.85, 0.95, 1.0 - length(grid - 0.5) * 2.0);
	base += vec3(0.1, 1.0, 0.2) * dot_val * (0.08 + pulse * 0.10);

	float streak_pos = fract(uv.x * 0.6 - uv.y * 0.25 - t * 0.18);
	float streak = smoothstep(0.0, 0.06, streak_pos) * smoothstep(0.14, 0.08, streak_pos);
	base += vec3(0.2, 1.0, 0.3) * streak * 0.18;

	float shine = pow(1.0 - uv.y, 3.0) * 0.08;
	base += vec3(0.3, 1.0, 0.4) * shine;

	float border_x = min(uv.x, 1.0 - uv.x);
	float border_y = min(uv.y, 1.0 - uv.y);
	float border = 1.0 - smoothstep(0.0, 0.06, min(border_x, border_y));
	base += vec3(0.1, 1.0, 0.2) * border * (0.3 + pulse * 0.4);

	float dist = length(uv - vec2(0.5, 0.48));
	float ring = smoothstep(0.02, 0.0, abs(dist - 0.18)) * (0.5 + pulse * 0.5);
	base += vec3(0.1, 1.0, 0.2) * ring * 0.6;

	COLOR = vec4(base, 0.88);
}
