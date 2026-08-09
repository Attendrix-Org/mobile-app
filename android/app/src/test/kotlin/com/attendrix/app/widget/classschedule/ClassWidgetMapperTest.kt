package com.attendrix.app.widget.classschedule

import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetSnapshot
import com.attendrix.app.widget.model.WidgetStatus
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class ClassWidgetMapperTest {

    @Test
    fun testLiveClassMapping() {
        val now = 1000000L
        val start = now - 1800000L // 30 min ago
        val end = now + 1800000L   // 30 min from now

        val payload = JSONObject().apply {
            put("state", "Ready")
            put("currentClass", JSONObject().apply {
                put("classId", "c101")
                put("courseName", "Database Systems")
                put("courseCode", "CS301")
                put("venue", "LT-204")
                put("startMillis", start)
                put("endMillis", end)
            })
            put("overallAttendancePercentage", 92.0)
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = ClassWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is ClassWidgetState.Ready)
        val readyState = state as ClassWidgetState.Ready
        assertNotNull(readyState.currentClass)
        assertEquals("Database Systems", readyState.currentClass?.courseName)
        assertEquals("LT-204", readyState.currentClass?.venue)
        assertEquals(0.5, readyState.progress, 0.01)
        assertEquals(30, readyState.remainingMinutes)
        assertEquals(92.0, readyState.overallAttendancePercentage, 0.01)
    }

    @Test
    fun testCancelledClassStatusMapping() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Ready")
            put("currentClass", JSONObject().apply {
                put("classId", "c102")
                put("courseName", "Compiler Design")
                put("venue", "LT-102")
                put("status", "CANCELLED")
                put("startMillis", now + 600000L)
                put("endMillis", now + 4200000L)
            })
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = ClassWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is ClassWidgetState.Ready)
        val readyState = state as ClassWidgetState.Ready
        assertEquals(WidgetStatus.CANCELLED, readyState.currentClass?.status)
    }

    @Test
    fun testRescheduledClassStatusMapping() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Ready")
            put("nextClass", JSONObject().apply {
                put("classId", "c103")
                put("courseName", "Software Engineering")
                put("venue", "LT-301")
                put("status", "RESCHEDULED")
                put("startMillis", now + 1200000L)
                put("endMillis", now + 4800000L)
            })
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = ClassWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is ClassWidgetState.Ready)
        val readyState = state as ClassWidgetState.Ready
        assertEquals(WidgetStatus.RESCHEDULED, readyState.nextClass?.status)
    }

    @Test
    fun testEmptyScheduleMapping() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Empty")
            put("emptyReason", "NO_CLASSES")
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = ClassWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is ClassWidgetState.Empty)
        assertEquals(EmptyState.NO_CLASSES, (state as ClassWidgetState.Empty).reason)
    }

    @Test
    fun testWeekendEmptyStateMapping() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Empty")
            put("emptyReason", "WEEKEND")
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = ClassWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is ClassWidgetState.Empty)
        assertEquals(EmptyState.WEEKEND, (state as ClassWidgetState.Empty).reason)
    }

    @Test
    fun testStaleSnapshotMapping() {
        val now = 100000000L
        val sevenHoursAgo = now - (7 * 3600 * 1000L)

        val payload = JSONObject().apply {
            put("state", "Ready")
            put("currentClass", JSONObject().apply {
                put("classId", "c101")
                put("courseName", "Algorithms")
                put("venue", "LT-101")
                put("startMillis", now - 600000L)
                put("endMillis", now + 600000L)
            })
        }

        val snapshot = WidgetSnapshot(generatedAt = sevenHoursAgo, payload = payload)
        val state = ClassWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is ClassWidgetState.Stale)
        val staleState = state as ClassWidgetState.Stale
        assertTrue(staleState.staleByMinutes >= 420)
        assertEquals("Algorithms", staleState.readyState.currentClass?.courseName)
    }
}
