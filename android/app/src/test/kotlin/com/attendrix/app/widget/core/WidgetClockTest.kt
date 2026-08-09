package com.attendrix.app.widget.core

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class WidgetClockTest {

    @Test
    fun testCalculateProgressBeforeStart() {
        val start = 1000L
        val end = 2000L
        val now = 500L

        val progress = WidgetClock.calculateProgress(start, end, now)
        assertEquals(0.0, progress, 0.001)
    }

    @Test
    fun testCalculateProgressMidway() {
        val start = 1000L
        val end = 2000L
        val now = 1500L

        val progress = WidgetClock.calculateProgress(start, end, now)
        assertEquals(0.5, progress, 0.001)
    }

    @Test
    fun testCalculateProgressAfterEnd() {
        val start = 1000L
        val end = 2000L
        val now = 2500L

        val progress = WidgetClock.calculateProgress(start, end, now)
        assertEquals(1.0, progress, 0.001)
    }

    @Test
    fun testRemainingMinutes() {
        val now = 1000000L
        val end = now + (30 * 60000L) // +30 minutes

        val remaining = WidgetClock.remainingMinutes(end, now)
        assertEquals(30, remaining)
    }

    @Test
    fun testFormatCountdownNow() {
        val now = 1000000L
        val target = now + 1000L // 1 second

        val formatted = WidgetClock.formatCountdown(target, now)
        assertEquals("Now", formatted)
    }

    @Test
    fun testFormatCountdownMinutes() {
        val now = 1000000L
        val target = now + (28 * 60000L) // 28 minutes

        val formatted = WidgetClock.formatCountdown(target, now)
        assertEquals("28 min", formatted)
    }

    @Test
    fun testFormatCountdownHours() {
        val now = 1000000L
        val target = now + (2 * 3600000L + 15 * 60000L) // 2h 15m

        val formatted = WidgetClock.formatCountdown(target, now)
        assertTrue(formatted.contains("2h"))
    }
}
