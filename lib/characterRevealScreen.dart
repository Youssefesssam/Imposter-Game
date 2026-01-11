import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imposter/Categories_page.dart';
import 'package:imposter/categoryCharacters.dart';
import 'package:imposter/categoryItems.dart';
import 'package:imposter/findImposter.dart';
import 'package:imposter/utilites.dart';

import 'imposterResultScreen.dart';


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
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  double dragOffset = 0;
  bool isRevealed = false;
  late List<int> imposterIndices; // ✅ تغيير: قائمة بدل رقم واحد
  late List<int> shuffledIndices;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    shuffledIndices = List.from(widget.selectedIndices)..shuffle();

    // ✅ اختيار عدد من الـ imposters عشوائياً
    imposterIndices = _selectRandomImposters();

    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  // ✅ دالة جديدة لاختيار الـ imposters
  List<int> _selectRandomImposters() {
    List<int> allIndices = List.generate(shuffledIndices.length, (i) => i);
    allIndices.shuffle();
    return allIndices.take(widget.imposterCount).toList();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void nextCharacter() {
    if (currentIndex < shuffledIndices.length - 1) {
      setState(() {
        currentIndex++;
        dragOffset = 0;
        isRevealed = false;
      });
    } else {
      // ✅ جمع بيانات كل الـ imposters
      List<Map<String, dynamic>> impostersData = imposterIndices.map((index) {
        int characterIndex = shuffledIndices[index];
        return {
          'name': namesCharacters[characterIndex + 1],
          'image': arrCharacters[characterIndex + 1],
        };
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FindImposter(
            selectedIndices: shuffledIndices,
            impostersData: impostersData, // ✅ إرسال كل الـ imposters
            onContinue: () {
              Navigator.pushNamed(context, Categories_page.routeName);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int characterIndex = shuffledIndices[currentIndex];
    bool isImposter = imposterIndices.contains(currentIndex); // ✅ تحقق من القائمة
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
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
                      if (dragOffset > 0) {
                        dragOffset = 0;
                      }
                      if (dragOffset < maxRevealOffset) {
                        dragOffset = maxRevealOffset;
                      }
                      if (dragOffset <= maxRevealOffset) {
                        isRevealed = true;
                      }
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
                          isRevealed = false;
                        });
                        _bounceController.reset();
                      });
                    }
                  },
                  child: Container(
                    height: screenHeight,
                    child: Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height / 2,
                          left: 220,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: nextCharacter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0x8307ef4e),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 7),
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
                        Positioned.fill(
                          child: Image(
                            image: arrCharacters[characterIndex + 1],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 2,
                          left: 220,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: nextCharacter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0x8307ef4e),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 7),
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
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  namesCharacters[characterIndex + 1],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '⬆️ Swip Up',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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