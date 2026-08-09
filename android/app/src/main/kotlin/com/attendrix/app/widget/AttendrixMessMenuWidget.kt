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
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetStateStore
import com.attendrix.app.widget.messmenu.LargeMessMenuLayout
import com.attendrix.app.widget.messmenu.MediumMessMenuLayout
import com.attendrix.app.widget.messmenu.MessMenuWidgetComponents
import com.attendrix.app.widget.messmenu.MessMenuWidgetMapper
import com.attendrix.app.widget.messmenu.MessMenuWidgetState
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
    val isSmall = size.width < AttendrixMessMenuWidget.MEDIUM_RECTANGLE.width
    val isLarge = size.height >= AttendrixMessMenuWidget.LARGE_RECTANGLE.height

    when (widgetState) {
        is MessMenuWidgetState.Loading -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
            ) {
                Text(
                    text = "MESS MENU",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextMuted,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Spacer(modifier = GlanceModifier.height(6.dp))
                Text(
                    text = "Syncing menu…",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
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
                MessMenuWidgetComponents.MessEmptyStateContent(EmptyState.NO_MENU_AVAILABLE)
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
                MessMenuWidgetComponents.MessEmptyStateContent(widgetState.reason)
            }
        }

        is MessMenuWidgetState.Ready -> {
            when {
                isSmall -> SmallMessMenuLayout(widgetState)
                isLarge -> LargeMessMenuLayout(widgetState)
                else    -> MediumMessMenuLayout(widgetState)
            }
        }

        is MessMenuWidgetState.Stale -> {
            when {
                isSmall -> SmallMessMenuLayout(widgetState.readyState, isStale = true, staleByMinutes = widgetState.staleByMinutes)
                isLarge -> LargeMessMenuLayout(widgetState.readyState, isStale = true, staleByMinutes = widgetState.staleByMinutes)
                else    -> MediumMessMenuLayout(widgetState.readyState, isStale = true, staleByMinutes = widgetState.staleByMinutes)
            }
        }
    }
}
