import 'dart:async';
import 'package:aki_calendar_date_time_picker/calendar/date_utils.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCalendar(
  BuildContext context, {
  String title = "Choose Date & Time",
  DateTime? currentDate,
  CalHead? calHead,
  CalCell? calCell,
  TextConfig? textConfig,
  bool canSelectPastDate = false,
}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime initDate = (currentDate ??= DateTime.now());

        return AlertDialog(
          title: Text(title),
          content: calWidget(initDate,
              w: MediaQuery.of(context).size.width - 80,
              calHead: calHead,
              calCell: calCell,
              textConfig: textConfig,
              canSelectPastDate: canSelectPastDate),
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        );
      });
}

Widget calWidget(DateTime initDate,
    {double? w,
    TimeUnit timeUnit = TimeUnit.fifteen,
    Color selectedColor = Colors.redAccent,
    CalHead? calHead,
    CalCell? calCell,
    TextConfig? textConfig,
    bool canSelectPastDate = false}) {
  StreamController<DateTime> sc = StreamController<DateTime>.broadcast();
  DateTime selectedDate = getUpperTime(initDate, timeUnit);
  ScrollController hourCtr =
      ScrollController(initialScrollOffset: initDate.hour * 65);
  late ScrollController minCtr;
  if (timeUnit == TimeUnit.one) {
    minCtr = ScrollController(initialScrollOffset: initDate.minute * 65);
  } else {
    minCtr = ScrollController();
  }

  sc.add(initDate);

  Border cellBorder = (calCell?.border == null)
      ? Border.all(color: Colors.transparent)
      : calCell!.border!;

  Border selCellBorder = (calCell?.selBorder == null)
      ? Border.all(color: Colors.redAccent)
      : calCell!.selBorder!;

  TextStyle todayStyle = (calCell?.todayStyle == null)
      ? const TextStyle(fontWeight: FontWeight.bold)
      : calCell!.todayStyle!;

  return StreamBuilder(
      stream: sc.stream,
      builder: (context, snapshot) {
        DateTime monthDate;
        if (!snapshot.hasData) {
          monthDate = getUpperTime(DateTime.now(), timeUnit);
        } else {
          monthDate = getUpperTime(snapshot.data!, timeUnit);
        }
        DateTime fd = firstday(monthDate);
        List<Widget> row1 = [];
        List<Widget> col = [];
        int startIdx = fd.weekday % 7;
        int dayIdx = 1;
        int monthdays = getMonthDays(monthDate.year, monthDate.month);
        int daysTotal = (startIdx + monthdays);
        int loopTotal = daysTotal;
        if (loopTotal % 7 != 0) {
          loopTotal = ((loopTotal ~/ 7) + 1) * 7;
        }

        for (int i = 1; i <= loopTotal; i++) {
          if (i > startIdx && dayIdx <= monthdays) {
            var k = dayIdx;
            row1.add(GestureDetector(
                onTap: () {
                  selectedDate = intToDate(monthDate.year, monthDate.month, k,
                      h: initDate.hour, min: initDate.minute);
                  if (selectedDate.isBefore(DateTime.now())) {
                    if (canSelectPastDate) {
                      sc.add(monthDate);
                    }
                  } else {
                    sc.add(monthDate);
                  }
                },
                child: Container(
                    width: (w != null) ? w / 7 : null,
                    height: (w != null) ? w / 7 : null,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular((w != null) ? w / 7 : 22),
                        border: isSelectDate(dateToString(selectedDate),
                                monthDate.year, monthDate.month, dayIdx)
                            ? selCellBorder
                            : cellBorder),
                    child: Center(
                        child: Text(
                      dayIdx.toString(),
                      style: isToday(monthDate.year, monthDate.month, dayIdx)
                          ? todayStyle
                          : TextStyle(
                              fontWeight: FontWeight.normal,
                              color: ((intToDate(monthDate.year,
                                          monthDate.month, dayIdx)
                                      .isBefore(DateTime.now())
                                  ? ((!canSelectPastDate)
                                      ? Colors.grey
                                      : Colors.black)
                                  : Colors.black))),
                    )))));
            dayIdx += 1;
          } else {
            row1.add(SizedBox(
              width: (w != null) ? w / 7 : null,
              height: (w != null) ? w / 7 : null,
            ));
          }

          if (i % 7 == 0) {
            col.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row1));
            row1 = [];
          }
        }
        List<Widget> hourArray = [];
        for (int i = 0; i < 24; i = i + 1) {
          hourArray.add(GestureDetector(
              onTap: () {
                selectedDate = selectedDate.setHour(i);
                monthDate.setHour(i);
                sc.add(monthDate);
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey, width: 1),
                      color: (selectedDate.hour) == i
                          ? selectedColor
                          : Colors.transparent),
                  width: 60,
                  height: 30,
                  child: Center(child: Text(i.toString().padLeft(2, "0"))))));
          hourArray.add(const SizedBox(
            width: 5,
          ));
        }
        List<Widget> minArray = [];
        for (int i = 0; i < 60; i = i + getTimeUnitInt(timeUnit)) {
          minArray.add(GestureDetector(
              onTap: () {
                selectedDate = selectedDate.setMin(i);
                monthDate.setMin(i);
                sc.add(monthDate);
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey, width: 1),
                      color: (selectedDate.minute) == i
                          ? selectedColor
                          : Colors.transparent),
                  width: 60,
                  height: 30,
                  child: Center(child: Text(i.toString().padLeft(2, "0"))))));
          minArray.add(const SizedBox(
            width: 5,
          ));
        }

        String getCalHead(int idx) {
          if (calHead == null || calHead.weekHeadString == null) {
            switch (idx) {
              case 0:
                return "Sun";
              case 1:
                return "Mon";
              case 2:
                return "Tue";
              case 3:
                return "Wed";
              case 4:
                return "Thu";
              case 5:
                return "Fri";
              case 6:
                return "Sat";
              default:
                return "";
            }
          }
          return calHead.weekHeadString![idx];
        }

        return SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          monthDate = preMonth(monthDate);
                          sc.add(monthDate);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                        )),
                    Expanded(
                        child: Center(
                            child: Text(
                      "${monthDate.year} / ${monthDate.month.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ))),
                    GestureDetector(
                        onTap: () {
                          monthDate = nextMonth(monthDate);
                          sc.add(monthDate);
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                        ))
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child: Text(
                              getCalHead(0),
                              style: calHead?.style,
                            ))),
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child: Text(getCalHead(1),
                                    style: calHead?.style))),
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child: Text(getCalHead(2),
                                    style: calHead?.style))),
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child: Text(getCalHead(3),
                                    style: calHead?.style))),
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child: Text(getCalHead(4),
                                    style: calHead?.style))),
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child: Text(getCalHead(5),
                                    style: calHead?.style))),
                        SizedBox(
                            width: (w != null) ? w / 7 : null,
                            height: (w != null) ? w / 7 : null,
                            child: Center(
                                child:
                                    Text(getCalHead(6), style: calHead?.style)))
                      ],
                    ),
                    Column(
                      children: col,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      textConfig?.hourHint ?? "Hour",
                      style: textConfig?.hintTextStyle ??
                          const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: SizedBox(
                            height: 30,
                            child: ListView(
                              controller: hourCtr,
                              scrollDirection: Axis.horizontal,
                              children: hourArray,
                            ))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      textConfig?.minHint ?? "Minute",
                      style: textConfig?.hintTextStyle ??
                          const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: SizedBox(
                            height: 30,
                            child: ListView(
                              controller: minCtr,
                              scrollDirection: Axis.horizontal,
                              children: minArray,
                            ))),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey)),
                            child: Text(
                              textConfig?.cancelString ?? "Cancel",
                              style: textConfig?.buttonTextStyle ??
                                  const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                            ))),
                    Expanded(
                        child: SizedBox(
                      child: Center(
                          child: Text(
                        dateToString(selectedDate, pattern: "yyyy/MM/dd HH:mm"),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    )),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(selectedDate);
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey)),
                            child: Text(
                              textConfig?.confirmString ?? "Confirm",
                              style: textConfig?.buttonTextStyle ??
                                  const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ));
      });
}

class CalHead {
  List<String>? weekHeadString;
  TextStyle? style;

  CalHead({this.weekHeadString, this.style});
}

class CalCell {
  Border? border;
  TextStyle? style;
  Border? selBorder;
  TextStyle? selStyle;
  TextStyle? todayStyle;

  CalCell(
      {this.border,
      this.style,
      this.selBorder,
      this.selStyle,
      this.todayStyle});
}

class TextConfig {
  TextStyle? buttonTextStyle;
  TextStyle? hintTextStyle;
  String? confirmString;
  String? cancelString;
  String? hourHint;
  String? minHint;
  TextConfig(
      {this.buttonTextStyle,
      this.hintTextStyle,
      this.confirmString,
      this.cancelString,
      this.hourHint,
      this.minHint});
}
