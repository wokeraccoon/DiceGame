shader_type canvas_item;

void fragment() {
	COLOR.a = mix(0.2,0.6,smoothstep(-1.0,1.0,sin(TIME*2.0)));
}

