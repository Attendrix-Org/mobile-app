package com.attendrix.app.widget.messmenu

import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.MessMenuWidgetState
import com.attendrix.app.widget.core.WidgetSnapshot
import com.attendrix.app.widget.model.DietType
import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class MessMenuWidgetMapperTest {

    @Test
    fun testReadyMessMenuMapping() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Ready")
            put("messName", "North Campus Mess")
            put("currentMeal", JSONObject().apply {
                put("mealName", "Lunch")
                put("timeRange", "12:30 PM - 2:30 PM")
                put("mainItems", JSONArray().apply {
                    put("Paneer Masala")
                    put("Dal Tadka")
                })
                put("staples", "Rice, Chapati, Salad")
                put("dietType", "VEG")
            })
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = MessMenuWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is MessMenuWidgetState.Ready)
        val readyState = state as MessMenuWidgetState.Ready
        assertEquals("North Campus Mess", readyState.messName)
        assertNotNull(readyState.currentMeal)
        assertEquals("Lunch", readyState.currentMeal?.mealName)
        assertEquals(DietType.VEG, readyState.currentMeal?.dietType)
        assertEquals(2, readyState.currentMeal?.mainItems?.size)
    }

    @Test
    fun testNoMessSelectedEmptyState() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Empty")
            put("emptyReason", "NO_MESS_SELECTED")
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = MessMenuWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is MessMenuWidgetState.Empty)
        assertEquals(EmptyState.NO_MESS_SELECTED, (state as MessMenuWidgetState.Empty).reason)
    }

    @Test
    fun testNoMenuAvailableEmptyState() {
        val now = 1000000L
        val payload = JSONObject().apply {
            put("state", "Empty")
            put("emptyReason", "NO_MENU_AVAILABLE")
        }

        val snapshot = WidgetSnapshot(generatedAt = now, payload = payload)
        val state = MessMenuWidgetMapper.toWidgetState(snapshot, now)

        assertTrue(state is MessMenuWidgetState.Empty)
        assertEquals(EmptyState.NO_MENU_AVAILABLE, (state as MessMenuWidgetState.Empty).reason)
    }
}
