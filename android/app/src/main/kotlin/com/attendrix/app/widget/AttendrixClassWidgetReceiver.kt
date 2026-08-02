package com.attendrix.app.widget

import android.content.Context
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver

class AttendrixClassWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = AttendrixClassWidget()

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
    }
}
