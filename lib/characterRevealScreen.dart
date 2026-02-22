import 'package:flutter/material.dart';
import 'package:imposter/categoryCharacters.dart';
import 'package:imposter/categoryItems.dart';
import 'package:imposter/utilites.dart';
import 'gameManager.dart';
import 'guessImposterScreen.dart';

class CharacterRevealScreen extends StatefulWidget {
  final List<int> selectedIndices;
  final VoidCallback onBack;
  final int imposterCount;

  const CharacterRevealScreen({
    required this.selectedIndices,
    required this.imposterCount,
    required this.onBack,
    super.key,
  });

  @override
  State<CharacterRevealScreen> createState() => _CharacterRevealScreenState();
}

class _CharacterRevealScreenState extends State<CharacterRevealScreen>
    with TickerProviderStateMixin {
  final GameManager _gameManager = GameManager();
  int currentIndex = 0;
  double dragOffset = 0;
  bool isRevealed = false;
  late List<int> imposterIndices;
  late List<int> shuffledIndices;
  late AnimationController _bounceController;
  late AnimationController _swipeAnimController;
  late Animation<double> _swipeFadeAnimation;
  late Animation<Offset> _swipeSlideAnimation;

  @override
  void initState() {
    super.initState();

    shuffledIndices = List.from(widget.selectedIndices)..shuffle();
    _selectAndSaveImposters();

    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _swipeAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _swipeFadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _swipeAnimController, curve: Curves.easeInOut),
    );

    _swipeSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.4),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _swipeAnimController, curve: Curves.easeInOut),
    );
  }

  void _selectAndSaveImposters() {
    List<int> randomPositions = List.generate(shuffledIndices.length, (i) => i);
    randomPositions.shuffle();
    imposterIndices = randomPositions.take(widget.imposterCount).toList();

    _gameManager.currentImposters = imposterIndices.map((position) {
      int characterIndex = shuffledIndices[position];
      return widget.selectedIndices.indexOf(characterIndex);
    }).toList();

    print('🎮 Selected Imposters:');
    for (int i = 0; i < imposterIndices.length; i++) {
      int displayPosition = imposterIndices[i];
      int characterIndex = shuffledIndices[displayPosition];
      int originalPosition = widget.selectedIndices.indexOf(characterIndex);
      print('   Position $displayPosition: ${namesCharacters[characterIndex + 1]} (Original: $originalPosition)');
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _swipeAnimController.dispose();
    super.dispose();
  }

  bool _isNavigating = false;

  void nextCharacter() {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;  // ← setState عشان الزرار يتعطل فوراً في الـ UI
    });

    if (currentIndex < shuffledIndices.length - 1) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          currentIndex++;
          dragOffset = 0;
          isRevealed = false;
          _isNavigating = false;
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuessImposterScreen()),
      ).then((_) => setState(() => _isNavigating = false));
    }
  }  @override
  Widget build(BuildContext context) {
    int characterIndex = shuffledIndices[currentIndex];
    bool isImposter = imposterIndices.contains(currentIndex);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ── الخلفية مع الدور ──
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: isImposter
                        ? Image(image: AssetImage(AppAssets.spy))
                        : Image(
                      image: AssetImage(AppAssets.huddle),
                      height: 160,
                      width: 160,
                    ),
                  ),
                  Text(
                    isImposter ? 'IMPOSTER' : CategoryItems.randomChoice,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isImposter ? Color(0xfffd0001) : Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── الشاشة القابلة للسحب ──
          AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              double bounceValue = _bounceController.value;
              double finalOffset = dragOffset + (bounceValue * (0 - dragOffset));
              final double maxRevealOffset = -screenHeight * 0.30;

              return Transform.translate(
                offset: Offset(0, finalOffset),
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      dragOffset += details.delta.dy;
                      if (dragOffset > 0) dragOffset = 0;
                      if (dragOffset < maxRevealOffset) dragOffset = maxRevealOffset;
                      if (dragOffset <= maxRevealOffset) isRevealed = true;
                    });
                  },
                  onVerticalDragEnd: (details) {
                    if (dragOffset < -screenHeight * 0.3) {
                      setState(() {
                        dragOffset = -screenHeight;
                        isRevealed = true;
                      });
                    } else {
                      _bounceController.forward(from: 0).then((_) {
                        setState(() {
                          dragOffset = 0;
                          // ✅ مش بنغير isRevealed هنا خالص
                          // لو اترفعت قبل كده تفضل ظاهرة
                        });
                        _bounceController.reset();
                      });
                    }
                  },                  child: SizedBox(
                    height: screenHeight,
                    child: Stack(
                      children: [
                        // ── صورة الشخصية ──
                        Positioned.fill(
                          child: Image(
                            image: arrCharacters[characterIndex + 1],
                            fit: BoxFit.cover,
                          ),
                        ),

                        // ── gradient سفلي + اسم الشخصية ──
                        Positioned(
                          bottom: 50,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(16, 40, 16, 100),

                            child: Text(
                              namesCharacters[characterIndex + 1],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // ── Swipe Up indicator متحرك ──
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: AnimatedOpacity(
                            opacity: isRevealed ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: SlideTransition(
                              position: _swipeSlideAnimation,
                              child: FadeTransition(
                                opacity: _swipeFadeAnimation,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.keyboard_double_arrow_up_rounded,
                                      color: Colors.white,
                                      size: 52,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Swipe Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── زرار Next/End يظهر بس بعد الرفع ──
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: AnimatedOpacity(
                            opacity: isRevealed ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 300),
                            child: IgnorePointer(
                              ignoring: !isRevealed,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: _isNavigating ? null : nextCharacter,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0x8307ef4e),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    currentIndex < shuffledIndices.length - 1
                                        ? 'Next'
                                        : 'End',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}