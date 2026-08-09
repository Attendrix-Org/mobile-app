package com.attendrix.app.widget.core

import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.util.Calendar

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

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = messPayload)

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

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertEquals(classStart, nextBoundary)
    }

    @Test
    fun testSelectsMealEndBoundary() {
        val cal = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 12)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val now = cal.timeInMillis

        // Meal ends at 13:00 (780 minutes since midnight)
        val mealEndMin = 13 * 60
        val expectedMealEndTimestamp = getStartOfDay(now) + (mealEndMin * 60000L)

        val classPayload = JSONObject()
        val messPayload = JSONObject().apply {
            put("currentMeal", JSONObject().apply {
                put("mealName", "Lunch")
                put("endMinutes", mealEndMin)
            })
        }

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertEquals(expectedMealEndTimestamp, nextBoundary)
    }

    @Test
    fun testSelectsNextMealStartBoundary() {
        val cal = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 11)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val now = cal.timeInMillis

        // Next meal starts at 12:30 (750 minutes since midnight)
        val mealStartMin = 12 * 60 + 30
        val expectedMealStartTimestamp = getStartOfDay(now) + (mealStartMin * 60000L)

        val classPayload = JSONObject()
        val messPayload = JSONObject().apply {
            put("nextMeal", JSONObject().apply {
                put("mealName", "Lunch")
                put("startMinutes", mealStartMin)
            })
        }

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertEquals(expectedMealStartTimestamp, nextBoundary)
    }

    @Test
    fun testIgnoresPastClassBoundaries() {
        val now = 1000000L
        val pastEnd = now - 500000L

        val classPayload = JSONObject().apply {
            put("currentClass", JSONObject().apply {
                put("endMillis", pastEnd)
            })
        }
        val messPayload = JSONObject()

        val classSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = classPayload)
        val messSnapshot = WidgetSnapshot(generatedAt = now, validUntil = 0L, payload = messPayload)

        val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot, now)

        assertNotNull(nextBoundary)
        assertTrue(nextBoundary!! > now)
    }

    private fun getStartOfDay(millis: Long): Long {
        return Calendar.getInstance().apply {
            timeInMillis = millis
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
    }
}
