import '../size/hm_button_size.dart';
import '../size/hm_checkbox_size.dart';
import '../size/hm_switch_size.dart';

/// Get the ratio
/// ``` dart
/// double getRatio(size) {
/// const double ratio = 1.905;
/// return size / ratio;
/// }
/// ```
double getRatio(double size) {
  // const double ratio = 1.905;
  const double ratio = 2.25;
  return size / ratio;
}

double getIconSize(HMButtonSize size) {
  switch (size) {
    case HMButtonSize.xs:
      return 16.0;
    case HMButtonSize.sm:
      return 20.0;
    case HMButtonSize.md:
      return 24.0;
    case HMButtonSize.lg:
      return 28.0;
    case HMButtonSize.xl:
      return 32.0;
  }
}

double getTextSize(HMButtonSize size) {
  switch (size) {
    case HMButtonSize.xs:
      return 12.0;
    case HMButtonSize.sm:
      return 14.0;
    case HMButtonSize.md:
      return 16.0;
    case HMButtonSize.lg:
      return 18.0;
    case HMButtonSize.xl:
      return 20.0;
  }
}

double getSwitchTextSize(HMSwitchSize size) {
  switch (size) {
    case HMSwitchSize.xs:
      return 6.5;
    case HMSwitchSize.sm:
      return 8.5;
    case HMSwitchSize.md:
      return 10.5;
    case HMSwitchSize.lg:
      return 12.5;
    case HMSwitchSize.xl:
      return 14.5;
  }
}

double getTrackSize(HMSwitchSize size) {
  switch (size) {
    case HMSwitchSize.xs:
      return 37.0;
    case HMSwitchSize.sm:
      return 44.0;
    case HMSwitchSize.md:
      return 50.0;
    case HMSwitchSize.lg:
      return 58.0;
    case HMSwitchSize.xl:
      return 70.0;
  }
}

double getLabelSize(dynamic size) {
  switch (size) {
    case HMSwitchSize.xs:
    case HMCheckBoxSize.xs:
      return 8.4;
    case HMSwitchSize.sm:
    case HMCheckBoxSize.sm:
      return 12.0;
    case HMSwitchSize.md:
    case HMCheckBoxSize.md:
      return 14.0;
    case HMSwitchSize.lg:
    case HMCheckBoxSize.lg:
      return 16.8;
    case HMSwitchSize.xl:
    case HMCheckBoxSize.xl:
      return 21.6;
    default:
      return 14.0;
  }
}
