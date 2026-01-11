import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imposter/homeScreen.dart';
import 'package:imposter/utilites.dart';
import 'categoryItems.dart';

class Categories_page extends StatefulWidget {
  static const String routeName = "cat";

  const Categories_page({super.key});

  @override
  State<Categories_page> createState() => _Categories_pageState();
}

class _Categories_pageState extends State<Categories_page>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _pulseController;
  int _currentPage = 0;
  bool _isAnimating = false;
  double _wheelRotation = 0.0;

  Map<String, List<String>> categories = {
    "أكلات": CategoryItems.aklat,
    "أنشطة / شغل": CategoryItems.activities,
    "أماكن": CategoryItems.places,
    "منستغناش": CategoryItems.stuff,
    "أفلام": CategoryItems.movies,
    "مشاهير": CategoryItems.celebrities,
  };

  final categoryIcons = [
    Icons.fastfood_rounded,
    Icons.business_center_rounded,
    Icons.explore_rounded,
    Icons.cases_rounded,
    Icons.theaters_rounded,
    Icons.emoji_events_rounded,
  ];

  final categoryColors = [
    Color(0xFFFFD166),
    Color(0xFF06B6D4),
    Color(0xFF9D4EDD),
    Color(0xFFEF4444),
    Color(0xFF10B981),
    Color(0xFFFF6B35),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pageController.addListener(() {
      if (_pageController.hasClients &&
          _pageController.position.haveDimensions) {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
          _wheelRotation =
              -(_pageController.page ?? 0) * (2 * pi / categories.length);
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String getRandomWord(String categoryName) {
    final random = Random();
    List<String> list = categories[categoryName]!;
    return list[random.nextInt(list.length)];
  }

  void _onCategorySelected(int index) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    List<String> categoryNames = categories.keys.toList();
    CategoryItems.randomChoice = getRandomWord(categoryNames[index]);

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushNamed(context, HomeScreen.routeName).then((_) {
        if (mounted) {
          setState(() {
            _isAnimating = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<String> categoryNames = categories.keys.toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 16),
                    Text(
                      "اختار الفئة المناسبة",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: categoryColors[_currentPage].withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(
                            text: "اللعبة ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextSpan(
                            text: "النهارده",
                            style: TextStyle(
                              color: categoryColors[_currentPage],
                              shadows: [
                                Shadow(
                                  color: categoryColors[_currentPage].withOpacity(0.8),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28),

              // Main Icon Display with Advanced Design
              Container(
                height: size.height * 0.24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated outer rings
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 200 + (index * 30) + (_pulseController.value * 15),
                            height: 200 + (index * 30) + (_pulseController.value * 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: categoryColors[_currentPage]
                                    .withOpacity(0.3 - (index * 0.08)),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    // Glow effect
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: categoryColors[_currentPage].withOpacity(0.4),
                            blurRadius: 60,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    // Icon Container
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.elasticOut,
                            ),
                          ),
                          child: child,
                        );
                      },
                      child: Container(
                        key: ValueKey(_currentPage),
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              categoryColors[_currentPage],
                              categoryColors[_currentPage].withOpacity(0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: categoryColors[_currentPage].withOpacity(0.6),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          categoryIcons[_currentPage],
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Category Name Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      "الفئة المختارة",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(_currentPage),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              categoryColors[_currentPage].withOpacity(0.2),
                              categoryColors[_currentPage].withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: categoryColors[_currentPage].withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          categoryNames[_currentPage],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: categoryColors[_currentPage],
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Confirm Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColors[_currentPage].withOpacity(0.5),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isAnimating
                        ? null
                        : () => _onCategorySelected(_currentPage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: categoryColors[_currentPage],
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "يلا نبدأ",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 24),
                      ],
                    ),
                  ),
                ),
              ),

              Spacer(),

              // Advanced Rotating Wheel
              Container(
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onPanUpdate: (details) {
                        if (_pageController.hasClients &&
                            _pageController.position.haveDimensions) {
                          final sensitivity = 3.0;
                          final newOffset = _pageController.offset +
                              (details.delta.dx * sensitivity);
                          _pageController.jumpTo(newOffset);
                        }
                      },
                      onPanEnd: (details) {
                        if (_pageController.hasClients &&
                            _pageController.position.haveDimensions) {
                          final velocity = details.velocity.pixelsPerSecond.dx;
                          if (velocity.abs() > 500) {
                            final targetPage = velocity > 0
                                ? _currentPage + 1
                                : _currentPage - 1;
                            if (targetPage >= 0 &&
                                targetPage < categories.length) {
                              _pageController.animateToPage(
                                targetPage,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          } else {
                            _pageController.animateToPage(
                              _currentPage,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 300,
                        color: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size.width,
                              height: 300,
                              child: CustomPaint(
                                painter: AdvancedWheelPainter(
                                  rotation: _wheelRotation,
                                  categories: categoryNames,
                                  icons: categoryIcons,
                                  colors: categoryColors,
                                  currentIndex: _currentPage,
                                ),
                              ),
                            ),
                            // Triangle indicator
                            Positioned(
                              top: 0,
                              child: Container(
                                width: 0,
                                height: 0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 18,
                                      color: Colors.transparent,
                                    ),
                                    right: BorderSide(
                                      width: 18,
                                      color: Colors.transparent,
                                    ),
                                    bottom: BorderSide(
                                      width: 24,
                                      color: categoryColors[_currentPage],
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: categoryColors[_currentPage].withOpacity(0.8),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: categoryNames.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) => Container(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class AdvancedWheelPainter extends CustomPainter {
  final double rotation;
  final List<String> categories;
  final List<IconData> icons;
  final List<Color> colors;
  final int currentIndex;

  AdvancedWheelPainter({
    required this.rotation,
    required this.categories,
    required this.icons,
    required this.colors,
    required this.currentIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.58;
    final segmentAngle = 2 * pi / categories.length;

    // Draw outer glow
    for (int i = 0; i < categories.length; i++) {
      final startAngle = rotation + (i * segmentAngle) - (segmentAngle / 2) - pi / 2;

      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius + 10),
        startAngle,
        segmentAngle,
        false,
      );
      path.close();

      final glowPaint = Paint()
        ..color = colors[i % colors.length].withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawPath(path, glowPaint);
    }

    // Draw each segment
    for (int i = 0; i < categories.length; i++) {
      final startAngle = rotation + (i * segmentAngle) - (segmentAngle / 2) - pi / 2;
      final isSelected = i == currentIndex;

      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        false,
      );
      path.close();

      // Gradient for segment
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = RadialGradient(
        colors: [
          colors[i % colors.length].withOpacity(0.9),
          colors[i % colors.length],
        ],
        stops: [0.5, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);

      // Border with glow
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 4 : 2.5;
      canvas.drawPath(path, borderPaint);

      // Draw icon and text
      final iconAngle = startAngle + (segmentAngle / 2);
      final iconRadius = radius * 0.68;
      final iconX = center.dx + cos(iconAngle) * iconRadius;
      final iconY = center.dy + sin(iconAngle) * iconRadius;

      // Icon background with shadow
      final iconBgPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, isSelected ? 8 : 4);
      canvas.drawCircle(Offset(iconX, iconY), isSelected ? 32 : 28, iconBgPaint);

      // Icon circle
      final iconPaint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(iconX, iconY), isSelected ? 28 : 24, iconPaint);

      // Draw icon using TextPainter (simplified representation)
      final iconTextPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icons[i].codePoint),
          style: TextStyle(
            fontFamily: icons[i].fontFamily,
            fontSize: isSelected ? 28 : 24,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.rtl,
      );
      iconTextPainter.layout();
      iconTextPainter.paint(
        canvas,
        Offset(
          iconX - iconTextPainter.width / 2,
          iconY - iconTextPainter.height / 2,
        ),
      );

      // Draw category name
      final textRadius = radius * 0.40;
      final textX = center.dx + cos(iconAngle) * textRadius;
      final textY = center.dy + sin(iconAngle) * textRadius;

      final textPainter = TextPainter(
        text: TextSpan(
          text: categories[i],
          style: TextStyle(
            fontSize: isSelected ? 13 : 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      );
      textPainter.layout(maxWidth: 80);

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(iconAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Draw center circle with advanced styling
    final centerGlowPaint = Paint()
      ..color = colors[currentIndex % colors.length].withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 50, centerGlowPaint);

    final centerGradient = RadialGradient(
      colors: [
        Color(0xFF2D3142),
        Color(0xFF1A1A2E),
      ],
    );
    final centerPaint = Paint()
      ..shader = centerGradient.createShader(
        Rect.fromCircle(center: center, radius: 42),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 42, centerPaint);

    final centerBorderPaint = Paint()
      ..color = colors[currentIndex % colors.length]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, 42, centerBorderPaint);

    final centerInnerBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 38, centerInnerBorderPaint);
  }

  @override
  bool shouldRepaint(AdvancedWheelPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.currentIndex != currentIndex;
  }
}