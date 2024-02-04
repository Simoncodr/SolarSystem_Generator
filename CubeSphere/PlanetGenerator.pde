class PlanetGenerator {
  private float radius;
  
  PlanetGenerator(float radius) {
    this.radius = radius;  
  }
  
  public PVector calculatePointOnPlanet(PVector unitSpherePoint) {
    
    noiseDetail(1);
    float elevation = noise(unitSpherePoint.x, unitSpherePoint.y, unitSpherePoint.z);
    return PVector.mult(unitSpherePoint, this.radius * (1 + elevation));
  }
}
