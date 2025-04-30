import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

String formatTimestamp(tz.TZDateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  final s = dt.second.toString().padLeft(2, '0');

  final offset = dt.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs().toString().padLeft(2, '0');
  final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

  return '$y-$m-${d}T$h:$min:$s$sign$hours:$minutes';
}

String getTimestamp(){
  tzdata.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  final now = tz.TZDateTime.now(bangkok); //.add(const Duration(hours: 7));
  return formatTimestamp(now);
}