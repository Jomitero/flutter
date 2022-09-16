// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'color_scheme.dart';
import 'material_state.dart';
import 'scrollbar_theme.dart';
import 'theme.dart';

const double _kScrollbarThickness = 8.0;
const double _kScrollbarThicknessWithTrack = 12.0;
const double _kScrollbarMargin = 2.0;
const double _kScrollbarMinLength = 48.0;
const Radius _kScrollbarRadius = Radius.circular(8.0);
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 300);
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 600);

/// A Material Design scrollbar.
///
/// To add a scrollbar to a [ScrollView], wrap the scroll view
/// widget in a [Scrollbar] widget.
///
/// {@macro flutter.widgets.Scrollbar}
///
/// Dynamically changes to an iOS style scrollbar that looks like
/// [CupertinoScrollbar] on the iOS platform.
///
/// The color of the Scrollbar will change when dragged. A hover animation is
/// also triggered when used on web and desktop platforms. A scrollbar track
/// can also been drawn when triggered by a hover event, which is controlled by
/// [showTrackOnHover]. The thickness of the track and scrollbar thumb will
/// become larger when hovering, unless overridden by [hoverThickness].
///
/// {@tool dartpad}
/// This sample shows a [Scrollbar] that executes a fade animation as scrolling occurs.
/// The Scrollbar will fade into view as the user scrolls, and fade out when scrolling stops.
///
/// ** See code in examples/api/lib/material/scrollbar/scrollbar.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// When isAlwaysShown is true, the scrollbar thumb will remain visible without the
/// fade animation. This requires that a ScrollController is provided to controller,
/// or that the PrimaryScrollController is available.
///
/// ** See code in examples/api/lib/material/scrollbar/scrollbar.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class to add more animations and behaviors.
///  * [ScrollbarTheme], which configures the Scrollbar's appearance.
///  * [CupertinoScrollbar], an iOS style scrollbar.
///  * [ListView], which displays a linear, scrollable list of children.
///  * [GridView], which displays a 2 dimensional, scrollable array of children.
class Scrollbar extends StatelessWidget {
  /// Creates a material design scrollbar that by default will connect to the
  /// closest Scrollable descendant of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to
  /// enable scrollbar dragging using the [PrimaryScrollController].
  ///
  /// When null, [thickness] defaults to 8.0 pixels on desktop and web, and 4.0
  /// pixels when on mobile platforms. A null [radius] will result in a default
  /// of an 8.0 pixel circular radius about the corners of the scrollbar thumb,
  /// except for when executing on [TargetPlatform.android], which will render the
  /// thumb without a radius.
  const Scrollbar({
    Key? key,
    required this.child,
    this.controller,
    this.isAlwaysShown,
    this.trackVisibility,
    this.showTrackOnHover,
    this.hoverThickness,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
  }) : super(key: key);

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.isAlwaysShown}
  final bool? isAlwaysShown;

  /// Controls the track visibility.
  ///
  /// If this property is null, then [ScrollbarThemeData.trackVisibility] of
  /// [ThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  ///
  /// If the track visibility is related to the scrollbar's material state,
  /// use the global [ScrollbarThemeData.trackVisibility] or override the
  /// sub-tree's theme data.
  ///
  /// [showTrackOnHover] can be replaced by this and will be deprecated.
  final bool? trackVisibility;

  /// Controls if the track will show on hover and remain, including during drag.
  ///
  /// If this property is null, then [ScrollbarThemeData.showTrackOnHover] of
  /// [ThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  ///
  /// This will be deprecated, and [trackVisibility] is recommended.
  final bool? showTrackOnHover;

  /// The thickness of the scrollbar when a hover state is active and
  /// [showTrackOnHover] is true.
  ///
  /// If this property is null, then [ScrollbarThemeData.thickness] of
  /// [ThemeData.scrollbarTheme] is used to resolve a thickness. If that is also
  /// null, the default value is 12.0 pixels.
  final double? hoverThickness;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// the default thickness is 4.0 pixels. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultThickness] is used. The remaining platforms have a
  /// default thickness of 8.0 pixels.
  final double? thickness;

  /// The [Radius] of the scrollbar thumb's rounded rectangle corners.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// no radius is applied to the scrollbar thumb. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultRadius] is used. The remaining platforms have a
  /// default [Radius.circular] of 8.0 pixels.
  final Radius? radius;

  /// {@macro flutter.widgets.Scrollbar.interactive}
  final bool? interactive;

  /// {@macro flutter.widgets.Scrollbar.notificationPredicate}
  final ScrollNotificationPredicate? notificationPredicate;

  /// {@macro flutter.widgets.Scrollbar.scrollbarOrientation}
  final ScrollbarOrientation? scrollbarOrientation;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoScrollbar(
        isAlwaysShown: isAlwaysShown ?? false,
        thickness: thickness ?? CupertinoScrollbar.defaultThickness,
        thicknessWhileDragging: thickness ?? CupertinoScrollbar.defaultThicknessWhileDragging,
        radius: radius ?? CupertinoScrollbar.defaultRadius,
        radiusWhileDragging: radius ?? CupertinoScrollbar.defaultRadiusWhileDragging,
        controller: controller,
        notificationPredicate: notificationPredicate,
        scrollbarOrientation: scrollbarOrientation,
        child: child,
      );
    }
    return _MaterialScrollbar(
      controller: controller,
      isAlwaysShown: isAlwaysShown,
      trackVisibility: trackVisibility,
      showTrackOnHover: showTrackOnHover,
      hoverThickness: hoverThickness,
      thickness: thickness,
      radius: radius,
      notificationPredicate: notificationPredicate,
      interactive: interactive,
      scrollbarOrientation: scrollbarOrientation,
      child: child,
    );
  }
}

class _MaterialScrollbar extends RawScrollbar {
  const _MaterialScrollbar({
    Key? key,
    required Widget child,
    ScrollController? controller,
    bool? isAlwaysShown,
    this.trackVisibility,
    this.showTrackOnHover,
    this.hoverThickness,
    double? thickness,
    Radius? radius,
    ScrollNotificationPredicate? notificationPredicate,
    bool? interactive,
    ScrollbarOrientation? scrollbarOrientation,
  }) : super(
         key: key,
         child: child,
         controller: controller,
         isAlwaysShown: isAlwaysShown,
         thickness: thickness,
         radius: radius,
         fadeDuration: _kScrollbarFadeDuration,
         timeToFade: _kScrollbarTimeToFade,
         pressDuration: Duration.zero,
         notificationPredicate: notificationPredicate ?? defaultScrollNotificationPredicate,
         interactive: interactive,
         scrollbarOrientation: scrollbarOrientation,
       );

  final bool? trackVisibility;
  final bool? showTrackOnHover;
  final double? hoverThickness;

  @override
  _MaterialScrollbarState createState() => _MaterialScrollbarState();
}

class _MaterialScrollbarState extends RawScrollbarState<_MaterialScrollbar> {
  late AnimationController _hoverAnimationController;
  bool _dragIsActive = false;
  bool _hoverIsActive = false;
  late ColorScheme _colorScheme;
  late ScrollbarThemeData _scrollbarTheme;
  // On Android, scrollbars should match native appearance.
  late bool _useAndroidScrollbar;

  @override
  bool get showScrollbar => widget.isAlwaysShown ?? _scrollbarTheme.isAlwaysShown ?? false;

  @override
  bool get enableGestures => widget.interactive ?? _scrollbarTheme.interactive ?? !_useAndroidScrollbar;

  bool get _showTrackOnHover => widget.showTrackOnHover ?? _scrollbarTheme.showTrackOnHover ?? false;

  MaterialStateProperty<bool> get _trackVisibility => MaterialStateProperty.resolveWith((Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered) && _showTrackOnHover) {
      return true;
    }
    return widget.trackVisibility ?? _scrollbarTheme.trackVisibility?.resolve(states) ?? false;
  });

  Set<MaterialState> get _states => <MaterialState>{
    if (_dragIsActive) MaterialState.dragged,
    if (_hoverIsActive) MaterialState.hovered,
  };

  MaterialStateProperty<Color> get _thumbColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    late Color dragColor;
    late Color hoverColor;
    late Color idleColor;
    switch (brightness) {
      case Brightness.light:
        dragColor = onSurface.withOpacity(0.6);
        hoverColor = onSurface.withOpacity(0.5);
        idleColor = _useAndroidScrollbar
          ? Theme.of(context).highlightColor.withOpacity(1.0)
          : onSurface.withOpacity(0.1);
        break;
      case Brightness.dark:
        dragColor = onSurface.withOpacity(0.75);
        hoverColor = onSurface.withOpacity(0.65);
        idleColor = _useAndroidScrollbar
          ? Theme.of(context).highlightColor.withOpacity(1.0)
          : onSurface.withOpacity(0.3);
        break;
    }

    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.dragged))
        return _scrollbarTheme.thumbColor?.resolve(states) ?? dragColor;

      // If the track is visible, the thumb color hover animation is ignored and
      // changes immediately.
      if (_trackVisibility.resolve(states))
        return _scrollbarTheme.thumbColor?.resolve(states) ?? hoverColor;

      return Color.lerp(
        _scrollbarTheme.thumbColor?.resolve(states) ?? idleColor,
        _scrollbarTheme.thumbColor?.resolve(states) ?? hoverColor,
        _hoverAnimationController.value,
      )!;
    });
  }

  MaterialStateProperty<Color> get _trackColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (_trackVisibility.resolve(states)) {
        return _scrollbarTheme.trackColor?.resolve(states)
          ?? (brightness == Brightness.light
            ? onSurface.withOpacity(0.03)
            : onSurface.withOpacity(0.05));
      }
      return const Color(0x00000000);
    });
  }

  MaterialStateProperty<Color> get _trackBorderColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (_trackVisibility.resolve(states)) {
        return _scrollbarTheme.trackBorderColor?.resolve(states)
          ?? (brightness == Brightness.light
            ? onSurface.withOpacity(0.1)
            : onSurface.withOpacity(0.25));
      }
      return const Color(0x00000000);
    });
  }

  MaterialStateProperty<double> get _thickness {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) && _trackVisibility.resolve(states))
        return widget.hoverThickness
          ?? _scrollbarTheme.thickness?.resolve(states)
          ?? _kScrollbarThicknessWithTrack;
      // The default scrollbar thickness is smaller on mobile.
      return widget.thickness
        ?? _scrollbarTheme.thickness?.resolve(states)
        ?? (_kScrollbarThickness / (_useAndroidScrollbar ? 2 : 1));
    });
  }

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimationController.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _colorScheme = theme.colorScheme;
    _scrollbarTheme = theme.scrollbarTheme;
    switch (theme.platform) {
      case TargetPlatform.android:
        _useAndroidScrollbar = true;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        _useAndroidScrollbar = false;
        break;
    }
    super.didChangeDependencies();
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = _thumbColor.resolve(_states)
      ..trackColor = _trackColor.resolve(_states)
      ..trackBorderColor = _trackBorderColor.resolve(_states)
      ..textDirection = Directionality.of(context)
      ..thickness = _thickness.resolve(_states)
      ..radius = widget.radius ?? _scrollbarTheme.radius ?? (_useAndroidScrollbar ? null : _kScrollbarRadius)
      ..crossAxisMargin = _scrollbarTheme.crossAxisMargin ?? (_useAndroidScrollbar ? 0.0 : _kScrollbarMargin)
      ..mainAxisMargin = _scrollbarTheme.mainAxisMargin ?? 0.0
      ..minLength = _scrollbarTheme.minThumbLength ?? _kScrollbarMinLength
      ..padding = MediaQuery.of(context).padding
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    setState(() { _dragIsActive = true; });
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    super.handleThumbPressEnd(localPosition, velocity);
    setState(() { _dragIsActive = false; });
  }

  @override
  void handleHover(PointerHoverEvent event) {
    super.handleHover(event);
    // Check if the position of the pointer falls over the painted scrollbar
    if (isPointerOverScrollbar(event.position, event.kind, forHover: true)) {
      // Pointer is hovering over the scrollbar
      setState(() { _hoverIsActive = true; });
      _hoverAnimationController.forward();
    } else if (_hoverIsActive) {
      // Pointer was, but is no longer over painted scrollbar.
      setState(() { _hoverIsActive = false; });
      _hoverAnimationController.reverse();
    }
  }

  @override
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);
    setState(() { _hoverIsActive = false; });
    _hoverAnimationController.reverse();
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }
}