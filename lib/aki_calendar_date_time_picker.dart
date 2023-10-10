library aki_calendar_date_time_picker;

import 'package:aki_calendar_date_time_picker/calendar/aki_calendar_datetime_picker.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCalendar(
  BuildContext context, {
  String title = "Choose Date & Time",
  DateTime? currentDate,
  CalHead? calHead,
  CalCell? calCell,
  TextConfig? textConfig,
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
              textConfig: textConfig),
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        );
      });
}
