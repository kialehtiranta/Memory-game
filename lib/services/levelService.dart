import 'package:hive/hive.dart';

class LevelService {
  final Box box;
  final totalLevels = 3;
  final completedLevels = <int>{};
  var currentLevel = 0;
  var totalAttempts = 0;

  LevelService(this.box) {
    _loadProgress();
  }

  void _loadProgress() {
    final savedCompleted = box.get(
      'completedLevels',
      defaultValue: <dynamic>[],
    );
    currentLevel = box.get('currentLevel', defaultValue: 0) as int;
    totalAttempts = box.get('totalAttempts', defaultValue: 0) as int;

    if (savedCompleted is Iterable) {
      completedLevels.addAll(savedCompleted.cast<int>());
    }
  }

  void saveProgress() {
    box.put('completedLevels', completedLevels.toList());
    box.put('currentLevel', currentLevel);
    box.put('totalAttempts', totalAttempts);
  }

  void setCurrentLevel(int level) {
    currentLevel = level;
    box.put('currentLevel', currentLevel);
  }

  void addCompletedLevel(int level) {
    completedLevels.add(level);
    saveProgress();
  }

  void addAttempts(int attemptsToAdd) {
    totalAttempts += attemptsToAdd;
    box.put('totalAttempts', totalAttempts);
  }

  void resetProgress() {
    completedLevels.clear();
    totalAttempts = 0;
    currentLevel = 0;
    saveProgress();
  }
}
