PShape s;
PShape sn;
PShader shader;

int noiseSeed = (int) random(Integer.MIN_VALUE, Integer.MAX_VALUE);

PlanetShaper planetShaper;

int resolution = 3;
boolean visibleNormals = false;
boolean visibleGrid = false;

void setup() {
  size(400, 400, P3D);

  shader = loadShader("PlanetFrag.glsl", "PlanetVert.glsl");

  planetShaper = new PlanetShaper(100.0);

  s = createPlanet(resolution);
  sn = getShapeNormals(s);

  noStroke();
  ortho();
}

void keyPressed() {
  switch(key) {
    case('+'): //Increase resolution
    resolution++;
    s = createPlanet(resolution);
    sn = getShapeNormals(s);
    break;
    case('-'): //Decrease resolution
    resolution = max(resolution-1, 2);
    s = createPlanet(resolution);
    sn = getShapeNormals(s);
    break;
    case('n'): //Toggle normals
    visibleNormals = !visibleNormals;
    break;
    case('g'): //Toggle grid
    println(visibleGrid);
    visibleGrid = !visibleGrid;
    if (visibleGrid) {
      stroke(0);
    } else {
      noStroke();
    }
    break;
    case('r'): //Randomize planet
    noiseSeed = (int) random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    noiseSeed(noiseSeed);
    
    s = createPlanet(resolution);
    sn = getShapeNormals(s);
    break;
  }
}

PShape getShapeNormals(PShape shape) {
  PShape n = createShape();

  n.beginShape(LINES);

  for (int i = 0; i < shape.getVertexCount(); i++) {
    PVector normal = shape.getNormal(i);
    PVector vert = shape.getVertex(i);
    n.vertex(vert.x, vert.y, vert.z);
    n.vertex(vert.x + normal.x*10.0, vert.y + normal.y*10.0, vert.z + normal.z*10.0);
  }

  n.endShape();
  n.setStroke(color(0, 255, 0));

  return n;
}

PShape createGridUnitCube(int resolution) {
  PShape gridCube = createShape();
  
  gridCube.beginShape(QUAD);
  
  final float edgeLength = 2.0/(resolution-1);

  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gridCube.vertex(-1 + u*edgeLength, -1 + v*edgeLength, -1);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength, -1);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength, -1);
      gridCube.vertex(-1 + u*edgeLength, -1 + v*edgeLength + edgeLength, -1);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gridCube.vertex(-1 + u*edgeLength, -1 + v*edgeLength + edgeLength, 1);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength, 1);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength, 1);
      gridCube.vertex(-1 + u*edgeLength, -1 + v*edgeLength, 1);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gridCube.vertex(-1, -1 + u*edgeLength, -1 + v*edgeLength);
      gridCube.vertex(-1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength);
      gridCube.vertex(-1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength);
      gridCube.vertex(-1, -1 + u*edgeLength, -1 + v*edgeLength + edgeLength);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gridCube.vertex(1, -1 + u*edgeLength, -1 + v*edgeLength + edgeLength);
      gridCube.vertex(1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength);
      gridCube.vertex(1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength);
      gridCube.vertex(1, -1 + u*edgeLength, -1 + v*edgeLength);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gridCube.vertex(-1 + u*edgeLength, -1, -1 + v*edgeLength + edgeLength);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, -1, -1 + v*edgeLength + edgeLength);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, -1, -1 + v*edgeLength);
      gridCube.vertex(-1 + u*edgeLength, -1, -1 + v*edgeLength);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gridCube.vertex(-1 + u*edgeLength, 1, -1 + v*edgeLength);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, 1, -1 + v*edgeLength);
      gridCube.vertex(-1 + u*edgeLength + edgeLength, 1, -1 + v*edgeLength + edgeLength);
      gridCube.vertex(-1 + u*edgeLength, 1, -1 + v*edgeLength + edgeLength);
    }
  }
  
  gridCube.endShape();
  
  return gridCube;
}

/*PShape createSpherifiedCubeUnitSphere(int resolution) {

}*/

PShape createNormalizedCubeUnitSphere(int resolution) {
  PShape gridCube = createGridUnitCube(resolution);

  for (int i = 0; i < gridCube.getVertexCount(); i++) {
    gridCube.setVertex(i,gridCube.getVertex(i).normalize());
  }
  
  return gridCube;
}

PShape createPlanet(int resolution) {
  PShape sphere = createNormalizedCubeUnitSphere(resolution);

  PShape planet = createShape();

  planet.beginShape(QUAD);
  //Kasse formes til kugle

  for (int i = 0; i < sphere.getVertexCount(); i++) {
    PVector point = sphere.getVertex(i).normalize();
    PVector surfacePoint = planetShaper.calculatePointOnPlanet(point);
    
    //cs.normal(point.x, point.y, point.z);
    planet.vertex(surfacePoint.x, surfacePoint.y, surfacePoint.z);
  }
  planet.endShape();

  planet.disableStyle();

  return planet;
}

void draw() {
  background(0, 100, 0);

  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("FPS: "+(int) frameRate, 10, textAscent() + 10);
  text("Punkter pr. side: "+resolution, 10, textAscent() + 20);
  text("Vertex count: "+s.getVertexCount(), 10, textAscent() + 30);
  text("Noise seed: "+noiseSeed, 10, textAscent() + 40);

  textAlign(CENTER);
  text("+/- for at ændre opløsning. 'n' for at vise normaler. 'g' for grid. 'r' randomize", width/2, height-textAscent());

  pushMatrix();
  //directionalLight(255, 0, 0, 0, -1, 0);

  translate(200, 200);
  rotateX(-QUARTER_PI*millis()*0.001);
  rotateY(QUARTER_PI*millis()*0.001);

  if (visibleNormals) shape(sn);

  lights();

  //shader.set("time", millis()*0.001);
  //shader(shader);

  shape(s);

  popMatrix();
}
