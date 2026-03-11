package com.example.voicescroll

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.graphics.Path
import android.view.accessibility.AccessibilityEvent

class ReelScrollAccessibilityService : AccessibilityService() {

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Optional: introspect package names (Instagram/YouTube) and tune gesture logic.
    }

    override fun onInterrupt() = Unit

    fun scrollNext() {
        val path = Path().apply {
            moveTo(500f, 1400f)
            lineTo(500f, 300f)
        }

        val stroke = GestureDescription.StrokeDescription(path, 0, 180)
        val gesture = GestureDescription.Builder().addStroke(stroke).build()
        dispatchGesture(gesture, null, null)
    }

    companion object {
        var instance: ReelScrollAccessibilityService? = null
            private set
    }
}
