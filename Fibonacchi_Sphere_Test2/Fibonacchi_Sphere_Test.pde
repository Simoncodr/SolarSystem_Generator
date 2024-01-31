// lignene: https://github.com/EndaHealion/Fibonacci-Sphere/blob/master/src/Main.java

int n = 50; // n er mængden af punkter på kuglen
int zoom = 300;
int mousePressedLocationX;
int mousePressedLocationY;
float sphereSize = 2;
float goldenRatio = (1 + sqrt(5)) / 2;
float rotationX = 0;
float rotationZ = 0;
// https://processing.org/reference/ArrayList.html
ArrayList<Float> x = new ArrayList<Float>();
ArrayList<Float> y = new ArrayList<Float>();
ArrayList<Float> z = new ArrayList<Float>();
ArrayList<Float> theta = new ArrayList<Float>();
ArrayList<Float> phi = new ArrayList<Float>();
boolean holdingMouse;
boolean addPoint = false;
boolean removePoint = false;

void setup() {
  frameRate(60);
  //size(800, 800, P3D);
  fullScreen(P3D);
}

void draw() {
  background(0);
  textSize(20);
  text("Press 'e' to exit", width - width +2, height - height + 20);
  text("Hold 'q' to add", width - width + 2, height - height + 40);
  text("Hold 'w' to remove", width - width + 2, height - height + 60);
  text("Number of points: " +str(n), width - width + 2, height - height + 80);
  text("Frames per second: " +int(frameRate), width - width + 2, height - height + 100);
  rotateSphere();
  increaseDecrease();
  // dette gør at kuglen bliver dannet i midten af skærmen.
  translate(width / 2, height / 2);
  // dette looper igennem de bestemte mængde af punkter i kuglen og tegner en lile kugle ved alle punkterne
  for (int i = 0; i < n; i++) {
    // dette er baseret på en fibonacci sphere, hvilket bruger den gyldne ratio til at lave punkter på en kugle der er ligeligt fordelt på hele kuglen.
    // https://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/
    theta.add(2 * PI * i / goldenRatio);
    // Her bliver n betegnet(castet) som en float da man ellers ville midste komma tallene, hvilket vil øddelægge kuglen da beregningerne ikke vil blive nøjagtige.
    // Derfor vil n blive betragtet som en float i udregningerne mens den stadig er en intager da man ikke kan have et halvt punkt.
    // https://processing.org/reference/floatconvert_.html
    phi.add(acos(1 - 2 * i / (float)n));
    // her bliver de forskellige koordinater bestemt for hvert punkt
    x.add(cos(theta.get(i)) * sin(phi.get(i)));
    y.add(sin(theta.get(i)) * sin(phi.get(i)));
    z.add(cos(phi.get(i)));
    // dette bestemmer de forskellige koordinater af kuglerne og bestemmer aftanden mellem punkterne
    float sphereX = x.get(i) * zoom;
    float sphereY = y.get(i) * zoom;
    float sphereZ = z.get(i) * zoom;
    // dette tegner selve kuglerne
    // https://processing.org/tutorials/p3d
    pushMatrix();
    rotateY(rotationX/400);
    rotateZ(rotationZ/400);
    // her får kuglen at vide hvilke koordinater den ska tegnes i, og hvilken farve den skal have samt radius.
    translate(sphereX, sphereY, sphereZ);
    fill(255, 255, 255);
    noStroke();
    sphere(sphereSize);
    popMatrix();
  }
}

// https://processing.org/reference/mouseWheel_.html
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  // her får man en værdi der er enten 1 eller -1. Dette ligger vi til zoom * 10 for at kunne zoome ind eller ud på kuglen
  zoom += e*10;
}

// https://processing.org/reference/mousePressed_.html
void mousePressed() {
  holdingMouse = true;
  mousePressedLocationX = mouseX;
  mousePressedLocationY = mouseY;
}
// https://processing.org/reference/mouseReleased_.html
void mouseReleased() {
  holdingMouse = false;
}

void rotateSphere() {
  if (holdingMouse) {
    rotationX += (mouseX-mousePressedLocationX);
    mousePressedLocationX = mouseX;
    rotationZ += (mouseY-mousePressedLocationY);
    mousePressedLocationY = mouseY;
  }
}

void keyPressed() {
  if (key == 'e' || key == 'E') {
    exit();
  }
  if (key == 'q' && !removePoint || key == 'Q' && !removePoint) {
    addPoint = true;
  }
  if (key == 'w' && !addPoint || key == 'W' && !addPoint) {
    removePoint = true;
  }
}
void keyReleased() {
  if (key == 'q' || key == 'Q') {
    addPoint = false;
  }
  if (key == 'w' || key == 'W') {
    removePoint = false;
  }
}

// Denne kode tilføjer eller fjerner punkter i kuglen
// Jeg bruger clear() til at lave en ny arraylist for at kunne opdatere punkternes position
void increaseDecrease() {
  if (addPoint) {
    x.clear();
    y.clear();
    z.clear();
    theta.clear();
    phi.clear();
    n++;
  } if (removePoint) {
    x.clear();
    y.clear();
    z.clear();
    theta.clear();
    phi.clear();
    n = max(5, n - 1);
  }
}
