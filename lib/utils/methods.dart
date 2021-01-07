import 'dart:math';

import 'package:makhosi_app/models/folder.dart';

class Methods {
  static String formatBytes(int bytes, {int decimals: 0}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static int getItemCount(List<Folders> folderList) {
    int count = 0;
    for (var folder in folderList) {
      count += folder.listOfFilesUrl.length;
    }
    return count;
  }

  static String totalFoldersSized(List<Folders> folderList) {
    int bytes = 0;
    for (var folder in folderList) {
      bytes += folder.foldersize;
    }
    String totalBytes = formatBytes(bytes);
    return totalBytes;
  }
}
