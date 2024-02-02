PShape s;
PShape sn;
PShader shader;

int size = 3;
boolean visibleNormals;

void setup() {
  size(400, 400, P3D);

  shader = loadShader("PlanetFrag.glsl", "PlanetVert.glsl");

  s = createCubeSphere(100.0, size);

  sn = getShapeNormals(s);

  ortho();
}

void keyPressed() {
  switch(key) {
    case('+'):
    size++;
    s = createCubeSphere(100.0, size);
    sn = getShapeNormals(s);
    break;
    case('-'):
    size = max(size-1, 2);
    s = createCubeSphere(100.0, size);
    sn = getShapeNormals(s);
    break;
    case('n'):
    visibleNormals = !visibleNormals;
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

PShape createCubeSphere(float radius, int resolution) {
  PShape gc = createShape();

  gc.beginShape(QUAD);

  final float edgeLength = 2.0/(resolution-1);

  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gc.vertex(-1 + u*edgeLength, -1 + v*edgeLength, -1);
      gc.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength, -1);
      gc.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength, -1);
      gc.vertex(-1 + u*edgeLength, -1 + v*edgeLength + edgeLength, -1);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gc.vertex(-1 + u*edgeLength, -1 + v*edgeLength + edgeLength, 1);
      gc.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength, 1);
      gc.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength, 1);

      gc.vertex(-1 + u*edgeLength, -1 + v*edgeLength, 1);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gc.vertex(-1, -1 + u*edgeLength, -1 + v*edgeLength);
      gc.vertex(-1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength);
      gc.vertex(-1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength);
      gc.vertex(-1, -1 + u*edgeLength, -1 + v*edgeLength + edgeLength);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gc.vertex(1, -1 + u*edgeLength, -1 + v*edgeLength + edgeLength);
      gc.vertex(1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength);
      gc.vertex(1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength);
      gc.vertex(1, -1 + u*edgeLength, -1 + v*edgeLength);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gc.vertex(-1 + u*edgeLength, -1, -1 + v*edgeLength + edgeLength);

      gc.vertex(-1 + u*edgeLength + edgeLength, -1, -1 + v*edgeLength + edgeLength);

      gc.vertex(-1 + u*edgeLength + edgeLength, -1, -1 + v*edgeLength);

      gc.vertex(-1 + u*edgeLength, -1, -1 + v*edgeLength);
    }
  }
  for (int u = 0; u < resolution-1; u++) {
    for (int v = 0; v < resolution-1; v++) {
      gc.vertex(-1 + u*edgeLength, 1, -1 + v*edgeLength);
      gc.vertex(-1 + u*edgeLength + edgeLength, 1, -1 + v*edgeLength);
      gc.vertex(-1 + u*edgeLength + edgeLength, 1, -1 + v*edgeLength + edgeLength);
      gc.vertex(-1 + u*edgeLength, 1, -1 + v*edgeLength + edgeLength);
    }
  }

  gc.endShape();

  PShape cs = createShape();
  cs.beginShape(QUAD);
  //Kasse formes til kugle
  for (int i = 0; i < gc.getVertexCount(); i++) {
    PVector point = gc.getVertex(i).normalize();
    cs.normal(point.x, point.y, point.z);
    point.mult(radius);
    cs.vertex(point.x, point.y, point.z);
  }
  cs.endShape();
  return cs;
}

void draw() {
  background(0, 100, 0);

  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("FPS: "+(int) frameRate, 10, textAscent() + 10);
  text("Punkter pr. side: "+size, 10, textAscent() + 20);
  textAlign(CENTER);
  text("+/- for at ændre opløsning. n for at vise normaler.", width/2, height-textAscent());

  pushMatrix();
  //directionalLight(255, 0, 0, 0, -1, 0);

  translate(200, 200);
  rotateX(-QUARTER_PI*millis()*0.001);
  rotateY(QUARTER_PI*millis()*0.001);
  
  if (visibleNormals) shape(sn);
  
  lights();

  shader.set("time", millis()*0.001);
  //shader(shader);

  shape(s);

  popMatrix();
}
