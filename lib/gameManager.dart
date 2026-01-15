import 'package:flutter/material.dart';

class GameManager {
  static final GameManager _instance = GameManager._internal();
  factory GameManager() => _instance;
  GameManager._internal();

  // Selected characters (persist throughout the game)
  List<int> selectedCharacters = [];

  // Number of imposters
  int imposterCount = 1;

  // Player scores (persist throughout rounds)
  Map<int, int> playerScores = {};

  // Current round data
  List<int> currentImposters = [];
  String currentCategory = "";
  String correctAnswer = "";

  // Reset only round data, keep characters and scores
  void resetRound() {
    currentImposters = [];
    currentCategory = "";
    correctAnswer = "";
  }

  // Reset everything (when going back to character selection)
  void resetAll() {
    selectedCharacters = [];
    playerScores = {};
    currentImposters = [];
    currentCategory = "";
    correctAnswer = "";
    imposterCount = 1;
  }

  // Initialize scores for all selected characters
  void initializeScores() {
      for (int i = 0; i < selectedCharacters.length; i++) {
        // Only set to 0 if player doesn't already have a score
        playerScores[i] ??= 0;
      }

  }

  // Add points to a player
  void addPoints(int playerIndex, int points) {
    playerScores[playerIndex] = (playerScores[playerIndex] ?? 0) + points;
  }

  // Get player score
  int getScore(int playerIndex) {
    return playerScores[playerIndex] ?? 0;
  }
}