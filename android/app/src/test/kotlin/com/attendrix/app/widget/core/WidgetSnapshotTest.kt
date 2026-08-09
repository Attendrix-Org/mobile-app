package com.attendrix.app.widget.core

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class WidgetSnapshotTest {

    @Test
    fun testValidSchemaV6SnapshotParsing() {
        val now = System.currentTimeMillis()
        val jsonStr = """
            {
                "schemaVersion": 6,
                "generatedAt": $now,
                "validUntil": ${now + 86400000L},
                "timezone": "Asia/Kolkata",
                "source": "app_state",
                "payload": {
                    "state": "Ready",
                    "currentClass": {
                        "classId": "c1",
                        "courseName": "DBMS",
                        "venue": "LT-204",
                        "startMillis": $now,
                        "endMillis": ${now + 3600000L}
                    }
                }
            }
        """.trimIndent()

        val snapshot = WidgetSnapshot.fromJson(jsonStr)

        assertEquals(6, snapshot.schemaVersion)
        assertEquals(now, snapshot.generatedAt)
        assertEquals("Asia/Kolkata", snapshot.timezone)
        assertEquals("app_state", snapshot.source)
        assertFalse(snapshot.isExpired())
        assertFalse(snapshot.isStale())
        assertNotNull(snapshot.payload.optJSONObject("currentClass"))
    }

    @Test
    fun testLegacySchemaV4Parsing() {
        val now = System.currentTimeMillis()
        val legacyJsonStr = """
            {
                "version": 4,
                "state": "Ready",
                "updatedAtMillis": $now,
                "overallAttendancePercentage": 85.5
            }
        """.trimIndent()

        val snapshot = WidgetSnapshot.fromJson(legacyJsonStr)

        assertEquals(4, snapshot.schemaVersion)
        assertEquals(now, snapshot.generatedAt)
        assertFalse(snapshot.isExpired())
        assertEquals("Ready", snapshot.payload.optString("state"))
        assertEquals(85.5, snapshot.payload.optDouble("overallAttendancePercentage"), 0.01)
    }

    @Test
    fun testMalformedJsonHandling() {
        val snapshot = WidgetSnapshot.fromJson("INVALID_JSON{}}")

        assertEquals(6, snapshot.schemaVersion)
        assertNotNull(snapshot.payload)
        assertFalse(snapshot.isExpired())
    }

    @Test
    fun testEmptyJsonHandling() {
        val snapshot = WidgetSnapshot.fromJson("")

        assertEquals(6, snapshot.schemaVersion)
        assertNotNull(snapshot.payload)
        assertFalse(snapshot.isExpired())
    }

    @Test
    fun testExpiredSnapshotDetection() {
        val past = System.currentTimeMillis() - 100000000L
        val snapshot = WidgetSnapshot(
            generatedAt = past - 100000L,
            validUntil = past
        )

        assertTrue(snapshot.isExpired())
    }

    @Test
    fun testStaleSnapshotDetection() {
        val now = System.currentTimeMillis()
        val sevenHoursAgo = now - (7 * 3600 * 1000L)
        val snapshot = WidgetSnapshot(
            generatedAt = sevenHoursAgo,
            validUntil = now + 86400000L
        )

        assertTrue(snapshot.isStale())
    }
}
