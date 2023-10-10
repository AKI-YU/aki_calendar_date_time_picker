import 'package:intl/intl.dart';

enum TimeUnit { one, five, ten, fifteen, twenty, thirty, hour }

String todayStr() {
  final fromFormatter = DateFormat("yyyy/MM/dd");
  return fromFormatter.format(DateTime.now());
}

bool isToday(int y, int m, int d) {
  var n = DateTime.now();
  return (n.year == y && n.month == m && n.day == d);
}

bool isSelectDate(String selectedStr, int y, int m, int d) {
  var day1 = dateToString(intToDate(y, m, d));

  return day1 == selectedStr;
}

DateTime strToDate(String day, {String pattern = "yyyy/MM/dd"}) {
  final fromFormatter = DateFormat(pattern);

  return fromFormatter.parse(day);
}

String intToDateStr(int y, int m, int d) {
  String day1 =
      "${y.toString().padLeft(4, "0")}/${m.toString().padLeft(2, "0")}/${d.toString().padLeft(2, "0")}";

  return day1;
}

DateTime intToDate(int y, int m, int d, {int h = 0, int min = 0}) {
  return strToDate(
      "${y.toString().padLeft(4, "0")}/${m.toString().padLeft(2, "0")}/${d.toString().padLeft(2, "0")} ${h.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}",
      pattern: "yyyy/MM/dd HH:mm");
}

String minToHourStr(int i) {
  var h = i ~/ 60;
  var m = i % 60;
  return "${h.toString().padLeft(2, "0")}:${m.toString().padLeft(2, "0")}";
}

String dateToString(DateTime date, {String pattern = "yyyy/MM/dd"}) {
  final fromFormatter = DateFormat(pattern);
  return fromFormatter.format(date);
}

DateTime firstday(DateTime d) {
  String day1 =
      "${d.year.toString().padLeft(4, "0")}/${d.month.toString().padLeft(2, "0")}/01";

  return strToDate(day1);
}

DateTime lastday(DateTime d) {
  int lastDay = getMonthDays(d.year, d.month);

  String dayLast =
      "${d.year.toString().padLeft(4, "0")}/${d.month.toString().padLeft(2, "0")}/${lastDay.toString().padLeft(2, "0")}";

  return strToDate(dayLast);
}

// DateTime intToDate(int y, int m, int d) {
//   String dayString =
//       "${y.toString().padLeft(4, "0")}/${m.toString().padLeft(2, "0")}/${d.toString().padLeft(2, "0")}";

//   return strToDate(dayString);
// }

int getMonthDays(int year, int month) {
  switch (month) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
      return 31;
    case 2:
      if (year % 4 == 0) {
        return 29;
      } else {
        return 28;
      }
    default:
      return 30;
  }
}

DateTime preMonth(DateTime date) {
  int y = date.year;
  int m = date.month;
  int d = date.day;

  if (m == 1) {
    y = y - 1;
    m = 12;
  } else {
    m = m - 1;
  }

  if (d > getMonthDays(y, m)) {
    d = getMonthDays(y, m);
  }

  return intToDate(y, m, d, h: date.hour, min: date.minute);
}

DateTime nextMonth(DateTime date) {
  int y = date.year;
  int m = date.month;
  int d = date.day;

  if (m == 12) {
    y = y + 1;
    m = 1;
  } else {
    m = m + 1;
  }

  if (d > getMonthDays(y, m)) {
    d = getMonthDays(y, m);
  }

  return intToDate(y, m, d, h: date.hour, min: date.minute);
}

DateTime getUpperTime(DateTime dt, TimeUnit tu) {
  if (tu == TimeUnit.one) {
    return dt;
  } else if (tu == TimeUnit.five) {
    return dt.add(Duration(minutes: -(dt.minute % 5)));
  } else if (tu == TimeUnit.ten) {
    return dt.add(Duration(minutes: -(dt.minute % 10)));
  } else if (tu == TimeUnit.fifteen) {
    return dt.add(Duration(minutes: -(dt.minute % 15)));
  } else if (tu == TimeUnit.twenty) {
    return dt.add(Duration(minutes: -(dt.minute % 20)));
  } else if (tu == TimeUnit.thirty) {
    return dt.add(Duration(minutes: -(dt.minute % 30)));
  } else if (tu == TimeUnit.hour) {
    return dt.add(Duration(minutes: -(dt.minute % 60)));
  }
  return dt;
}

int getTimeUnitInt(TimeUnit tu) {
  switch (tu) {
    case TimeUnit.one:
      return 1;
    case TimeUnit.five:
      return 5;
    case TimeUnit.ten:
      return 10;
    case TimeUnit.fifteen:
      return 15;
    case TimeUnit.twenty:
      return 20;
    case TimeUnit.thirty:
      return 30;
    case TimeUnit.hour:
      return 60;
    default:
      return 1;
  }
}

extension DateExt on DateTime {
  DateTime setHour(int hour) {
    var d = dateToString(this, pattern: "yyyy/MM/dd HH:mm");

    return strToDate(
        "${d.split(" ")[0]} ${hour.toString().padLeft(2, "0")}:${d.split(":")[1]}",
        pattern: "yyyy/MM/dd HH:mm");
  }

  DateTime setMin(int min) {
    var d = dateToString(this, pattern: "yyyy/MM/dd HH:mm");

    return strToDate("${d.split(":")[0]}:${min.toString().padLeft(2, "0")}}",
        pattern: "yyyy/MM/dd HH:mm");
  }
}
