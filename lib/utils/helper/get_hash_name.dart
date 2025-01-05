import 'dart:convert';
import 'package:crypto/crypto.dart';

String getHashName(String value) =>
    md5.convert(utf8.encode(value)).toString().substring(0, 23);
