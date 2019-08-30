import java.math.BigDecimal;

int maxIterations = 1000;
float zoom = 1f;
float zoomFactor = 0.01f;
Complex center;
boolean reset = true;
int halfWidth;
int halfHeight;

boolean mandelbrot = true;
boolean absValue = false;
Complex juliaConstant = new Complex(-1, 0.1);

boolean blackAndWhite = false;
float rLowerBound = 0;
float gLowerBound = 0;
float bLowerBound = 0;
float rUpperBound = 1;
float gUpperBound = 1;
float bUpperBound = 1;
float r, g, b;

void setup() {
  size(1000,1000);
  halfWidth = (int)width/2;
  halfHeight = (int)height/2;
  center = new Complex(0, 0);
  r = random(rLowerBound, rUpperBound);
  g = random(gLowerBound, gUpperBound);
  b = random(bLowerBound, bUpperBound);
  noLoop();
}

void draw() {
  clear();
  colorImaginary();
}



void colorImaginary() {
  for(int x = 0; x < width; x++) {
    double mappedX = mapX(x);
    for(int y = 0; y < height; y++) {
      double mappedY = mapY(y);

      int hue = iterateImaginary(mappedX, mappedY);
      float mappedHue = ((float) hue / maxIterations) * 255;
      if(!blackAndWhite) {
        stroke(mappedHue * r, mappedHue * g, mappedHue * b);
      } else {
        stroke(mappedHue);
      }
      point(x, y);
    }
  }
}

double mapX(int x) {
  return zoom * ((double)(x - halfWidth) / halfWidth + center.real) * 2;
}
double mapY(int y) {
  return zoom * ((double)(y - halfHeight) / halfHeight + center.img) * 2;
}

int iterateImaginary(double x, double y) {
  Complex c = mandelbrot ? new Complex(x, y) : juliaConstant;
  Complex z = mandelbrot ? new Complex(0, 0) : new Complex(x, y);
  int hue = maxIterations;
  for(int i = 0; i < maxIterations; i++) {
    z = doCalculation(z, c);
    
    //break out of loop once past 2
    if(z.magnitude() > 2) {
      hue = i;
      break;
    }
  }
  
  return hue;
}

Complex doCalculation(Complex z, Complex c){
  if(absValue) {
    return z.absComplex().sq().add(c);
  } else {
    return z.sq().add(c);
  }
}

void mousePressed() {
  double x = (1 / (zoom * 2 * zoomFactor)) * mapX(mouseX);
  double y = (1 / (zoom * 2 * zoomFactor)) * mapY(mouseY);
  Complex v = new Complex(x,y);
  center = v;
  zoom *= zoomFactor;
  redraw();
}

class Complex {
    double real;  // the real part
    double img;   // the imaginary part

    public Complex(double real, double img) {
        this.real = real;
        this.img = img;
    }

    public Complex mult(Complex b) {
        double real = this.real * b.real - this.img * b.img;
        double img = this.real * b.img + this.img * b.real;
        return new Complex(real, img);
    }
    
    public Complex absComplex() {
      return new Complex(Math.abs(this.real), Math.abs(this.img));
    }
    
    public Complex sq() {
      return this.mult(this);
    }
    
    public Complex add(Complex b) {
      return new Complex(real + b.real, img + b.img);
    }
    
    public double magnitude() {
      return Math.sqrt(Math.pow(real, 2) + Math.pow(img, 2));
    }
}
