import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imposter/Categories_page.dart';
import 'package:imposter/CategoryItems.dart';
import 'gameManager.dart';
import 'categoryCharacters.dart';
import 'mCQScreen.dart';

class GuessImposterScreen extends StatefulWidget {
  static const String routeName = 'GuessImposterScreen';
  const GuessImposterScreen({super.key});

  @override
  State createState() => _GuessImposterScreenState();
}

class _GuessImposterScreenState extends State<GuessImposterScreen> {
  final GameManager _gameManager = GameManager();
  int currentPlayerIndex = 0;
  Set<int> selectedImposters = {};
  int randomHighlight = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRandomizing();
  }

  void _startRandomizing() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (mounted) {
        setState(() {
          List<int> unselectedIndices = [];
          for (int i = 0; i < _gameManager.selectedCharacters.length; i++) {
            if (!selectedImposters.contains(i)) {
              unselectedIndices.add(i);
            }
          }
          if (unselectedIndices.isNotEmpty) {
            randomHighlight =
            unselectedIndices[Random().nextInt(unselectedIndices.length)];
          }
        });
      }
    });
  }

  void _submitAndNext() {
    if (selectedImposters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك اختر على الأقل شخصية واحدة'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    int correctGuesses = selectedImposters
        .where((i) => _gameManager.currentImposters.contains(i))
        .length;
    _gameManager.addPoints(currentPlayerIndex, correctGuesses);

    if (currentPlayerIndex < _gameManager.selectedCharacters.length - 1) {
      setState(() {
        currentPlayerIndex++;
        selectedImposters.clear();
        randomHighlight = 0;
      });
      _timer?.cancel();
      _startRandomizing();
    } else {
      _timer?.cancel();
      Navigator.pushReplacementNamed(context, MCQScreen.routeName);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Responsive helpers ──────────────────────────────────────────────────────
  double _sw(BuildContext ctx) => MediaQuery.of(ctx).size.width;
  double _sh(BuildContext ctx) => MediaQuery.of(ctx).size.height;

  /// Clamp a fraction of screen width between [min] and [max] px.
  double _w(BuildContext ctx, double fraction,
      {double min = 0, double max = double.infinity}) =>
      (_sw(ctx) * fraction).clamp(min, max);

  /// Clamp a fraction of screen height between [min] and [max] px.
  double _h(BuildContext ctx, double fraction,
      {double min = 0, double max = double.infinity}) =>
      (_sh(ctx) * fraction).clamp(min, max);

  /// Responsive font – scales between [minSize] and [maxSize].
  double _fs(BuildContext ctx, double fraction,
      {double min = 10, double max = 30}) =>
      (_sw(ctx) * fraction).clamp(min, max);
  // ────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    int playerCharacterIndex =
    _gameManager.selectedCharacters[currentPlayerIndex];

    final sw = _sw(context);
    final sh = _sh(context);

    // Grid columns: 2 on tiny screens, 3 on normal, 4 on tablets
    final int crossAxisCount = sw < 360 ? 2 : sw > 600 ? 4 : 3;

    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(_w(context, 0.06, min: 16, max: 32)),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
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
                    offset: const Offset(0, 10),
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
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.amber,
                      size: _w(context, 0.12, min: 36, max: 56)),
                  SizedBox(height: _h(context, 0.015, min: 8, max: 16)),
                  Text(
                    'تأكيد الخروج',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _fs(context, 0.055, min: 16, max: 26),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: _h(context, 0.012, min: 6, max: 14)),
                  Text(
                    'هل أنت متأكد أنك تريد العودة؟\nسيتم فقدان التقدم الحالي.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: _fs(context, 0.038, min: 12, max: 18),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: _h(context, 0.03, min: 16, max: 28)),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                _h(context, 0.015, min: 10, max: 14)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side:
                              const BorderSide(color: Colors.white38),
                            ),
                          ),
                          child: Text(
                            'لا',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                              _fs(context, 0.04, min: 14, max: 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: _w(context, 0.03, min: 8, max: 16)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            Navigator.pushNamed(
                                context, Categories_page.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical:
                                _h(context, 0.015, min: 10, max: 14)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'نعم',
                            style: TextStyle(
                              color: const Color(0xFF960D3B),
                              fontSize:
                              _fs(context, 0.04, min: 14, max: 18),
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
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const Positioned.fill(child: ChineseBackground()),
            SafeArea(
              child: Column(
                children: [
                  // ── Header ─────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _w(context, 0.04, min: 12, max: 24),
                      vertical: _h(context, 0.015, min: 8, max: 20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Player card image
                        Container(
                          width: _w(context, 0.22, min: 70, max: 120),
                          height: _h(context, 0.17, min: 100, max: 160),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff4CAF50),
                              width: _w(context, 0.007, min: 2, max: 4),
                            ),
                          ),
                          child: Image(
                            image:
                            arrCharacters[playerCharacterIndex + 1],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                            width: _w(context, 0.04, min: 10, max: 24)),
                        // Player info + counter
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                namesCharacters[
                                playerCharacterIndex + 1],
                                style: TextStyle(
                                  fontSize: _fs(context, 0.055,
                                      min: 14, max: 24),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                  height: _h(context, 0.004,
                                      min: 2, max: 6)),
                              Text(
                                'Score: ${_gameManager.getScore(currentPlayerIndex)}',
                                style: TextStyle(
                                  fontSize: _fs(context, 0.035,
                                      min: 11, max: 16),
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(
                                  height:
                                  _h(context, 0.01, min: 6, max: 14)),
                              // Imposter counter badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: _h(context, 0.012,
                                      min: 8, max: 14),
                                  horizontal: _w(context, 0.04,
                                      min: 12, max: 20),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      _w(context, 0.04,
                                          min: 10, max: 16)),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF6C092A),
                                      Color(0xFF960D3B),
                                      Color(0xFF6C092A),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.45),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Who chose ${_gameManager.currentImposters.length} Imposters?',
                                      style: TextStyle(
                                        fontSize: _fs(context, 0.038,
                                            min: 12, max: 20),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                        height: _h(context, 0.005,
                                            min: 3, max: 6)),
                                    Text(
                                      '(${selectedImposters.length}/${_gameManager.currentImposters.length} Selected)',
                                      style: TextStyle(
                                        fontSize: _fs(context, 0.03,
                                            min: 10, max: 15),
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
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

                  _divider(),

                  // ── Grid ───────────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          _w(context, 0.03, min: 8, max: 20)),
                      child: GridView.builder(
                        itemCount:
                        _gameManager.selectedCharacters.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing:
                          _w(context, 0.025, min: 6, max: 16),
                          mainAxisSpacing:
                          _w(context, 0.025, min: 6, max: 16),
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          int characterIndex =
                          _gameManager.selectedCharacters[index];
                          bool isHighlighted =
                              !selectedImposters.contains(index) &&
                                  randomHighlight == index;
                          bool isSelected =
                          selectedImposters.contains(index);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedImposters.contains(index)) {
                                  selectedImposters.remove(index);
                                } else {
                                  if (selectedImposters.length <
                                      _gameManager
                                          .currentImposters.length) {
                                    selectedImposters.add(index);
                                  }
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration:
                              const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    _w(context, 0.04,
                                        min: 10, max: 18)),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : isHighlighted
                                      ? Colors.amber
                                      : Colors.grey[300]!,
                                  width: (isHighlighted || isSelected)
                                      ? 3
                                      : 2,
                                ),
                                boxShadow: [
                                  if (isHighlighted || isSelected)
                                    BoxShadow(
                                      color: (isSelected
                                          ? Colors.blue
                                          : Colors.amber)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    )
                                  else
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    _w(context, 0.04,
                                        min: 10, max: 18)),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image(
                                      image: arrCharacters[
                                      characterIndex + 1],
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black
                                                .withOpacity(0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom:
                                      _h(context, 0.008, min: 4, max: 10),
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        namesCharacters[
                                        characterIndex + 1],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: _fs(context, 0.032,
                                              min: 10, max: 16),
                                          fontWeight: FontWeight.bold,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: _h(context, 0.008,
                                            min: 4, max: 10),
                                        right: _w(context, 0.015,
                                            min: 4, max: 10),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              _w(context, 0.012,
                                                  min: 4, max: 8)),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blue
                                                    .withOpacity(0.5),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: _w(context, 0.05,
                                                min: 14, max: 24),
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
                    ),
                  ),

                  _divider(),

                  // ── Bottom button ───────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                      _w(context, 0.05, min: 14, max: 28),
                      vertical: _h(context, 0.02, min: 10, max: 24),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: _h(context, 0.07, min: 44, max: 62),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: selectedImposters.length ==
                                _gameManager.currentImposters.length
                                ? const [
                              Color(0xff4CAF50),
                              Color(0xff45a049)
                            ]
                                : [
                              Colors.grey[400]!,
                              Colors.grey[500]!
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: (selectedImposters.length ==
                                  _gameManager
                                      .currentImposters.length
                                  ? Colors.green
                                  : Colors.grey)
                                  .withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: selectedImposters.length ==
                              _gameManager.currentImposters.length
                              ? _submitAndNext
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentPlayerIndex <
                                    _gameManager
                                        .selectedCharacters
                                        .length -
                                        1
                                    ? 'Next player'
                                    : 'Let imposters answer',
                                style: TextStyle(
                                  fontSize: _fs(context, 0.045,
                                      min: 14, max: 22),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                  width: _w(context, 0.025,
                                      min: 6, max: 12)),
                              Icon(
                                currentPlayerIndex <
                                    _gameManager
                                        .selectedCharacters
                                        .length -
                                        1
                                    ? Icons.arrow_forward
                                    : Icons.quiz,
                                color: Colors.white,
                                size: _w(context, 0.06, min: 18, max: 28),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _divider() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}