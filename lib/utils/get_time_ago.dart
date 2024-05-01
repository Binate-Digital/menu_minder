import 'package:intl/intl.dart';

class GetTimeAgo {
  static String getTime(DateTime time) {
    final now = DateTime.now();
    int differenceHours = (now.hour - time.hour).abs();
    int differenceMinutes = (now.minute - time.minute).abs();
    print(time.hour);
    // If the time is today
    if (differenceHours == 0 && differenceMinutes < 15) {
      return 'Just Now';
    }
    if (differenceHours > 0) {
      return '${differenceHours}h ago';
    }
    if (differenceMinutes > 15) {
      return '$differenceMinutes minutes ago';
    }
    // If the time is yesterday
    else if (differenceHours <= 24) {
      return 'Yesterday';
    }
    // If the time is this week
    else if (differenceHours <= 7 * 24) {
      return DateFormat('EEE').format(time);
    }
    // If the time is older than a week
    else {
      return DateFormat('MMM d').format(time);
    }
  }
}
