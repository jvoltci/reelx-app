String getFileName(vidPath) {
  List vidPathFolderList = vidPath.split('/');
  String fileName = vidPathFolderList[vidPathFolderList.length - 1];
  fileName = fileName.substring(0, fileName.length - 4);
  return fileName;
}
