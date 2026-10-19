enum AchievementId {
  firstBite,
  weekPlanner,
  onARoll,
  stockedUp,
  explorer,
  checkedOut,
  levelFive,
}

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
  });

  final AchievementId id;
  final String title;
  final String description;
  final int xpReward;
}
