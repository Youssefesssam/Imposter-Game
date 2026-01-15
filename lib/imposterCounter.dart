import 'package:flutter/material.dart';

class ImposterCounter extends StatelessWidget {
  final int imposterCount;
  final int maxImposters;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ImposterCounter({
    super.key,
    required this.imposterCount,
    required this.maxImposters,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
          ),
        ],
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLabel(),
            const SizedBox(width: 20),
            _buildCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imposters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Max: $maxImposters',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCounter() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00F260),
            Color(0xFF0575E6),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDecreaseButton(),
          const SizedBox(width: 10),
          _buildCountText(),
          const SizedBox(width: 10),
          _buildIncreaseButton(),
        ],
      ),
    );
  }

  Widget _buildDecreaseButton() {
    return IconButton(
      onPressed: imposterCount > 1 ? onDecrease : null,
      icon: Icon(
        Icons.remove_circle,
        color: imposterCount > 1 ? Colors.redAccent : Colors.grey.shade400,
        size: 25,
      ),
    );
  }

  Widget _buildCountText() {
    return Text(
      '$imposterCount',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildIncreaseButton() {
    return IconButton(
      onPressed: imposterCount < maxImposters ? onIncrease : null,
      icon: Icon(
        Icons.add_circle,
        color: imposterCount < maxImposters ? Colors.greenAccent : Colors.grey,
        size: 25,
      ),
    );
  }
}