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
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.preview.Preview
import com.attendrix.app.MainActivity

class AttendrixClassWidget : GlanceAppWidget() {

    companion object {
        val SMALL_SQUARE = DpSize(140.dp, 110.dp)
        val MEDIUM_RECTANGLE = DpSize(260.dp, 110.dp)
        val LARGE_RECTANGLE = DpSize(260.dp, 220.dp)
    }

    override val sizeMode = SizeMode.Responsive(setOf(SMALL_SQUARE, MEDIUM_RECTANGLE, LARGE_RECTANGLE))

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val snapshot = WidgetStateRepository.getSnapshot(context)
        val uiState = WidgetStateMapper.toUiState(snapshot)

        provideContent {
            GlanceTheme {
                WidgetStateRenderer(snapshot = snapshot, uiState = uiState)
            }
        }
    }
}

@Composable
fun WidgetStateRenderer(snapshot: WidgetState, uiState: WidgetUiState) {
    val size = LocalSize.current

    when (uiState) {
        is WidgetUiState.Loading -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
            ) {
                WidgetComponents.Header(contextTitle = "Syncing", isSyncing = true)
                WidgetComponents.StaticLoadingPlaceholder()
            }
        }
        is WidgetUiState.Error -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
                    .clickable(actionStartActivity<MainActivity>())
            ) {
                WidgetComponents.Header(contextTitle = "Error")
                WidgetComponents.ErrorStateView()
            }
        }
        is WidgetUiState.Empty -> {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(WidgetTokens.Colours.Background)
                    .cornerRadius(WidgetTokens.Radius.Card)
                    .padding(WidgetTokens.Spacing.md)
                    .clickable(actionStartActivity<MainActivity>())
            ) {
                WidgetComponents.Header(contextTitle = "Schedule")
                WidgetComponents.ContextualEmptyStateView(uiState.reason)
            }
        }
        is WidgetUiState.Ready, is WidgetUiState.Offline -> {
            val isSmall = size.width < AttendrixClassWidget.MEDIUM_RECTANGLE.width
            val isLarge = size.height >= AttendrixClassWidget.LARGE_RECTANGLE.height

            when {
                isSmall -> SmallLayout(snapshot)
                isLarge -> LargeLayout(snapshot)
                else -> MediumLayout(snapshot)
            }
        }
    }
}

class RefreshWidgetAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: androidx.glance.action.ActionParameters) {
        WidgetUpdater.updateAllWidgets(context)
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview(widthDp = 140, heightDp = 110)
@Composable
fun WidgetPreviewSmall() {
    GlanceTheme {
        SmallLayout(WidgetState(version = 4, state = "Ready"))
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview(widthDp = 260, heightDp = 110)
@Composable
fun WidgetPreviewMedium() {
    GlanceTheme {
        MediumLayout(WidgetState(version = 4, state = "Ready"))
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview(widthDp = 260, heightDp = 220)
@Composable
fun WidgetPreviewLarge() {
    GlanceTheme {
        LargeLayout(WidgetState(version = 4, state = "Ready"))
    }
}
