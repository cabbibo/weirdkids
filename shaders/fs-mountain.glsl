#extension GL_OES_standard_derivatives : enable

uniform float waterRender;

uniform sampler2D t_audio;
uniform vec3 camPos;
uniform sampler2D t_normal;
uniform float timer;

varying vec3 vNormal;
varying vec3 vPos;
varying vec3 vMPos;
varying vec2 vUv;

varying vec3 vLightDir;
varying vec3 vCamDir;


void main(){





  if( waterRender > .5 ){

    if( vPos.y < 0. ){
      discard;
    }

  }

  // FROM @thespite

  vec3 vNorm = vNormal;
  vec3 n = normalize( vNormal.xyz );
  vec3 blend_weights = abs( n );
  blend_weights = ( blend_weights - 0.2 ) * 7.;  
  blend_weights = max( blend_weights, 0. );
  blend_weights /= ( blend_weights.x + blend_weights.y + blend_weights.z );

  vec2 coord1 = vPos.yz * .0011;
  vec2 coord2 = vPos.zx * .0011;
  vec2 coord3 = vPos.xy * .0011;

  vec3 bump1 = texture2D( t_normal , coord1 + vec2( timer * .1 , timer * .2 )   *.0001  ).rgb;  
  vec3 bump2 = texture2D( t_normal , coord2 + vec2( timer * .13 , timer * .083 )*.0001  ).rgb;  
  vec3 bump3 = texture2D( t_normal , coord3 + vec2( timer * .05 , timer * .15 ) *.0001 ).rgb; 

  vec3 blended_bump = bump1 * blend_weights.xxx +  
                      bump2 * blend_weights.yyy +  
                      bump3 * blend_weights.zzz;

  vec3 tanX = vec3( vNorm.x, -vNorm.z, vNorm.y);
  vec3 tanY = vec3( vNorm.z, vNorm.y, -vNorm.x);
  vec3 tanZ = vec3(-vNorm.y, vNorm.x, vNorm.z);
  vec3 blended_tangent = tanX * blend_weights.xxx +  
                         tanY * blend_weights.yyy +  
                         tanZ * blend_weights.zzz; 

  vec3 normalTex = blended_bump * 2.0 - 1.0;
  normalTex.xy *= .01;
  normalTex.y *= -1.;
  normalTex = normalize( normalTex );
  mat3 tsb = mat3( normalize( blended_tangent ), normalize( cross( vNormal, blended_tangent ) ), normalize( vNormal ) );
 
 // vec3 bump = texture2D( tNormal , vUv ).xyz;
  vec3 fNorm = tsb * normalTex;




  vec3 c = vec3( 1. , 1. , 1. );
  float a = 1.;
  if( vMPos.y < 0. ){

    c = vec3( .1 , .9 , .6 ) * (40. - abs( vMPos.y )) /30.;

    a = 3. - abs( vMPos.y );

  }

  vec4 aC = texture2D( t_audio , vec2( abs( (vMPos.y-50.) / 300. ) , 0. ) );
 
  vec4 multiColor = mix( vec4( 1. , .8 , .3 , 1. ) , vec4( 1. , .2 , 0. , 1.) , vMPos.y );


  float fr = max( 0. ,  dot( -vLightDir , fNorm ));

  vec3 refl = reflect( -vLightDir , fNorm );
  float reflFR = dot( -refl , vCamDir );

  vec3 iri = texture2D( t_audio , vec2( reflFR*reflFR , 0. ) ).xyz;

  
  gl_FragColor = vec4( iri , 1.); //* aC * vec4(c,a);

    //gl_FragColor = vec4( vec3( vUv.x , vUv.y , 0. ) * a, a );

}
