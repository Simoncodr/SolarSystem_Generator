uniform mat4 transform;

uniform float time;

attribute vec4 position;
attribute vec3 normal;
attribute vec4 color;

varying vec4 vertColor;

void main() {
  gl_Position = transform * position;
  vertColor = vec4(normal, 1.0);//color;
}