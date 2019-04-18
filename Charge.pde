class Charge {
  
  public final float K = 8.99 * pow(10, -9);
  
  private int x;
  private int y;
  private int charge;
  public Charge(int x, int y, int charge) {
    this.x = x;
    this.y = y;
    this.charge = charge;
  }
  
  public float[] getElectricFieldToCharge(int x, int y) {
    float angle = atan2(y-this.y, x-this.x);
    float magnitude = getMagnitudeToPoint(x, y);
    return new float[] {magnitude * cos(angle), magnitude * sin(angle)};
  }
  
  public float getMagnitudeToPoint(int x, int y) {
    return (K * charge) / distSq(x, y);
  }
  
  public float distSq(int x, int y) {
    return (this.x-x) * (this.x-x) + (this.y-y) * (this.y-y);
  }
  
  public void render() {
    int radius = 7;
    
    color toRender = color(255, 40, 80);
    if (charge < 0) {
      toRender = color(80, 120, 255);
    }
    
    //resetMatrix();
    color prevStroke = g.strokeColor;
    color prevFill = g.fillColor;
    stroke(toRender);
    fill(toRender);
    circle(x, y, radius + (abs(charge) / 1.8f));
    stroke(prevStroke);
    stroke(prevFill);
  }
  
  public int setX(int x) {
    int prev = this.x;
    this.x = x;
    return prev;
  }
  
  public int setY(int y) {
    int prev = this.y;
    this.y = y;
    return prev;
  }
  
  public int setCharge(int charge) {
    int prev = this.charge;
    this.charge = charge;
    return prev;
  }
}
