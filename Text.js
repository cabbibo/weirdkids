function Text( text , mat ){

  //var text = "#weirdkids",

    height = 20,
    size = 300,
    hover = 30,

    curveSegments = 4,

    bevelThickness = 2,
    bevelSize = 1.5,
    bevelSegments = 3,
    bevelEnabled = true,

    font ="helvetiker", // helvetiker, optimer, gentilis, droid sans, droid serif
    weight = "bold", // normal bold
    style = "normal"; // normal italic


  var geo = new THREE.TextGeometry( text, {

    size: size,
    height: height,
    curveSegments: curveSegments,

    font: font,
    weight: weight,
    style: style,

    bevelThickness: bevelThickness,
    bevelSize:  bevelSize,
    bevelEnabled: bevelEnabled,

    material: 0,
    extrudeMaterial: 1

  });

  geo.computeBoundingBox();
  geo.computeFaceNormals();
 // geo.computeVertexNormals();

  var mesh = new THREE.Mesh( geo ,/* new THREE.MeshBasicMaterial({
  
    color:0xffffff,
    map: t_audio.value
   // wireframe:true
    
  }) */ mat);

  this.mesh = mesh;
  //scene.add( mesh );



}
