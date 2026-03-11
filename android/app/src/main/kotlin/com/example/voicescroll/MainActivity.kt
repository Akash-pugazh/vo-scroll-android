package com.example.voicescroll

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "voice_scroll/bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startListening" -> {
                        val phrases = call.argument<ArrayList<String>>("phrases")
                        val intent = Intent(this, VoiceCommandForegroundService::class.java).apply {
                            action = VoiceCommandForegroundService.ACTION_START
                            putStringArrayListExtra(VoiceCommandForegroundService.EXTRA_PHRASES, phrases)
                        }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                        result.success(null)
                    }

                    "stopListening" -> {
                        val intent = Intent(this, VoiceCommandForegroundService::class.java).apply {
                            action = VoiceCommandForegroundService.ACTION_STOP
                        }
                        stopService(intent)
                        result.success(null)
                    }

                    "scrollNext" -> {
                        ReelScrollAccessibilityService.instance?.scrollNext()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
