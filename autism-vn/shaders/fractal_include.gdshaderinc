
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

uniform float _randSeed = 0.;
vec2 nextRand2() {
	float randSeed = _randSeed;
    vec2 v = vec2( randSeed++, randSeed++ );
	return vec2( random( v+0.34 ), random( v+0.75 ) );
}

float mandelbrot(vec2 uv, vec2 zoom, vec2 center, int max_iterations, float debug, float threshold){
	vec2 z = vec2(0.0);
	vec2 c = uv * zoom + center;
	float iterations = 0.0;

	for(int i = 0; i < max_iterations; i++){
		z = vec2(z.x * z.x - z.y * z.y, debug * z.x * z.y) + c;
		if(length(z) > threshold){
			break;
		}
		iterations++;
	}
	return iterations / float(max_iterations);
}
vec2 cmul (vec2 c1, vec2 c2)
{
	float a = c1.x;
	float b = c1.y;
	float c = c2.x;
	float d = c2.y;

	return vec2 (a * c - b * d, b * c + a * d);
}
float cabs (in vec2 complex)
{
	float x = complex.x;
	float y = complex.y;

	return sqrt(x*x + y*y);
}
float ship(vec2 uv, float zoom, vec2 center, int max_iterations, float debug, float threshold){
	vec2 c = uv * zoom + center;
	c = c * vec2(4.7, 3.5) - vec2(2.7, 1.3);
	vec2 z = vec2(0);

	float iterations = 0.0;
	for(int i = 0 ; i < max_iterations; i++){
		z = cmul(abs(z), abs(z));
		//z.y *= -1.;
		z += c;
		if(cabs(z) >= threshold){
			break;
		}
		iterations++;
	}
	return iterations / float(max_iterations);
}

vec2 f(vec2 v, vec2 c)
{
    return vec2(v.x/cos(v.y), v.y/sin(v.x))+c;
}
float secant_sea(vec2 uv, float zoom, vec2 center, float debug, int max_iterations, vec2 resolution){
	float time_scale = TIME/5.;
	vec2 c = uv * zoom + center ;//* vec2(sin(time_scale), sin(time_scale));
	//vec2 c = vec2(cos(time_scale), sin(time_scale));

	vec2 k = (debug*2.)*uv/resolution-debug;

	float iterations = 0.0;

	for(int i = 0; i <= max_iterations; i++){
		k = f(k, c);
		if(length(k) >= 10000.0){
			break;
		}
		iterations++;
	}
	return iterations * 3. / float(max_iterations);
}