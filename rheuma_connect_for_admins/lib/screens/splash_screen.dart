import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for background animation
    _controller = AnimationController(
      duration:
          const Duration(seconds: 3), // Duration for full progress and scaling
      vsync: this,
    )..forward();

    // Setup an animated value that loops
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));

    // Navigate to the next screen after the animation completes
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/admin-login');
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background - Key UI Principle: Visual Appeal and Feedback
          AnimatedBuilder(
            animation: _animation!,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1D9EB1).withOpacity(_animation!.value),
                      Color(0xFFE0F7FA).withOpacity(_animation!.value),
                      Color(0xFF4FC3F7),
                    ],
                  ),
                ),
              );
            },
          ),
          // Bottom-left large circle - Visual Interest
          Positioned(
            bottom: -80,
            left: -60,
            child: CircleAvatar(
              radius: 160,
              backgroundColor: Color(0xFFAEDFF7)
                  .withOpacity(0.9), // Slightly transparent blue
            ),
          ),
          // Medium upper-right circle - Balanced Visual Design
          Positioned(
            top: 100,
            right: -40,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Color(0xFF81D4FA)
                  .withOpacity(0.8), // Slightly transparent blue
            ),
          ),
          // Small bottom-left circle - Complements Larger Elements
          Positioned(
            bottom: 90,
            left: 100,
            child: CircleAvatar(
              radius: 50,
              backgroundColor:
                  Color(0xFFB3E5FC).withOpacity(0.9), // Light blue circle
            ),
          ),
          // Triangle and medical cross at the top-right - Icon for Clarity
          Positioned(
            top: 150,
            right: 70,
            child: Stack(
              children: [
                Transform.rotate(
                  angle: 0.785398, // 45 degrees in radians
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFF29B6F6)
                          .withOpacity(0.85), // Transparent blue triangle
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add, // Medical cross icon - Clarity
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // App name "RHEUMA CONNECT" with Gray/Black Text - Simplicity and Visual Hierarchy
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'RHEUMA',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .black87, // Gray/Black color for the app name for simplicity
                    letterSpacing: 5,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black38,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'CONNECT',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 38,
                    fontWeight: FontWeight.w300,
                    color: Colors
                        .black54, // Slightly lighter gray for the "CONNECT" text
                    letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          // The Logo with Medical Plus Mark and One-time Scaling Animation - Simplicity
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: Center(
              child: ScaleTransition(
                scale: _controller!,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment(-0.5, -0.6),
                      colors: [
                        Color(0xFF1D9EB1),
                        Color(0xFF4FC3F7).withOpacity(0.8),
                        Color(0xFF81D4FA).withOpacity(0.6),
                      ],
                      stops: [0.3, 0.7, 1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(8, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // The "R" letter with glow effect - Enhances Hierarchy and Appeal
                      Positioned(
                        top: 40,
                        left: 60,
                        child: Text(
                          'R',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 20.0,
                                color: Colors.blueAccent,
                                offset: Offset(2, 2),
                              ),
                              Shadow(
                                blurRadius: 12.0,
                                color: Colors.lightBlueAccent,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // The "C" letter with glow effect - Enhances Hierarchy and Appeal
                      Positioned(
                        bottom: 40,
                        right: 60,
                        child: Text(
                          'C',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 20.0,
                                color: Colors.blueAccent,
                                offset: Offset(2, 2),
                              ),
                              Shadow(
                                blurRadius: 12.0,
                                color: Colors.lightBlueAccent,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Animated Progress bar - User Feedback and Efficiency
          Positioned(
            bottom: 80,
            left: 80,
            right: 80,
            child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                return Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: LinearProgressIndicator(
                      value: _controller!
                          .value, // Progress bar value controlled by animation
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF29B6F6)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
