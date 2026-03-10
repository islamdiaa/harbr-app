import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

export 'ui/appbar.dart';
export 'ui/assets.dart';
export 'ui/banner.dart';
export 'ui/block.dart';
export 'ui/bottom_bar.dart';
export 'ui/bottom_modal_sheet.dart';
export 'ui/button.dart';
export 'ui/card.dart';
export 'ui/colors.dart';
export 'ui/containers.dart';
export 'ui/controllers.dart';
export 'ui/dialog.dart';
export 'ui/divider.dart';
export 'ui/drawer.dart';
export 'ui/floating_action_button.dart';
export 'ui/grid_view.dart';
export 'ui/header.dart';
export 'ui/highlighted_node.dart';
export 'ui/icons.dart';
export 'ui/input_bar.dart';
export 'ui/linear_indicator.dart';
export 'ui/list_tile.dart';
export 'ui/list_view.dart';
export 'ui/loader.dart';
export 'ui/message.dart';
export 'ui/mixins.dart';
export 'ui/images.dart';
export 'ui/page_view.dart';
export 'ui/popup_menu_button.dart';
export 'ui/refresh_indicator.dart';
export 'ui/scaffold.dart';
export 'ui/shape.dart';
export 'ui/shimmer.dart';
export 'ui/snackbar.dart';
export 'ui/switch.dart';
export 'ui/table.dart';
export 'ui/text_span.dart';
export 'ui/text_style.dart';
export 'ui/text.dart';
export 'ui/theme.dart';
export 'ui/theme_extension.dart';
export 'ui/tokens.dart';
export 'ui/harbr_colors.dart';
export 'ui/status_badge.dart';
export 'ui/meta_chip.dart';
export 'ui/empty_state.dart';
export 'ui/progress_bar.dart';
export 'ui/surface.dart';
export 'ui/poster.dart';
export 'ui/media_row.dart';
export 'ui/harbr_tab_bar.dart';
export 'ui/harbr_nav_rail.dart';
export 'ui/harbr_app_shell.dart';
export 'ui/responsive_layout.dart';
export 'ui/responsive_grid.dart';
export 'ui/pill_nav_bar.dart';
export 'ui/collapsible_section.dart';
export 'ui/poster_carousel.dart';
export 'ui/bar_chart_card.dart';
export 'ui/gradient_progress_bar.dart';
export 'ui/icon_circle.dart';
export 'ui/timeline_indicator.dart';
export 'ui/filter_action_bar.dart';
export 'ui/search_field.dart';

// ignore: avoid_classes_with_only_static_members
class HarbrUI {
  // Text Constants
  static const String TEXT_ARROW_LEFT = '←';
  static const String TEXT_ARROW_RIGHT = '→';
  static const String TEXT_BULLET = '•';
  static const String TEXT_OBFUSCATED_PASSWORD = '••••••••••••';
  static const String TEXT_ELLIPSIS = '…';
  static const String TEXT_EMDASH = '—';

  // <--> Font Sizes
  static const double FONT_SIZE_H1 = 24.0;
  static const double FONT_SIZE_H2 = 20.0;
  static const double FONT_SIZE_H3 = 18.0;
  static const double FONT_SIZE_H4 = 16.0;
  static const double FONT_SIZE_H5 = 12.0;

  // <--> Font Size Mappings
  static const double FONT_SIZE_BUTTON = FONT_SIZE_H3;
  static const double FONT_SIZE_GRAPH_LEGEND = FONT_SIZE_H5;
  static const double FONT_SIZE_HEADER = FONT_SIZE_H2;
  static const double FONT_SIZE_MESSAGES = FONT_SIZE_H2;
  static const double FONT_SIZE_SUBHEADER = FONT_SIZE_H3;
  static const double FONT_SIZE_SUBTITLE = FONT_SIZE_H3;
  static const double FONT_SIZE_TITLE = FONT_SIZE_H2;

  // <--> Icons
  static const double ICON_SIZE = 24.0;

  // <--> Animations
  static const int ANIMATION_SPEED = 250;
  static const int ANIMATION_SPEED_IMAGES = ANIMATION_SPEED ~/ 2;
  static const int ANIMATION_SPEED_SCROLLING = ANIMATION_SPEED * 2;
  static const int ANIMATION_SPEED_SHIMMER = ANIMATION_SPEED * 4;

  // <--> Other
  static const double BORDER_RADIUS = 12.0;
  static const double OPACITY_DIMMED = 0.75;
  static const double OPACITY_DISABLED = 0.50;
  static const double OPACITY_SPLASH = 0.25;
  static const double OPACITY_SELECTED = 0.35;
  static const double ELEVATION = 0.0;
  static const FontWeight FONT_WEIGHT_BOLD = FontWeight.w500;

  // <--> Margins
  static const double DEFAULT_MARGIN_SIZE = 12.0;
  static const double MARGIN_SIZE_HALF = DEFAULT_MARGIN_SIZE / 2;

  static const EdgeInsets MARGIN_DEFAULT = EdgeInsets.all(DEFAULT_MARGIN_SIZE);
  static const EdgeInsets MARGIN_HALF = EdgeInsets.all(MARGIN_SIZE_HALF);

  static const EdgeInsets MARGIN_DEFAULT_HORIZONTAL =
      EdgeInsets.symmetric(horizontal: DEFAULT_MARGIN_SIZE);
  static const EdgeInsets MARGIN_DEFAULT_VERTICAL =
      EdgeInsets.symmetric(vertical: DEFAULT_MARGIN_SIZE);

  static const EdgeInsets MARGIN_HALF_HORIZONTAL =
      EdgeInsets.symmetric(horizontal: MARGIN_SIZE_HALF);
  static const EdgeInsets MARGIN_HALF_VERTICAL =
      EdgeInsets.symmetric(vertical: MARGIN_SIZE_HALF);

  static const EdgeInsets MARGIN_H_DEFAULT_V_HALF = EdgeInsets.symmetric(
      horizontal: DEFAULT_MARGIN_SIZE, vertical: MARGIN_SIZE_HALF);
  static const EdgeInsets MARGIN_H_HALF_V_DEFAULT = EdgeInsets.symmetric(
      horizontal: MARGIN_SIZE_HALF, vertical: DEFAULT_MARGIN_SIZE);

  // <--> Borders
  static bool get shouldUseBorder {
    return HarbrTheme.isAMOLEDTheme && HarbrTheme.useBorders;
  }

  static ShapeBorder get shapeBorder {
    return HarbrShapeBorder(useBorder: shouldUseBorder);
  }
}
