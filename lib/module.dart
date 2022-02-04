import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

ThemeData get activeTheme => Theme.of(gizContext);

GizThemeData get activeGizTheme => Theme.of(gizContext) as GizThemeData;

//region giz_module

class giz_module {
  static String DateFomat = "dd.MM.yyyy";

  static var formatter = new NumberFormat.currency(locale: "tr_TR", symbol: "");

  static Future<SharedPreferences> setup() async =>
      await SharedPreferences.getInstance();

  static Future setSetup(String Key, String Value) async =>
      (await setup()).setString(Key, Value);

  //istenilen değeri okur
  static Future<String> getSetup(String Key, {String Value = ""}) async {
    try {
      return (await setup()).getString(Key) ?? Value;
    } catch (Ex) {
      return Value;
    }
  }

  static Future<String> getToken() async => getSetup("TOKEN");

  //Tokeni cihaza kayıt Eder
  static Future setToken(String token) async => setSetup("TOKEN", token);
}

extension DateEx on DateTime {
  String toFormat({String format}) =>
      DateFormat(format ?? giz_module.DateFomat).format(this);
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

BuildContext get gizContext => navigatorKey.currentContext;

typedef WidgetGetter<T> = T Function(GizState state);

abstract class GizStatefulWidget extends StatefulWidget {
  Widget buildWidget(GizState state);

  GizState state;
  BuildContext buildContext;

  void setState(VoidCallback fn) {
    try {
      state.setState(fn);
    } catch (ex) {
      print("State Exception -------------------" + ex.toString());
    }
  }

  void initState() {}

  @override
  State<StatefulWidget> createState() {
    if (Platform.isAndroid) {
      return state = GizState(
              (x) =>
              WillPopScope(
                onWillPop: onBackPressed,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(gizContext).requestFocus(new FocusNode());
                  },
                  child: buildWidget(x),
                ),
              ),
          initState);
    }
    return state = GizState(
            (x) =>
            GestureDetector(
              onTap: () {
                FocusScope.of(gizContext).requestFocus(new FocusNode());
              },
              child: buildWidget(x),
            ),
        initState);
  }

  Future<bool> onBackPressed() async {
    return true;
  }
}

class GizState<T extends GizStatefulWidget> extends State<T> {
  WidgetGetter<Widget> buildWidget;
  Function function;

  GizState(this.buildWidget, this.function);

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    widget.buildContext = context;
    return buildWidget(this);
  }

  @override
  void initState() {
    super.initState();
    function();
  }
}

//endregion

//region GizTheme

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString != null && hexString.length == 6 || hexString.length == 7)
      buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class GizTheme {
  static MaterialColor colorPrimary = MaterialColor(
    0xFF24364a,
    <int, Color>{
      50: Color(0xFF0a0f15),
      100: Color(0xFF0a0f15),
      200: Color(0xFF111922),
      300: Color(0xFF172330),
      400: Color(0xFF1e2c3d),
      500: Color(0xFF24364a),
      600: Color(0xFF2a4057),
      700: Color(0xFF314964),
      800: Color(0xFF375372),
      900: Color(0xFF3e5d7f),
    },
  );
  static MaterialColor colorPrimaryDark = MaterialColor(
    0xFF001E66,
    <int, Color>{
      50: Color(0xFF000032),
      100: Color(0xFF00003F),
      200: Color(0xFF000A4C),
      300: Color(0xFF001459),
      400: Color(0xFF001459),
      500: Color(0xFF001E66),
      600: Color(0xFF062873),
      700: Color(0xFF0C3280),
      800: Color(0xFF123C8D),
      900: Color(0xFF18469A),
    },
  );
  static MaterialColor colorConfirm = MaterialColor(
    0xFF7CB342,
    <int, Color>{
      50: Color(0xFF648B0E),
      100: Color(0xFF6A951B),
      200: Color(0xFF709F28),
      300: Color(0xFF76A935),
      400: Color(0xFF76A935),
      500: Color(0xFF7CB342),
      600: Color(0xFF82BD4F),
      700: Color(0xFF88C75C),
      800: Color(0xFF8ED169),
      900: Color(0xFF94DB76),
    },
  );
  static MaterialColor colorCancel = MaterialColor(
    0xFFC75450,
    <int, Color>{
      50: Color(0xFFAF2C1C),
      100: Color(0xFFB53629),
      200: Color(0xFFBB4036),
      300: Color(0xFFC14A43),
      400: Color(0xFFC14A43),
      500: Color(0xFFC75450),
      600: Color(0xFFCD5E5D),
      700: Color(0xFFD3686A),
      800: Color(0xFFD97277),
      900: Color(0xFFDF7C84),
    },
  );
  static MaterialColor colorInfoBorder = MaterialColor(
    0xFF2296F3,
    <int, Color>{
      50: Color(0xFF0A6EBF),
      100: Color(0xFF1078CC),
      200: Color(0xFF1682D9),
      300: Color(0xFF1C8CE6),
      400: Color(0xFF1C8CE6),
      500: Color(0xFF2296F3),
      600: Color(0xFF28A0FF),
      700: Color(0xFF2EAAFF),
      800: Color(0xFF34B4FF),
      900: Color(0xFF3ABEFF),
    },
  );
  static MaterialColor colorInfo = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFE7D7CB),
      100: Color(0xFFEDE1D8),
      200: Color(0xFFF3EBE5),
      300: Color(0xFFF9F5F2),
      400: Color(0xFFF9F5F2),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static MaterialColor colorErrorBorder = MaterialColor(
    0xFFC75450,
    <int, Color>{
      50: Color(0xFFAF2C1C),
      100: Color(0xFFB53629),
      200: Color(0xFFBB4036),
      300: Color(0xFFC14A43),
      400: Color(0xFFC14A43),
      500: Color(0xFFC75450),
      600: Color(0xFFCD5E5D),
      700: Color(0xFFD3686A),
      800: Color(0xFFD97277),
      900: Color(0xFFDF7C84),
    },
  );
  static MaterialColor colorError = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFE7D7CB),
      100: Color(0xFFEDE1D8),
      200: Color(0xFFF3EBE5),
      300: Color(0xFFF9F5F2),
      400: Color(0xFFF9F5F2),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static MaterialColor colorAskBorder = MaterialColor(
    0xFF0078D7,
    <int, Color>{
      50: Color(0xFF0050A3),
      100: Color(0xFF005AB0),
      200: Color(0xFF0064BD),
      300: Color(0xFF006ECA),
      400: Color(0xFF006ECA),
      500: Color(0xFF0078D7),
      600: Color(0xFF0682E4),
      700: Color(0xFF0C8CF1),
      800: Color(0xFF1296FE),
      900: Color(0xFF18A0FF),
    },
  );
  static MaterialColor colorAsk = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFE7D7CB),
      100: Color(0xFFEDE1D8),
      200: Color(0xFFF3EBE5),
      300: Color(0xFFF9F5F2),
      400: Color(0xFFF9F5F2),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static MaterialColor colorSuccessBorder = MaterialColor(
    0xFF7CB342,
    <int, Color>{
      50: Color(0xFF648B0E),
      100: Color(0xFF6A951B),
      200: Color(0xFF709F28),
      300: Color(0xFF76A935),
      400: Color(0xFF76A935),
      500: Color(0xFF7CB342),
      600: Color(0xFF82BD4F),
      700: Color(0xFF88C75C),
      800: Color(0xFF8ED169),
      900: Color(0xFF94DB76),
    },
  );
  static MaterialColor colorSuccess = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFE7D7CB),
      100: Color(0xFFEDE1D8),
      200: Color(0xFFF3EBE5),
      300: Color(0xFFF9F5F2),
      400: Color(0xFFF9F5F2),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  static ThemeData createThemeData() =>
      ThemeData(primaryColor: GizTheme.colorPrimary);
}

class GizThemeData {
  ThemeData themeData;

  Brightness brightness;
  VisualDensity visualDensity;
  MaterialColor primarySwatch;
  Color primaryColor = GizTheme.colorPrimary.shade400;
  Brightness primaryColorBrightness;
  Color primaryColorLight;
  Color primaryColorDark;
  Color accentColor;
  Brightness accentColorBrightness;
  Color canvasColor;
  Color shadowColor;
  Color scaffoldBackgroundColor;
  Color bottomAppBarColor;
  Color cardColor;
  Color dividerColor;
  Color focusColor;
  Color hoverColor;
  Color highlightColor;
  Color splashColor;
  InteractiveInkFeatureFactory splashFactory;
  Color selectedRowColor;
  Color unselectedWidgetColor;
  Color disabledColor;
  Color buttonColor;
  ButtonThemeData buttonTheme;
  ToggleButtonsThemeData toggleButtonsTheme;
  Color secondaryHeaderColor;
  Color textSelectionColor;
  Color cursorColor;
  Color textSelectionHandleColor;
  Color backgroundColor;
  Color dialogBackgroundColor;
  Color indicatorColor;
  Color hintColor;
  Color errorColor;
  Color toggleableActiveColor;
  String fontFamily; //
  TextTheme textTheme;
  TextTheme primaryTextTheme; //
  TextTheme accentTextTheme; //
  InputDecorationTheme inputDecorationTheme;
  IconThemeData iconTheme;
  IconThemeData primaryIconTheme;
  IconThemeData accentIconTheme; //
  SliderThemeData sliderTheme;
  TabBarTheme tabBarTheme;
  TooltipThemeData tooltipTheme;
  CardTheme cardTheme;
  ChipThemeData chipTheme; //
  TargetPlatform platform;
  MaterialTapTargetSize materialTapTargetSize;
  bool applyElevationOverlayColor; //
  PageTransitionsTheme pageTransitionsTheme;
  AppBarTheme appBarTheme;
  ScrollbarThemeData scrollbarTheme;
  BottomAppBarTheme bottomAppBarTheme;
  ColorScheme colorScheme;
  DialogTheme dialogTheme;
  FloatingActionButtonThemeData floatingActionButtonTheme;
  NavigationRailThemeData navigationRailTheme;
  Typography typography;
  SnackBarThemeData snackBarTheme;
  BottomSheetThemeData bottomSheetTheme;
  PopupMenuThemeData popupMenuTheme;
  MaterialBannerThemeData bannerTheme;
  DividerThemeData dividerTheme;
  ButtonBarThemeData buttonBarTheme;
  BottomNavigationBarThemeData bottomNavigationBarTheme;
  TimePickerThemeData timePickerTheme;
  TextButtonThemeData textButtonTheme;
  ElevatedButtonThemeData elevatedButtonTheme;
  OutlinedButtonThemeData outlinedButtonTheme;
  TextSelectionThemeData textSelectionTheme;
  DataTableThemeData dataTableTheme;
  CheckboxThemeData checkboxTheme;
  RadioThemeData radioTheme;
  SwitchThemeData switchTheme;
  bool fixTextFieldOutlineLabel;
  bool useTextSelectionTheme;

  GizThemeData({this.brightness,
    this.visualDensity,
    this.primarySwatch,
    this.primaryColor,
    this.primaryColorBrightness,
    this.primaryColorLight,
    this.primaryColorDark,
    this.accentColor,
    this.accentColorBrightness,
    this.canvasColor,
    this.shadowColor,
    this.scaffoldBackgroundColor,
    this.bottomAppBarColor,
    this.cardColor,
    this.dividerColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.splashFactory,
    this.selectedRowColor,
    this.unselectedWidgetColor,
    this.disabledColor,
    this.buttonColor,
    this.buttonTheme,
    this.toggleButtonsTheme,
    this.secondaryHeaderColor,
    this.textSelectionColor,
    this.cursorColor,
    this.textSelectionHandleColor,
    this.backgroundColor,
    this.dialogBackgroundColor,
    this.indicatorColor,
    this.hintColor,
    this.errorColor,
    this.toggleableActiveColor,
    this.fontFamily,
    this.textTheme,
    this.primaryTextTheme,
    this.primaryIconTheme,
    this.accentIconTheme,
    this.sliderTheme,
    this.tabBarTheme,
    this.tooltipTheme,
    this.cardTheme,
    this.chipTheme,
    this.platform,
    this.materialTapTargetSize,
    this.applyElevationOverlayColor,
    this.pageTransitionsTheme,
    this.appBarTheme,
    this.scrollbarTheme,
    this.bottomAppBarTheme,
    this.colorScheme,
    this.dialogTheme,
    this.floatingActionButtonTheme,
    this.navigationRailTheme,
    this.typography,
    this.snackBarTheme,
    this.bottomSheetTheme,
    this.popupMenuTheme,
    this.bannerTheme,
    this.dividerTheme,
    this.buttonBarTheme,
    this.bottomNavigationBarTheme,
    this.timePickerTheme,
    this.textButtonTheme,
    this.elevatedButtonTheme,
    this.outlinedButtonTheme,
    this.textSelectionTheme,
    this.dataTableTheme,
    this.checkboxTheme,
    this.radioTheme,
    this.switchTheme,
    this.fixTextFieldOutlineLabel,
    this.useTextSelectionTheme}) {
    themeData = ThemeData(
        brightness: brightness,
        primaryColor: primaryColor,
        visualDensity: visualDensity,
        primarySwatch: primarySwatch,
        primaryColorBrightness: primaryColorBrightness,
        primaryColorLight: primaryColorLight,
        primaryColorDark: primaryColorDark,
        accentColor: accentColor,
        accentColorBrightness: accentColorBrightness,
        canvasColor: canvasColor,
        shadowColor: shadowColor ?? HexColor.fromHex("#edebeb"),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        bottomAppBarColor: bottomAppBarColor,
        cardColor: cardColor,
        dividerColor: dividerColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        splashFactory: splashFactory,
        selectedRowColor: selectedRowColor,
        unselectedWidgetColor: unselectedWidgetColor,
        disabledColor: disabledColor,
        buttonColor: buttonColor,
        buttonTheme: buttonTheme,
        toggleButtonsTheme: toggleButtonsTheme,
        secondaryHeaderColor: secondaryHeaderColor,
        textSelectionColor: textSelectionColor,
        cursorColor: cursorColor,
        textSelectionHandleColor: textSelectionHandleColor,
        backgroundColor: backgroundColor,
        dialogBackgroundColor: dialogBackgroundColor,
        indicatorColor: indicatorColor,
        hintColor: hintColor,
        errorColor: errorColor,
        toggleableActiveColor: toggleableActiveColor,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryTextTheme: primaryTextTheme,
        primaryIconTheme: primaryIconTheme,
        accentIconTheme: accentIconTheme,
        accentTextTheme: accentTextTheme,
        sliderTheme: sliderTheme,
        appBarTheme: appBarTheme,
        bottomAppBarTheme: bottomAppBarTheme,
        applyElevationOverlayColor: applyElevationOverlayColor,
        bannerTheme: bannerTheme,
        bottomNavigationBarTheme: bottomNavigationBarTheme,
        buttonBarTheme: buttonBarTheme,
        cardTheme: cardTheme,
        checkboxTheme: checkboxTheme,
        colorScheme: colorScheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        dataTableTheme: dataTableTheme,
        dialogTheme: dialogTheme,
        dividerTheme: dividerTheme,
        inputDecorationTheme: inputDecorationTheme,
        scrollbarTheme: scrollbarTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        fixTextFieldOutlineLabel: fixTextFieldOutlineLabel,
        materialTapTargetSize: materialTapTargetSize,
        navigationRailTheme: navigationRailTheme,
        pageTransitionsTheme: pageTransitionsTheme,
        platform: platform,
        popupMenuTheme: popupMenuTheme,
        timePickerTheme: timePickerTheme,
        typography: typography,
        tabBarTheme: tabBarTheme,
        textButtonTheme: textButtonTheme,
        textSelectionTheme: textSelectionTheme,
        tooltipTheme: tooltipTheme,
        iconTheme: iconTheme,
        radioTheme: radioTheme,
        snackBarTheme: snackBarTheme,
        bottomSheetTheme: bottomSheetTheme,
        outlinedButtonTheme: outlinedButtonTheme,
        useTextSelectionTheme: useTextSelectionTheme,
        switchTheme: switchTheme);
  }
}

enum GizTextImageAlign { LEFT, RIGHT }

Widget GizText(String text, {
  String assetIconName,
  String svgIcon,
  Color textColor = Colors.white,
  Color tintColor = Colors.white,
  Color hoverColor = Colors.white,
  double fontSize = 14,
  double iconWidth = 20,
  double iconHeight = 20,
  GizTextImageAlign imageAlign = GizTextImageAlign.LEFT,
  TextStyle textStyle,
  double leftPadding = 0,
  double rightPadding = 0,
  double topPadding = 0,
  double bottomPadding = 0,
  IconData icon,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
  VoidCallback iconClik,
}) {
  Widget image;

  TextStyle _textStyle = textStyle != null
      ? textStyle
      : TextStyle(color: textColor, fontSize: fontSize);

  if (assetIconName != null)
    image = Image.asset(
      "assets/images/" + assetIconName + ".png",
      height: iconHeight,
      width: iconWidth,
      color: tintColor,
    );

  if (svgIcon != null)
    image = SvgPicture.string(
      svgIcon,
      width: iconWidth,
      height: iconHeight,
      color: tintColor,
    );

  if (icon != null)
    image = Icon(
      icon,
      color: tintColor,
    );

  return Padding(
    padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding),
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (imageAlign == GizTextImageAlign.LEFT && image != null)
          FlatButton(
            onPressed: iconClik,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: image,
            ),
          ),
        Text(
          text,
          style: _textStyle,
        ),
        if (imageAlign == GizTextImageAlign.RIGHT && image != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: iconClik,
              hoverColor: hoverColor,
              child: image,
            ),
          )
      ],
    ),
  );
}

Widget GizTextField_1({
  String text,
  IconData icon = Icons.edit,
  Color textColor = Colors.white,
  Color iconColor: Colors.white,
  String hintText = "",
  Color hintTextColor = Colors.white70,
  TextEditingController controller,
  bool isPassword = false,
  String passwordChar = "*",
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30),
    child: TextFormField(
      obscureText: isPassword,
      obscuringCharacter: passwordChar,
      initialValue: text,
      controller: controller,
      style: TextStyle(fontSize: 13, color: Color.fromRGBO(0, 34, 124, 5)),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromRGBO(0, 34, 124, 5)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: textColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(
            icon,
            color: Color.fromRGBO(0, 34, 124, 5),
          ),
          fillColor: Color.fromRGBO(229, 229, 229, 5),
          filled: true,
          labelStyle:
          TextStyle(fontSize: 12, color: Color.fromRGBO(0, 34, 124, 5))),
    ),
  );
}

Widget GizTextField({
  bool enable,
  TextAlign align,
  var ontap,
  double fontsize,
  bool text_type,
  var keyboard,
  var textinputaction,
  var validator,
  var onEnter,
  bool autofocus = false,
  String text,
  bool filled = false,
  IconData icon = Icons.edit,
  Color textColor,
  Color iconColor,
  String hintText = "",
  Color hintTextColor,
  TextEditingController controller,
  bool isPassword = false,
  String passwordChar = "*",
  double radius = 10,
  double leftPadding = 5.0,
  double rightPadding = 5,
  double topPadding = 2,
  double bottomPadding = 2,
  List<TextInputFormatter> formatters,
  ValueChanged<String> valueChanged,
}) {
  if (textColor == null)
    textColor = filled ? Colors.white : GizTheme.colorPrimary;

  if (autofocus == null) autofocus = autofocus ? false : true;

  return Padding(
    padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding),
    child: TextFormField(
      onFieldSubmitted: onEnter,
      enabled: enable ?? true,
      textAlign: align ?? TextAlign.start,
      keyboardType: keyboard,
      textInputAction: textinputaction,
      validator: validator,
      autofocus: autofocus,
      inputFormatters: formatters,
      obscureText: isPassword,
      obscuringCharacter: passwordChar,
      controller: controller,
      onChanged: valueChanged,
      style: TextStyle(fontSize: fontsize, color: textColor),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: hintText,
          hintStyle: TextStyle(color: hintTextColor),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(radius)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor),
              borderRadius: BorderRadius.circular(radius)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor),
            borderRadius: BorderRadius.circular(radius),
          ),
          prefixIcon: icon == null
              ? null
              : Icon(
            icon,
            color: iconColor,
          ),
          fillColor: Color.fromRGBO(31, 64, 128, 5),
          filled: filled,
          labelStyle: TextStyle(fontSize: 12, color: textColor)),
    ),
  );
}

Widget GizTextField_2({
  String text,
  bool filled = false,
  Color textColor,
  Color iconColor,
  String hintText = "",
  Color hintTextColor,
  TextEditingController controller,
  bool isPassword = false,
  String passwordChar = "*",
  double radius = 10,
  double leftPadding = 5.0,
  double rightPadding = 5,
  double topPadding = 2,
  double bottomPadding = 2,
  List<TextInputFormatter> formatters,
  ValueChanged<String> valueChanged,
}) {
  if (textColor == null)
    textColor = filled ? Colors.white : GizTheme.colorPrimary;

  return Padding(
    padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding),
    child: TextFormField(
      inputFormatters: formatters,
      obscureText: isPassword,
      obscuringCharacter: passwordChar,
      initialValue: text,
      controller: controller,
      onChanged: valueChanged,
      style: TextStyle(fontSize: 13, color: textColor),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: hintText,
          hintStyle: TextStyle(color: hintTextColor),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(radius)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor),
              borderRadius: BorderRadius.circular(radius)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor),
            borderRadius: BorderRadius.circular(radius),
          ),
          fillColor: Color.fromRGBO(31, 64, 128, 5),
          filled: filled,
          labelStyle: TextStyle(fontSize: 12, color: textColor)),
    ),
  );
}

//endregion

//region DialogBox

class DialogBox {
  static void show(String title,
      {GizDialogButtonType buttonType = GizDialogButtonType.Ok,
        GizDialogType dialogType = GizDialogType.Info,
        ValueChanged<GizDialogButtons> buttonClick,
        BuildContext buildContext}) //asd
  {
    MaterialColor borderColor;
    MaterialColor tintColor;
    String rawSvg = "";

    if (buildContext == null) buildContext = gizContext;

    switch (dialogType) {
      case GizDialogType.Info:
        borderColor = GizTheme.colorInfoBorder;
        tintColor = GizTheme.colorInfo;
        rawSvg = svgInfo;
        break;
      case GizDialogType.Error:
        borderColor = GizTheme.colorErrorBorder;
        tintColor = GizTheme.colorError;
        rawSvg = svgError;
        break;
      case GizDialogType.Ask:
        borderColor = GizTheme.colorAskBorder;
        tintColor = GizTheme.colorAsk;
        rawSvg = svgAsk;
        break;
      case GizDialogType.Success:
        borderColor = GizTheme.colorSuccessBorder;
        tintColor = GizTheme.colorSuccess;
        rawSvg = svgCheck;
        break;
    }

    showDialog(
        context: buildContext,
        builder: (context) =>
            Center(
              child: Wrap(
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(25.0),
                        width: double.infinity,
                        constraints: BoxConstraints(minHeight: 200),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(width: 5, color: borderColor)),
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                              textAlign: TextAlign.center,
                            ),
                            if (buttonType == GizDialogButtonType.Ok)
                              ElevatedButton(
                                child: Text('Tamam'),
                                onPressed: () {
                                  Navigator.pop(gizContext);
                                  if (buttonClick != null)
                                    buttonClick(GizDialogButtons.Ok);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: borderColor,
                                    padding: EdgeInsets.all(5.0),
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            if (buttonType == GizDialogButtonType.YesNo)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    child: Text('Hayır'),
                                    onPressed: () {
                                      Navigator.pop(gizContext);
                                      if (buttonClick != null)
                                        buttonClick(GizDialogButtons.No);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: GizTheme.colorCancel,
                                        padding: EdgeInsets.all(5.0),
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    child: Text('Evet'),
                                    onPressed: () {
                                      Navigator.pop(gizContext);
                                      if (buttonClick != null)
                                        buttonClick(GizDialogButtons.Yes);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: GizTheme.colorConfirm,
                                        padding: EdgeInsets.all(5.0),
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                      Positioned(
                        top: -35,
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tintColor,
                            border: Border.all(width: 5, color: borderColor),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -35,
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SvgPicture.string(
                                rawSvg,
                                fit: BoxFit.cover,
                                color: borderColor,
                              ),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }

  static void showLoading() {
    try {
      showDialog(
        barrierDismissible: false,
        context: gizContext,
        builder: (context) =>
            Center(
              child: CircularProgressIndicator(),
            ),
      );
    } catch (Ex) {}
  }

  static void close() {
    try {
      Navigator.pop(gizContext);
    } catch (err) {}
  }
}

enum GizDialogButtonType { Ok, YesNo }
enum GizDialogButtons { Ok, Yes, No }
enum GizDialogType { Info, Error, Success, Ask }

final String svgInfo = '''<?xml version="1.0" encoding="iso-8859-1"?>
<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 viewBox="0 0 111.577 111.577" style="enable-background:new 0 0 111.577 111.577;" xml:space="preserve">
<g>
	<path d="M78.962,99.536l-1.559,6.373c-4.677,1.846-8.413,3.251-11.195,4.217c-2.785,0.969-6.021,1.451-9.708,1.451
		c-5.662,0-10.066-1.387-13.207-4.142c-3.141-2.766-4.712-6.271-4.712-10.523c0-1.646,0.114-3.339,0.351-5.064
		c0.239-1.727,0.619-3.672,1.139-5.846l5.845-20.688c0.52-1.981,0.962-3.858,1.316-5.633c0.359-1.764,0.532-3.387,0.532-4.848
		c0-2.642-0.547-4.49-1.636-5.529c-1.089-1.036-3.167-1.562-6.252-1.562c-1.511,0-3.064,0.242-4.647,0.71
		c-1.59,0.47-2.949,0.924-4.09,1.346l1.563-6.378c3.829-1.559,7.489-2.894,10.99-4.002c3.501-1.111,6.809-1.667,9.938-1.667
		c5.623,0,9.962,1.359,13.009,4.077c3.047,2.72,4.57,6.246,4.57,10.591c0,0.899-0.1,2.483-0.315,4.747
		c-0.21,2.269-0.601,4.348-1.171,6.239l-5.82,20.605c-0.477,1.655-0.906,3.547-1.279,5.676c-0.385,2.115-0.569,3.731-0.569,4.815
		c0,2.736,0.61,4.604,1.833,5.597c1.232,0.993,3.354,1.487,6.368,1.487c1.415,0,3.025-0.251,4.814-0.744
		C76.854,100.348,78.155,99.915,78.962,99.536z M80.438,13.03c0,3.59-1.353,6.656-4.072,9.177c-2.712,2.53-5.98,3.796-9.803,3.796
		c-3.835,0-7.111-1.266-9.854-3.796c-2.738-2.522-4.11-5.587-4.11-9.177c0-3.583,1.372-6.654,4.11-9.207
		C59.447,1.274,62.729,0,66.563,0c3.822,0,7.091,1.277,9.803,3.823C79.087,6.376,80.438,9.448,80.438,13.03z"/>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
</svg>
''';
final String svgError =
'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 30">    <path d="M 12.355469 3 L 12.785156 19 L 17.199219 19 L 17.644531 3 L 12.355469 3 z M 15.007812 22 C 13.364813 22 12.339844 22.953813 12.339844 24.507812 C 12.339844 26.047813 13.365813 27 15.007812 27 C 16.649812 27 17.662109 26.047812 17.662109 24.507812 C 17.662109 22.953813 16.650813 22 15.007812 22 z"></path></svg>''';
final String svgAsk =
'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">    <path d="M 12 2 C 8.691 2 6 4.691 6 8 L 8 8 C 8 5.794 9.794 4 12 4 C 14.206 4 16 5.794 16 8 C 16 9.678 14.963672 10.698859 13.763672 11.880859 C 12.468672 13.155859 11 14.601 11 17 L 13 17 C 13 15.438 14.004016 14.449641 15.166016 13.306641 C 16.495016 11.998641 18 10.516 18 8 C 18 4.691 15.309 2 12 2 z M 11 20 L 11 22 L 13 22 L 13 20 L 11 20 z"></path></svg>''';
final String svgCheck =
'''<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" width="405.272px" height="405.272px" viewBox="0 0 405.272 405.272" style="enable-background:new 0 0 405.272 405.272;" xml:space="preserve">
<g>
	<path d="M393.401,124.425L179.603,338.208c-15.832,15.835-41.514,15.835-57.361,0L11.878,227.836   c-15.838-15.835-15.838-41.52,0-57.358c15.841-15.841,41.521-15.841,57.355-0.006l81.698,81.699L336.037,67.064   c15.841-15.841,41.523-15.829,57.358,0C409.23,82.902,409.23,108.578,393.401,124.425z"/>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
</svg>''';

//endregion

//region  httpRequest
extension HttpResponseParsing on http.Response {
  get decode => jsonDecode(utf8.decode(this.bodyBytes));

  bool get isOk => this.statusCode >= 200 && this.statusCode < 300;
}

class httpRequest {
  static Function AutohorizationError;
  static Map<String, String> DefaultHeaders = {};

  static Future<http.Response> post(String url,
      String jsonBody, {
        int timeout = 5 * 60 * 1000,
        bool iscontrollresponsecode = true,
        String token,
        bool isShowLoading = true,
      }) async {
    print(jsonBody);
    print(url);

    token = token ?? await giz_module.getToken();

    if (isShowLoading) DialogBox.showLoading();
    var response = await http
        .post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          "Authorization": "bearer " + token,
          for (var i in DefaultHeaders.entries.toList()) i.key: i.value
        },
        body: jsonBody)
        .timeout(Duration(milliseconds: timeout));
    if (isShowLoading) DialogBox.close();
    if (iscontrollresponsecode) {
      if ((response.statusCode == 401 ||
          (response.statusCode == 500 &&
              response.decode["Message"] == "Geçersiz Kullanıcı.")) &&
          AutohorizationError != null) {
        AutohorizationError();
      } else if (response.statusCode >= 400) {
        DialogBox.show(response.decode["Message"],
            dialogType: GizDialogType.Error);
      }
    }

    print(response.body);
    print(response.statusCode);
    return response;
  }

  static Future postSync(String url,
      String jsonBody,
      Function(http.Response) res, {
        int timeout = 5 * 60 * 1000,
        bool iscontrollresponsecode = true,
        String token,
      }) async {
    print(jsonBody);

    res(await post(url, jsonBody,
        timeout: timeout,
        iscontrollresponsecode: iscontrollresponsecode,
        token: token));
  }

  static Future<http.Response> put(String url,
      String jsonBody, {
        int timeout = 5 * 60 * 1000,
        bool iscontrollresponsecode = true,
        String token,
      }) async {
    print(jsonBody);

    print(url);
    token = token ?? await giz_module.getToken();
    DialogBox.showLoading();
    var response = await http
        .put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          "Authorization": "bearer " + token,
          for (var i in DefaultHeaders.entries.toList()) i.key: i.value
        },
        body: jsonBody)
        .timeout(Duration(milliseconds: timeout));
    DialogBox.close();
    if (iscontrollresponsecode) {
      if ((response.statusCode == 401 ||
          (response.statusCode == 500 &&
              response.decode["Message"] == "Geçersiz Kullanıcı.")) &&
          AutohorizationError != null) {
        AutohorizationError();
      }

/*      if(response.statusCode==401 || (response.statusCode==500 && response.decode["Message"]=="Geçersiz Kullanıcı."))
      {
        DialogBox.show("Başka bir kullanıcı tarafından giriş yapıldığı için oturumunuz sonlanmıştır",buttonClick: (x)
        {
          Navigator.push(gizContext, MaterialPageRoute(builder: (context)=>login()));
        });
      }*/
      else if (response.statusCode >= 400) {
        DialogBox.show(response.decode["Message"],
            dialogType: GizDialogType.Error);
      }
    }

    print(response.body);
    print(response.statusCode);
    return response;
  }

  static Future putSync(String url,
      String jsonBody,
      Function(http.Response) res, {
        int timeout = 5 * 60 * 1000,
        bool iscontrollresponsecode = true,
        String token,
      }) async {
    res(await put(url, jsonBody,
        timeout: timeout,
        iscontrollresponsecode: iscontrollresponsecode,
        token: token));
  }

  static Future<http.Response> get(String url, {
    int Timeout = 5 * 60,
    bool iscontrollresponsecode = true,
    String token,
  }) async {
    try {
      token = token ?? await giz_module.getToken();
      DialogBox.showLoading();
      var response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'bearer ' + token,
        for (var i in DefaultHeaders.entries.toList()) i.key: i.value
      }).timeout(Duration(seconds: Timeout));
      DialogBox.close();

      if (iscontrollresponsecode) {
        if ((response.statusCode == 401 ||
            (response.statusCode == 500 &&
                response.decode["Message"] == "Geçersiz Kullanıcı.")) &&
            AutohorizationError != null) {
          AutohorizationError();
        } else if (response.statusCode >= 400 &&
            response.statusCode != 404 &&
            response.statusCode != 401) {
          DialogBox.show(response.decode["Message"],
              dialogType: GizDialogType.Error);
        }
      }

      return response;
    } on TimeoutException catch (e) {
      DialogBox.close();
      return http.Response('{"Message":"."}', 502);
    } catch (e) {
      DialogBox.close();
      return http.Response('{"Message":"${e.toString()}"}', 500);
    }
  }

  static Future getSync(String url, Function(http.Response) res,
      {int timeout = 5 * 60 * 1000,
        bool iscontrollresponsecode = true,
        String token}) async {
    res(await get(url,
        Timeout: timeout,
        iscontrollresponsecode: iscontrollresponsecode,
        token: token));
  }
}
//endregion

//region  GizApp
class GizApp extends StatelessWidget {
  static GizApp app;
  Widget widget;
  String title;
  Map<String, WidgetBuilder> routes;
  GizThemeData themeData;
  MaterialApp materialApp;

  GizApp(this.title, this.widget, {this.themeData, this.routes});

  @override
  Widget build(BuildContext context) {
    if (themeData == null) themeData = GizThemeData();
    app = this;
    return materialApp = MaterialApp(
      title: title,
      theme: themeData.themeData,
      home: widget,
      routes: routes ?? {},
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}

extension EX_BuildContext on BuildContext {
  get height =>
      MediaQuery
          .of(this)
          .size
          .height;

  get width =>
      MediaQuery
          .of(this)
          .size
          .width;

  MediaQueryData get media => MediaQuery.of(this);

  get isLarge => this.height > 800;

  get isKeyBoardOpen => WidgetsBinding.instance.window.viewInsets.bottom > 0;
}

extension EX_Int on int {
  get sp => this * (1.0 / gizContext.media.textScaleFactor);
}

//endregion

class GizEditText extends StatelessWidget {
  TextEditingController controller;
  String hint;
  bool showClearButton;
  bool showBarcodeButton;
  bool enabled;
  ValueChanged<String> valueChanged;
  Icon icon;
  TextStyle textStyle;


  GizEditText(this.controller,
      {this.hint,
        this.showClearButton = true,
        this.showBarcodeButton = false,
        this.enabled = true,
        this.valueChanged,
        this.icon,
        this.textStyle});

  ValueNotifier<bool> _listener = ValueNotifier(false);

  String get text => controller.text;

  set text(String _text) {
    controller.text = _text;
    _listener.value = !_listener.value;
  }

  void clear() => text = "";

  Future<String> scanBarcode() async {
    String res = await FlutterBarcodeScanner.scanBarcode(
        "", "Kapat", true, ScanMode.DEFAULT);
    text = res == "-1" ? "" : res;

    if (res != "-1" && valueChanged != null) valueChanged(text);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _listener,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hint != null)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    hint,
                    style: TextStyle(color: activeTheme.primaryColor),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                    color: activeTheme.shadowColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: enabled
                    ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: icon,
                    ),
                    Flexible(
                      child: TextField(
                        decoration:
                        InputDecoration(border: InputBorder.none),
                        controller: controller,
                        onSubmitted: valueChanged,
                        style: textStyle,
                      ),
                    ),
                    if (showClearButton)
                      IconButton(
                          onPressed: () => clear(),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          )),
                    if (showBarcodeButton)
                      IconButton(
                          onPressed: () => scanBarcode(),
                          icon: Icon(
                            Icons.qr_code,
                            color: activeTheme.primaryColor,
                          ))
                  ],
                )
                    : Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: icon,
                            ),
                            Text(controller.text, style: textStyle,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//region SearchText

class GizSearchTextEditingController extends ValueNotifier<GizSearchTextValue> {
  GizSearchTextEditingController({GizSearchTextValue value})
      : super(value ?? GizSearchTextValue());
}

class GizSearchTextValue {
  dynamic item, id;
  String title = "";
}

class GizSearchText extends StatelessWidget {
  GizSearchTextEditingController controller;
  String hint;
  bool showClearButton;
  bool showSearchButton;
  bool enabled;
  ValueChanged<dynamic> valueChanged;
  GestureTapCallback onClick;
  TextStyle textStyle;

  String get title => controller.value.title;

  set title(String _text) {
    controller.value.title = _text;
    _listener.value = !_listener.value;
  }

  GizSearchText(this.controller,
      {this.hint,
        this.showClearButton = true,
        this.showSearchButton = true,
        this.enabled = true,
        this.valueChanged,
        this.onClick,
        this.textStyle});

  ValueNotifier<bool> _listener = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _listener,
      builder: (context, value, child) =>
          InkWell(
            onTap: onClick,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hint != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        hint,
                        style: TextStyle(color: activeTheme.primaryColor),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                        color: activeTheme.shadowColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: enabled
                            ? Row(
                          children: [
                            Flexible(
                              child: Container(
                                  width: double.maxFinite,
                                  child: Text(title, style: textStyle,)),
                            ),
                            IconButton(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  showSearchButton && enabled
                                      ? Icons.search
                                      : Icons.search_off,
                                  color: activeTheme.primaryColor,
                                )),
                            if (showClearButton)
                              IconButton(
                                  onPressed: () {
                                    controller.value.item = null;
                                    controller.value.id = null;
                                    title = "";
                                    if (valueChanged != null)
                                      valueChanged(controller.value.item);
                                  },
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(),
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  )),
                          ],
                        )
                            : Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("", style: textStyle),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

//endregion

//regionDateText

class GizDateText extends StatelessWidget {
  GizDateTextEditingController controller;
  String hint;
  bool showClearButton;
  bool showSearchButton;
  bool enabled;
  ValueChanged<dynamic> valueChanged;
  TextStyle textStyle;

  DateTime get dateTime => controller.value;
  DateTime firstDate = DateTime(DateTime
      .now()
      .year - 150, 1, 1);
  DateTime lastDate = DateTime(DateTime
      .now()
      .year, 12, 31);

  set dateTime(DateTime dateTime) {
    controller.value = dateTime;
    _listener.value = !_listener.value;
  }

  GizDateText(this.controller, {
    this.hint,
    this.showClearButton = true,
    this.showSearchButton = true,
    this.enabled = true,
    this.valueChanged,
    this.textStyle,
    this.firstDate,
    this.lastDate
  }) {
    if (firstDate == null)
      firstDate = DateTime(DateTime
          .now()
          .year - 150, 1, 1);
    if (lastDate == null)
      lastDate = DateTime(DateTime
          .now()
          .year, 12, 31);
  }



  ValueNotifier<bool> _listener = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _listener,
      builder: (context, value, child) =>
          InkWell(
            onTap: () async {
              try {
                dateTime = (await showDatePicker(
                  context: gizContext,
                  initialDate: dateTime,
                  firstDate: firstDate,
                  lastDate: lastDate,

                )) ??
                    dateTime;
              } catch (ex) {}
              //
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hint != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        hint,
                        style: TextStyle(color: activeTheme.primaryColor),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                        color: activeTheme.shadowColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: enabled
                            ? Row(
                          children: [
                            Flexible(
                              child: Container(
                                  width: double.maxFinite,
                                  child: Text(controller?.value.toFormat(),
                                      style: textStyle)),
                            ),
                            IconButton(
                                onPressed: () {},
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.date_range,
                                  color: Colors.red,
                                )),
                          ],
                        )
                            : Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(controller?.value.toFormat()),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class GizDateTextEditingController extends ValueNotifier<DateTime> {
  GizDateTextEditingController({DateTime value})
      : super(value ?? DateTime.now());
}
//endregion

class GizSwitch extends StatelessWidget {
  bool value;
  String hint;
  bool showClearButton;
  bool showBarcodeButton;
  bool enabled;
  ValueChanged<bool> valueChanged;
  TextStyle textStyle;

  GizSwitch({this.value = false,
    this.hint,
    this.showClearButton = true,
    this.showBarcodeButton = false,
    this.enabled = true,
    this.valueChanged,
    this.textStyle}) {
    // key = GlobalKey();
  }

  ValueNotifier<bool> _listener = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _listener,
      builder: (context, value, child) =>
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SwitchListTile(
              tileColor: activeTheme.shadowColor,
              title: Text(hint, style: textStyle,),
              value: this.value,
              onChanged: (value) {
                this.value = value;
                if (valueChanged != null) valueChanged(this.value);
                _listener.value = !_listener.value;
              },
            ),
          ),
    );
  }
}

class GizDropdown<T> extends StatefulWidget {
  final Widget child;
  final void Function(T, int) onChange;

  final List<GizDropdownItem<T>> items;
  final GizDropdownStyle dropdownStyle;

  final GizDropdownButtonStyle dropdownButtonStyle;

  final String hint;

  final Icon icon;
  final bool hideIcon;

  final bool leadingIcon;

  GizDropdown({Key key,
    this.hideIcon = false,
    @required this.child,
    @required this.items,
    this.dropdownStyle = const GizDropdownStyle(),
    this.dropdownButtonStyle = const GizDropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    this.hint})
      : super(key: key);

  @override
  _GizDropdownDropdownState<T> createState() => _GizDropdownDropdownState<T>();
}

class _GizDropdownDropdownState<T> extends State<GizDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  AnimationController _animationController;
  Animation<double> _expandAnimation;
  Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle;
    // link the overlay to the button
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.hint != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.hint,
                  style: TextStyle(color: activeTheme.primaryColor),
                ),
              ),
            Container(
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                  color: activeTheme.shadowColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                onTap: _toggleDropdown,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (_currentIndex == -1) ...[
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: widget.child,
                          )),
                    ] else
                      ...[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: widget.items[_currentIndex],
                            )),
                      ],
                    if (!widget.hideIcon)
                      RotationTransition(
                        turns: _rotateAnimation,
                        child: widget.icon ?? Icon(Icons.arrow_drop_down),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) =>
          GestureDetector(
            onTap: () => _toggleDropdown(close: true),
            behavior: HitTestBehavior.translucent,
            // full screen container to register taps anywhere and close drop down
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                children: [
                  Positioned(
                    left: offset.dx,
                    top: topOffset,
                    width: widget.dropdownStyle.width ?? size.width,
                    child: CompositedTransformFollower(
                      offset:
                      widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                      link: this._layerLink,
                      showWhenUnlinked: false,
                      child: Material(
                        elevation: widget.dropdownStyle.elevation ?? 0,
                        borderRadius:
                        widget.dropdownStyle.borderRadius ?? BorderRadius.zero,
                        color: widget.dropdownStyle.color,
                        child: SizeTransition(
                          axisAlignment: 1,
                          sizeFactor: _expandAnimation,
                          child: ConstrainedBox(
                            constraints: widget.dropdownStyle.constraints ??
                                BoxConstraints(
                                  maxHeight: MediaQuery
                                      .of(context)
                                      .size
                                      .height -
                                      topOffset -
                                      15,
                                ),
                            child: ListView(
                              padding:
                              widget.dropdownStyle.padding ?? EdgeInsets.zero,
                              shrinkWrap: true,
                              children: widget.items
                                  .asMap()
                                  .entries
                                  .map((item) {
                                return InkWell(
                                  onTap: () {
                                    setState(() => _currentIndex = item.key);
                                    widget.onChange(item.value.value, item.key);
                                    _toggleDropdown();
                                  },
                                  child: item.value,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      this._overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

class GizDropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const GizDropdownItem({Key key, this.value, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class GizDropdownButtonStyle {
  final MainAxisAlignment mainAxisAlignment;
  final ShapeBorder shape;
  final double elevation;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BoxConstraints constraints;
  final double width;
  final double height;
  final Color primaryColor;

  const GizDropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class GizDropdownStyle {
  final BorderRadius borderRadius;
  final double elevation;
  final Color color;
  final EdgeInsets padding;
  final BoxConstraints constraints;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset offset;

  ///button width must be set for this to take effect
  final double width;

  const GizDropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}
