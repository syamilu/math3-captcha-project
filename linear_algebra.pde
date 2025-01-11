import java.util.Random;
import java.util.ArrayList;

// Global variables
PImage[] images = new PImage[30];
ArrayList<Integer> selectedImages = new ArrayList<Integer>();
int currentLevel = 0; // 0: easy, 1: medium, 2: hard, 3: insane
String[] levels = {"Easy", "Medium", "Hard", "Insane"};
int currentImage = 0;
float imageX, imageY;
float imageSpeed = 2;
float directionX = 1;
float directionY = 1;
boolean solved = false;
boolean showMathProblem = false;
String mathProblem = "";
String userAnswer = "";
int correctAnswer = 0;
boolean mathSolved = false;
boolean showCongrats = false;
int congratsTimer = 0;
int attempts = 0;
boolean buttonHovered = false;

// Add these variables to the global declarations
boolean mouseTrackingEnabled = true;
ArrayList<PVector> mouseTrail = new ArrayList<PVector>();
int mouseTrailLength = 50;
float mouseSpeed = 0;
float lastMouseX, lastMouseY;
int lastClickTime = 0;
int minimumClickInterval = 200; // Minimum time between clicks in milliseconds
int sessionTimeout = 30000; // 30 seconds timeout
int sessionStartTime;
boolean sessionExpired = false;
int maxAttempts = 5;
int totalAttempts = 0;
boolean blocked = false;
int blockStartTime = 0;
int blockDuration = 10000; // 10 seconds block

final int LINEAR_CHECK_DURATION = 3000; // 3 seconds in milliseconds
float linearMovementStartTime = 0;
boolean isCurrentlyLinear = false;

void setup() {
    size(800, 600);
    // Load all images
    for (int i = 0; i < 30; i++) {
        images[i] = loadImage("images/image" + (i + 1) + ".jpg");
    }
    setupNewChallenge();
    sessionStartTime = millis();
    lastMouseX = mouseX;
    lastMouseY = mouseY;
}

void updateMouseTracking() {
    if (mouseTrackingEnabled) {
        // Calculate mouse speed
        float dx = mouseX - lastMouseX;
        float dy = mouseY - lastMouseY;
        mouseSpeed = sqrt(dx*dx + dy*dy);
        
        // Store mouse position and timestamp in trail
        mouseTrail.add(new PVector(mouseX, mouseY, millis())); // Using z component to store timestamp
        if (mouseTrail.size() > mouseTrailLength) {
            mouseTrail.remove(0);
        }
        
        // Update last position
        lastMouseX = mouseX;
        lastMouseY = mouseY;
        
        // Only check for linear movement if we have enough points
        if (mouseTrail.size() > 20) { // Increased minimum points for better accuracy
            boolean currentlyLinear = checkLinearMovement();
            
            if (currentlyLinear) {
                if (!isCurrentlyLinear) {
                    // Movement just became linear, start timing
                    linearMovementStartTime = millis();
                    isCurrentlyLinear = true;
                } else if (millis() - linearMovementStartTime > LINEAR_CHECK_DURATION) {
                    // Movement has been linear for more than 3 seconds
                    blocked = true;
                    blockStartTime = millis();
                    isCurrentlyLinear = false; // Reset the flag
                }
            } else {
                // Reset if movement becomes non-linear
                isCurrentlyLinear = false;
            }
        }
    }
}

boolean checkLinearMovement() {
    // Get the last 20 points
    int pointsToCheck = min(20, mouseTrail.size());
    ArrayList<PVector> recentPoints = new ArrayList<PVector>(
        mouseTrail.subList(mouseTrail.size() - pointsToCheck, mouseTrail.size())
    );
    
    // Calculate average deviation from a straight line
    PVector start = recentPoints.get(0);
    PVector end = recentPoints.get(recentPoints.size() - 1);
    
    // Only check if mouse has moved significantly
    float totalDistance = PVector.dist(start, end);
    if (totalDistance < 50) { // Minimum distance threshold
        return false;
    }
    
    // Calculate deviations
    float totalDeviation = 0;
    PVector line = PVector.sub(end, start);
    for (int i = 1; i < recentPoints.size() - 1; i++) {
        PVector point = recentPoints.get(i);
        // Calculate perpendicular distance from point to line
        float deviation = abs(
            ((end.y - start.y) * point.x - (end.x - start.x) * point.y + end.x * start.y - end.y * start.x) /
            sqrt(sq(end.y - start.y) + sq(end.x - start.x))
        );
        totalDeviation += deviation;
    }
    
    float averageDeviation = totalDeviation / (pointsToCheck - 2);
    float deviationThreshold = 5.0; // Increased threshold for more leniency
    
    return averageDeviation < deviationThreshold;
}

void setupNewChallenge() {
    // Show congrats message when math is solved
    if (mathSolved) {
        showCongrats = true;
        congratsTimer = frameCount;
    }
    // Reset variables
    solved = false;
    mathSolved = false;
    showMathProblem = false;
    userAnswer = "";
    attempts = 0;
    
    // Set initial image position
    imageX = random(width - 200);
    imageY = random(height - 200);
    
    // Select random image
    currentImage = (int)random(30);
    
    // Adjust speed based on level
    switch(currentLevel) {
        case 0: // Easy
            imageSpeed = 2;
            break;
        case 1: // Medium
            imageSpeed = 6;
            break;
        case 2: // Hard
            imageSpeed = 10;
            break;
        case 3: // Insane
            imageSpeed = 50;
            break;
    }
    
    directionX = random(-1, 1) > 0 ? 1 : -1;
    directionY = random(-1, 1) > 0 ? 1 : -1;
}

void generateMathProblem() {
    Random rand = new Random();
    int num1, num2, operation;
    
    switch(currentLevel) {
        case 0: // Easy - Simple addition
            num1 = rand.nextInt(10) + 1;
            num2 = rand.nextInt(10) + 1;
            mathProblem = num1 + " + " + num2 + " = ?";
            correctAnswer = num1 + num2;
            break;
            
        case 1: // Medium - Multiplication
            num1 = rand.nextInt(12) + 1;
            num2 = rand.nextInt(12) + 1;
            mathProblem = num1 + " × " + num2 + " = ?";
            correctAnswer = num1 * num2;
            break;
            
        case 2: // Hard - Mixed operations
            num1 = rand.nextInt(20) + 1;
            num2 = rand.nextInt(20) + 1;
            operation = rand.nextInt(3);
            switch(operation) {
                case 0:
                    mathProblem = num1 + " + " + num2 + " = ?";
                    correctAnswer = num1 + num2;
                    break;
                case 1:
                    mathProblem = num1 + " × " + num2 + " = ?";
                    correctAnswer = num1 * num2;
                    break;
                case 2:
                    num1 = num1 * num2; // Ensure division results in whole number
                    mathProblem = num1 + " ÷ " + num2 + " = ?";
                    correctAnswer = num1 / num2;
                    break;
            }
            break;
            
        case 3: // Insane - Complex operations
            num1 = rand.nextInt(50) + 10;
            num2 = rand.nextInt(50) + 10;
            operation = rand.nextInt(4);
            switch(operation) {
                case 0:
                    int num3 = rand.nextInt(20) + 1;
                    mathProblem = num1 + " + " + num2 + " × " + num3 + " = ?";
                    correctAnswer = num1 + (num2 * num3);
                    break;
                case 1:
                    mathProblem = num1 + "² + " + num2 + " = ?";
                    correctAnswer = (num1 * num1) + num2;
                    break;
                case 2:
                    mathProblem = "(" + num1 + " + " + num2 + ") × 2 = ?";
                    correctAnswer = (num1 + num2) * 2;
                    break;
                case 3:
                    num1 = (num1 / 10) * 10; // Make it divisible by 10
                    mathProblem = num1 + " ÷ 10 + " + num2 + " = ?";
                    correctAnswer = (num1 / 10) + num2;
                    break;
            }
            break;
    }
}

void draw() {
  if (millis() - sessionStartTime > sessionTimeout) {
        sessionExpired = true;
        background(255);
        fill(255, 0, 0);
        textSize(24);
        textAlign(CENTER, CENTER);
        text("Session Expired. Please Refresh.", width/2, height/2);
        return;
    }
    
    // Check if blocked
    if (blocked) {
        if (millis() - blockStartTime > blockDuration) {
            blocked = false;
        } else {
            background(255);
            fill(255, 0, 0);
            textSize(24);
            textAlign(CENTER, CENTER);
            text("Suspicious Activity Detected. Please Wait.", width/2, height/2);
            return;
        }
    }
    
    // Update mouse tracking
    updateMouseTracking();
    
    background(255);
    
    // Show congratulatory message
    if (showCongrats) {
        if (frameCount - congratsTimer < 90) {  // Show for 1.5 seconds (90 frames)
            drawCongrats();
            return;
        } else {
            showCongrats = false;
        }
    }
    
    // Draw level selection buttons
    drawLevelButtons();
    
    if (!showMathProblem) {
        // Move and draw the image
        moveImage();
        image(images[currentImage], imageX, imageY, 100, 100);
        
        // Display instructions
        fill(0);
        textSize(20);
        textAlign(CENTER);
        text("Click on the moving image to proceed", width/2, 30);
        text("Current Level: " + levels[currentLevel], width/2, 60);
    } else {
        // Draw math problem interface
        drawMathProblem();
    }
}

void moveImage() {
    imageX += imageSpeed * directionX;
    imageY += imageSpeed * directionY;
    
    // Bounce off walls
    if (imageX <= 0 || imageX >= width - 200) {
        directionX *= -1;
    }
    if (imageY <= 0 || imageY >= height - 200) {
        directionY *= -1;
    }
}

void drawMathProblem() {
    fill(0);
    textSize(32);
    textAlign(CENTER);
    text(mathProblem, width/2, height/3);
    
    // Draw input box
    fill(255);
    stroke(0);
    rect(width/2 - 100, height/2 - 25, 200, 50);
    
    // Draw user input
    fill(0);
    textSize(24);
    text(userAnswer, width/2, height/2 + 10);
    
    // Draw submit button
    drawSubmitButton();
    
    // Show attempts
    textSize(16);
    text("Attempts: " + attempts, width/2, height/2 + 100);
}

void drawSubmitButton() {
    int buttonX = width/2 - 60;
    int buttonY = height/2 + 50;
    int buttonWidth = 120;
    int buttonHeight = 40;
    
    // Check hover
    buttonHovered = mouseX > buttonX && mouseX < buttonX + buttonWidth &&
                    mouseY > buttonY && mouseY < buttonY + buttonHeight;
    
    // Draw button
    fill(buttonHovered ? color(0, 200, 0) : color(0, 255, 0));
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
    
    // Button text
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Submit", buttonX + buttonWidth/2, buttonY + buttonHeight/2);
}

void drawLevelButtons() {
    for (int i = 0; i < levels.length; i++) {
        float x = 10 + i * 120;
        float y = height - 40;
        
        // Highlight current level
        if (i == currentLevel) {
            fill(0, 255, 0);
        } else {
            fill(200);
        }
        
        rect(x, y, 100, 30);
        fill(0);
        textSize(16);
        textAlign(CENTER, CENTER);
        text(levels[i], x + 50, y + 15);
    }
}

void mousePressed() {
  if (sessionExpired || blocked) return;
    
    // Check for rapid clicking
    int currentTime = millis();
    if (currentTime - lastClickTime < minimumClickInterval) {
        blocked = true;
        blockStartTime = millis();
        return;
    }
    lastClickTime = currentTime;
    
    // Check total attempts
    if (totalAttempts >= maxAttempts) {
        blocked = true;
        blockStartTime = millis();
        return;
    }
    
    // Check level buttons
    for (int i = 0; i < levels.length; i++) {
        float x = 10 + i * 120;
        float y = height - 40;
        if (mouseX >= x && mouseX <= x + 100 && mouseY >= y && mouseY <= y + 30) {
            currentLevel = i;
            setupNewChallenge();
            return;
        }
    }
    
    if (!showMathProblem) {
        // Check if user clicked on the moving image
        if (mouseX >= imageX && mouseX <= imageX + 100 &&
            mouseY >= imageY && mouseY <= imageY + 100) {
            showMathProblem = true;
            generateMathProblem();
        }
    } else if (buttonHovered) {
        // Check answer when submit button is clicked
        checkAnswer();
    }
    
    totalAttempts++;
}

void keyPressed() {
    if (showMathProblem) {
        if (key >= '0' && key <= '9') {
            userAnswer += key;
        } else if (key == BACKSPACE && userAnswer.length() > 0) {
            userAnswer = userAnswer.substring(0, userAnswer.length() - 1);
        } else if (key == ENTER || key == RETURN) {
            checkAnswer();
        }
    }
}

void drawCongrats() {
    // Create a semi-transparent overlay
    fill(0, 0, 0, 127);
    rect(0, 0, width, height);
    
    // Draw congratulatory message
    textAlign(CENTER, CENTER);
    
    // Draw glowing effect
    float glowSize = 50 + sin(frameCount * 0.1) * 10;  // Pulsing effect
    for (int i = 5; i > 0; i--) {
        fill(0, 255, 0, 50/i);  // Green glow
        textSize(32 + i * 2);
        text("Congratulations!", width/2, height/2 - 40);
        text("You Are Human!", width/2, height/2 + 40);
    }
    
    // Draw main text
    fill(255);
    textSize(32);
    text("Congratulations!", width/2, height/2 - 40);
    text("You Are Human!", width/2, height/2 + 40);
}

class EntropyCollector {
    private ArrayList<Integer> entropyPool;
    private final int POOL_SIZE = 100;
    
    EntropyCollector() {
        entropyPool = new ArrayList<Integer>();
    }
    
    void addEntropy(float mouseX, float mouseY, float time) {
        if (entropyPool.size() >= POOL_SIZE) {
            entropyPool.remove(0);
        }
        
        int entropy = (int)(mouseX * 1000 + mouseY * 100 + time);
        entropyPool.add(entropy);
    }
    
    int getRandomSeed() {
        int seed = 0;
        for (int value : entropyPool) {
            seed ^= value;
        }
        return seed;
    }
}

// Add visual noise pattern
void addVisualNoise() {
    loadPixels();
    for (int i = 0; i < pixels.length; i += 10) {
        if (random(1) < 0.1) {
            pixels[i] = color(random(255));
        }
    }
    updatePixels();
}


void checkAnswer() {
  if (blocked || sessionExpired) return;
    
    if (totalAttempts >= maxAttempts) {
        blocked = true;
        blockStartTime = millis();
        return;
    }
    
    if (userAnswer.length() > 0) {
        attempts++;
        try {
            int answer = Integer.parseInt(userAnswer);
            if (answer == correctAnswer) {
                // Correct answer
                mathSolved = true;
                setupNewChallenge();
            } else {
                // Wrong answer
                userAnswer = "";
                if (attempts >= 3) {
                    // Reset after 3 attempts
                    setupNewChallenge();
                }
            }
        } catch (NumberFormatException e) {
            userAnswer = "";
        }
    }
}
