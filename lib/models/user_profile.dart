/// Local profile only. No login system yet.
class UserProfile {
  const UserProfile({required this.name, this.campus = 'USJ-R'});

  final String name;
  final String campus;
}
