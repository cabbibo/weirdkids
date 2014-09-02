
uniform vec3 lightPos;
uniform vec3 camPos;

varying vec3 vNormal;
varying vec3 vPos;
varying vec3 vMPos;
varying vec2 vUv;

varying vec3 vLightDir;
varying vec3 vCamDir;

void main(){

  vNormal = normal;
  vPos = position;

  vMPos = ( modelMatrix  * vec4( vPos, 1. ) ).xyz;
  vUv = uv;
  vLightDir = normalize( vMPos - lightPos );
  vCamDir   = normalize( vMPos - camPos);
  
  gl_Position  = projectionMatrix * modelViewMatrix * vec4( position , 1.0 );


}
