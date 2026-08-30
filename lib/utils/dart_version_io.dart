import 'dart:io' show Platform;

String getDartVersion() {
  try {
    // Platform.version looks like "3.13.1 (stable) (Tue Aug 18 ...) on linux_x64"
    return Platform.version.split(' ').first;
  } catch (_) {
    return 'unknown';
  }
}
