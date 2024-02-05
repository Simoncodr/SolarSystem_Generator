#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;

vec3 sunDir = vec3(0, -1, 0);

void main() {
  gl_FragColor = vertColor;
}