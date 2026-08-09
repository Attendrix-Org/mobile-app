package com.attendrix.app.widget

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.LocalSize
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.classschedule.ClassWidgetComponents
import com.attendrix.app.widget.classschedule.ClassWidgetMapper
import com.attendrix.app.widget.classschedule.ClassWidgetState
import com.attendrix.app.widget.classschedule.LargeClassLayout
import com.attendrix.app.widget.classschedule.MediumClassLayout
import com.attendrix.app.widget.classschedule.SmallClassLayout
import com.attendrix.app.widget.core.WidgetStateStore

class AttendrixClassWidget : GlanceAppWidget() {

    companion object {
        val SMALL_SQUARE = DpSize(140.dp, 110.dp)
        val MEDIUM_RECTANGLE = DpSize(260.dp, 110.dp)
        val LARGE_RECTANGLE = DpSize(260.dp, 220.dp)
    }

    override val sizeMode = SizeMode.Responsive(setOf(SMALL_SQUARE, MEDIUM_RECTANGLE, LARGE_RECTANGLE))

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val snapshot = WidgetStateStore.getClassSnapshot(context)
        val widgetState = ClassWidgetMapper.toWidgetState(snapshot)

        provideContent {
            GlanceTheme {
                ClassStateRenderer(widgetState = widgetState)
            }
        }
    }
}

@Composable
fun ClassStateRenderer(widgetState: ClassWidgetState) {
    val size = LocalSize.current

    when (widgetState) {
        is ClassWidgetState.Loading -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
            ) {
                ClassWidgetComponents.Header(contextTitle = "Syncing")
            }
        }
        is ClassWidgetState.Error -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
                    .clickable(actionStartActivity<MainActivity>())
            ) {
                ClassWidgetComponents.Header(contextTitle = "Error")
                ClassWidgetComponents.ContextualEmptyStateView(com.attendrix.app.widget.core.EmptyState.NO_CLASSES)
            }
        }
        is ClassWidgetState.Empty -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
                    .clickable(actionStartActivity<MainActivity>())
            ) {
                ClassWidgetComponents.Header(contextTitle = "Schedule")
                ClassWidgetComponents.ContextualEmptyStateView(widgetState.reason)
            }
        }
        is ClassWidgetState.Ready -> {
            val isSmall = size.width < AttendrixClassWidget.MEDIUM_RECTANGLE.width
            val isLarge = size.height >= AttendrixClassWidget.LARGE_RECTANGLE.height

            when {
                isSmall -> SmallClassLayout(widgetState)
                isLarge -> LargeClassLayout(widgetState)
                else -> MediumClassLayout(widgetState)
            }
        }
        is ClassWidgetState.Stale -> {
            val isSmall = size.width < AttendrixClassWidget.MEDIUM_RECTANGLE.width
            val isLarge = size.height >= AttendrixClassWidget.LARGE_RECTANGLE.height

            when {
                isSmall -> SmallClassLayout(widgetState.readyState, isStale = true)
                isLarge -> LargeClassLayout(widgetState.readyState, isStale = true)
                else -> MediumClassLayout(widgetState.readyState, isStale = true)
            }
        }
    }
}

class RefreshWidgetAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: androidx.glance.action.ActionParameters) {
        WidgetUpdater.updateAllWidgets(context)
    }
}
