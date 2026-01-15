import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imposter/Categories_page.dart';
import 'package:imposter/categoryItems.dart';
import 'gameManager.dart';
import 'categoryCharacters.dart';
import 'finalResultScreen.dart';

class MCQScreen extends StatefulWidget {
  static const String routeName = 'MCQScreen';
  const MCQScreen({super.key});

  @override
  State<MCQScreen> createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> with TickerProviderStateMixin {
  final GameManager _gameManager = GameManager();
  int currentImposterIndex = 0;
  List<String> options = [];
  String? selectedAnswer;
  bool hasAnswered = false;
  Timer? _timer;

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<Color> _optionAccents = [
    const Color(0xFFB20C6C),
    const Color(0xFF6418A6),
    const Color(0xFF114B8D),
    const Color(0xFF11628D),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _generateOptions();
    _animateIn();
  }

  void _animateIn() {
    _fadeController.forward(from: 0);
    _slideController.forward(from: 0);
  }

  void _generateOptions() {
    Map<String, List<String>> categories = {
      "أكلات": CategoryItems.aklat,
      "أنشطة / شغل": CategoryItems.activities,
      "أماكن": CategoryItems.places,
      "منستغناش": CategoryItems.stuff,
      "أفلام": CategoryItems.movies,
      "مشاهير": CategoryItems.celebrities,
    };

    List<String> categoryItems = categories[_gameManager.currentCategory] ?? [];
    List<String> wrongAnswers = List.from(categoryItems);
    wrongAnswers.remove(_gameManager.correctAnswer);
    wrongAnswers.shuffle();
    wrongAnswers = wrongAnswers.take(3).toList();
    options = [...wrongAnswers, _gameManager.correctAnswer];
    options.shuffle();
  }

  void _submitAnswer() {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('اختار إجابة أول!', textAlign: TextAlign.center),
          backgroundColor: const Color(0xFFFF0022),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        ),
      );
      return;
    }

    setState(() => hasAnswered = true);

    int imposterPlayerIndex = _gameManager.currentImposters[currentImposterIndex];
    if (selectedAnswer == _gameManager.correctAnswer) {
      _gameManager.addPoints(imposterPlayerIndex, 1);
    }

    _showFeedbackDialog();
  }

  void _showFeedbackDialog() {
    bool isCorrect = selectedAnswer == _gameManager.correctAnswer;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (ctx, anim, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, _, __) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D14),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isCorrect ? const Color(0xFF00FF88) : const Color(0xFFFF0022),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isCorrect
                    ? const Color(0xFF00FF88).withOpacity(0.25)
                    : const Color(0xFFFF0022).withOpacity(0.25),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Big icon with glow
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isCorrect
                      ? const Color(0xFF00FF88)
                      : const Color(0xFFFF0022))
                      .withOpacity(0.12),
                  border: Border.all(
                    color: isCorrect ? const Color(0xFF00FF88) : const Color(0xFFFF0022),
                    width: 2,
                  ),
                ),
                child: Icon(
                  isCorrect ? Icons.check_rounded : Icons.close_rounded,
                  size: 50,
                  color: isCorrect ? const Color(0xFF00FF88) : const Color(0xFFFF0022),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isCorrect ? '🎉 صح!' : '❌ غلط!',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: isCorrect ? const Color(0xFF00FF88) : const Color(0xFFFF0022),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text(
                      'الإجابة الصحيحة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _gameManager.correctAnswer,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _nextImposter();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isCorrect ? const Color(0xFF00FF88) : const Color(0xFFFF0022),
                    foregroundColor: const Color(0xFF0D0D14),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'التالي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextImposter() {
    if (currentImposterIndex < _gameManager.currentImposters.length - 1) {
      setState(() {
        currentImposterIndex++;
        selectedAnswer = null;
        hasAnswered = false;
      });
      _generateOptions();
      _animateIn();
    } else {
      Navigator.pushReplacementNamed(context, FinalResultScreen.routeName);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int imposterPlayerIndex = _gameManager.currentImposters[currentImposterIndex];
    int characterIndex = _gameManager.selectedCharacters[imposterPlayerIndex];

    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6C092A),
                    Color(0xFF960D3B),
                    Color(0xFF6C092A),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'تأكيد الخروج',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'هل أنت متأكد أنك تريد العودة؟\nسيتم فقدان التقدم الحالي.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.white38),
                            ),
                          ),
                          child: Text(
                            'لا',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            Navigator.pushNamed(context, Categories_page.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'نعم',
                            style: TextStyle(
                              color: Color(0xFF960D3B),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        return shouldLeave ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF07070F),
        body: Stack(
          children: [
            // ── Background: glowing orbs ──
            Positioned(
              top: -80,
              right: -80,
              child: _GlowOrb(color: const Color(0xFFFF0022), size: 280),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: _GlowOrb(color: const Color(0xFF3A0070), size: 240),
            ),

            // ── Main content ──
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    // ── Top bar ──
                    _buildHeader(characterIndex),

                    // ── Progress dots ──
                    _buildProgressIndicator(),

                    const SizedBox(height: 20),

                    // ── Question card ──
                    SlideTransition(
                      position: _slideAnim,
                      child: _buildQuestionCard(),
                    ),

                    const SizedBox(height: 24),

                    // ── Options ──
                    Expanded(
                      child: SlideTransition(
                        position: _slideAnim,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                          itemCount: options.length,
                          itemBuilder: (context, index) =>
                              _buildOption(index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Floating Done button ──
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: _buildDoneButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // HEADER
  // ───────────────────────────────────────────────
  Widget _buildHeader(int characterIndex) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          // Avatar with animated ring
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) => Transform.scale(
              scale: _pulseAnim.value,
              child: child,
            ),
            child: Container(
              width: 62,
              height: 62,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(colors: [
                  Color(0xFFFF0022),
                  Color(0xFFFF6B00),
                  Color(0xFFFF0022),
                ]),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0022).withOpacity(0.5),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image(
                  image: arrCharacters[characterIndex + 1],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namesCharacters[characterIndex + 1],
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0022).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: const Color(0xFFFF0022).withOpacity(0.4)),
                      ),
                      child: const Text(
                        '🕵️ IMPOSTER',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF0022),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Counter badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              '${currentImposterIndex + 1} / ${_gameManager.currentImposters.length}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // PROGRESS DOTS
  // ───────────────────────────────────────────────
  Widget _buildProgressIndicator() {
    int total = _gameManager.currentImposters.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(total, (i) {
          bool active = i == currentImposterIndex;
          bool done = i < currentImposterIndex;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: done
                    ? const Color(0xFF00FF88)
                    : active
                    ? const Color(0xFFFF0022)
                    : Colors.white12,
                boxShadow: active
                    ? [
                  BoxShadow(
                    color: const Color(0xFFFF0022).withOpacity(0.6),
                    blurRadius: 8,
                  )
                ]
                    : [],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // QUESTION CARD
  // ───────────────────────────────────────────────
  Widget _buildQuestionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color(0xFF39FF14),
                Color(0xFF00C853),
              ]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF39FF14).withOpacity(0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Text(
              _gameManager.currentCategory,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D0D14),
              ),
            ),
          ),
          const Text(
            ' ؟!',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          Text(
            '..إيه اللي في الفئة',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // OPTION TILE
  // ───────────────────────────────────────────────
  Widget _buildOption(int index) {
    final String text = options[index];
    final bool isSelected = selectedAnswer == text;
    final bool showCorrect =
        hasAnswered && text == _gameManager.correctAnswer;
    final bool showWrong = hasAnswered && isSelected && !showCorrect;

    final Color accent = showCorrect
        ? const Color(0xFF00FF88)
        : showWrong
        ? const Color(0xFFFF0022)
        : isSelected
        ? _optionAccents[index % _optionAccents.length]
        : Colors.transparent;

    final String letter =
    ['أ', 'ب', 'ج', 'د'][index % 4]; // Arabic letters

    return GestureDetector(
      onTap: hasAnswered
          ? null
          : () => setState(() => selectedAnswer = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: showCorrect
              ? const Color(0xFF00FF88).withOpacity(0.08)
              : showWrong
              ? const Color(0xFFFF0022).withOpacity(0.08)
              : isSelected
              ? _optionAccents[index % _optionAccents.length]
              .withOpacity(0.10)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: accent == Colors.transparent
                ? Colors.white12
                : accent.withOpacity(0.6),
            width: (isSelected || showCorrect || showWrong) ? 1.5 : 1,
          ),
          boxShadow: (isSelected || showCorrect || showWrong) && accent != Colors.transparent
              ? [
            BoxShadow(
              color: accent.withOpacity(0.18),
              blurRadius: 18,
              spreadRadius: 1,
            )
          ]
              : [],
        ),
        child: Row(
          children: [
            // Letter badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent == Colors.transparent
                    ? Colors.white.withOpacity(0.08)
                    : accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: accent == Colors.transparent
                      ? Colors.white12
                      : accent.withOpacity(0.5),
                ),
              ),
              child: Center(
                child: showCorrect
                    ? const Icon(Icons.check_rounded,
                    color: Color(0xFF00FF88), size: 20)
                    : showWrong
                    ? const Icon(Icons.close_rounded,
                    color: Color(0xFFFF0022), size: 20)
                    : Text(
                  letter,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: accent == Colors.transparent
                        ? Colors.white38
                        : accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: isSelected || showCorrect
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: showCorrect
                      ? const Color(0xFF00FF88)
                      : showWrong
                      ? const Color(0xFFFF0022)
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // DONE BUTTON
  // ───────────────────────────────────────────────
  Widget _buildDoneButton() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: hasAnswered ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: hasAnswered ? null : _submitAnswer,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: hasAnswered
                ? null
                : const LinearGradient(colors: [
              Color(0xFF0FD076),
              Color(0xFF00C853),
            ]),
            color: hasAnswered ? Colors.white12 : null,
            borderRadius: BorderRadius.circular(18),
            boxShadow: hasAnswered
                ? []
                : [
              BoxShadow(
                color: const Color(0xFF119B5B).withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              hasAnswered ? 'تم ✓' : 'تأكيد الإجابة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: hasAnswered ? Colors.white38 : const Color(0xFF07070F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// HELPER WIDGET: Glow orb background accent
// ──────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.18), Colors.transparent],
        ),
      ),
    );
  }
}