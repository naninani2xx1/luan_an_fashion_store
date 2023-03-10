import 'package:encrypt/encrypt.dart' as ecp;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';

extension StringX on String {
  ///Accepts encrypted data and decrypt it. Returns plain text
  String decryptWithAES(String key, ecp.Encrypted encryptedData) {
    final cipherKey = ecp.Key.fromUtf8(key);
    final encryptService = ecp.Encrypter(
        ecp.AES(cipherKey, mode: ecp.AESMode.cbc)); //Using AES CBC encryption
    final initVector = ecp.IV.fromUtf8(key.substring(0,
        16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData, iv: initVector);
  }

  ///Encrypts the given plainText using the key. Returns encrypted data
  ecp.Encrypted encryptWithAES(String key, String plainText) {
    final cipherKey = ecp.Key.fromUtf8(key);
    final encryptService =
        ecp.Encrypter(ecp.AES(cipherKey, mode: ecp.AESMode.cbc));
    final initVector = ecp.IV.fromUtf8(key.substring(0,
        16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    ecp.Encrypted encryptedData =
        encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  String translateLabelBottomNavigationBar(BuildContext context) {
    switch (this) {
      case Routes.HOME:
        return AppLocalizations.of(context)!.homePage;
      case Routes.NOTIFICATION:
        return AppLocalizations.of(context)!.notificationPage;
      case Routes.PROFILE:
        return AppLocalizations.of(context)!.mePage;
      default:
    }
    return "";
  }

  String translateLabelFeatureProfile(BuildContext context) {
    switch (this) {
      case Routes.PERSONAL:
        return AppLocalizations.of(context)!.personal;
      case Routes.ORDER:
        return AppLocalizations.of(context)!.order;
      case Routes.MESSENGER:
        return AppLocalizations.of(context)!.messenger;
      case Routes.ADDRESSMANAGEMENT:
        return AppLocalizations.of(context)!.address;
      case Routes.FAVORITE:
        return AppLocalizations.of(context)!.favorite;
      case Routes.SETTING:
        return AppLocalizations.of(context)!.setting;
      default:
    }
    return "";
  }

  String toBeginningOfSentenceCase() =>
      this[0].toUpperCase() + substring(1).toLowerCase();

  String toFormattedPhoneNumberVN() {
    if (length != 10) {
      return this;
    }
    const prefix = '+84';
    final firstPart = substring(1, 4);
    final secondPart = substring(4, 7);
    final thirdPart = substring(7, 10);
    return '($prefix) $firstPart $secondPart $thirdPart';
  }

  bool isValidEmail() {
    // Ki???m tra xem chu???i c?? r???ng hay kh??ng
    if (isEmpty) return false;

    // Ki???m tra xem chu???i c?? ph?? h???p v???i y??u c???u ?????c bi???t kh??ng
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final String emailDomain = split('@').last;
    return emailRegex.hasMatch(this) &&
        emailDomain.contains('gmail') &&
        endsWith('.com');
  }
}
