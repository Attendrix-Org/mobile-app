package com.attendrix.app.widget

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.unit.ColorProvider

/**
 * Design Tokens for Attendrix Widget System — UI/UX Refinement Pass.
 * Small, semantic, no dead code.
 */
object WidgetTokens {

    object Radius {
        val Card: Dp = 16.dp
        val Chip: Dp = 8.dp
        val AccentBar: Dp = 3.dp
    }

    object Spacing {
        val xs: Dp = 4.dp
        val sm: Dp = 8.dp
        val md: Dp = 12.dp
        val lg: Dp = 16.dp
    }

    object Typography {
        // Dominant — course name, meal name
        val Hero: TextUnit = 16.sp
        // Secondary meta — venue, time range, countdown
        val Body: TextUnit = 12.sp
        // Status label — LIVE / NEXT / DONE / diet badge
        val Label: TextUnit = 10.sp
        // Tertiary — stale notice, supporting info
        val Caption: TextUnit = 11.sp
    }

    object Colours {
        // Surfaces
        val Background    = ColorProvider(Color(0xFFF5F6FA))
        val Surface       = ColorProvider(Color(0xFFFFFFFF))
        val SurfaceDim    = ColorProvider(Color(0xFFEEEFF4))
        val Divider       = ColorProvider(Color(0xFFE0E3E7))

        // Text
        val TextPrimary   = ColorProvider(Color(0xFF14181B))
        val TextSecondary = ColorProvider(Color(0xFF57636C))
        val TextMuted     = ColorProvider(Color(0xFF9DA3A8))

        // Brand accent (purple)
        val Primary       = ColorProvider(Color(0xFF6F61EF))

        // Semantic status — each unique hue
        val StatusLive    = ColorProvider(Color(0xFF1B8A5A))   // green
        val StatusNext    = ColorProvider(Color(0xFF6F61EF))   // purple
        val StatusDone    = ColorProvider(Color(0xFF9DA3A8))   // muted
        val StatusWarning = ColorProvider(Color(0xFFB45309))   // amber
        val StatusError   = ColorProvider(Color(0xFFDC2626))   // red

        // Hero card surfaces
        val HeroLiveBg    = ColorProvider(Color(0xFFEAF7F1))   // mint
        val HeroLiveAccent= ColorProvider(Color(0xFF1B8A5A))
        val HeroNextBg    = ColorProvider(Color(0xFFEFEDFB))   // lavender
        val HeroNextAccent= ColorProvider(Color(0xFF6F61EF))
        val HeroCancelBg  = ColorProvider(Color(0xFFFFF1F2))
        val HeroCancelAccent = ColorProvider(Color(0xFFDC2626))

        // Diet badges
        val DietVegBg     = ColorProvider(Color(0xFFDCFCE7))
        val DietVegText   = ColorProvider(Color(0xFF166534))
        val DietEggBg     = ColorProvider(Color(0xFFFEF3C7))
        val DietEggText   = ColorProvider(Color(0xFFB45309))
        val DietNonVegBg  = ColorProvider(Color(0xFFFEE2E2))
        val DietNonVegText= ColorProvider(Color(0xFF991B1B))
        val DietSpecialBg = ColorProvider(Color(0xFFEDE7F6))
        val DietSpecialText = ColorProvider(Color(0xFF6D28D9))

        // Attendance
        val AttendAtRiskBg   = ColorProvider(Color(0xFFFFCDD2))
        val AttendAtRiskText = ColorProvider(Color(0xFFB3261E))
        val AttendOnEdgeBg   = ColorProvider(Color(0xFFFFF0C2))
        val AttendOnEdgeText = ColorProvider(Color(0xFF7A5900))
        val AttendSafeBg     = ColorProvider(Color(0xFFDCFCE7))
        val AttendSafeText   = ColorProvider(Color(0xFF166534))
    }
}
