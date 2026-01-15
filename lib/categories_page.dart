import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:imposter/finalResultScreen.dart';
import 'package:imposter/utilites.dart';
import 'categoryCharacters.dart';
import 'categoryItems.dart';
import 'characterRevealScreen.dart';
import 'gameManager.dart';

// ─── Pharaonic Color Palette ───────────────────────────────────────────────
class PharaohColors {
  static const gold         = Color(0xFFEEB807);
  static const deepGold     = Color(0xFFB8860B);
  static const lightGold    = Color(0xFFEDB21D);
  static const puprble      = Color(0xFF6E0D61);
  static const darkLapis    = Color(0xFF0A1628);
  static const lapis        = Color(0xFF1A2F5A);
  static const midLapis     = Color(0xFF243B6E);
  static const turquoise    = Color(0xFF00A89D);
  static const deepRed      = Color(0xFF8B1A1A);
  static const scarabGreen  = Color(0xFF2D6A4F);
  static const ivory        = Color(0xFFFAF0DC);
}

// ─── Category Image Paths ───────────────────────────────────────────────────
class CategoryImages {
  static  String food         = AppAssets.food;
  static  String worker       = AppAssets.worker;
  static  String place        = AppAssets.place;
  static  String manstahnash  = AppAssets.manstahnash;
  static  String film         = AppAssets.film;
  static  String celebrities  = AppAssets.celebrities; // reuse or add
}

// ─── Pharaonic Cartouche Widget (header text frame) ────────────────────────
class CartoucheBox extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color bgColor;

  const CartoucheBox({
    super.key,
    required this.child,
    this.borderColor = PharaohColors.gold,
    this.bgColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CartouchePainter(borderColor: borderColor, bgColor: bgColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: child,
      ),
    );
  }
}

class _CartouchePainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;
  const _CartouchePainter({required this.borderColor, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.height / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(r),
    );

    if (bgColor != Colors.transparent) {
      canvas.drawRRect(rect, Paint()..color = bgColor);
    }

    final borderPaint = Paint()
      ..color = borderColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(rect, borderPaint);

    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 4, size.width - 8, size.height - 8),
      Radius.circular(r - 4),
    );
    canvas.drawRRect(
      innerRect,
      Paint()
        ..color = borderColor.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_CartouchePainter old) => false;
}

// ─── Eye of Horus Decorative Widget ────────────────────────────────────────


// ─── Glass Image Circle Widget ──────────────────────────────────────────────
/// Shows a PNG image inside a pharaonic glass circle.
/// The image "pops out" slightly by clipping only 85% of the bottom,
/// letting the top of the image overflow the circle frame.
class GlassImageCircle extends StatelessWidget {
  final String imagePath;
  final Color accentColor;
  final double size;
  final Animation<double> pulseAnimation;

  const GlassImageCircle({
    super.key,
    required this.imagePath,
    required this.accentColor,
    required this.size,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 32,
      height: size + 48, // extra height so image can overflow upward
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // ── Outer glow rings (pulse) ──
          ...List.generate(3, (index) {
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, _) {
                  final ringSize = size + (index * 22) + (pulseAnimation.value * 10);
                  return Center(
                    child: SizedBox(
                      width: ringSize,
                      height: ringSize,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withOpacity(0.30 - index * 0.08),
                            width: index == 0 ? 2 : 1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // ── Glass circle base ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withOpacity(0.35),
                          accentColor.withOpacity(0.12),
                          PharaohColors.darkLapis.withOpacity(0.6),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      border: Border.all(
                        color: PharaohColors.gold.withOpacity(0.75),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.45),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: PharaohColors.gold.withOpacity(0.15),
                          blurRadius: 60,
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Inner decorative ring ──
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: size - 14,
                height: size - 14,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: PharaohColors.gold.withOpacity(0.22),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Glass highlight arc (top specular) ──
          Positioned(
            bottom: size * 0.45,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.45),
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Image — overflows top of circle ──
          Positioned(
            bottom: size * 0.08,   // sits slightly above bottom of circle
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                imagePath,
                width: size * 0.88,
                height: size * 2.05, // taller than circle → pops out at top
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_rounded,
                  size: size * 0.4,
                  color: accentColor.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Main Categories Page ───────────────────────────────────────────────────
class Categories_page extends StatefulWidget {
  static const String routeName = "cat";
  const Categories_page({super.key});

  @override
  State<Categories_page> createState() => _Categories_pageState();
}

class _Categories_pageState extends State<Categories_page>
    with SingleTickerProviderStateMixin {
  final GameManager _gameManager = GameManager();
  late PageController _pageController;
  late AnimationController _pulseController;
  int _currentPage = 0;
  bool _isAnimating = false;
  double _wheelRotation = 0.0;
  int _keyCounter = 0;

  Map<String, List<dynamic>> categories = {
    "أكلات": CategoryItems.aklat,
    "أنشطة / شغل": CategoryItems.activities,
    "أماكن": CategoryItems.places,
    "منستغناش": CategoryItems.stuff,
    "أفلام": CategoryItems.movies,
    "مشاهير": CategoryItems.celebrities,
  };

  // Image paths per category (same order as categories map)
  final List<String> categoryImages = [
    CategoryImages.food,
    CategoryImages.worker,
    CategoryImages.place,
    CategoryImages.manstahnash,
    CategoryImages.film,
    CategoryImages.celebrities,
  ];

  // Pharaonic-inspired category colors
  final categoryColors = [
    PharaohColors.gold,
    PharaohColors.turquoise,
    PharaohColors.puprble,
    PharaohColors.lightGold,
    PharaohColors.deepRed,
    PharaohColors.scarabGreen,
    PharaohColors.lightGold,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 500000,
      viewportFraction: 1.0,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pageController.addListener(() {
      if (_pageController.hasClients &&
          _pageController.position.haveDimensions) {
        setState(() {
          final page = _pageController.page ?? 0;
          final newPage = page.round() % categories.length;
          if (newPage != _currentPage) {
            _currentPage = newPage;
            _keyCounter++;
          }
          _wheelRotation = -(page) * (2 * pi / categories.length);
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
    List<dynamic> list = categories[categoryName]!;
    return list[random.nextInt(list.length)];
  }

  void _onCategorySelected(int index) {
    if (_isAnimating) return;
    setState(() => _isAnimating = true);

    List<String> categoryNames = categories.keys.toList();
    String selectedCategory = categoryNames[index];
    String correctAnswer = getRandomWord(selectedCategory);

    _gameManager.currentCategory = selectedCategory;
    _gameManager.correctAnswer = correctAnswer;
    CategoryItems.randomChoice = correctAnswer;

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterRevealScreen(
            selectedIndices: _gameManager.selectedCharacters,
            imposterCount: _gameManager.imposterCount,
            onBack: () => Navigator.pop(context),
          ),
        ),
      ).then((_) {
        if (mounted) setState(() => _isAnimating = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 680;
    final isTall = size.height > 900;
    List<String> categoryNames = categories.keys.toList();

    final headerFontSize = isSmall ? 20.0 : (isTall ? 30.0 : 24.0);
    final iconContainerSize = isSmall ? 120.0 : (isTall ? 170.0 : 140.0);
    final wheelHeight = isSmall ? 170.0 : (isTall ? 240.0 : 200.0);

    return WillPopScope(
      onWillPop: ()async{
          Navigator.pushNamed(context, CategoryCharacters.routeName);
          return false;
              },
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: ChineseBackground()),

            SafeArea(
              child: Column(
                children: [
                  // ── Top Ornament ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: List.generate(
                            5,
                                (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(
                                Icons.star,
                                size: 15,
                                color: PharaohColors.gold.withOpacity(0.5 + i * 0.08),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, FinalResultScreen.routeName);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PharaohColors.gold.withOpacity(0.12),
                              border: Border.all(
                                color: PharaohColors.gold.withOpacity(0.8),
                                width: 1.5,
                              ),

                            ),
                            child: Icon(
                              Icons.sports_score,
                              size: 30,
                              color: PharaohColors.gold.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose a category for",
                          style: TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.w700,
                            color: PharaohColors.ivory,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: PharaohColors.gold.withOpacity(0.4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: headerFontSize,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                            children: [
                              const TextSpan(
                                text: "today's ",
                                style: TextStyle(color: PharaohColors.ivory),
                              ),
                              TextSpan(
                                text: "game",
                                style: TextStyle(
                                  color: categoryColors[_currentPage],
                                  shadows: [
                                    Shadow(
                                      color: categoryColors[_currentPage].withOpacity(0.5),
                                      blurRadius: 12,
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

                  SizedBox(height: isSmall ? 8 : 14),

                  // ── Main Glass Image Display ──
                  SizedBox(
                    height: iconContainerSize + 60,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.elasticOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation.drive(Tween<double>(begin: 0.82, end: 1.0)),
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: GlassImageCircle(
                        key: ValueKey('glass_img_${_currentPage}_$_keyCounter'),
                        imagePath: categoryImages[_currentPage],
                        accentColor: categoryColors[_currentPage],
                        size: iconContainerSize,
                        pulseAnimation: _pulseController,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmall ? 4 : 8),

                  // ── Category Name (Cartouche style) ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          "Select category",
                          style: TextStyle(
                            fontSize: 12,
                            color: PharaohColors.gold.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: CartoucheBox(
                            key: ValueKey('cat_${_currentPage}_$_keyCounter'),
                            borderColor: categoryColors[_currentPage],
                            bgColor: categoryColors[_currentPage].withOpacity(0.12),
                            child: Text(
                              categoryNames[_currentPage],
                              style: TextStyle(
                                fontSize: isSmall ? 18 : 22,
                                fontWeight: FontWeight.w700,
                                color: categoryColors[_currentPage],
                                shadows: [
                                  Shadow(
                                    color: categoryColors[_currentPage].withOpacity(0.3),
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

                  SizedBox(height: isSmall ? 10 : 16),

                  // ── Confirm Button ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: PharaohButton(
                      color: categoryColors[_currentPage],
                      onPressed: _isAnimating ? null : () => _onCategorySelected(_currentPage),
                      isSmall: isSmall,
                    ),
                  ),

                  const Spacer(),

                  // ── Wheel ──
                  SizedBox(
                    height: wheelHeight + 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onPanUpdate: (details) {
                            if (_pageController.hasClients &&
                                _pageController.position.haveDimensions) {
                              const sensitivity = 3.0;
                              final newOffset = _pageController.offset -
                                  (details.delta.dx * sensitivity);
                              if (newOffset >= 0 &&
                                  newOffset <=
                                      _pageController.position.maxScrollExtent) {
                                _pageController.jumpTo(newOffset);
                              }
                            }
                          },
                          onPanEnd: (details) {
                            if (_pageController.hasClients &&
                                _pageController.position.haveDimensions) {
                              final velocity = details.velocity.pixelsPerSecond.dx;
                              if (velocity.abs() > 500) {
                                final page = _pageController.page?.round() ?? 0;
                                final targetPage = velocity > 0 ? page - 1 : page + 1;
                                _pageController.animateToPage(
                                  targetPage,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              } else {
                                _pageController.animateToPage(
                                  _currentPage,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                );
                              }
                            }
                          },
                          child: Container(
                            height: wheelHeight + 40,
                            color: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // ── Wheel with images ──
                                SizedBox(
                                  width: size.width,
                                  height: wheelHeight + 40,
                                  child: _WheelWithImages(
                                    rotation: _wheelRotation,
                                    categories: categoryNames,
                                    imagePaths: categoryImages,
                                    colors: categoryColors,
                                    currentIndex: _currentPage,
                                    wheelHeight: wheelHeight,
                                    screenWidth: size.width,
                                  ),
                                ),

                                // Indicator triangle
                                Positioned(
                                  top: wheelHeight * 0.08,                                  child: Column(
                                    children: [
                                      Container(
                                        width: 0,
                                        height: 0,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: const BorderSide(
                                                width: 12, color: Colors.transparent),
                                            right: const BorderSide(
                                                width: 12, color: Colors.transparent),
                                            bottom: BorderSide(
                                              width: 20,
                                              color: categoryColors[_currentPage],
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: categoryColors[_currentPage]
                                                  .withOpacity(0.7),
                                              blurRadius: 16,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 4,
                                        height: 8,
                                        color: categoryColors[_currentPage],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 1,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: 1000000,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index % categories.length;
                              });
                            },
                            itemBuilder: (context, index) => const SizedBox.shrink(),
                          ),
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
    );
  }
}

// ─── Wheel With Images Widget ───────────────────────────────────────────────
/// Wraps AdvancedWheelPainter + overlays Image widgets at each segment position.
class _WheelWithImages extends StatelessWidget {
  final double rotation;
  final List<String> categories;
  final List<String> imagePaths;
  final List<Color> colors;
  final int currentIndex;
  final double wheelHeight;
  final double screenWidth;

  const _WheelWithImages({
    required this.rotation,
    required this.categories,
    required this.imagePaths,
    required this.colors,
    required this.currentIndex,
    required this.wheelHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final center = Offset(screenWidth / 2, wheelHeight + 40);
    final radius = screenWidth * 0.55;
    final segmentAngle = 2 * pi / categories.length;

    return Stack(
      children: [
        // Base wheel (no icons)
        CustomPaint(
          size: Size(screenWidth, wheelHeight + 40),
          painter: AdvancedWheelPainter(
            rotation: rotation,
            categories: categories,
            colors: colors,
            currentIndex: currentIndex,
          ),
        ),

        // Image overlays at each segment
        ...List.generate(categories.length, (i) {
          final iconAngle = rotation + (i * segmentAngle) - pi / 2;
          final iconRadius = radius * 0.67;
          final iconX = center.dx + cos(iconAngle) * iconRadius;
          final iconY = center.dy + sin(iconAngle) * iconRadius;
          final isSelected = i == currentIndex;
          final circleSize = isSelected ? 52.0 : 44.0;
          final imageSize = isSelected ? 46.0 : 38.0;

          return Positioned(
            left: iconX - circleSize / 2,
            top: iconY - circleSize / 2,
            child: _WheelImageBubble(
              imagePath: imagePaths[i % imagePaths.length],
              accentColor: colors[i % colors.length],
              circleSize: circleSize,
              imageSize: imageSize,
              isSelected: isSelected,
            ),
          );
        }),
      ],
    );
  }
}

// ─── Wheel Image Bubble ──────────────────────────────────────────────────────
class _WheelImageBubble extends StatelessWidget {
  final String imagePath;
  final Color accentColor;
  final double circleSize;
  final double imageSize;
  final bool isSelected;

  const _WheelImageBubble({
    required this.imagePath,
    required this.accentColor,
    required this.circleSize,
    required this.imageSize,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize,
      height: circleSize + (isSelected ? 12 : 8), // extra height for pop-out
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Glass circle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withOpacity(0.40),
                        PharaohColors.darkLapis.withOpacity(0.55),
                      ],
                    ),
                    border: Border.all(
                      color: PharaohColors.gold.withOpacity(isSelected ? 0.85 : 0.5),
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: accentColor.withOpacity(0.55),
                        blurRadius: 18,
                        spreadRadius: 2,
                      )
                    ]
                        : [],
                  ),
                ),
              ),
            ),
          ),

          // Top specular glass highlight
          Positioned(
            bottom: circleSize * 0.5,
            left: circleSize * 0.18,
            right: circleSize * 0.18,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Image — pops slightly above circle
          Positioned(
            bottom: circleSize * 0.04,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize + (isSelected ? 10 : 6), // overflows upward
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_rounded,
                  size: imageSize * 0.6,
                  color: accentColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Advanced Wheel Painter (no icons — images handled by overlay) ──────────
class AdvancedWheelPainter extends CustomPainter {
  final double rotation;
  final List<String> categories;
  final List<Color> colors;
  final int currentIndex;

  AdvancedWheelPainter({
    required this.rotation,
    required this.categories,
    required this.colors,
    required this.currentIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.55;
    final segmentAngle = 2 * pi / categories.length;

    // Outer glow ring
    canvas.drawCircle(
      center, radius + 12,
      Paint()
        ..color = PharaohColors.gold.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(
      center, radius + 6,
      Paint()
        ..color = PharaohColors.gold.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Segment outer glow
    for (int i = 0; i < categories.length; i++) {
      final startAngle = rotation + (i * segmentAngle) - (segmentAngle / 2) - pi / 2;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius + 8),
          startAngle, segmentAngle, false,
        )
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..color = colors[i % colors.length].withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    // Draw segments
    for (int i = 0; i < categories.length; i++) {
      final startAngle = rotation + (i * segmentAngle) - (segmentAngle / 2) - pi / 2;
      final isSelected = i == currentIndex;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle, segmentAngle, false,
        )
        ..close();

      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawPath(
        path,
        Paint()
          ..shader = RadialGradient(
            colors: [
              PharaohColors.midLapis,
              colors[i % colors.length].withOpacity(isSelected ? 0.8 : 0.5),
            ],
            stops: const [0.3, 1.0],
          ).createShader(rect)
          ..style = PaintingStyle.fill,
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = PharaohColors.gold.withOpacity(isSelected ? 0.9 : 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 3 : 1.5,
      );

      // Category text label (inner ring)
      final iconAngle = startAngle + (segmentAngle / 2);
      final textRadius = radius * 0.35;
      final textX = center.dx + cos(iconAngle) * textRadius;
      final textY = center.dy + sin(iconAngle) * textRadius;

      final textPainter = TextPainter(
        text: TextSpan(
          text: categories[i],
          style: TextStyle(
            fontSize: isSelected ? 11 : 9,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: PharaohColors.lightGold,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 6),
            ],
          ),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      );
      textPainter.layout(maxWidth: 70);

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(iconAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Center hub — pharaonic sun disc
    canvas.drawCircle(
      center, 52,
      Paint()
        ..color = colors[currentIndex % colors.length].withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
    canvas.drawCircle(
      center, 44,
      Paint()
        ..shader = RadialGradient(
          colors: [PharaohColors.midLapis, PharaohColors.darkLapis],
        ).createShader(Rect.fromCircle(center: center, radius: 44)),
    );
    canvas.drawCircle(
      center, 44,
      Paint()
        ..color = PharaohColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      center, 38,
      Paint()
        ..color = PharaohColors.gold.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    for (int r = 0; r < 8; r++) {
      final angle = r * pi / 4;
      canvas.drawLine(
        Offset(center.dx + cos(angle) * 20, center.dy + sin(angle) * 20),
        Offset(center.dx + cos(angle) * 34, center.dy + sin(angle) * 34),
        Paint()
          ..color = PharaohColors.gold.withOpacity(0.5)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.drawCircle(
      center, 8,
      Paint()
        ..color = colors[currentIndex % colors.length]
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(AdvancedWheelPainter old) =>
      old.rotation != rotation || old.currentIndex != currentIndex;
}

// ─── Pharaoh Button ──────────────────────────────────────────────────────────
class PharaohButton extends StatefulWidget {
  final Color color;
  final VoidCallback? onPressed;
  final bool isSmall;
  final String label;

  const PharaohButton({
    super.key,
    required this.color,
    required this.onPressed,
    this.isSmall = false,
    this.label = "let's get started",
  });

  @override
  State<PharaohButton> createState() => _PharaohButtonState();
}

class _PharaohButtonState extends State<PharaohButton>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowAnim;
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();
    _shimmerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear),
    );
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.35, end: 0.9).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _glowCtrl.dispose();
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _pressCtrl.forward();
  void _onTapUp(TapUpDetails _) => _pressCtrl.reverse();
  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final double height = widget.isSmall ? 52 : 64;
    final double fontSize = widget.isSmall ? 15 : 17;
    final Color c = widget.color;

    return AnimatedBuilder(
      animation: Listenable.merge([_shimmerAnim, _glowAnim, _scaleAnim]),
      builder: (context, _) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: c.withOpacity(_glowAnim.value * 0.6), blurRadius: 36, spreadRadius: 3),
                BoxShadow(color: c.withOpacity(0.45), blurRadius: 10, spreadRadius: 0, offset: const Offset(0, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: CustomPaint(
                  painter: _PharaohGlassBorderPainter(
                    color: c,
                    shimmerProgress: _shimmerAnim.value,
                    glowOpacity: _glowAnim.value,
                  ),
                  child: GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,
                    child: InkWell(
                      onTap: widget.onPressed,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: c.withOpacity(0.2),
                      highlightColor: c.withOpacity(0.08),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.13),
                              c.withOpacity(0.08),
                              c.withOpacity(0.18),
                              Colors.white.withOpacity(0.04),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 0.35, 0.7, 1.0],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomPaint(
                                  painter: _ShimmerPainter(color: c, progress: _shimmerAnim.value),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0, left: 16, right: 16,
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.6),
                                      Colors.white.withOpacity(0.8),
                                      Colors.white.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _GlyphMark(color: c, size: widget.isSmall ? 14 : 16),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.label,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0,
                                      shadows: [
                                        Shadow(color: c.withOpacity(0.9), blurRadius: 14),
                                        Shadow(color: c.withOpacity(0.5), blurRadius: 30),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: c.withOpacity(0.5), width: 1),
                                      color: c.withOpacity(0.15),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      size: widget.isSmall ? 14 : 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlyphMark extends StatelessWidget {
  final Color color;
  final double size;
  const _GlyphMark({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.6, size),
      painter: _GlyphPainter(color: color),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  final Color color;
  const _GlyphPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color.withOpacity(0.9)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), p);
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), p);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6), p);
    canvas.drawCircle(Offset(cx, size.height * 0.85), 1.5, p..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_GlyphPainter old) => old.color != color;
}

class _ShimmerPainter extends CustomPainter {
  final Color color;
  final double progress;
  const _ShimmerPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double bandWidth = size.width * 0.45;
    final double totalTravel = size.width + bandWidth;
    final double centerX = -bandWidth / 2 + progress * totalTravel;
    final Rect bandRect = Rect.fromLTWH(centerX - bandWidth / 2, 0, bandWidth, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.04),
          Colors.white.withOpacity(0.20),
          Colors.white.withOpacity(0.28),
          Colors.white.withOpacity(0.20),
          Colors.white.withOpacity(0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.15, 0.35, 0.5, 0.65, 0.85, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bandRect);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.skew(-0.22, 0);
    canvas.drawRect(bandRect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.progress != progress || old.color != color;
}

class _PharaohGlassBorderPainter extends CustomPainter {
  final Color color;
  final double shimmerProgress;
  final double glowOpacity;
  const _PharaohGlassBorderPainter({required this.color, required this.shimmerProgress, required this.glowOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(8)),
      Paint()..color = Colors.white.withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 1.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(1.5, 1.5, w - 3, h - 3), const Radius.circular(7)),
      Paint()..color = color.withOpacity(0.25)..style = PaintingStyle.stroke..strokeWidth = 1.0,
    );

    final cornerPaint = Paint()
      ..color = color.withOpacity(0.9 + glowOpacity * 0.1)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final cornerGlowPaint = Paint()
      ..color = color.withOpacity(glowOpacity * 0.4)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    const cs = 16.0;
    const gap = 4.0;
    final corners = [
      [[Offset(gap, cs + gap), Offset(gap, gap)], [Offset(gap, gap), Offset(cs + gap, gap)]],
      [[Offset(w - cs - gap, gap), Offset(w - gap, gap)], [Offset(w - gap, gap), Offset(w - gap, cs + gap)]],
      [[Offset(gap, h - cs - gap), Offset(gap, h - gap)], [Offset(gap, h - gap), Offset(cs + gap, h - gap)]],
      [[Offset(w - cs - gap, h - gap), Offset(w - gap, h - gap)], [Offset(w - gap, h - cs - gap), Offset(w - gap, h - gap)]],
    ];
    for (final corner in corners) {
      for (final line in corner) {
        canvas.drawLine(line[0] as Offset, line[1] as Offset, cornerGlowPaint);
        canvas.drawLine(line[0] as Offset, line[1] as Offset, cornerPaint);
      }
    }

    final dotPaint = Paint()..color = color.withOpacity(glowOpacity)..style = PaintingStyle.fill;
    for (final pos in [Offset(gap, gap), Offset(w - gap, gap), Offset(gap, h - gap), Offset(w - gap, h - gap)]) {
      canvas.drawCircle(pos, 4, Paint()..color = color.withOpacity(glowOpacity * 0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(pos, 2.5, dotPaint);
    }

    final tickPaint = Paint()..color = color.withOpacity(0.45)..strokeWidth = 1.2..strokeCap = StrokeCap.round;
    const tickLen = 5.0;
    const tickH = 3.0;
    _drawTickGroup(canvas, Offset(w / 2, 0), tickPaint, tickLen, tickH, true);
    _drawTickGroup(canvas, Offset(w / 2, h), tickPaint, tickLen, tickH, true);
    _drawTickGroup(canvas, Offset(0, h / 2), tickPaint, tickLen, tickH, false);
    _drawTickGroup(canvas, Offset(w, h / 2), tickPaint, tickLen, tickH, false);
  }

  void _drawTickGroup(Canvas canvas, Offset center, Paint paint, double len, double spacing, bool horizontal) {
    for (int i = -1; i <= 1; i++) {
      if (horizontal) {
        final x = center.dx + i * spacing * 2.5;
        canvas.drawLine(Offset(x, center.dy - len / 2), Offset(x, center.dy + len / 2), paint);
      } else {
        final y = center.dy + i * spacing * 2.5;
        canvas.drawLine(Offset(center.dx - len / 2, y), Offset(center.dx + len / 2, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PharaohGlassBorderPainter old) =>
      old.color != color || old.shimmerProgress != shimmerProgress || old.glowOpacity != glowOpacity;
}