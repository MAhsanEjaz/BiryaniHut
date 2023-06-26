import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shop_app/sales%20rep/salesrep_dashboard.dart';
import 'package:shop_app/size_config.dart';
import 'package:pdf/widgets.dart' as pw;

import 'components/default_button.dart';

class NavigatorWidget extends StatelessWidget {
  Color? color;

  NavigatorWidget({this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SalesRepDashboardPage()),
        );
      },
      icon: Icon(
        Icons.home,
        color: color ?? Colors.white,
      ),
    );
  }
}

const kPrimaryColor = Colors.black;
const Color appColor = Color(0xFF990D38);
const kPrimaryLightColor = Color(0xFFFFECDF);
const whiteColor = Colors.white;
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const lightBlackColor = Colors.black12;
const kAnimationDuration = Duration(milliseconds: 200);

// String customerUrl = "http://173.208.142.67:8060/api/Customer";
const String apiBaseUrl = "http://38.17.51.206:8070/api";
// const String apiBaseUrl = "https://firstsparklymouse88.conveyor.cloud/api";

// const String apiBaseUrl = "http://38.17.51.206:8073/api";
String baseUrlWithoutApi =
    apiBaseUrl.substring(0, apiBaseUrl.lastIndexOf("/api"));

// const String apiBaseUrl = "https://192.168.18.207:45456/api";
// const String apiBaseUrl = "http://192.168.18.8:45455/api";
const String imageBaseUrl = "http://38.17.51.206:8073/api";
// http://38.17.51.206:8070/

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);
final pdfHeaderStyle = pw.TextStyle(
  fontSize: 12,
  fontWeight: pw.FontWeight.bold,
  height: 1.6,
  color: const PdfColor.fromInt(0xff000000),
);
final pdfStyle = pw.TextStyle(
  fontSize: 12,
  fontWeight: pw.FontWeight.normal,
  color: const PdfColor.fromInt(0x000000),
);

String dummyImageUrl = "https://picsum.photos/200/300";
String userDummyUrl =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTz-bjByJY1rNIa6Yn8Et3RwlOuOMklKNM5cA&usqp=CAU";

String getImageUrl(String url) {
  log("url to split = $url");
  List<String> list = url.split("\\");
  log("My List ${list.last}");

  // url = "http://38.17.51.206:8070/productImages/" + list.last;
  // url = "http://38.17.51.206:8020/productImages/productImages/";

  log("new url after split= $url");
  // http://192.168.18.37:5955/influanceweb/productImages

  return url;
}

showAwesomeAlert({
  required BuildContext context,
  required String msg,
  AnimType? animType,
  String? okBtnText,
  String? cancelBtnText,
  DialogType? dialogType,
  void Function()? onOkPress,
  void Function()? onCancelPress,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType ?? DialogType.info,
    animType: animType ?? AnimType.rightSlide,
    title: msg,
    btnOkText: okBtnText,
    btnCancelText: cancelBtnText,
    // desc: desc,
    btnOkOnPress: (onOkPress),
    btnCancelOnPress: () {},
  )..show();
}

const TextStyle nameStyle = TextStyle(
    color: kPrimaryColor, fontSize: 16.0, fontWeight: FontWeight.bold);
const TextStyle detStyle = TextStyle(color: whiteColor, fontSize: 14.0);
const TextStyle appbarTextStye =
    TextStyle(color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w500);
const TextStyle welStyle = TextStyle(
    color: kPrimaryColor,
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    height: 2.0);
const TextStyle dayStyle = TextStyle(
  color: kTextColor,
  fontSize: 12.0,
);
const TextStyle custStyle =
    TextStyle(color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.w500);
const TextStyle dateStyle = TextStyle(
    color: kPrimaryColor, fontSize: 12.0, fontWeight: FontWeight.w700);
const TextStyle idStyle =
    TextStyle(color: appColor, fontSize: 16.0, fontWeight: FontWeight.w500);
const TextStyle timeStyle = TextStyle(
    color: kPrimaryColor,
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 2.3);
const defaultDuration = Duration(milliseconds: 250);
const TextStyle detailsStyle = TextStyle(
    color: kPrimaryColor,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    height: 1.8);
const TextStyle orderStyle = TextStyle(
    color: kTextColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 2.2);
final dealStyle = pw.TextStyle(
  fontSize: 14,
  height: 1.8,
  fontWeight: pw.FontWeight.bold,
  color: const PdfColor.fromInt(0x000000),
);
pw.TextStyle pdfTitleStyle = pw.TextStyle(
    color: const PdfColor.fromInt(0x000000),
    fontSize: 12.0,
    fontWeight: pw.FontWeight.bold);
final reportStyle = pw.TextStyle(
    color: const PdfColor.fromInt(0x000000),
    fontSize: 18.0,
    fontWeight: pw.FontWeight.bold,
    height: 1.8);
pw.TextStyle pdfOrderStyle = pw.TextStyle(
    color: const PdfColor.fromInt(0x000000),
    fontSize: 16.0,
    fontWeight: pw.FontWeight.bold,
    height: 2.2);
const TextStyle tableStyle = TextStyle(
  color: kTextColor,
  fontSize: 12.0,
);
const TextStyle titleStyle = TextStyle(
    color: kPrimaryColor, fontSize: 14.0, fontWeight: FontWeight.bold);
// Form Error
final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

RoundedRectangleBorder rectangleBorder() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0));
}

const iconTheme = IconThemeData(color: whiteColor);

Divider divider() {
  return const Divider(
    color: lightBlackColor,
    thickness: 1.5,
  );
}

Row formErrorText({required String error}) {
  return Row(
    children: [
      SvgPicture.asset(
        "assets/icons/Error.svg",
        height: getProportionateScreenWidth(14),
        width: getProportionateScreenWidth(14),
      ),
      SizedBox(
        width: getProportionateScreenWidth(10),
      ),
      Text(error),
    ],
  );
}

String getDate(date) {
  DateTime dates = DateTime.parse(date);
  return DateFormat.yMMMd().format(dates) + "";
  // "   ${DateFormat.jm().format()}";
}

String getTime(time) {
  return DateFormat.jm().format(DateTime.parse(time));
  // String myTime = "${time.hour}:${time.minute}:${time.second}";
  // DateTime dates = DateTime.parse(myTime);
  // return dates;
  // "   ${DateFormat.jm().format()}";
}

removeFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  currentFocus.unfocus();
}

bool isLetter(String input) {
  final RegExp regExp = RegExp('[a-zA-Z]');
  return regExp.hasMatch(input);
}

Container reportButton({required Function()? onTap}) {
  return Container(
    height: kToolbarHeight * 1.0,
    width: double.infinity,
    decoration:
        BoxDecoration(border: Border.all(color: kSecondaryColor, width: 1.5)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DefaultButton(
          height: SizeConfig.screenHeight * 0.05,
          width: SizeConfig.screenWidth * 0.5,
          text: "Print Report",
          press: onTap,
        )
      ],
    ),
  );
}
