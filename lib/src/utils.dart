import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

extension StringExtension on String? {
  String stagingEncryptedKey() =>
      "7jKXHCNc6vTgE5fizvDJTTdykDLW8aAIxE1yrx6ssSY=";

  String prodEncryptedKey() => "XNf+fGK3z250wnkIqFgmUvHOjPwqnoYPm1L91c87III=";

  String toCapitalize() {
    if (this == null) {
      return "";
    } else if (this!.isEmpty) {
      return "";
    } else {
      return "${this![0].toUpperCase()}${this!.substring(1)}";
    }
  }

  String ConvertTimeToUtc() {
    if (this == null) return "";

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime date = DateTime.parse(this!);
    final String utcDate = formatter.format(date.toUtc());
    return utcDate;
  }

  String encodeToBase64() {
    if (this == null) return "";
    final bytes = utf8.encode(this!);
    final base64Str = base64Encode(bytes);
    return base64Str;
  }

  bool isValid() {
    if (this == null) {
      return false;
    } else if (this!.isEmpty) {
      return false;
    } else if (this == "null") {
      return false;
    } else {
      return true;
    }
  }

  bool equalsIgnoreCase(String? string2) {
    return this?.toLowerCase() == string2?.toLowerCase();
  }

  bool isValidShopActNumber() {
    if (this == null) {
      return false;
    } else if (this!.isEmpty) {
      return false;
    } else if (this!.length == 12) {
      return true;
    } else {
      return false;
    }
  }

  double toParseDouble() {
    if (this == null) {
      return 0.0;
    } else if (this!.isEmpty) {
      return 0.0;
    } else {
      return double.tryParse(this!) ?? 0.0;
    }
  }

  int toParseInt() {
    if (this == null) {
      return 0;
    } else if (this!.isEmpty) {
      return 0;
    } else {
      return int.tryParse(this!) ?? 0;
    }
  }

  bool isValidUpiDetailsRegularExpression() {
    if (!this.isValid()) {
      return false;
    }

    final numericRegex = RegExp(r'^(.+)@(.+)$');
    return numericRegex.hasMatch(this!);
  }

  bool isIntNumericUsingRegularExpression() {
    if (!this.isValid()) {
      return false;
    }
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)))$');

    return numericRegex.hasMatch(this!);
  }

  bool isDoubleNumericUsingRegularExpression() {
    if (!this.isValid()) {
      return false;
    }
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(this!);
  }


}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

String toTitleCase(String str) {
  if (!str.isValid()) {
    return "";
  }
  return str
      .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
              "${m[0]![0].toUpperCase()}${m[0]!.substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-)+'), ' ');
}

class TitleCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: toTitleCase(newValue.text),
      selection: newValue.selection,
    );
  }
}

Color getRandomColor(double opacity) {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
      .withOpacity(opacity);
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

int calculateDifferenceHours(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day, now.hour, now.minute)
      .difference(
          DateTime(date.year, date.month, date.day, date.hour, date.minute))
      .inHours;
}

String getDateDifference(DateTime createdAt) {
  String difference = "Today";
  int diff = calculateDifference(createdAt);
  print("$createdAt $diff");
  if (diff == 0) {
    difference = "Today";
  } else if (diff == -1) {
    difference = "Yesterday";
  } else {
    difference = "${diff.abs()}d";
  }
  return difference;
}

String getInitials(String inputString, int characters) {
  if (inputString.length == 0) return '';

  List<String> wordsList = inputString.split(' ');
  String initials = '';
  wordsList.forEach((element) {
    initials = initials + element[0].toUpperCase();
  });

  if (initials.length > characters) return inputString.substring(0, characters);

  return initials.substring(0, 1);
}

extension IntExtension on int {
  DateTime convertDateTimeStamp() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}

extension DoubleExtension on double? {
  bool isValid() {
    if (this == null) {
      return false;
    } else if (this == 0.0) {
      return false;
    } else {
      return true;
    }
  }
}

extension ListExtensions<E> on List<E> {
  List<E> removeAll(Iterable<E> allToRemove) {
    allToRemove.forEach((element) {
      this.remove(element);
    });
    return this;
  }

  List<E> distinctBy(predicate(E selector)) {
    HashSet set = HashSet();
    List<E> list = [];
    toList().forEach((e) {
      dynamic key = predicate(e);
      if (set.add(key)) {
        list.add(e);
      }
    });

    return list;
  }

  List<E> sortedBy(Comparable Function(E e) key) =>
      toList()..sort((a, b) => key(a).compareTo(key(b)));

  List<E> getDupes({required E Function(E) distinctBy}) {
    List<E> dupes = List.from(this);
    dupes.removeAll(this.distinctBy(distinctBy).toSet().toList());
    return dupes;
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension AadharNumberValidator on String {
  bool isValidAadharNumber() {
    return RegExp(r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$').hasMatch(this);
  }
}

extension PanCardValidator on String {
  bool isValidPanCardNo() {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(this);
  }
}

extension DrivingLicenseValidator on String {
  bool isValidLicenseNo() {
    return RegExp(
            r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$')
        .hasMatch(this);
  }
}

extension FSSAINumberValidator on String {
  bool isValidFssaiNo() {
    return RegExp(
      r'^[1-9][0-9]{12}$',
    ).hasMatch(this);
  }
}

extension GSTNumberValidator on String {
  bool isValidGSTNo() {
    return RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(this);
  }
}

extension DOBValidator on String {
  bool isAdult() {
    String datePattern = "dd/MM/yyyy";
    // Current time - at this moment
    DateTime today = DateTime.now();
    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(this);
    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );

    return adultDate.isBefore(today);
  }
}

const String DATE_TIME_FORMAT = "dd/MM/yyyy HH:mm:ss";
const String TIME_FORMAT = "hh:mm";
const String TIME_12HOUR_FORMAT = "hh:mm a";
const String DATE_TIME_12HOUR_FORMAT = "dd/MM/yyyy hh:mm:ss a";

class CommonUtils {
  static Future<bool> checkInternetConnectivity() async {
    // ConnectivityResult result = ConnectivityResult.none;
    // result = await Connectivity().checkConnectivity();
    // if (result == ConnectivityResult.mobile ||
    //     result == ConnectivityResult.wifi) {
    //   return true;
    // } else {
    //   return false;
    // }

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> checkStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.mediaLibrary,
      Permission.camera,
    ].request();

    PermissionStatus cameraPermissionStatus = statuses[Permission.camera]!;
    PermissionStatus storagePermissionStatus = statuses[Permission.mediaLibrary]!;

    if (cameraPermissionStatus.isGranted && storagePermissionStatus.isGranted ) {
      print("checkPermission status isGranted");
      return true;
    } else if (cameraPermissionStatus.isDenied ||
        storagePermissionStatus.isDenied ) {
      return false;
    } else if (cameraPermissionStatus.isPermanentlyDenied ||
        storagePermissionStatus.isPermanentlyDenied ) {
      print("checkPermission status isPermanentlyDenied");
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  static hideKeyBoard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static String addLeadingZeroIfNeeded(int? value) {
    if (value != null && value < 10) return '0$value';
    return (value ?? 0).toString();
  }

  static String toUTC(
      String? dateTime, String inputFormat, String outputFormat) {
    if (!dateTime.isValid()) {
      return "";
    }

    String outPutDate = DateFormat(outputFormat).format(
      DateFormat(inputFormat).parse(dateTime!, false).toUtc(),
    );

    return outPutDate;
  }

  static String toLocal(
      String? dateTime, String inputFormat, String outputFormat) {
    if (!dateTime.isValid()) {
      return "";
    }

    String outPutDate = DateFormat(outputFormat).format(
      DateFormat(inputFormat).parse(dateTime!, true).toLocal(),
    );

    return outPutDate;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static bool isValidPhone(String? s) {
    if (s == null) {
      return false;
    }
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (s.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(s)) {
      return false;
    }
    return true;
  }

  static bool isValidEmail(String? s) {
    if (s == null) {
      return false;
    }
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
  }

  static bool regex(String? value) {
    if (value == null) {
      return false;
    }
    return value.contains("(") ||
        value.contains(")") ||
        value.contains("{") ||
        value.contains("}") ||
        value.contains("[") ||
        value.contains("]");
  }

  static String parseName(String name, int? count) {
    // separate each word
    var parts = name.split(' ');
    var initial = '';

    // check length
    if (parts.length > 1) {
      // check max limit
      if (count != null) {
        for (var i = 0; i < count; i++) {
          // combine the first letters of each word
          initial += parts[i][0];
        }
      } else {
        // this default, if word > 1
        initial = parts[0][0] + " " + parts[1][0];
      }
    } else {
      // this default, if word <=1
      initial = parts[0][0];
    }
    return initial;
  }
}
