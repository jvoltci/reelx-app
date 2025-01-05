import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:reelx/utils/contstants/api_constants.dart';

const key = ApiConstants.key;
const updateHitApi = ApiConstants.updateHit;
const roundInstagramApi = ApiConstants.roundInstagram;
const updateInstagramApi = ApiConstants.updateInstagram;
const tronDataApi = ApiConstants.tronData;

updateDownloadHit(String social) async {
  await Dio().post(updateHitApi, data: {"social": social, "api": key});
}

roundInstagramDb(String url) async {
  return await Dio().post(roundInstagramApi, data: {'url': url, 'api': key});
}

updateInstagram(String url, String fileUrl, String type) async {
  return await Dio().post(updateInstagramApi,
      data: {'url': url, 'file_url': fileUrl, 'type': type, 'api': key});
}

getTronAPIData() async {
  try {
    final dio = Dio();
    var response = await dio.post(tronDataApi, data: {"api": key});
    Map<String, dynamic> data = jsonDecode(response.toString());
    if (data['data']['data']['tron'] == true) {
      return data['data']['data'];
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
