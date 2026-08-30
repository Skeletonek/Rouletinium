// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

String getWebUserAgent() {
  try {
    return html.window.navigator.userAgent;
  } catch (_) {
    return '';
  }
}
