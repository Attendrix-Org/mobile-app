package com.attendrix.app.widget

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.unit.ColorProvider

/**
 * Design Tokens for Attendrix Widget System v2 UX Refactor.
 * Material 3 Semantic Color Roles & Expressive Tones.
 */
object WidgetTokens {

    object Radius {
        val Card: Dp = 28.dp
        val Chip: Dp = 16.dp
        val Button: Dp = 20.dp
        val IconButton: Dp = 18.dp
        val InnerBlock: Dp = 20.dp
        val SmallBadge: Dp = 8.dp
    }

    object Spacing {
        val xs: Dp = 4.dp
        val sm: Dp = 8.dp
        val md: Dp = 12.dp
        val lg: Dp = 16.dp
        val xl: Dp = 24.dp
        val IconButtonSize: Dp = 36.dp
        val MinTouchTarget: Dp = 48.dp
    }

    object Typography {
        val Title: TextUnit = 16.sp
        val ClassHeader: TextUnit = 18.sp
        val CourseCode: TextUnit = 14.sp
        val Body: TextUnit = 12.sp
        val Caption: TextUnit = 11.sp
        val Micro: TextUnit = 10.sp
    }

    object Colours {
        // Material 3 Color Roles
        val Primary = ColorProvider(Color(0xFF6F61EF))
        val Secondary = ColorProvider(Color(0xFF39D2C0))
        val Tertiary = ColorProvider(Color(0xFFEE8B60))
        val Background = ColorProvider(Color(0xFFF8F9FF))
        val Surface = ColorProvider(Color(0xFFFFFFFF))
        val SurfaceVariant = ColorProvider(Color(0xFFE0E3E7))
        val SurfaceContainer = ColorProvider(Color(0xFFF5F7FA))
        val TextPrimary = ColorProvider(Color(0xFF14181B))
        val TextSecondary = ColorProvider(Color(0xFF57636C))
        val Error = ColorProvider(Color(0xFFFF5963))

        // Hero Card Themes
        val HeroContainerLive = ColorProvider(Color(0xFFE2F3E8))     // Mint Green (Now Serving / Live)
        val OnHeroContainerLive = ColorProvider(Color(0xFF052111))
        val HeroContainerUpcoming = ColorProvider(Color(0xFFEDE7F6)) // Deep Lavender (Next Up)
        val OnHeroContainerUpcoming = ColorProvider(Color(0xFF1D0061))

        // Meal Accent Tones (Left Accent Stripes & Card Backgrounds)
        val BreakfastContainer = ColorProvider(Color(0xFFFFF3E0))    // Warm Amber/Orange
        val BreakfastAccent = ColorProvider(Color(0xFFFF9800))

        val LunchContainer = ColorProvider(Color(0xFFE8F5E9))        // Fresh Mint Green
        val LunchAccent = ColorProvider(Color(0xFF4CAF50))

        val TeaContainer = ColorProvider(Color(0xFFF3E5F5))          // Light Berry/Purple
        val TeaAccent = ColorProvider(Color(0xFFAB47BC))

        val DinnerContainer = ColorProvider(Color(0xFFE1F5FE))       // Soft Sky Blue
        val DinnerAccent = ColorProvider(Color(0xFF0288D1))

        // Diet Badges
        val VegChipBg = ColorProvider(Color(0xFFE8F5E9))             // Soft Green
        val VegChipText = ColorProvider(Color(0xFF2E7D32))           // Dark Green

        val NonVegChipBg = ColorProvider(Color(0xFFFFEBEE))          // Soft Red
        val NonVegChipText = ColorProvider(Color(0xFFC62828))        // Dark Red

        val EggChipBg = ColorProvider(Color(0xFFFFF8E1))             // Warm Amber
        val EggChipText = ColorProvider(Color(0xFFF57F17))           // Dark Gold

        // Semantic Status Roles
        val StatusLive = Primary
        val StatusUpcoming = Secondary
        val StatusCompleted = SurfaceVariant
        val StatusCancelled = Error
        val StatusOffline = Tertiary
        val StatusHoliday = ColorProvider(Color(0xFFE0F2FE))
    }
}
