import 'package:flutter/material.dart';
import 'package:imposter/utilites.dart';

import 'characterRevealScreen.dart';

class CategoryCharacters extends StatefulWidget {
  static const String routeName = 'CategoryCharacters';
  const CategoryCharacters({super.key});

  @override
  State<CategoryCharacters> createState() => _CategoryCharactersState();
}

List<AssetImage> arrCharacters = [
  const AssetImage(AppAssets.b),
  const AssetImage(AppAssets.c),
  const AssetImage(AppAssets.d),
  const AssetImage(AppAssets.e),
  const AssetImage(AppAssets.f),
  const AssetImage(AppAssets.g),
  const AssetImage(AppAssets.h),
  const AssetImage(AppAssets.i),
  const AssetImage(AppAssets.k),
  const AssetImage(AppAssets.l),
  const AssetImage(AppAssets.m),
  const AssetImage(AppAssets.o),
  const AssetImage(AppAssets.p),
  const AssetImage(AppAssets.q),
  const AssetImage(AppAssets.r),
  const AssetImage(AppAssets.mino),
  const AssetImage(AppAssets.joe),
  const AssetImage(AppAssets.tantoon),
];

List<String> namesCharacters = [
  'jessy',
  'DoaDoa',
  'Lome',
  'John',
  'Abo ElDahab',
  'Goku',
  'Sam',
  'Zezo',
  'Yoka',
  'Vanom',
  'Bulk',
  'jessy',
  'Teko',
  'Taliska',
  'nazeh',
  'mino',
  'Joe',
  'TanToon',
];

List<Color> funnyColors = [
  const Color(0xFFFF6B9D),
  const Color(0xFFFFC107),
  const Color(0xFF4CAF50),
  const Color(0xFF00BCD4),
  const Color(0xFF9C27B0),
  const Color(0xFFFF5722),
  const Color(0xFF3F51B5),
  const Color(0xFFE91E63),
];

class _CategoryCharactersState extends State<CategoryCharacters>
    with SingleTickerProviderStateMixin {
  List<int> numSelected = [];
  bool showCharacterView = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int imposterCount = 1;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showCharacterView && numSelected.isNotEmpty) {
      return CharacterRevealScreen(
        selectedIndices: numSelected,
        imposterCount: imposterCount,
        onBack: () {
          setState(() {
            showCharacterView = false;
          });
        },
      );

    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff241a5e),
              Color(0xff750b0b),

            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: 17,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: numSelected.isNotEmpty ? 100 : 12,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = numSelected.contains(index);
                  Color cardColor = funnyColors[index % funnyColors.length];

                  // انميشن دخول متدرج لكل كارد
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400 + (index * 80)),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (numSelected.contains(index)) {
                                  numSelected.remove(index);
                                  if (imposterCount > numSelected.length) {
                                    imposterCount = numSelected.length;
                                  }
                                } else {
                                  numSelected.add(index);
                                }

                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? Colors.green.withOpacity(0.6)
                                        : cardColor.withOpacity(0.4),
                                    blurRadius: isSelected ? 20 : 15,
                                    offset: Offset(0, isSelected ? 10 : 8),
                                    spreadRadius: isSelected ? 2 : 0,
                                  ),
                                ],
                                border: Border.all(
                                  color: isSelected ? Colors.green : Colors.white,
                                  width: isSelected ? 5 : 3,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      image: arrCharacters[index + 1],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),

                                  // الاسم في الأسفل مع خلفية شفافة
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.8),
                                            Colors.black.withOpacity(0.4),
                                            Colors.transparent,
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(22),
                                          bottomRight: Radius.circular(22),
                                        ),
                                      ),
                                      child: Text(
                                        namesCharacters[index + 1],
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.greenAccent
                                              : Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            const Shadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),

                                  // علامة الاختيار
                                  if (isSelected)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: TweenAnimationBuilder(
                                        duration: const Duration(milliseconds: 300),
                                        tween: Tween<double>(begin: 0.0, end: 1.0),
                                        builder: (context, double scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.green
                                                        .withOpacity(0.8),
                                                    blurRadius: 15,
                                                    spreadRadius: 3,
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
      // الزر الطافي في الأسفل
      // استبدل الـ floatingActionButton بهذا الكود:

      floatingActionButton: numSelected.isNotEmpty
          ? TweenAnimationBuilder(
        duration: const Duration(milliseconds: 400),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Number Picker Container
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Select Imposters Count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Number Picker
                          Container(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Decrease Button
                                IconButton(
                                  onPressed: () {
                                    if (imposterCount > 1) {
                                      setState(() {
                                        imposterCount--;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: imposterCount > 1
                                        ? Colors.redAccent
                                        : Colors.grey,
                                    size: 36,
                                  ),
                                ),

                                const SizedBox(width: 20),

                                // Number Display
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF00F260),
                                        Color(0xFF0575E6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.greenAccent.withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$imposterCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 20),

                                // Increase Button
                                IconButton(
                                  onPressed: () {
                                    if (imposterCount < numSelected.length) {
                                      setState(() {
                                        imposterCount++;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: imposterCount < numSelected.length
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            'Max: ${numSelected.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Start Game Button
                    InkWell(
                      onTap: () {
                        setState(() {
                          showCharacterView = true;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00F260),
                              Color(0xFF0575E6),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0575E6).withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Start Game',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.people,
                                    color: Color(0xFF0575E6),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${numSelected.length}',
                                    style: const TextStyle(
                                      color: Color(0xFF0575E6),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}