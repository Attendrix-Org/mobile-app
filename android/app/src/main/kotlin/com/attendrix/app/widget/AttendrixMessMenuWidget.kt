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
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.preview.Preview
import com.attendrix.app.MainActivity

class AttendrixMessMenuWidget : GlanceAppWidget() {

    companion object {
        val SMALL_SQUARE = DpSize(140.dp, 110.dp)
        val MEDIUM_RECTANGLE = DpSize(260.dp, 110.dp)
        val LARGE_RECTANGLE = DpSize(260.dp, 220.dp)
        private const val PREFS_NAME = "HomeWidgetPreferences"
        private const val KEY = "mess_menu_widget_state_json"

        fun getSnapshot(context: Context): MessMenuWidgetState {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val jsonStr = prefs.getString(KEY, null)
            if (jsonStr.isNullOrBlank()) {
                return MessMenuWidgetState(state = "Empty", emptyReason = EmptyState.NO_MESS_SELECTED)
            }
            return MessMenuWidgetState.fromJson(jsonStr)
        }
    }

    override val sizeMode = SizeMode.Responsive(setOf(SMALL_SQUARE, MEDIUM_RECTANGLE, LARGE_RECTANGLE))

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val snapshot = getSnapshot(context)
        val uiState = when (snapshot.state) {
            "Loading" -> WidgetUiState.Loading
            "Offline" -> WidgetUiState.Offline(WidgetState(version = 5), snapshot.updatedAtMillis)
            "Error", "SyncFailed" -> WidgetUiState.Error("Couldn't load mess menu")
            "AuthExpired" -> WidgetUiState.Empty(EmptyState.LOGGED_OUT)
            "Empty" -> WidgetUiState.Empty(snapshot.emptyReason)
            else -> {
                if (snapshot.currentMeal == null && snapshot.nextMeal == null && snapshot.todayMeals.isEmpty()) {
                    WidgetUiState.Empty(snapshot.emptyReason)
                } else {
                    WidgetUiState.Ready(WidgetState(version = 5))
                }
            }
        }

        provideContent {
            GlanceTheme {
                MessMenuStateRenderer(snapshot = snapshot, uiState = uiState)
            }
        }
    }
}

class AttendrixMessMenuWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = AttendrixMessMenuWidget()
}

@Composable
fun MessMenuStateRenderer(snapshot: MessMenuWidgetState, uiState: WidgetUiState) {
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
                WidgetComponents.Header(contextTitle = "Syncing", brand = "MESS MENU", isSyncing = true)
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
                WidgetComponents.Header(contextTitle = "Error", brand = "MESS MENU")
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
                WidgetComponents.Header(contextTitle = "Mess Menu", brand = "ATTENDRIX")
                WidgetComponents.ContextualEmptyStateView(uiState.reason)
            }
        }
        is WidgetUiState.Ready, is WidgetUiState.Offline -> {
            val isSmall = size.width < AttendrixMessMenuWidget.MEDIUM_RECTANGLE.width
            val isLarge = size.height >= AttendrixMessMenuWidget.LARGE_RECTANGLE.height

            when {
                isSmall -> SmallMessMenuLayout(snapshot)
                isLarge -> LargeMessMenuLayout(snapshot)
                else -> MediumMessMenuLayout(snapshot)
            }
        }
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview(widthDp = 140, heightDp = 110)
@Composable
fun MessMenuPreviewSmall() {
    GlanceTheme {
        SmallMessMenuLayout(MessMenuWidgetState(version = 5, state = "Ready"))
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview(widthDp = 260, heightDp = 110)
@Composable
fun MessMenuPreviewMedium() {
    GlanceTheme {
        MediumMessMenuLayout(MessMenuWidgetState(version = 5, state = "Ready"))
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview(widthDp = 260, heightDp = 220)
@Composable
fun MessMenuPreviewLarge() {
    GlanceTheme {
        LargeMessMenuLayout(MessMenuWidgetState(version = 5, state = "Ready"))
    }
}
