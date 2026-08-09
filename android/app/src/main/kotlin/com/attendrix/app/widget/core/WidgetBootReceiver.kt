package com.attendrix.app.widget.core

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.attendrix.app.widget.WidgetUpdater
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * System Lifecycle Broadcast Receiver for Attendrix Native Widgets.
 * Listens for BOOT_COMPLETED, PACKAGE_REPLACED, TIMEZONE_CHANGED, and TIME_SET intents
 * to recover widget UI state and re-align boundary alarm schedules automatically.
 */
class WidgetBootReceiver : BroadcastReceiver() {
    private companion object {
        private const val TAG = "WidgetBootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "Received system broadcast action: $action")

        val pendingResult = goAsync()
        CoroutineScope(Dispatchers.Default).launch {
            try {
                WidgetUpdater.updateAllWidgets(context)
            } catch (e: Throwable) {
                Log.e(TAG, "Failed to restore widget state after lifecycle event: $action", e)
            } finally {
                pendingResult.finish()
            }
        }
    }
}
