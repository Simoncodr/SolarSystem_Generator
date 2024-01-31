PShape s;

void setup() {
  size(400, 400, P3D);
  s = CreateCubeSphere(50.0, 8);

  ortho();
}

PShape CreateCubeSphere(float radius, int resolution) {
  PShape cs = createShape();

  cs.beginShape(QUAD);
  
  final float edgeLength = 2.0/(resolution-1);
  
  for(int u = 0; u < resolution-1; u++) {
    for(int v = 0; v < resolution-1; v++) {
      cs.vertex(-1 + u*edgeLength, -1 + v*edgeLength, -1);
      cs.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength, -1);
      cs.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength, -1);
      cs.vertex(-1 + u*edgeLength, -1 + v*edgeLength + edgeLength, -1);
    }
  }
  for(int u = 0; u < resolution-1; u++) {
    for(int v = 0; v < resolution-1; v++) {
      cs.vertex(-1 + u*edgeLength, -1 + v*edgeLength, 1);
      cs.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength, 1);
      cs.vertex(-1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength, 1);
      cs.vertex(-1 + u*edgeLength, -1 + v*edgeLength + edgeLength, 1);
    }
  }
  for(int u = 0; u < resolution-1; u++) {
    for(int v = 0; v < resolution-1; v++) {
      cs.vertex(-1, -1 + u*edgeLength, -1 + v*edgeLength);
      cs.vertex(-1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength);
      cs.vertex(-1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength);
      cs.vertex(-1, -1 + u*edgeLength, -1 + v*edgeLength + edgeLength);
    }
  }
  for(int u = 0; u < resolution-1; u++) {
    for(int v = 0; v < resolution-1; v++) {
      cs.vertex(1, -1 + u*edgeLength, -1 + v*edgeLength);
      cs.vertex(1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength);
      cs.vertex(1, -1 + u*edgeLength + edgeLength, -1 + v*edgeLength + edgeLength);
      cs.vertex(1, -1 + u*edgeLength, -1 + v*edgeLength + edgeLength);
    }
  }
  for(int u = 0; u < resolution-1; u++) {
    for(int v = 0; v < resolution-1; v++) {
      cs.vertex(-1 + u*edgeLength, -1, -1 + v*edgeLength);
      cs.vertex(-1 + u*edgeLength + edgeLength, -1, -1 + v*edgeLength);
      cs.vertex(-1 + u*edgeLength + edgeLength, -1, -1 + v*edgeLength + edgeLength);
      cs.vertex(-1 + u*edgeLength, -1, -1 + v*edgeLength + edgeLength);
    }
  }
  for(int u = 0; u < resolution-1; u++) {
    for(int v = 0; v < resolution-1; v++) {
      cs.vertex(-1 + u*edgeLength, 1, -1 + v*edgeLength);
      cs.vertex(-1 + u*edgeLength + edgeLength, 1, -1 + v*edgeLength);
      cs.vertex(-1 + u*edgeLength + edgeLength, 1, -1 + v*edgeLength + edgeLength);
      cs.vertex(-1 + u*edgeLength, 1, -1 + v*edgeLength + edgeLength);
    }
  }
  
  cs.endShape();
  
  //Kasse formes til kugle
  for (int i = 0; i < cs.getVertexCount(); i++) {
    cs.setVertex(i, cs.getVertex(i).normalize().mult(radius));
  }
  
  return cs;
}

void draw() {
  background(0, 255, 0);
  
  pushMatrix();
  
  translate(200, 200);
  rotateX(-QUARTER_PI*millis()*0.001);
  rotateY(QUARTER_PI*millis()*0.001);

  shape(s);
  
  /*for (int i = 0; i < s.getVertexCount(); i++) {
    point(s.getVertex(i).x, s.getVertex(i).y, s.getVertex(i).z);
  }*/
  popMatrix();
}
