Table table;

float xMargin = 100;
int numRows;
float groundY;
float hairMin = 20;
float hairMax = 500;

PVector[] hairTipPoints; 

void setup() {
  size(1400, 1000);
  smooth();
  background(0);

  
  table = loadTable("hairdata.csv", "header"); 
 
  
  numRows = table.getRowCount();
  hairTipPoints = new PVector[numRows]; 

  groundY = height - 150;

  textAlign(CENTER, CENTER);
  textSize(14);
  noLoop();
}

void draw() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    int c = lerpColor(color(10,10,15), color(0), inter);
    stroke(c);
    line(0, y, width, y);
  }

      fill(255);
  textSize(40);
  text("Hair Loss Trend", width / 2, 40);

  fill(180);
  textSize(16);
      String trendExplanation = "Increasing percentage (line moves up) = hair is being lost\nDecreasing percentage (line moves down) = hair is being gained";
  text(trendExplanation, width / 2, 85);

  stroke(150);
  strokeWeight(2);
    line(xMargin, groundY, width - xMargin, groundY);

  float usableWidth = width - 2 * xMargin;
      float step = usableWidth / numRows;

  for (int i = 0; i < numRows; i++) {
    // Note: table.getRow(i) works correctly for external files too
    TableRow row = table.getRow(i);
    int year = row.getInt("Year");
      int month = row.getInt("Month");
    
    int percent = row.getInt("VisibilityPercent"); 

    float baseX = xMargin + i * step + step / 2;
    float baseY = groundY;
    
    float hairLength = map(percent, 0, 100, hairMin, hairMax); 
    
    float hairWidth = map(percent, 0, 100, 10, 2); 
    colorMode(HSB, 255);
    float hue = map(percent, 0, 100, 120, 10); 
    
    float curveX = map(noise(i * 0.3f), 0, 1, -20, 20);
    float curveY = hairLength * 0.5;

    stroke(hue, 200, 255);
    strokeWeight(hairWidth);
    noFill();
    bezier(baseX, baseY,
           baseX + curveX, baseY - curveY,
           baseX - curveX, baseY - hairLength + curveY,
           baseX, baseY - hairLength);
    colorMode(RGB);

    float tipY = baseY - hairLength; 

    hairTipPoints[i] = new PVector(baseX, tipY);

    noStroke();
      fill(255, 200, 220, 255);
    ellipse(baseX, tipY, 12, 12); 

    fill(255);
      textSize(16);
    textAlign(CENTER, BOTTOM);
    text(percent + "%", baseX, tipY - 18);

          fill(255);
    textSize(12);
      textAlign(CENTER, TOP);
    text(year + "-" + nf(month,2), baseX, groundY + 8);

    if (percent > 60) {
      int fallen = (percent - 60)/5 + 1;
      for (int j = 0; j < fallen; j++) {
        float fx = baseX + random(-12,12);
        float fy = groundY + random(4,18);
        noStroke();
        fill(255, 180, 180, 180);
        ellipse(fx, fy, 4, 4);
      }
    }
  }
  
  noFill();
  stroke(255, 255, 0); 
  strokeWeight(3);
  
  beginShape();
  for (int i = 0; i < numRows; i++) {
    vertex(hairTipPoints[i].x, hairTipPoints[i].y); 
  }
  endShape();

  fill(255);
  textAlign(RIGHT, CENTER);
  textSize(16);
  
  text("0% (Best)", xMargin - 15, groundY - hairMin);
  text("100% (Worst)", xMargin - 15, groundY - hairMax);

  textAlign(LEFT, CENTER);
  textSize(12);
  fill(180);
  text("Lower % / Better Condition", xMargin + 10, groundY - hairMin - 5);
  text("Higher % / Worse Condition", xMargin + 10, groundY - hairMax + 10);
}
