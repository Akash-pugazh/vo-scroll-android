package com.example.voicescroll

import android.content.Intent
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
                        val intent = Intent(this, VoiceCommandForegroundService::class.java)
                        intent.action = VoiceCommandForegroundService.ACTION_START
                        intent.putExtra("commands", call.argument<ArrayList<HashMap<String, Any>>>("commands"))
                        startForegroundService(intent)
                        result.success(null)
                    }

                    "stopListening" -> {
                        val intent = Intent(this, VoiceCommandForegroundService::class.java)
                        intent.action = VoiceCommandForegroundService.ACTION_STOP
                        startService(intent)
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
