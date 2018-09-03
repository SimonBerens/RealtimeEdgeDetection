import processing.video.*;

Capture cam;
PImage img;
double[] transformationMatrix;


public void setup() {
  size(640, 480);
    transformationMatrix =
            new double[]{-1, -1, -1, -1, 8, -1, -1, -1, -1};

    String[] cameras = Capture.list();

    if (cameras.length <= 0) {
        println("There are no cameras available for capture.");
        exit();
    } else {
        println("Available cameras:");
        for (int i = 0; i < cameras.length; i++) {
            println(cameras[i]);
        }

        // The camera can be initialized directly using an
        // element from the array returned by list():
        cam = new Capture(this, cameras[0]);
        cam.start();
    }

}

public void draw() {
    if (cam.available()) cam.read();
    img = cam;
    image(img, 0, 0);
    loadPixels();
    transform();
}

private void transform() {
    for (int row = 0; row < width; row++) {
        for (int col = 0; col < height; col++) {
            int[] kernel = img.get(row, col, 3, 3).pixels;
            changePixel(row, col, kernel);
        }
    }
}

private void changePixel(int row, int col, int[] kernel) {
    color redSum = 0;
    color greenSum = 0;
    color blueSum = 0;
    for (int i = 0; i < kernel.length; i++) {
        redSum += red(kernel[i]) * transformationMatrix[i];
        greenSum += green(kernel[i]) * transformationMatrix[i];
        blueSum += blue(kernel[i]) * transformationMatrix[i];
    }
    set(row, col, color(redSum, greenSum, blueSum));
}
