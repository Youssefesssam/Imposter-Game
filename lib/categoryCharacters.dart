import 'package:flutter/material.dart';
import 'package:imposter/utilites.dart';
import 'dart:ui';
import 'Categories_page.dart';
import 'customBottomBar.dart';
import 'finalResultScreen.dart';
import 'gameManager.dart';

// ════════════════════════════════════════════════════════════════
//  SECTION 1 — STATIC DATA
// ════════════════════════════════════════════════════════════════

List<AssetImage> arrCharacters = [
  AssetImage(AppAssets.b),
  AssetImage(AppAssets.c),
  AssetImage(AppAssets.d),
  AssetImage(AppAssets.e),
  AssetImage(AppAssets.f),
  AssetImage(AppAssets.g),
  AssetImage(AppAssets.tito),
  AssetImage(AppAssets.h),
  AssetImage(AppAssets.i),
  AssetImage(AppAssets.k),
  AssetImage(AppAssets.l),
  AssetImage(AppAssets.m),
  AssetImage(AppAssets.o),
  AssetImage(AppAssets.p),
  AssetImage(AppAssets.q),
  AssetImage(AppAssets.r),
  AssetImage(AppAssets.mino),
  AssetImage(AppAssets.joe),
  AssetImage(AppAssets.tantoon),
];

List<String> namesCharacters = [
  'jessy',
  'DoaDoa',
  'Lome',
  'John',
  'Abo ElDahab',
  'Goku',
  'Tito',
  'Sam',
  'Zezo',
  'Yoka',
  'Venom',
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

const List<String> _chineseChars = [
  '龍',
  '火',
  '戰',
  '勇',
  '力',
  '神',
  '王',
  '鬼',
  '劍',
  '風',
  '影',
  '血',
  '命',
  '霸',
  '天',
  '地',
  '殺',
  '魂',
  '氣',
  '虎',
  '武',
  '道',
  '刃',
  '雷',
  '炎',
  '獸',
  '狂',
  '暗',
  '毒',
  '冥',
];

// ════════════════════════════════════════════════════════════════
//  SECTION 2 — BACKGROUND PAINTER
// ════════════════════════════════════════════════════════════════

class _ChineseBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: const Color(0xFF0E34B0).withOpacity(0.4),
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );

    const double colSpacing = 38;
    const double rowSpacing = 44;

    int charIndex = 0;
    double y = -10;
    int row = 0;

    while (y < size.height + rowSpacing) {
      double x = (row % 2 == 0) ? 0 : -colSpacing / 2;
      while (x < size.width + colSpacing) {
        final char = _chineseChars[charIndex % _chineseChars.length];
        final tp = TextPainter(
          text: TextSpan(text: char, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x, y));
        x += colSpacing;
        charIndex++;
      }
      y += rowSpacing;
      row++;
    }
  }

  @override
  bool shouldRepaint(_ChineseBgPainter oldDelegate) => false;
}

// ════════════════════════════════════════════════════════════════
//  SECTION 3 — BACKGROUND WIDGET
// ════════════════════════════════════════════════════════════════

class ChineseBackground extends StatelessWidget {
  const ChineseBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF0A0A0A)),
      child: CustomPaint(
        painter: _ChineseBgPainter(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0D1531).withOpacity(0.3),
                const Color(0xFF17235E).withOpacity(0.5),
                const Color(0xFF0D1531).withOpacity(0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SECTION 4 — STATEFUL WIDGET (Entry Point)
// ════════════════════════════════════════════════════════════════

class CategoryCharacters extends StatefulWidget {
  static const String routeName = 'CategoryCharacters';

  const CategoryCharacters({super.key});

  @override
  State<CategoryCharacters> createState() => _CategoryCharactersState();
}

// ════════════════════════════════════════════════════════════════
//  SECTION 5 — STATE CLASS
// ════════════════════════════════════════════════════════════════

class _CategoryCharactersState extends State<CategoryCharacters>
    with TickerProviderStateMixin {
  // ── 5.1  State Variables ─────────────────────────────────────
  final GameManager _gameManager = GameManager();
  List<int> numSelected = [];

  // ── 5.2  Animation Controllers ───────────────────────────────
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── 5.3  Lifecycle ───────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    if (_gameManager.selectedCharacters.isNotEmpty) {
      numSelected = List.from(_gameManager.selectedCharacters);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════════
  //  SECTION 6 — BUSINESS LOGIC / ACTIONS
  // ════════════════════════════════════════════════════════════════

  void _goToCategories() {
    if (numSelected.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'اختار على الأقل 3 شخصيات!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    _gameManager.selectedCharacters = List.from(numSelected);
    _gameManager.initializeScores();
    Navigator.pushNamed(context, Categories_page.routeName);
  }

  void _onToggleCharacter({
    required int index,
    required void Function(void Function()) setModalState,
  }) {
    final isSelected = numSelected.contains(index);
    setState(() {
      setModalState(() {
        if (isSelected) {
          numSelected.remove(index);
          final maxI = numSelected.isEmpty ? 1 : numSelected.length;
          if (_gameManager.imposterCount > maxI) {
            _gameManager.imposterCount = maxI;
          }
        } else {
          numSelected.add(index);
        }
      });
    });
  }

  // ════════════════════════════════════════════════════════════════
  //  SECTION 7 — BOTTOM SHEET
  // ════════════════════════════════════════════════════════════════

  void _showCharacterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1A0000),
                      const Color(0xFF0D0000),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFCC0000).withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCC0000).withOpacity(0.25),
                      blurRadius: 40,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSheetHandle(),
                    _buildSheetHeader(numSelected.length),
                    _buildSheetTitle(),
                    if (numSelected.isNotEmpty) ...[
                      _buildSelectedChipsRow(setModalState),
                      const SizedBox(height: 12),
                    ],
                    _buildSheetDivider(),
                    const SizedBox(height: 12),
                    _buildCharacterGrid(setModalState),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── 7.1  Sheet Handle ────────────────────────────────────────
  Widget _buildSheetHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 6),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFCC0000).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ── 7.2  Sheet Header Row ────────────────────────────────────
  Widget _buildSheetHeader(int selectedCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 6),
      child: Row(
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFCC0000).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFCC0000).withOpacity(0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'SELECT CREW',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Count label
          Text(
            '$selectedCount selected',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── 7.3  Sheet Title ─────────────────────────────────────────
  Widget _buildSheetTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Select Characters',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  // ── 7.4  Selected Characters Chips Row ───────────────────────
  Widget _buildSelectedChipsRow(void Function(void Function()) setModalState) {
    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: numSelected.length,
        itemBuilder: (context, listIndex) {
          final index = numSelected[listIndex];
          return Container(
            margin: const EdgeInsets.only(right: 10,top: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Chip image
                Container(
                  width: 62,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFCC0000).withOpacity(0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCC0000).withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image(
                      image: arrCharacters[index + 1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Remove button
                Positioned(
                  top: -5,
                  right: -5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        setModalState(() {
                          numSelected.remove(index);
                          final maxI =
                              numSelected.isEmpty ? 1 : numSelected.length;
                          if (_gameManager.imposterCount > maxI) {
                            _gameManager.imposterCount = maxI;
                          }
                        });
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCC0000),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 6),
                        ],
                      ),
                      child: const Icon(Icons.close,
                          size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── 7.5  Sheet Divider ───────────────────────────────────────
  Widget _buildSheetDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFCC0000).withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ── 7.6  Character Selection Grid ────────────────────────────
  Widget _buildCharacterGrid(void Function(void Function()) setModalState) {
    return Expanded(
      child: GridView.builder(
        itemCount: 18,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final isSelected = numSelected.contains(index);
          return GestureDetector(
            onTap: () => _onToggleCharacter(
              index: index,
              setModalState: setModalState,
            ),
            child: _buildCharacterCard(index: index, isSelected: isSelected),
          );
        },
      ),
    );
  }

  // ── 7.7  Single Character Card ───────────────────────────────
  Widget _buildCharacterCard({
    required int index,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFCC0000)
              : Colors.white.withOpacity(0.08),
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFCC0000).withOpacity(0.45),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Character image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image(
              image: arrCharacters[index + 1],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Dark overlay (unselected)
          if (!isSelected)
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),

          // Name tag
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                namesCharacters[index + 1],
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFF6B6B) : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(1, 1)),
                  ],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Checkmark (selected)
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFCC0000),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCC0000).withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  SECTION 8 — HERO SECTION WIDGET
  // ════════════════════════════════════════════════════════════════

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Card Background ──
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 10, 140, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
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
                    color: const Color(0xFF000000).withOpacity(0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildHeroBadge(),
                      SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, FinalResultScreen.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: PharaohColors.gold.withOpacity(0.12),
                            border: Border.all(
                              color: PharaohColors.gold.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.sports_score,
                            size: 20,
                            color: PharaohColors.gold.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHeroTitle(),
                  const SizedBox(height: 10),
                  _buildHeroSubtitle(),
                  const SizedBox(height: 16),
                  _buildHeroAccentLine(),
                  const SizedBox(height: 14),
                  _buildHeroHint(),
                ],
              ),
            ),
          ),

          // ── Character Illustration ──
          Positioned(
            top: -170,
            bottom: -100,
            right: -30,
            width: MediaQuery.of(context).size.width * 0.45,
            child: Image.asset(AppAssets.man, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Card Background ──
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 10, 140, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B0000),
                    Color(0xFFCC0000),
                    Color(0xFF8B0000),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCC0000).withOpacity(0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroBadge2(),
                  const SizedBox(height: 12),
                  _buildHeroTitle2(),
                  const SizedBox(height: 10),
                  _buildHeroSubtitle2(),
                  const SizedBox(height: 16),
                  _buildHeroAccentLine(),
                  const SizedBox(height: 14),
                  _buildHeroHint2(),
                ],
              ),
            ),
          ),

          // ── Character Illustration ──
          Positioned(
            top: -120,
            bottom: -80,
            right: -30,
            width: 180,
            child: Image.asset(AppAssets.man2, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  // ── 8.1  Hero Badge ──────────────────────────────────────────
  Widget _buildHeroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Color(0xFFFFD700), shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          const Text(
            'READY TO PLAY',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── 8.2  Hero Title ──────────────────────────────────────────
  Widget _buildHeroTitle() {
    return const Text(
      'Welcome,\nImpostor.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w900,
        height: 1.15,
        letterSpacing: -0.5,
      ),
    );
  }

  // ── 8.3  Hero Subtitle ───────────────────────────────────────
  Widget _buildHeroSubtitle() {
    return Text(
      'Pick your crew.\nDecide who to trust.',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 13,
        height: 1.5,
        letterSpacing: 0.2,
      ),
    );
  }

  // ── 8.4  Hero Accent Line ────────────────────────────────────
  Widget _buildHeroAccentLine() {
    return Row(
      children: [
        Container(
            width: 30,
            height: 2,
            decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Container(
            width: 8,
            height: 2,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2))),
      ],
    );
  }

  // ── 8.5  Hero Hint Row ───────────────────────────────────────
  Widget _buildHeroHint() {
    return Row(
      children: [
        const Icon(Icons.tips_and_updates_rounded,
            color: Color(0xFFFFD700), size: 14),
        const SizedBox(width: 6),
        Text(
          'Min. 3 characters to start',
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

// ── 8.1  Hero Badge (Section 2) ──────────────────────────────────────────
  Widget _buildHeroBadge2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Color(0xFFFFD700), shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          const Text(
            'CHOOSE YOUR SQUAD',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

// ── 8.2  Hero Title (Section 2) ──────────────────────────────────────────
  Widget _buildHeroTitle2() {
    return const Text(
      'Build Your\nTeam.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w900,
        height: 1.15,
        letterSpacing: -0.5,
      ),
    );
  }

// ── 8.3  Hero Subtitle (Section 2) ───────────────────────────────────────
  Widget _buildHeroSubtitle2() {
    return Text(
      'Every player has a role.\nWho will betray you?',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 13,
        height: 1.5,
        letterSpacing: 0.2,
      ),
    );
  }

// ── 8.5  Hero Hint Row (Section 2) ───────────────────────────────────────
  Widget _buildHeroHint2() {
    return Row(
      children: [
        const Icon(Icons.group_rounded, color: Color(0xFFFFD700), size: 14),
        const SizedBox(width: 6),
        Text(
          'More players = more chaos',
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  SECTION 9 — MAIN BUILD
  // ════════════════════════════════════════════════════════════════

  @override
  @override
  Widget build(BuildContext context) {
    final maxImposters = numSelected.isEmpty ? 1 : numSelected.length;
    if (_gameManager.imposterCount > maxImposters) {
      _gameManager.imposterCount = maxImposters;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Layer 1: Chinese character background (fill the whole screen) ──
          const Positioned.fill(child: ChineseBackground()),

          // ── Layer 2: Red radial vignette ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF8B0000).withOpacity(0.25),
                  ],
                ),
              ),
            ),
          ),

          // ── Layer 3: Scrollable content ──
          SingleChildScrollView(
            child: Column(
              children: [
                // ── "Hello" Text ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello 👋',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                _buildHeroSection(),

                // ── "Select Characters" label + Bottom Bar ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Characters',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                PremiumBottomBar(
                  onAddTap: _showCharacterBottomSheet,
                  onStartTap: _goToCategories,
                  selectedCount: numSelected.length,
                  imposterCount: _gameManager.imposterCount,
                  maxImposters: maxImposters,
                  onIncreaseImposter: () {
                    if (_gameManager.imposterCount < maxImposters) {
                      setState(() => _gameManager.imposterCount++);
                    }
                  },
                  onDecreaseImposter: () {
                    if (_gameManager.imposterCount > 1) {
                      setState(() => _gameManager.imposterCount--);
                    }
                  },
                ),

                const SizedBox(height: 30),
                // padding تحت
              ],
            ),
          ),
        ],
      ),
    );
  }
}
