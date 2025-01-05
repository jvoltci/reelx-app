import 'package:video_thumbnail/video_thumbnail.dart';

Future<bool> genrateThumb(String videoPath, String thumbPath) async {
  try {
    final generated = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: thumbPath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 30,
    );
    if (generated != '') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
