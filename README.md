# CAPTCHA System with Image and Math Challenges

A sophisticated CAPTCHA system built using Processing that combines moving image selection with mathematical challenges. This system includes multiple difficulty levels, security features, and bot detection mechanisms. This project developed for Math 3 Group Project at IIUM

## Features

### Core Functionality
- Moving image targets that users must click
- Mathematical challenges after successful image selection
- Four difficulty levels: Easy, Medium, Hard, and Insane
- Visual feedback and congratulatory messages
- Interactive user interface with hover effects

### Security Features
- Mouse movement pattern analysis for bot detection
- Session timeout management
- Anti-automation measures
- Attempt limiting and temporary blocking
- Visual noise patterns to prevent image recognition
- Entropy-based randomization

### Difficulty Levels
1. **Easy**
   - Slow-moving images
   - Simple addition problems (1-10)
   - Perfect for testing and demonstrations

2. **Medium**
   - Moderate image speed
   - Multiplication tables (1-12)
   - Balanced challenge level

3. **Hard**
   - Fast-moving images
   - Mixed operations (addition, multiplication, division)
   - Challenging for most users

4. **Insane**
   - Extremely fast-moving images
   - Complex mathematical expressions
   - Maximum security level

## Requirements

- Processing 4.x or higher
- Java Runtime Environment (JRE) 8 or higher
- Minimum screen resolution: 800x600
- 30 images for CAPTCHA (numbered 1-30)

## Installation

1. Download and install Processing from [processing.org](https://processing.org/download)
2. Clone this repository or download the source code:
   ```bash
   git clone [your-repository-url]
   ```
3. Create an 'images' folder in your sketch directory
4. Add 30 images named 'image1.jpg' through 'image30.jpg' to the images folder

## Project Structure

```
advanced-captcha/
│
├── advanced_captcha.pde    # Main Processing sketch file
├── images/                 # Directory containing CAPTCHA images
│   ├── image1.jpg
│   ├── image2.jpg
│   └── ... (up to image30.jpg)
│
└── README.md              # This file
```

## How to Run

1. Open Processing IDE
2. File > Open > Navigate to the project folder
3. Open 'advanced_captcha.pde'
4. Click the "Run" button (play icon) or press Ctrl+R (Cmd+R on Mac)

### Alternative Run Method
1. Open terminal/command prompt
2. Navigate to project directory
3. Run using Processing command line:
   ```bash
   processing-java --sketch=[path_to_sketch] --run
   ```

## Usage Instructions

1. **Starting the Application**
   - Launch the program
   - Select difficulty level using buttons at bottom
   - Begin with Easy level to familiarize yourself

2. **Playing the Game**
   - Click the moving image to proceed
   - Solve the mathematical challenge
   - Use number keys to input answer
   - Press Enter or click Submit to verify

3. **Demo Features** (For Testing)
   - Retry buttons available during blocks/timeouts
   - Session can be reset instantly
   - Visual feedback for all actions

## Security Notes

For demonstration purposes, this version includes:
- Instant retry options
- Visual countdown timers
- Reduced timeout durations
- Visible feedback messages

In a production environment, these features should be modified for enhanced security.

## Troubleshooting

Common issues and solutions:

1. **Images Not Loading**
   - Verify images are in correct folder
   - Check image naming convention
   - Ensure images are .jpg format
