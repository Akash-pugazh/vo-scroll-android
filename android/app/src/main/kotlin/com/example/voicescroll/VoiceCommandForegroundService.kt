package com.example.voicescroll

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.app.NotificationCompat

class VoiceCommandForegroundService : Service(), RecognitionListener {

    private var speechRecognizer: SpeechRecognizer? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var commandPhrases: Set<String> = emptySet()
    private var isListening = false

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                updateCommandPhrases(intent)
                startListening()
            }
            ACTION_STOP -> stopSelf()
        }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        stopRecognitionLoop()
        stopForeground(STOP_FOREGROUND_REMOVE)
    }

    private fun updateCommandPhrases(intent: Intent) {
        val rawCommands = intent.getSerializableExtra("commands")
        val maps = rawCommands as? ArrayList<HashMap<String, Any>>
        if (maps.isNullOrEmpty()) {
            commandPhrases = setOf("next", "okay")
            return
        }

        commandPhrases = maps
            .mapNotNull { it["phrase"] as? String }
            .map { it.trim().lowercase() }
            .filter { it.isNotBlank() }
            .toSet()
            .ifEmpty { setOf("next", "okay") }
    }

    private fun startListening() {
        val notificationManager = getSystemService(NotificationManager::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "VoiceScroll background listening",
                NotificationManager.IMPORTANCE_LOW
            )
            notificationManager.createNotificationChannel(channel)
        }

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setContentTitle("VoiceScroll is listening")
            .setContentText("Say your configured trigger phrase to scroll next")
            .setOngoing(true)
            .build()

        startForeground(NOTIFICATION_ID, notification)

        if (!SpeechRecognizer.isRecognitionAvailable(this)) {
            stopSelf()
            return
        }

        if (speechRecognizer == null) {
            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this).also {
                it.setRecognitionListener(this)
            }
        }

        startRecognitionLoop()
    }

    private fun startRecognitionLoop() {
        if (isListening) return
        isListening = true

        val listenIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)
        }

        speechRecognizer?.startListening(listenIntent)
    }

    private fun restartRecognitionLoop(delayMs: Long = 200L) {
        isListening = false
        mainHandler.postDelayed({
            if (speechRecognizer != null) {
                startRecognitionLoop()
            }
        }, delayMs)
    }

    private fun stopRecognitionLoop() {
        isListening = false
        mainHandler.removeCallbacksAndMessages(null)
        speechRecognizer?.stopListening()
        speechRecognizer?.cancel()
        speechRecognizer?.destroy()
        speechRecognizer = null
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onReadyForSpeech(params: Bundle?) = Unit

    override fun onBeginningOfSpeech() = Unit

    override fun onRmsChanged(rmsdB: Float) = Unit

    override fun onBufferReceived(buffer: ByteArray?) = Unit

    override fun onEndOfSpeech() = Unit

    override fun onError(error: Int) {
        restartRecognitionLoop(delayMs = 450L)
    }

    override fun onResults(results: Bundle?) {
        handleRecognitionBundle(results)
        restartRecognitionLoop()
    }

    override fun onPartialResults(partialResults: Bundle?) {
        handleRecognitionBundle(partialResults)
    }

    override fun onEvent(eventType: Int, params: Bundle?) = Unit

    private fun handleRecognitionBundle(results: Bundle?) {
        val heard = results
            ?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
            ?.map { it.lowercase().trim() }
            .orEmpty()

        if (heard.isEmpty()) return

        val matched = heard.any { transcript ->
            commandPhrases.any { phrase ->
                transcript == phrase || transcript.contains(phrase)
            }
        }

        if (matched) {
            ReelScrollAccessibilityService.instance?.scrollNext()
        }
    }

    companion object {
        const val ACTION_START = "voice_scroll.action.START"
        const val ACTION_STOP = "voice_scroll.action.STOP"
        const val CHANNEL_ID = "voice_scroll_bg"
        const val NOTIFICATION_ID = 101
    }
}
