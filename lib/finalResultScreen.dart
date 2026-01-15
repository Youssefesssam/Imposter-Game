import 'package:flutter/material.dart';
import 'package:imposter/guessImposterScreen.dart';
import 'gameManager.dart';
import 'categoryCharacters.dart';
import 'Categories_page.dart';

class FinalResultScreen extends StatefulWidget {
  static const String routeName = 'FinalResultScreen';

  const FinalResultScreen({super.key});

  @override
  State<FinalResultScreen> createState() => _FinalResultScreenState();
}

class _FinalResultScreenState extends State<FinalResultScreen>
    with TickerProviderStateMixin {
  final GameManager _gameManager = GameManager();
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  // Design tokens
  static const _bg = Color(0xFF0A0A0F);
  static const _surface = Color(0xFF13131A);
  static const _surfaceAlt = Color(0xFF1C1C27);
  static const _gold = Color(0xFFFFCC00);
  static const _silver = Color(0xFFB0BEC5);
  static const _bronze = Color(0xFFBF7B4A);
  static const _accent = Color(0xFF6C63FF);
  static const _danger = Color(0xB3E00F0F);
  static const _textPrimary = Color(0xFFF0F0F5);
  static const _textSecondary = Color(0xFF8888AA);

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _playAgain() {
    _gameManager.resetRound();
    Navigator.pushNamedAndRemoveUntil(
      context,
      CategoryCharacters.routeName,
          (route) => false,
    );
  }

  void _newGame() {
    _gameManager.resetAll();
    Navigator.pushNamedAndRemoveUntil(
      context,
      CategoryCharacters.routeName,
          (route) => false,
    );
  }

  List<MapEntry<int, int>> _getSortedScores() {
    List<MapEntry<int, int>> sortedScores =
    _gameManager.playerScores.entries.toList();
    sortedScores.sort((a, b) => b.value.compareTo(a.value));
    return sortedScores;
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return _gold;
      case 1:
        return _silver;
      case 2:
        return _bronze;
      default:
        return _textSecondary;
    }
  }

  String _getRankEmoji(int index) {
    switch (index) {
      case 0:
        return '🥇';
      case 1:
        return '🥈';
      case 2:
        return '🥉';
      default:
        return '${index + 1}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedScores = _getSortedScores();
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final isTablet = size.width > 600;

    final horizontalPad = isTablet ? size.width * 0.12 : 20.0;
    final titleFontSize = isTablet ? 38.0 : isSmall ? 24.0 : 30.0;
    final cardPad = isTablet ? 20.0 : 14.0;
    final avatarSize = isTablet ? 72.0 : isSmall ? 48.0 : 58.0;
    final rankSize = isTablet ? 48.0 : 40.0;
    final nameFontSize = isTablet ? 20.0 : isSmall ? 15.0 : 17.0;
    final scoreFontSize = isTablet ? 26.0 : isSmall ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: ChineseBackground()),

          Column(
            children: [
              SizedBox(height: isTablet ? 48 : 32),
              // ── Header ──────────────────────────────────────────────
              FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPad, 24, horizontalPad, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trophy + Title row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Glowing trophy container
                            Container(
                              width: isTablet ? 72 : 60,
                              height: isTablet ? 72 : 60,
                              decoration: BoxDecoration(
                                color: _gold.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: _gold.withOpacity(0.35), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: _gold.withOpacity(0.25),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '🏆',
                                  style: TextStyle(fontSize: isTablet ? 36 : 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Final Results',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w900,
                                    color: _textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rankings & Scores',
                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 13,
                                    color: _textSecondary,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Thin divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _accent.withOpacity(0.7),
                                _gold.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Leaderboard ─────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                  physics: const BouncingScrollPhysics(),
                  itemCount: sortedScores.length,
                  itemBuilder: (context, index) {
                    final playerIndex = sortedScores[index].key;
                    final score = sortedScores[index].value;
                    final characterIndex = _gameManager.selectedCharacters[playerIndex];
                    final isImposter = _gameManager.currentImposters.contains(playerIndex);
                    final rankColor = _getRankColor(index);
                    final isWinner = index == 0;

                    return AnimatedBuilder(
                      animation: _listController,
                      builder: (context, child) {
                        final delay = (index * 0.12).clamp(0.0, 0.8);
                        final animStart = delay;
                        final animEnd = (delay + 0.4).clamp(0.0, 1.0);
                        final localT = ((_listController.value - animStart) /
                            (animEnd - animStart))
                            .clamp(0.0, 1.0);
                        final curved = Curves.easeOutBack.transform(localT);

                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - curved)),
                          child: Opacity(
                            opacity: Curves.easeOut.transform(localT),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isWinner
                              ? _gold.withOpacity(0.07)
                              : _surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isWinner
                                ? _gold.withOpacity(0.4)
                                : isImposter
                                ? _danger.withOpacity(0.25)
                                : _surfaceAlt,
                            width: isWinner ? 1.5 : 1,
                          ),
                          boxShadow: isWinner
                              ? [
                            BoxShadow(
                              color: _gold.withOpacity(0.12),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ]
                              : null,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(cardPad),
                          child: Row(
                            children: [
                              // Rank badge
                              SizedBox(
                                width: rankSize,
                                height: rankSize,
                                child: index < 3
                                    ? Center(
                                  child: Text(
                                    _getRankEmoji(index),
                                    style: TextStyle(
                                      fontSize: isTablet ? 30 : 24,
                                    ),
                                  ),
                                )
                                    : Container(
                                  decoration: BoxDecoration(
                                    color: _surfaceAlt,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 15,
                                        fontWeight: FontWeight.w800,
                                        color: _textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Avatar
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: avatarSize,
                                    height: avatarSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isImposter
                                            ? _danger
                                            : isWinner
                                            ? _gold
                                            : _surfaceAlt,
                                        width: isWinner ? 2.5 : 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isImposter
                                              ? _danger
                                              : isWinner
                                              ? _gold
                                              : _accent)
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 0,
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
                                  if (isImposter)
                                    Positioned(
                                      right: -4,
                                      bottom: -4,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: _danger,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: _bg, width: 1.5),
                                        ),
                                        child: const Text(
                                          '🕵️',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(width: 14),

                              // Name + tag
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      namesCharacters[characterIndex + 1],
                                      style: TextStyle(
                                        fontSize: nameFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: isWinner ? _gold : _textPrimary,
                                        letterSpacing: -0.2,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (isImposter) ...[
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _danger.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                              color: _danger.withOpacity(0.4),
                                              width: 1),
                                        ),
                                        child: const Text(
                                          'IMPOSTER',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: _danger,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Score pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: rankColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: rankColor.withOpacity(
                                        index < 3 ? 0.5 : 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: scoreFontSize,
                                    fontWeight: FontWeight.w900,
                                    color: index < 3 ? rankColor : _textSecondary,
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

              // ── Action Buttons ───────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 20),
                child: Row(
                  children: [
                    // New Round
                    Expanded(
                      child: _ActionButton(
                        label: 'New Round',
                        icon: Icons.replay_rounded,
                        color: const Color(0x8906C000),
                        onPressed: _playAgain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // New Game
                    Expanded(
                      child: _ActionButton(
                        label: 'New Game',
                        icon: Icons.home_rounded,
                        color: _danger,
                        onPressed: _newGame,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: isTablet ? 68 : 58,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: isTablet ? 26 : 22),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}