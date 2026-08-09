package com.attendrix.app.widget.core

import android.content.Context
import android.util.Log

/**
 * Dedicated Persistence Abstraction for Attendrix Home Screen Widgets.
 * Encapsulates SharedPreferences access, corruption handling, schema version checks, and key management.
 */
object WidgetStateStore {
    private const val TAG = "WidgetStateStore"
    private const val PREFS_NAME = "HomeWidgetPreferences"
    private const val KEY_CLASS_WIDGET_STATE = "widget_state_json"
    private const val KEY_MESS_MENU_WIDGET_STATE = "mess_menu_widget_state_json"

    fun getClassSnapshot(context: Context): WidgetSnapshot {
        return loadSnapshot(context, KEY_CLASS_WIDGET_STATE)
    }

    fun getMessMenuSnapshot(context: Context): WidgetSnapshot {
        return loadSnapshot(context, KEY_MESS_MENU_WIDGET_STATE)
    }

    fun saveClassSnapshot(context: Context, jsonStr: String): Boolean {
        return saveSnapshot(context, KEY_CLASS_WIDGET_STATE, jsonStr)
    }

    fun saveMessMenuSnapshot(context: Context, jsonStr: String): Boolean {
        return saveSnapshot(context, KEY_MESS_MENU_WIDGET_STATE, jsonStr)
    }

    fun clearAll(context: Context) {
        try {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().clear().apply()
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to clear WidgetStateStore", e)
        }
    }

    private fun loadSnapshot(context: Context, key: String): WidgetSnapshot {
        return try {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            var jsonStr = prefs.getString(key, null)

            if (jsonStr.isNullOrBlank()) {
                val fallbackPrefs = context.getSharedPreferences(context.packageName + "_preferences", Context.MODE_PRIVATE)
                jsonStr = fallbackPrefs.getString(key, null)
            }

            if (!jsonStr.isNullOrBlank()) {
                WidgetSnapshot.fromJson(jsonStr)
            } else {
                WidgetSnapshot()
            }
        } catch (e: Throwable) {
            Log.e(TAG, "Error reading widget snapshot for key $key", e)
            WidgetSnapshot()
        }
    }

    private fun saveSnapshot(context: Context, key: String, jsonStr: String): Boolean {
        return try {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().putString(key, jsonStr).apply()
            true
        } catch (e: Throwable) {
            Log.e(TAG, "Error saving widget snapshot for key $key", e)
            false
        }
    }
}
