import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "voice_scroll/bridge"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "startListening":
        // NOTE: iOS supports speech recognition only in active app contexts.
        // App Store-safe background continuous listening for arbitrary commands
        // and controlling third-party apps is not supported.
        result(nil)
      case "stopListening":
        result(nil)
      case "scrollNext":
        result(FlutterError(code: "UNSUPPORTED", message: "iOS cannot control third-party app scrolling", details: nil))
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
