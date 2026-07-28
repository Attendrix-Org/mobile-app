package com.attendrix.app.widget

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

object WidgetBridge {
    private const val CHANNEL_NAME = "com.attendrix.app/widget"
    private var methodChannel: MethodChannel? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private val scope = CoroutineScope(Dispatchers.Default)

    fun attach(context: Context, messenger: BinaryMessenger) {
        val channel = MethodChannel(messenger, CHANNEL_NAME)
        methodChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidgetSnapshot", "refreshWidgets" -> {
                    scope.launch {
                        WidgetUpdater.updateAllWidgets(context)
                    }
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    fun notifyAuthExpired(context: Context) {
        mainHandler.post {
            methodChannel?.invokeMethod("onWidgetAuthExpired", null)
        }
    }

    fun notifyAbsenceChanged(context: Context, classId: String, isAbsent: Boolean) {
        mainHandler.post {
            methodChannel?.invokeMethod(
                "onWidgetAbsenceChanged",
                mapOf("classId" to classId, "isAbsent" to isAbsent)
            )
        }
        scope.launch {
            WidgetUpdater.updateAllWidgets(context)
        }
    }

    /**
     * Notify Flutter to cycle to the next available mess.
     * Flutter should listen for "onWidgetCycleMess" and rotate userPreferences.messID.
     */
    fun notifyCycleMess(context: Context) {
        mainHandler.post {
            methodChannel?.invokeMethod("onWidgetCycleMess", null)
        }
        scope.launch {
            WidgetUpdater.updateAllWidgets(context)
        }
    }
}
