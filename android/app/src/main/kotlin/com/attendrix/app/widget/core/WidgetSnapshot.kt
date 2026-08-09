package com.attendrix.app.widget.core

import org.json.JSONObject
import java.util.TimeZone

/**
 * Standard Envelope Metadata for all Attendrix Native Widget Snapshots (Schema v6).
 * validUntil is the authoritative expiration mechanism specified by the state provider.
 * isStale is a freshness indicator used for UI badges, not an invalidation mechanism.
 */
data class WidgetSnapshot(
    val schemaVersion: Int = 6,
    val generatedAt: Long = System.currentTimeMillis(),
    val validUntil: Long = 0L, // 0L = No explicit expiration
    val timezone: String = TimeZone.getDefault().id,
    val source: String = "app_state",
    val payload: JSONObject = JSONObject()
) {
    fun isExpired(nowMillis: Long = System.currentTimeMillis()): Boolean {
        return validUntil > 0L && nowMillis > validUntil
    }

    fun isStale(nowMillis: Long = System.currentTimeMillis(), staleThresholdMillis: Long = 6 * 3600 * 1000L): Boolean {
        if (generatedAt <= 0L) return false
        return (nowMillis - generatedAt) > staleThresholdMillis
    }

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
                        validUntil = json.optLong("validUntil", 0L),
                        timezone = json.optString("timezone", TimeZone.getDefault().id),
                        source = json.optString("source", "app_state"),
                        payload = json.optJSONObject("payload") ?: JSONObject()
                    )
                } else {
                    // Legacy payload (Schema v4 / v5 without envelope)
                    WidgetSnapshot(
                        schemaVersion = json.optInt("version", 4),
                        generatedAt = json.optLong("updatedAtMillis", System.currentTimeMillis()),
                        validUntil = 0L,
                        payload = json
                    )
                }
            } catch (_: Throwable) {
                WidgetSnapshot()
            }
        }
    }
}
