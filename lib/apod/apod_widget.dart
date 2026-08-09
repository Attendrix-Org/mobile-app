import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'apod_model.dart';
export 'apod_model.dart';

/// Design a visually appealing and modern APOD (Astronomy Picture of the Day)
/// Viewer page for a student productivity app.
///
/// This page should highlight NASA’s daily space image and make the
/// experience engaging but minimal.
///
/// 📸 Key Elements:
/// - A **large preview image** of the current day’s APOD, filling the top or
/// center
/// - The **APOD title** (bold, large font)
/// - The **date** shown in a human-readable format (e.g., July 8, 2025)
/// - A scrollable **description** with clean typography and proper padding
/// - A **“Learn More” button** that links to the official NASA APOD page
/// - Optional: Add a subtle astronomy-themed background or animated stars
///
/// 🎨 UI Style:
/// - Modern and elegant
/// - Dark theme or glassmorphic look preferred (space-like aesthetics)
/// - Use soft shadows, rounded corners, and calming transitions
/// - Must be responsive for mobile and tablet layouts
///
/// 🎯 UX Goals:
/// - Simple to understand at a glance
/// - Easy to return to main app/home
/// - Optimized for daily use — users check this regularly
///
/// ⚙️ Data Source:
/// - Designed to dynamically load APOD data (image URL, title, date,
/// description, NASA link) via backend/API
///
/// Output a complete page layout ready to plug into a Flutter or FlutterFlow
/// app.
class ApodWidget extends StatefulWidget {
  const ApodWidget({super.key});

  static String routeName = 'APOD';
  static String routePath = 'apod';

  @override
  State<ApodWidget> createState() => _ApodWidgetState();
}

class _ApodWidgetState extends State<ApodWidget> {
  late ApodModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ApodModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'APOD'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'APOD',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFF0A0E1A),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2D1B69),
                          Color(0xFF1A1F2E),
                          Color(0xFF0A0E1A)
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: AlignmentDirectional(1.0, 1.0),
                        end: AlignmentDirectional(-1.0, -1.0),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Container(
                            width: double.infinity,
                            height: 400.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent(
                                            'APOD_PAGE_Image_vb6wcq3x_ON_TAP');
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: CachedNetworkImage(
                                                fadeInDuration:
                                                    Duration(milliseconds: 0),
                                                fadeOutDuration:
                                                    Duration(milliseconds: 0),
                                                imageUrl: FFAppState()
                                                    .apodData
                                                    .imageUrl,
                                                fit: BoxFit.contain,
                                                memCacheWidth: 50,
                                                memCacheHeight: 50,
                                              ),
                                              allowRotation: false,
                                              tag: FFAppState()
                                                  .apodData
                                                  .imageUrl,
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: FFAppState().apodData.imageUrl,
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                Duration(milliseconds: 0),
                                            fadeOutDuration:
                                                Duration(milliseconds: 0),
                                            imageUrl:
                                                FFAppState().apodData.imageUrl,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                1.0,
                                            fit: BoxFit.cover,
                                            memCacheWidth: 50,
                                            memCacheHeight: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0x80000000)
                                          ],
                                          stops: [0.0, 1.0],
                                          begin: AlignmentDirectional(0.0, 1.0),
                                          end: AlignmentDirectional(0, -1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 32.0, 24.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FlutterFlowIconButton(
                                              borderColor: Colors.transparent,
                                              borderRadius: 22.0,
                                              buttonSize: 44.0,
                                              fillColor: Color(0x40000000),
                                              icon: Icon(
                                                FFIcons.karrowBackUp,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                              onPressed: () async {
                                                logFirebaseEvent(
                                                    'APOD_PAGE_arrowBackUp_ICN_ON_TAP');
                                                logFirebaseEvent(
                                                    'IconButton_navigate_to');

                                                context.goNamed(
                                                    DashboardWidget.routeName);
                                              },
                                            ),
                                            Builder(
                                              builder: (context) =>
                                                  FlutterFlowIconButton(
                                                borderColor: Colors.transparent,
                                                borderRadius: 22.0,
                                                buttonSize: 44.0,
                                                fillColor: Color(0x40000000),
                                                icon: Icon(
                                                  FFIcons.kshare,
                                                  color: Colors.white,
                                                  size: 20.0,
                                                ),
                                                onPressed: () async {
                                                  logFirebaseEvent(
                                                      'APOD_PAGE_share_ICN_ON_TAP');
                                                  logFirebaseEvent(
                                                      'IconButton_share');
                                                  await Share.share(
                                                    FFAppState()
                                                        .apodData
                                                        .shareUrl,
                                                    sharePositionOrigin:
                                                        getWidgetBoundingBox(
                                                            context),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF0F1419),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20.0,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0.0,
                                    -5.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        valueOrDefault<String>(
                                          FFAppState().apodData.apodDate,
                                          'July 6, 2026',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF64748B),
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          FFAppState().apodData.title,
                                          'Centaurus A : The Iconic Starburst Galaxy',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLargeFamily,
                                              color: Colors.white,
                                              fontSize: 28.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              lineHeight: 1.2,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .headlineLargeIsCustom,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      FFAppState().apodData.description,
                                      'This combined view of Centaurus A from NASA’s James Webb Space Telescope pairs observations from the Near-Infrared Camera (NIRCam) and Mid-Infrared Instrument (MIRI). Webb’s infrared vision exposes a warped disk of gas and dust left behind by a collision with another galaxy billions of years ago.What may first appear as a grainy glow is actually a dense field of millions of individually resolved stars. By distinguishing different generations of stars embedded throughout the dusty center, Webb gives astronomers new clues to the galaxy’s history and the processes that continue to shape it.',
                                    ),
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFFCBD5E1),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          lineHeight: 1.6,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      FFAppState().apodData.copyright,
                                      'Image: NASA, ESA, CSA, STScI; Image Processing: Alyssa Pagan (STScI), Joseph DePasquale (STScI), Macarena Garcia Marin (ESA Office at STScI)',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFF64748B),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x00334155),
                                          Color(0xFF334155)
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'APOD_PAGE_LEARN_MORE_BTN_ON_TAP');
                                            logFirebaseEvent(
                                                'Button_launch_u_r_l');
                                            await launchURL(
                                                FFAppState().apodData.shareUrl);
                                          },
                                          text: 'Learn More',
                                          options: FFButtonOptions(
                                            height: 52.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFF3B82F6),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
