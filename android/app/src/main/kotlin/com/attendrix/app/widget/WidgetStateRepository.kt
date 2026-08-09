package com.attendrix.app.widget

import android.content.Context
import com.attendrix.app.widget.core.WidgetSnapshot
import com.attendrix.app.widget.core.WidgetStateStore
import com.attendrix.app.widget.model.WidgetState

/**
 * Legacy Repository Compatibility Layer.
 * Delegates all persistence and snapshot reading to WidgetStateStore.
 */
object WidgetStateRepository {
    fun getSnapshot(context: Context): WidgetState {
        val snapshot = WidgetStateStore.getClassSnapshot(context)
        return WidgetState.fromJson(snapshot.payload.toString())
    }

    fun getSnapshotObject(context: Context): WidgetSnapshot {
        return WidgetStateStore.getClassSnapshot(context)
    }
}
