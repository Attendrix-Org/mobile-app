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
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.classschedule.ClassWidgetComponents
import com.attendrix.app.widget.core.MessMenuWidgetState
import com.attendrix.app.widget.core.WidgetStateStore
import com.attendrix.app.widget.core.WidgetTokens
import com.attendrix.app.widget.messmenu.LargeMessMenuLayout
import com.attendrix.app.widget.messmenu.MediumMessMenuLayout
import com.attendrix.app.widget.messmenu.MessMenuWidgetComponents
import com.attendrix.app.widget.messmenu.MessMenuWidgetMapper
import com.attendrix.app.widget.messmenu.SmallMessMenuLayout

class AttendrixMessMenuWidget : GlanceAppWidget() {

    companion object {
        val SMALL_SQUARE = DpSize(140.dp, 110.dp)
        val MEDIUM_RECTANGLE = DpSize(260.dp, 110.dp)
        val LARGE_RECTANGLE = DpSize(260.dp, 220.dp)
    }

    override val sizeMode = SizeMode.Responsive(setOf(SMALL_SQUARE, MEDIUM_RECTANGLE, LARGE_RECTANGLE))

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val snapshot = WidgetStateStore.getMessMenuSnapshot(context)
        val widgetState = MessMenuWidgetMapper.toWidgetState(snapshot)

        provideContent {
            GlanceTheme {
                MessMenuStateRenderer(widgetState = widgetState)
            }
        }
    }
}

class AttendrixMessMenuWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = AttendrixMessMenuWidget()
}

@Composable
fun MessMenuStateRenderer(widgetState: MessMenuWidgetState) {
    val size = LocalSize.current

    when (widgetState) {
        is MessMenuWidgetState.Loading -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
            ) {
                MessMenuWidgetComponents.MessMenuHeader(messName = "Mess Menu")
            }
        }
        is MessMenuWidgetState.Error -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
                    .clickable(actionStartActivity<MainActivity>())
            ) {
                MessMenuWidgetComponents.MessMenuHeader(messName = "Mess Menu")
                ClassWidgetComponents.ContextualEmptyStateView(com.attendrix.app.widget.core.EmptyState.NO_MENU_AVAILABLE)
            }
        }
        is MessMenuWidgetState.Empty -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
                    .clickable(actionStartActivity<MainActivity>())
            ) {
                MessMenuWidgetComponents.MessMenuHeader(messName = "Mess Menu")
                ClassWidgetComponents.ContextualEmptyStateView(widgetState.reason)
            }
        }
        is MessMenuWidgetState.Ready -> {
            val isSmall = size.width < AttendrixMessMenuWidget.MEDIUM_RECTANGLE.width
            val isLarge = size.height >= AttendrixMessMenuWidget.LARGE_RECTANGLE.height

            when {
                isSmall -> SmallMessMenuLayout(widgetState)
                isLarge -> LargeMessMenuLayout(widgetState)
                else -> MediumMessMenuLayout(widgetState)
            }
        }
        is MessMenuWidgetState.Stale -> {
            val isSmall = size.width < AttendrixMessMenuWidget.MEDIUM_RECTANGLE.width
            val isLarge = size.height >= AttendrixMessMenuWidget.LARGE_RECTANGLE.height

            when {
                isSmall -> SmallMessMenuLayout(widgetState.readyState, isStale = true)
                isLarge -> LargeMessMenuLayout(widgetState.readyState, isStale = true)
                else -> MediumMessMenuLayout(widgetState.readyState, isStale = true)
            }
        }
    }
}
