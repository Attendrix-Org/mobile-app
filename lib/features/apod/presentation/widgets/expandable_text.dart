import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget that displays text with a "Read More" / "Read Less" toggle
/// if the text content exceeds the specified line limit.
class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    super.key,
    this.trimLines = 4,
  });
  final String text;
  final int trimLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textStyle = GoogleFonts.plusJakartaSans(
      fontSize: 15,
      height: 1.6,
      color: isDark ? const Color(0xFFC8C4D6) : const Color(0xFF606A85),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
        )..layout(maxWidth: constraints.maxWidth);

        final didExceed = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Text(
                widget.text,
                style: textStyle,
                maxLines: _isExpanded ? null : widget.trimLines,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ),
            if (didExceed) ...[
              const SizedBox(height: 10),
              Semantics(
                button: true,
                label: _isExpanded
                    ? 'Show less explanation'
                    : 'Show more explanation',
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'READ LESS' : 'READ MORE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark
                                ? const Color(0xFFC5C0FF)
                                : const Color(0xFF6F61EF),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: isDark
                              ? const Color(0xFFC5C0FF)
                              : const Color(0xFF6F61EF),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
