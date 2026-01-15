import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:imposter/utilites.dart';

class PremiumBottomBar extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback onStartTap;
  final int selectedCount;
  final int imposterCount;
  final int maxImposters;
  final VoidCallback onIncreaseImposter;
  final VoidCallback onDecreaseImposter;

  const PremiumBottomBar({
    Key? key,
    required this.onAddTap,
    required this.onStartTap,
    required this.selectedCount,
    required this.imposterCount,
    required this.maxImposters,
    required this.onIncreaseImposter,
    required this.onDecreaseImposter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 480,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 0, child: _buildGlassPanel2(screenWidth,context)),
          Positioned(top: 0, child: _buildBackgroundImage()),
          Positioned(bottom: 0, child: _buildGlassPanel(screenWidth)),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      width: 400,
      height: 390,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.Group),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ─────────────────────── glass panel ───────────────────────
  Widget _buildGlassPanel2(double screenWidth,BuildContext context) {
    final double panelWidth = screenWidth.clamp(280.0, 360.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: panelWidth,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.9),
                Color(0xff8c0b31).withOpacity(0.8),

                Color(0xff051680).withOpacity(0.5),
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.9),
              ],

            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child:  SizedBox(height: MediaQuery.of(context).size.height/2,),
        ),
      ),
    );
  }

  Widget _buildGlassPanel(double screenWidth) {
    final double panelWidth = screenWidth.clamp(280.0, 360.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: panelWidth,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.22),
                Colors.black.withOpacity(0.07),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Stats row: characters + imposters ──
              _buildStatsRow(),
              const SizedBox(height: 16),
              // ── Divider ──
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ── Actions row: Add + Start ──
              _buildActionsRow(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────── stats row ───────────────────────
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Characters pill
        _buildStatPill(
          label: 'Characters',
          child: Text(
            '$selectedCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          gradientColors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF510404),
            const Color(0xFF0A0A0A),
          ],
          glowColor: Color(0xFFA20707),
        ),

        // Vertical divider
        Container(width: 1, height: 50, color: Colors.white.withOpacity(0.2)),

        // Imposters counter
        _buildImposterPill(),
      ],
    );
  }

  Widget _buildStatPill({
    required String label,
    required Widget child,
    required List<Color> gradientColors,
    required Color glowColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFFFFFFF),
              width: .4,
            ),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildImposterPill() {
    final bool canDecrease = imposterCount > 1;
    final bool canIncrease = imposterCount < maxImposters;

    return Column(
      children: [
        Text(
          'IMPOSTERS  ·  MAX $maxImposters',
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCounterBtn(
                icon: Icons.remove_rounded,
                onTap: canDecrease ? onDecreaseImposter : null,
                active: canDecrease,
                color: const Color(0xFFFF6B9D),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$imposterCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildCounterBtn(
                icon: Icons.add_rounded,
                onTap: canIncrease ? onIncreaseImposter : null,
                active: canIncrease,
                color: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterBtn({
    required IconData icon,
    required VoidCallback? onTap,
    required bool active,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: active
              ? color.withOpacity(0.25)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 15,
          color: active ? color : Colors.white.withOpacity(0.25),
        ),
      ),
    );
  }

  // ─────────────────────── actions row ───────────────────────
  Widget _buildActionsRow() {
    return Row(
      children: [
        // Add Character — ghost style
        Expanded(
          child: GestureDetector(
            onTap: onAddTap,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Start — solid gradient
        GestureDetector(
          onTap: onStartTap,
          child: Container(
            width: 130,
            height: 52,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFFFFFF),
                width: .4,
              ),
              gradient: const LinearGradient(
                colors: [
                  const Color(0xFF0A0A0A),
                  const Color(0xFF510404),
                  const Color(0xFF0A0A0A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA20707).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                SizedBox(width: 4),
                Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
