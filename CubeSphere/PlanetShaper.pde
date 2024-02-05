class PlanetShaper {
  private float radius;
  
  PlanetShaper(float radius) {
    this.radius = radius;  
  }
  
  public PVector calculatePointOnPlanet(PVector unitSpherePoint) {
    
    noiseDetail(4, 0.4);
    final float noiseScale = 2.0;
    final float noiseStrength = 50.0;
    
    PVector noiseSamplePos = unitSpherePoint.copy();
    noiseSamplePos.add(1.0, 1.0, 1.0);
    noiseSamplePos.mult(noiseScale);
    
    float elevation = noise(noiseSamplePos.x, noiseSamplePos.y, noiseSamplePos.z);
    elevation *= noiseStrength;
    
    return PVector.mult(unitSpherePoint, this.radius + elevation);
  }
}
