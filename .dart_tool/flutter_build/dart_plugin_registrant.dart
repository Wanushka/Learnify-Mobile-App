//
// Generated file. Do not edit.
// This file is generated from template in file `flutter_tools/lib/src/flutter_plugins.dart`.
//

// @dart = 3.5

import 'dart:io'; // flutter_ignore: dart_io_import.
import 'package:flutter_inappwebview_android/flutter_inappwebview_android.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:video_player_android/video_player_android.dart';
import 'package:flutter_inappwebview_ios/flutter_inappwebview_ios.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';
import 'package:video_player_avfoundation/video_player_avfoundation.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';
import 'package:flutter_inappwebview_macos/flutter_inappwebview_macos.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';
import 'package:video_player_avfoundation/video_player_avfoundation.dart';
import 'package:flutter_inappwebview_windows/flutter_inappwebview_windows.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

@pragma('vm:entry-point')
class _PluginRegistrant {

  @pragma('vm:entry-point')
  static void register() {
    if (Platform.isAndroid) {
      try {
        AndroidInAppWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`flutter_inappwebview_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        PathProviderAndroid.registerWith();
      } catch (err) {
        print(
          '`path_provider_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        SharedPreferencesAndroid.registerWith();
      } catch (err) {
        print(
          '`shared_preferences_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        AndroidVideoPlayer.registerWith();
      } catch (err) {
        print(
          '`video_player_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isIOS) {
      try {
        IOSInAppWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`flutter_inappwebview_ios` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        PathProviderFoundation.registerWith();
      } catch (err) {
        print(
          '`path_provider_foundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        SharedPreferencesFoundation.registerWith();
      } catch (err) {
        print(
          '`shared_preferences_foundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        AVFoundationVideoPlayer.registerWith();
      } catch (err) {
        print(
          '`video_player_avfoundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isLinux) {
      try {
        PathProviderLinux.registerWith();
      } catch (err) {
        print(
          '`path_provider_linux` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        SharedPreferencesLinux.registerWith();
      } catch (err) {
        print(
          '`shared_preferences_linux` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isMacOS) {
      try {
        MacOSInAppWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`flutter_inappwebview_macos` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        PathProviderFoundation.registerWith();
      } catch (err) {
        print(
          '`path_provider_foundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        SharedPreferencesFoundation.registerWith();
      } catch (err) {
        print(
          '`shared_preferences_foundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        AVFoundationVideoPlayer.registerWith();
      } catch (err) {
        print(
          '`video_player_avfoundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isWindows) {
      try {
        WindowsInAppWebViewPlatform.registerWith();
      } catch (err) {
        print(
          '`flutter_inappwebview_windows` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        PathProviderWindows.registerWith();
      } catch (err) {
        print(
          '`path_provider_windows` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

      try {
        SharedPreferencesWindows.registerWith();
      } catch (err) {
        print(
          '`shared_preferences_windows` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    }
  }
}
