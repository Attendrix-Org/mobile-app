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
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.classschedule.ClassWidgetComponents
import com.attendrix.app.widget.classschedule.ClassWidgetMapper
import com.attendrix.app.widget.classschedule.ClassWidgetState
import com.attendrix.app.widget.classschedule.LargeClassLayout
import com.attendrix.app.widget.classschedule.MediumClassLayout
import com.attendrix.app.widget.classschedule.SmallClassLayout
import com.attendrix.app.widget.core.EmptyState
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
    val isSmall = size.width < AttendrixClassWidget.MEDIUM_RECTANGLE.width
    val isLarge = size.height >= AttendrixClassWidget.LARGE_RECTANGLE.height

    when (widgetState) {
        is ClassWidgetState.Loading -> {
            // Minimal loading placeholder — persisted snapshots make this rare
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
            ) {
                Text(
                    text = "LOADING",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextMuted,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Spacer(modifier = GlanceModifier.height(6.dp))
                Text(
                    text = "Syncing schedule…",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
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
                ClassWidgetComponents.EmptyStateContent(EmptyState.NO_CLASSES)
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
                ClassWidgetComponents.EmptyStateContent(widgetState.reason)
            }
        }

        is ClassWidgetState.Ready -> {
            when {
                isSmall -> SmallClassLayout(widgetState)
                isLarge -> LargeClassLayout(widgetState)
                else    -> MediumClassLayout(widgetState)
            }
        }

        is ClassWidgetState.Stale -> {
            when {
                isSmall -> SmallClassLayout(widgetState.readyState, isStale = true, staleByMinutes = widgetState.staleByMinutes)
                isLarge -> LargeClassLayout(widgetState.readyState, isStale = true, staleByMinutes = widgetState.staleByMinutes)
                else    -> MediumClassLayout(widgetState.readyState, isStale = true, staleByMinutes = widgetState.staleByMinutes)
            }
        }
    }
}

class RefreshWidgetAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: androidx.glance.action.ActionParameters) {
        WidgetUpdater.updateAllWidgets(context)
    }
}
