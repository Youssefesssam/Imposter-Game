import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:imposter/CategoryItems.dart';
import 'package:imposter/utilites.dart';

import 'Categories_page.dart';
import 'categoryCharacters.dart';
import 'characterRevealScreen.dart';
import 'imposterResultScreen.dart';

class FindImposter extends StatefulWidget {
  final List<int> selectedIndices;
  final List<Map<String, dynamic>> impostersData; // ✅ تغيير من imposter واحد لقائمة
  final VoidCallback onContinue;

  const FindImposter({
    required this.selectedIndices,
    required this.impostersData,
    required this.onContinue,
    super.key,
  });

  @override
  State<FindImposter> createState() => _FindImposterState();
}

class _FindImposterState extends State<FindImposter> {
  late List<int> imposterIndices; // ✅ قائمة الـ imposters
  Set<int> selectedCharacters = {}; // ✅ الشخصيات اللي تم اختيارها
  bool isRandomizing = true;
  Timer? _timer;
  int currentHighlightedIndex = 0;
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    // ✅ استخراج indices الـ imposters من البيانات
    imposterIndices = [];
    for (var imposterData in widget.impostersData) {
      String name = imposterData['name'];
      int index = widget.selectedIndices.indexWhere((i) =>
      namesCharacters[i + 1] == name
      );
      if (index != -1) {
        imposterIndices.add(index);
      }
    }
    startRandomSelection();
  }

  void startRandomSelection() {
    _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
      if (mounted) {
        setState(() {
          currentHighlightedIndex =
              Random().nextInt(widget.selectedIndices.length);
        });
      }
    });
  }

  void stopRandomization() {
    _timer?.cancel();
    setState(() {
      isRandomizing = false;
    });
  }

  void selectCharacter(int index) {
    if (!isRandomizing && !gameEnded) {
      setState(() {
        if (selectedCharacters.contains(index)) {
          selectedCharacters.remove(index);
        } else {
          selectedCharacters.add(index);
        }

        // ✅ لو اختار نفس عدد الـ imposters، نوقف اللعبة
        if (selectedCharacters.length == imposterIndices.length) {
          gameEnded = true;
          stopRandomization();

          Future.delayed(Duration(milliseconds: 800), () {
            showResultDialog();
          });
        }
      });
    }
  }

  void showResultDialog() {
    // ✅ حساب الإجابات الصح والغلط
    Set<int> correctSelections = selectedCharacters.intersection(imposterIndices.toSet());
    Set<int> wrongSelections = selectedCharacters.difference(imposterIndices.toSet());
    int correctCount = correctSelections.length;
    int totalImposters = imposterIndices.length;

    bool isAllCorrect = correctCount == totalImposters && wrongSelections.isEmpty;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isAllCorrect
                  ? [Color(0xff004d00), Color(0xff00b300)]
                  : correctCount > 0
                  ? [Color(0xff4d4500), Color(0xffb39800)]
                  : [Color(0xff4d0000), Color(0xffb30000)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isAllCorrect
                    ? Colors.green
                    : correctCount > 0
                    ? Colors.orange
                    : Colors.red).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAllCorrect
                      ? Icons.check_circle
                      : correctCount > 0
                      ? Icons.warning
                      : Icons.cancel,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  isAllCorrect
                      ? 'PERFECT!'
                      : correctCount > 0
                      ? 'PARTIAL!'
                      : 'WRONG!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You found $correctCount / $totalImposters imposters',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'The Imposters were:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 15),
                // ✅ عرض كل الـ imposters
                ...widget.impostersData.map((imposterData) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: Image(
                              image: imposterData['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          imposterData['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isAllCorrect
                              ? Color(0xff00b300)
                              : correctCount > 0
                              ? Colors.orange
                              : Color(0xffb30000),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showLoadingAnimation(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Play Again',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isAllCorrect
                              ? Color(0xff00b300)
                              : correctCount > 0
                              ? Colors.orange
                              : Color(0xffb30000),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showLoadingAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.09),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xfffd0001),
                      width: 8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xfffd0001).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Hour hand
                      Transform.rotate(
                        angle: value * 2 * pi,
                        child: Container(
                          width: 6,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xfffd0001),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          margin: EdgeInsets.only(bottom: 40),
                        ),
                      ),
                      // Minute hand
                      Transform.rotate(
                        angle: value * 24 * pi,
                        child: Container(
                          width: 4,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Color(0xfffd0001),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          margin: EdgeInsets.only(bottom: 55),
                        ),
                      ),
                      // Center dot
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(0xfffd0001),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onEnd: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Categories_page.routeName);
              },
            ),
          ),
        );
      },
    );
  }  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0a0a0a),
              Color(0xff1a1a2e),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // الهيدر
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: 30),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'FIND THE IMPOSTERS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffd0001),
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isRandomizing
                          ? '🎲 Randomizing...'
                          : '👆 Find ${imposterIndices.length} Imposters (${selectedCharacters.length}/${imposterIndices.length} selected)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Grid الشخصيات
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    itemCount: widget.selectedIndices.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      int characterIndex = widget.selectedIndices[index];
                      bool isHighlighted =
                          isRandomizing && currentHighlightedIndex == index;
                      bool isSelected = selectedCharacters.contains(index);
                      bool isImposterRevealed =
                          gameEnded && imposterIndices.contains(index);
                      bool isCorrectChoice =
                          gameEnded && isSelected && imposterIndices.contains(index);
                      bool isWrongChoice =
                          gameEnded && isSelected && !imposterIndices.contains(index);

                      return GestureDetector(
                        onTap: () => selectCharacter(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isCorrectChoice
                                  ? Colors.green
                                  : isImposterRevealed
                                  ? Color(0xfffd0001)
                                  : isWrongChoice
                                  ? Colors.orange
                                  : isSelected
                                  ? Colors.blue
                                  : isHighlighted
                                  ? Colors.yellow
                                  : Colors.white30,
                              width: isHighlighted ||
                                  isImposterRevealed ||
                                  isWrongChoice ||
                                  isSelected
                                  ? 4
                                  : 2,
                            ),
                            boxShadow: [
                              if (isHighlighted ||
                                  isImposterRevealed ||
                                  isWrongChoice ||
                                  isSelected)
                                BoxShadow(
                                  color: (isCorrectChoice
                                      ? Colors.green
                                      : isImposterRevealed
                                      ? Color(0xfffd0001)
                                      : isWrongChoice
                                      ? Colors.orange
                                      : isSelected
                                      ? Colors.blue
                                      : Colors.yellow)
                                      .withOpacity(0.6),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image(
                                  image: arrCharacters[characterIndex + 1],
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Text(
                                    namesCharacters[characterIndex + 1],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // أيقونة الـ Imposter (لما اللعبة تخلص)
                                if (isImposterRevealed)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: isCorrectChoice
                                            ? Colors.green
                                            : Color(0xfffd0001),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image(
                                        image: AssetImage(AppAssets.spy),
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                // علامة X للاختيار الخطأ
                                if (isWrongChoice)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                // علامة الاختيار (أثناء اللعب)
                                if (isSelected && !gameEnded)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 25,
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

              // زر Stop Randomizing / Submit
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    if (isRandomizing) {
                      stopRandomization();
                    } else if (!gameEnded && selectedCharacters.length == imposterIndices.length) {
                      setState(() {
                        gameEnded = true;
                      });
                      Future.delayed(Duration(milliseconds: 800), () {
                        showResultDialog();
                      });
                    } else {
                      // ✅ زر Skip/Show Results
                      setState(() {
                        gameEnded = true;
                        stopRandomization();
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        showResultDialog();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRandomizing
                        ? Color(0xfffd0001)
                        : selectedCharacters.length == imposterIndices.length
                        ? Colors.green
                        : Colors.orange,
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isRandomizing
                        ? 'STOP'
                        : selectedCharacters.length == imposterIndices.length
                        ? 'SUBMIT'
                        : 'SHOW RESULTS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}