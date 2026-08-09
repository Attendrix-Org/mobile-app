package com.attendrix.app.widget.core

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class WidgetRefreshSchedulerTest {

    @Test
    fun testSelectsEarliestClassEndBoundary() {
        val now = 1000000L
        val classEnd = now + 1800000L // +30 min

        val classPayload = JSONObject().apply {
            put("currentClass", JSONObject().apply {
                put("endMillis", classEnd)
            })
        }
        val messPayload = JSONObject()

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = now + 86400000L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = now + 86400000L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertEquals(classEnd, nextBoundary)
    }

    @Test
    fun testSelectsNextClassStartBoundary() {
        val now = 1000000L
        val classStart = now + 900000L // +15 min

        val classPayload = JSONObject().apply {
            put("nextClass", JSONObject().apply {
                put("startMillis", classStart)
            })
        }
        val messPayload = JSONObject()

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = now + 86400000L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = now + 86400000L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertEquals(classStart, nextBoundary)
    }

    @Test
    fun testIgnoresPastClassBoundaries() {
        val now = 1000000L
        val pastEnd = now - 500000L // -8 min

        val classPayload = JSONObject().apply {
            put("currentClass", JSONObject().apply {
                put("endMillis", pastEnd)
            })
        }
        val messPayload = JSONObject()

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = now + 86400000L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = now + 86400000L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertTrue(nextBoundary!! > now)
    }
}
