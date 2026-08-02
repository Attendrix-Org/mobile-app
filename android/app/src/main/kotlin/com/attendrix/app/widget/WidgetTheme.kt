package com.attendrix.app.widget

import androidx.compose.runtime.Composable
import androidx.glance.GlanceTheme

@Composable
fun AttendrixWidgetTheme(content: @Composable () -> Unit) {
    GlanceTheme {
        content()
    }
}
