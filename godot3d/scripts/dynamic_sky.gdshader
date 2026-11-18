shader_type sky;

uniform vec3 zenith_color : source_color = vec3(0.09, 0.15, 0.25);
uniform vec3 horizon_color : source_color = vec3(0.45, 0.56, 0.67);
uniform vec3 ground_color : source_color = vec3(0.08, 0.10, 0.17);
uniform float night_amount : hint_range(0.0, 1.0) = 0.0;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float value_noise(vec2 p) {
	vec2 cell = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash21(cell);
	float b = hash21(cell + vec2(1.0, 0.0));
	float c = hash21(cell + vec2(0.0, 1.0));
	float d = hash21(cell + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void sky() {
	float elevation = EYEDIR.y;
	float sky_gradient = smoothstep(-0.08, 0.52, elevation);
	vec3 color = mix(horizon_color, zenith_color, sky_gradient);
	if (elevation < 0.0) {
		color = mix(ground_color, horizon_color, smoothstep(-0.25, 0.0, elevation));
	}

	// Soft, drifting cloud banks stay above the horizon through day and dusk.
	vec2 cloud_uv = vec2(atan(EYEDIR.z, EYEDIR.x) * 2.1, elevation * 10.0);
	cloud_uv.x += TIME * 0.018;
	float clouds = value_noise(cloud_uv * 2.5) * 0.68 + value_noise(cloud_uv * 5.0) * 0.32;
	float cloud_band = smoothstep(0.035, 0.12, elevation) * (1.0 - smoothstep(0.48, 0.64, elevation));
	float cloud_mask = smoothstep(0.56, 0.76, clouds) * cloud_band * (1.0 - night_amount);
	vec3 cloud_color = mix(vec3(0.77, 0.84, 0.91), vec3(0.93, 0.62, 0.52), smoothstep(0.0, 0.85, horizon_color.r - horizon_color.b));
	color = mix(color, cloud_color, cloud_mask * 0.82);

	// A fixed star field fades in as night arrives; tiny brightness variation adds a gentle twinkle.
	vec2 star_uv = vec2(atan(EYEDIR.z, EYEDIR.x), asin(clamp(elevation, -1.0, 1.0)));
	vec2 star_grid = star_uv * vec2(390.0, 210.0);
	vec2 star_cell = floor(star_grid);
	vec2 star_local = fract(star_grid) - vec2(hash21(star_cell), hash21(star_cell + vec2(17.0)));
	float star_random = hash21(star_cell + vec2(31.7));
	float star_dot = 1.0 - smoothstep(0.025, 0.075, length(star_local));
	float twinkle = 0.72 + 0.28 * sin(TIME * (1.2 + star_random * 2.6) + star_random * 80.0);
	float stars = step(0.95, star_random) * star_dot * twinkle * night_amount * smoothstep(0.02, 0.24, elevation);
	color += vec3(0.67, 0.79, 1.0) * stars * 1.8;

	// Pale moon with a restrained halo, visible only during the night phase.
	vec3 moon_direction = normalize(vec3(-0.55, 0.43, -0.72));
	float moon_dot = dot(normalize(EYEDIR), moon_direction);
	float moon_disk = smoothstep(0.9985, 0.99935, moon_dot) * night_amount;
	float moon_halo = pow(max(moon_dot, 0.0), 96.0) * night_amount * 0.22;
	color = mix(color, vec3(0.87, 0.91, 1.0), moon_disk);
	color += vec3(0.34, 0.43, 0.68) * moon_halo;
	COLOR = color;
}
