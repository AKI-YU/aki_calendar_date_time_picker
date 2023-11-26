# AKI Calendar DateTime Picker

* A lightweight and calendar date time picker.

<img src="https://raw.githubusercontent.com/nobodyyu/file/master/aki_calendar_datetime_picker.png" alt="screenshot" width="200"/>

## Intro

AKI Calendar DateTime Picker widget:

- `AKI Calendar DateTime Picker`, this widget can make a dialog with calendar and button list to help users to select date and time.


### Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  aki_calendar_date_time_picker: ^0.0.4
```


## How to use

```dart
import 'package:aki_calendar_date_time_picker/aki_calendar_date_time_picker.dart';
```

## basic use

```dart

var rtn = await showCalendar(context);
                    
```

## Customized


```dart
CalHead ch = CalHead(
              weekHeadString: ["日", "一", "二", "三", "四", "五", "六"],
              style: const TextStyle(fontWeight: FontWeight.w500));
          CalCell ce =
              CalCell(todayStyle: const TextStyle(color: Colors.blue));
          TextConfig textConfig = TextConfig(
              confirmString: "確定",
              cancelString: "算了",
              hourHint: "時",
              minHint: "分");
          var rtn = await showCalendar(context,
              calHead: ch, calCell: ce, textConfig: textConfig);
                    
```

Feel free to contribute to this project. 🍺 Pull requests are welcome!

There are some tips before creating a PR:

- Please always create an issue/feature before raising a PR
- Please always create a minimum reproducible example for an issue
- Please use the official [Dart Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) as your formatter or use `flutter format . -l 80` if you are not using VS Code
- Please keep your changes to its minimum needed scope (avoid introducing unrelated changes)
- Please follow this git commit [convention](https://www.conventionalcommits.org/en/v1.0.0-beta.2/) by adding `feat:` or `fix:` to your PR commit