@JS("libphonenumber")
library libphonenumber;

import 'package:js/js.dart';

@JS()
@anonymous
class PhoneNumberUtil {
  external factory PhoneNumberUtil();

  external PhoneNumber parse(String phoneNumber, String? region);

  external bool isValidNumber(PhoneNumber phoneNumber);

  external String getNumberType(PhoneNumber phoneNumber);

  external String format(PhoneNumber phoneNumber, int format);
  
  external String? getCountryCodeForRegion(String region);

  external List<String> getSupportedRegions();

  external PhoneNumber? getExampleNumberForType(String region, int numberType);

  external static PhoneNumberUtil getInstance();
}

@JS()
@anonymous
class PhoneNumberFormat {
  external static int E164;
  external static int NATIONAL;
  external static int INTERNATIONAL;
}

@JS()
@anonymous
class PhoneNumberType {
  external static int MOBILE;
  external static int FIXED_LINE;
}

@JS()
class PhoneNumber {
  external factory PhoneNumber();

  external String getCountryCode();

  external String getNationalNumber();
}

@JS()
class AsYouTypeFormatter {
  external factory AsYouTypeFormatter(String region);

  external void clear();

  external String inputDigit(String digit);
}