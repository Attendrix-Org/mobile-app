package com.attendrix.app.widget.core

import org.json.JSONObject
import java.util.TimeZone

/**
 * Standard Envelope Metadata for all Attendrix Native Widget Snapshots (Schema v6).
 */
data class WidgetSnapshot(
    val schemaVersion: Int = 6,
    val generatedAt: Long = System.currentTimeMillis(),
    val validUntil: Long = System.currentTimeMillis() + 86400000L, // 24 hours
    val timezone: String = TimeZone.getDefault().id,
    val source: String = "app_state",
    val payload: JSONObject = JSONObject()
) {
    val isExpired: Boolean
        get() = System.currentTimeMillis() > validUntil

    val isStale: Boolean
        get() = (System.currentTimeMillis() - generatedAt) > (6 * 3600 * 1000L) // > 6 hours old

    fun toJson(): JSONObject = JSONObject().apply {
        put("schemaVersion", schemaVersion)
        put("generatedAt", generatedAt)
        put("validUntil", validUntil)
        put("timezone", timezone)
        put("source", source)
        put("payload", payload)
    }

    companion object {
        fun fromJson(rawJson: String): WidgetSnapshot {
            if (rawJson.isBlank()) return WidgetSnapshot()
            return try {
                val json = JSONObject(rawJson)
                if (json.has("schemaVersion") && json.has("payload")) {
                    WidgetSnapshot(
                        schemaVersion = json.optInt("schemaVersion", 6),
                        generatedAt = json.optLong("generatedAt", System.currentTimeMillis()),
                        validUntil = json.optLong("validUntil", System.currentTimeMillis() + 86400000L),
                        timezone = json.optString("timezone", TimeZone.getDefault().id),
                        source = json.optString("source", "app_state"),
                        payload = json.optJSONObject("payload") ?: JSONObject()
                    )
                } else {
                    // Legacy payload (Schema v4 / v5 without envelope)
                    WidgetSnapshot(
                        schemaVersion = json.optInt("version", 4),
                        generatedAt = json.optLong("updatedAtMillis", System.currentTimeMillis()),
                        validUntil = System.currentTimeMillis() + 86400000L,
                        payload = json
                    )
                }
            } catch (_: Throwable) {
                WidgetSnapshot()
            }
        }
    }
}
