import 'dart:async';

import "package:flutter/services.dart";
import 'package:flutter_libphonenumber_web/src/lib_phone_number.dart';
import 'package:flutter_libphonenumber_web/src/util.dart';
import "package:flutter_web_plugins/flutter_web_plugins.dart";

class FlutterLibPhoneNumberWebPlugin {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      "flutter_libphonenumber",
      const StandardMethodCodec(),
      registrar,
    );
    channel.setMethodCallHandler(handleMethodCall);
  }

  static Future<dynamic> handleMethodCall(MethodCall call) async {
    await _initialized;

    switch (call.method) {
      case "parse":
        final args = call.arguments as Map<dynamic, dynamic>;
        final String? phone = args["phone"];
        final region = args["region"];

        if (phone?.isNotEmpty != true) {
          throw PlatformException(
            code: "InvalidParameters",
            message: "Invalid 'phone' parameter.",
          );
        }

        // final library = await _library;
        PhoneNumberUtil util = PhoneNumberUtil.getInstance();
        // PhoneNumberFormat format = PhoneNumberFormat;

        final phoneNumber = util.parse(phone!, region);

        if (!util.isValidNumber(phoneNumber)) {
          return null;
        } else {
          final result = Map();

          result["type"] = util.getNumberType(phoneNumber);
          result["e164"] =
              util.format(phoneNumber, PhoneNumberFormat.E164);
          result["international"] =
              util.format(phoneNumber, PhoneNumberFormat.INTERNATIONAL);
          result["national"] =
              util.format(phoneNumber, PhoneNumberFormat.NATIONAL);
          result["country_code"] = phoneNumber.getCountryCode().toString();
          result["national_number"] =
              phoneNumber.getNationalNumber().toString();

          return result;
        }
      
      case "format":
        final args = call.arguments as Map<dynamic, dynamic>;
        final String? phone = args["phone"];
        final region = args["region"];

        if (phone?.isNotEmpty != true) {
          throw PlatformException(
            code: "InvalidParameters",
            message: "Invalid 'phone' parameter.",
          );
        }

        final formatter = AsYouTypeFormatter(region);

        String formatted = "";
        formatter.clear();
        for (final charCode in phone!.codeUnits) {
          formatted = formatter.inputDigit(String.fromCharCode(charCode));
        }

        return <String, String>{formatted: formatted};
      
      case "get_all_supported_regions":
        final util = PhoneNumberUtil.getInstance();

        var regionsMap = Map<String, Map<String, String>>();

        for (final region in util.getSupportedRegions()) {
          var itemMap = Map<String, String>();

          final phoneCode = util.getCountryCodeForRegion(region).toString();
          itemMap["phoneCode"] = phoneCode;

          final exampleNumberMobile = util.getExampleNumberForType(region, PhoneNumberType.MOBILE) ?? PhoneNumber();
          final exampleNumberFixedLine = util.getExampleNumberForType(region, PhoneNumberType.FIXED_LINE) ?? PhoneNumber();
          itemMap["exampleNumberMobileNational"] = util.format(exampleNumberMobile, PhoneNumberFormat.NATIONAL).toString();
          itemMap["exampleNumberFixedLineNational"] = util.format(exampleNumberFixedLine, PhoneNumberFormat.NATIONAL).toString();
          itemMap["phoneMaskMobileNational"] = util.format(exampleNumberMobile, PhoneNumberFormat.NATIONAL).toString().replaceAll(RegExp("\\d"), "0");
          itemMap["phoneMaskFixedLineNational"] = util.format(exampleNumberFixedLine, PhoneNumberFormat.NATIONAL).toString().replaceAll(RegExp("\\d"), "0");
          itemMap["exampleNumberMobileInternational"] = util.format(exampleNumberMobile, PhoneNumberFormat.INTERNATIONAL).toString();
          itemMap["exampleNumberFixedLineInternational"] = util.format(exampleNumberFixedLine, PhoneNumberFormat.INTERNATIONAL).toString();
          itemMap["phoneMaskMobileInternational"] = util.format(exampleNumberMobile, PhoneNumberFormat.INTERNATIONAL).toString().replaceAll(RegExp("\\d"), "0");
          itemMap["phoneMaskFixedLineInternational"] = util.format(exampleNumberFixedLine, PhoneNumberFormat.INTERNATIONAL).toString().replaceAll(RegExp("\\d"), "0");
          // itemMap["countryName"] = Locale("",region).displayCountry;

          regionsMap[region] = itemMap;
        }

        break;
    }

    return null;
  }

  static Future<void>? _init;
  static Future<void> get _initialized {
    _init ??= loadScripts([
          "assets/packages/flutter_libphonenumber_web/assets/js/stringbuffer.js",
          "assets/packages/flutter_libphonenumber_web/assets/js/libphonenumber.js"
    ]);
    return _init!;
  }
}
