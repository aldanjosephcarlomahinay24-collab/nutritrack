const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime addDays(DateTime d, int days) => DateTime(d.year, d.month, d.day + days);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Monday of the week that contains [d].
DateTime startOfWeek(DateTime d) => addDays(dateOnly(d), 1 - d.weekday);

String peso(double amount) {
  final whole = amount == amount.roundToDouble();
  return '₱${amount.toStringAsFixed(whole ? 0 : 2)}';
}

String shortWeekday(DateTime d) => _weekdays[d.weekday - 1];

String shortDate(DateTime d) => '${_months[d.month - 1]} ${d.day}';

String clockTime(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${d.hour < 12 ? 'AM' : 'PM'}';
}

String greetingFor(DateTime now) {
  if (now.hour < 12) return 'Good morning';
  if (now.hour < 18) return 'Good afternoon';
  return 'Good evening';
}

String relativeDay(DateTime day, DateTime today) {
  if (isSameDay(day, today)) return 'Today';
  if (isSameDay(day, addDays(today, -1))) return 'Yesterday';
  if (isSameDay(day, addDays(today, 1))) return 'Tomorrow';
  return '${shortWeekday(day)}, ${shortDate(day)}';
}

String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
