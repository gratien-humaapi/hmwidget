import 'package:flutter/material.dart';

import 'hmwidget.dart';

class HMButtonTheme extends ThemeExtension<HMButtonTheme> {
  HMButtonTheme(
      { // this.fullWidth,
      this.fillColor,
      this.textColor,
      this.buttonVariant = HMButtonVariant.filled,
      this.radius = HMRadius.md,
      this.size = HMButtonSize.md});

  Color? fillColor;
  Color? textColor;
  HMRadius radius;
  HMButtonSize size;
  // bool? fullWidth;
  HMButtonVariant buttonVariant;

  @override
  HMButtonTheme copyWith(
      {Color? fillColor,
      Color? textColor,
      HMButtonVariant? buttonVariant,
      HMRadius? radius,
      HMButtonSize? size}) {
    return HMButtonTheme(
      fillColor: fillColor ?? this.fillColor,
      textColor: textColor ?? this.textColor,
      radius: radius ?? this.radius,
      size: size ?? this.size,
      buttonVariant: buttonVariant ?? this.buttonVariant,
    );
  }

  @override
  HMButtonTheme lerp(ThemeExtension<HMButtonTheme>? other, double t) {
    if (other is! HMButtonTheme) {
      return this;
    }
    return HMButtonTheme(
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      buttonVariant: other.buttonVariant,
      radius: other.radius,
      size: other.size,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMButtonTheme(fillColor: $fillColor, textColor: $textColor, buttonVariant: $buttonVariant, radius: $radius, size: $size)';
}

class HMCheckBoxTheme extends ThemeExtension<HMCheckBoxTheme> {
  HMCheckBoxTheme({
    this.color,
    this.radius = HMRadius.md,
    this.size = HMCheckBoxSize.md,
  });

  final Color? color;
  final HMRadius radius;
  final HMCheckBoxSize size;

  @override
  HMCheckBoxTheme copyWith({
    Color? color,
    HMRadius? radius,
    HMCheckBoxSize? size,
  }) {
    return HMCheckBoxTheme(
      color: color ?? this.color,
      radius: radius ?? this.radius,
      size: size ?? this.size,
    );
  }

  @override
  HMCheckBoxTheme lerp(ThemeExtension<HMCheckBoxTheme>? other, double t) {
    if (other is! HMCheckBoxTheme) {
      return this;
    }
    return HMCheckBoxTheme(
      color: Color.lerp(color, other.color, t),
      radius: other.radius,
      size: other.size,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMCheckBoxTheme(color: $color, radius: $radius, size: $size)';
}

class HMChipTheme extends ThemeExtension<HMChipTheme> {
  HMChipTheme({
    this.backgroundColor,
    this.radius,
    this.selectedColor,
    this.textColor,
    this.isFilled,
    this.borderSide,
  });
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final HMRadius? radius;
  final bool? isFilled;
  final BorderSide? borderSide;

  @override
  HMChipTheme copyWith({
    Color? backgroundColor,
    Color? selectedColor,
    Color? textColor,
    HMRadius? radius,
    bool? isFilled,
    BorderSide? borderSide,
  }) {
    return HMChipTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      radius: radius ?? this.radius,
      selectedColor: selectedColor ?? this.selectedColor,
      textColor: textColor ?? this.textColor,
      isFilled: isFilled ?? this.isFilled,
      borderSide: borderSide ?? this.borderSide,
    );
  }

  @override
  HMChipTheme lerp(ThemeExtension<HMChipTheme>? other, double t) {
    if (other is! HMChipTheme) {
      return this;
    }
    return HMChipTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      radius: other.radius,
      isFilled: other.isFilled,
      borderSide: other.borderSide,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMChipTheme(backgroundColor: $backgroundColor, radius: $radius, textColor: $textColor,selectedColor: $selectedColor, isFilled: $isFilled, borderSide: $borderSide)';
}

class HMIconButtonTheme extends ThemeExtension<HMIconButtonTheme> {
  HMIconButtonTheme({
    this.fillColor,
    this.iconColor,
    this.buttonVariant,
    this.radius,
    this.size,
  });

  final Color? fillColor;
  final Color? iconColor;
  final HMIconButtonSize? size;
  final HMRadius? radius;
  final HMButtonVariant? buttonVariant;

  @override
  HMIconButtonTheme copyWith({
    Color? fillColor,
    Color? iconColor,
    HMIconButtonSize? size,
    HMRadius? radius,
    HMButtonVariant? buttonVariant,
  }) {
    return HMIconButtonTheme(
      fillColor: fillColor ?? this.fillColor,
      iconColor: iconColor ?? this.iconColor,
      radius: radius ?? this.radius,
      buttonVariant: buttonVariant ?? this.buttonVariant,
      size: size ?? this.size,
    );
  }

  @override
  HMIconButtonTheme lerp(ThemeExtension<HMIconButtonTheme>? other, double t) {
    if (other is! HMIconButtonTheme) {
      return this;
    }
    return HMIconButtonTheme(
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      radius: other.radius,
      buttonVariant: other.buttonVariant,
      size: other.size,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMIconButtonTheme(fillColor: $fillColor, iconColor: $iconColor, buttonVariant: $buttonVariant, radius: $radius, size: $size)';
}

class HMRadioTheme extends ThemeExtension<HMRadioTheme> {
  HMRadioTheme({
    this.size,
    this.border,
    this.boxRadius,
    this.isLeft,
    this.radioColor,
    this.separatorLineColor,
    this.separatorLineHeight,
    this.textColor,
  });

  final HMRadioSize? size;
  final Color? radioColor;
  final Color? textColor;
  final Color? separatorLineColor;
  final double? separatorLineHeight;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? isLeft;
  final HMRadius? boxRadius;
  final Border? border;

  @override
  HMRadioTheme copyWith({
    HMRadioSize? size,
    Color? radioColor,
    Color? textColor,
    Color? separatorLineColor,
    double? separatorLineHeight,
    bool? isLeft,
    HMRadius? boxRadius,
    Border? border,
  }) {
    return HMRadioTheme(
      radioColor: radioColor ?? this.radioColor,
      textColor: textColor ?? this.textColor,
      separatorLineColor: separatorLineColor ?? this.separatorLineColor,
      border: border ?? this.border,
      boxRadius: boxRadius ?? this.boxRadius,
      isLeft: isLeft ?? this.isLeft,
      size: size ?? this.size,
      separatorLineHeight: separatorLineHeight ?? this.separatorLineHeight,
    );
  }

  @override
  HMRadioTheme lerp(ThemeExtension<HMRadioTheme>? other, double t) {
    if (other is! HMRadioTheme) {
      return this;
    }
    return HMRadioTheme(
      radioColor: Color.lerp(radioColor, other.radioColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      separatorLineColor:
          Color.lerp(separatorLineColor, other.separatorLineColor, t),
      isLeft: other.isLeft,
      boxRadius: other.boxRadius,
      border: other.border,
      size: other.size,
      separatorLineHeight: other.separatorLineHeight,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMRadioTheme(radioColor: $radioColor, textColor: $textColor, separatorLineColor: $separatorLineColor, isLeft: $isLeft, boxRadius: $boxRadius, border: $border, size: $size, separatorLineHeight: $separatorLineHeight)';
}

class HMSelectTheme extends ThemeExtension<HMSelectTheme> {
  HMSelectTheme({
    this.size,
    this.radius,
    this.selectIconAtLeft,
    this.selectIconColor,
  });

  final HMSelectSize? size;
  final Color? selectIconColor;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? selectIconAtLeft;
  final HMRadius? radius;

  @override
  HMSelectTheme copyWith({
    HMSelectSize? size,
    Color? selectIconColor,
    bool? selectIconAtLeft,
    HMRadius? radius,
  }) {
    return HMSelectTheme(
      selectIconColor: selectIconColor ?? this.selectIconColor,
      radius: radius ?? this.radius,
      selectIconAtLeft: selectIconAtLeft ?? this.selectIconAtLeft,
      size: size ?? this.size,
    );
  }

  @override
  HMSelectTheme lerp(ThemeExtension<HMSelectTheme>? other, double t) {
    if (other is! HMSelectTheme) {
      return this;
    }
    return HMSelectTheme(
      selectIconColor: Color.lerp(selectIconColor, other.selectIconColor, t),
      selectIconAtLeft: other.selectIconAtLeft,
      radius: other.radius,
      size: other.size,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMSelectTheme(selectIconColor: $selectIconColor, selectIconAtLeft: $selectIconAtLeft, radius: $radius, size: $size)';
}

class HMMultiSelectTheme extends ThemeExtension<HMMultiSelectTheme> {
  HMMultiSelectTheme({
    this.size,
    this.radius,
    this.selectIconAtLeft,
    this.selectIconColor,
  });

  final HMSelectSize? size;
  final Color? selectIconColor;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? selectIconAtLeft;
  final HMRadius? radius;

  @override
  HMMultiSelectTheme copyWith({
    HMSelectSize? size,
    Color? selectIconColor,
    bool? selectIconAtLeft,
    HMRadius? radius,
  }) {
    return HMMultiSelectTheme(
      selectIconColor: selectIconColor ?? this.selectIconColor,
      radius: radius ?? this.radius,
      selectIconAtLeft: selectIconAtLeft ?? this.selectIconAtLeft,
      size: size ?? this.size,
    );
  }

  @override
  HMMultiSelectTheme lerp(ThemeExtension<HMMultiSelectTheme>? other, double t) {
    if (other is! HMMultiSelectTheme) {
      return this;
    }
    return HMMultiSelectTheme(
      selectIconColor: Color.lerp(selectIconColor, other.selectIconColor, t),
      selectIconAtLeft: other.selectIconAtLeft,
      radius: other.radius,
      size: other.size,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMMultiSelectTheme(selectIconColor: $selectIconColor, selectIconAtLeft: $selectIconAtLeft, radius: $radius, size: $size)';
}

class HMSelectBagdeTheme extends ThemeExtension<HMSelectBagdeTheme> {
  HMSelectBagdeTheme({
    this.backgroundColor,
    this.radius,
    this.selectedColor,
    this.textColor,
    this.spacing,
    this.chipColor,
    this.deleteIconColor,
    this.isFilled,
  });
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final double? spacing;
  final HMRadius? radius;
  final Color? deleteIconColor;
  final Color? chipColor;
  final bool? isFilled;

  @override
  HMSelectBagdeTheme copyWith({
    Color? backgroundColor,
    Color? selectedColor,
    Color? textColor,
    double? spacing,
    HMRadius? radius,
    BorderSide? borderSide,
    Color? deleteIconColor,
    Color? chipColor,
    bool? isFilled,
  }) {
    return HMSelectBagdeTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      spacing: spacing ?? this.spacing,
      deleteIconColor: deleteIconColor ?? this.deleteIconColor,
      chipColor: chipColor ?? this.chipColor,
      radius: radius ?? this.radius,
      selectedColor: selectedColor ?? this.selectedColor,
      textColor: textColor ?? this.textColor,
      isFilled: isFilled ?? this.isFilled,
    );
  }

  @override
  HMSelectBagdeTheme lerp(ThemeExtension<HMSelectBagdeTheme>? other, double t) {
    if (other is! HMSelectBagdeTheme) {
      return this;
    }
    return HMSelectBagdeTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      chipColor: Color.lerp(chipColor, other.chipColor, t),
      deleteIconColor: Color.lerp(deleteIconColor, other.deleteIconColor, t),
      spacing: other.spacing,
      radius: other.radius,
      isFilled: other.isFilled,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMSelectBagdeTheme(backgroundColor: $backgroundColor, spacing: $spacing, deleteIconColor: $deleteIconColor, chipColor: $chipColor, radius: $radius, selectedColor: $selectedColor, textColor: $textColor, isFilled: $isFilled )';
}

// class HMRangeSliderTheme extends ThemeExtension<HMRangeSliderTheme> {
//   HMRangeSliderTheme({
//     this.color,
//     this.radius,
//     this.size,
//     this.orientation,
//   });

//   final HMOrientation? orientation;
//   final Color? color;
//   final HMRadius? radius;
//   final HMSliderSize? size;

//   @override
//   HMRangeSliderTheme copyWith({
//     HMOrientation? orientation,
//     Color? color,
//     HMRadius? radius,
//     HMSliderSize? size,
//   }) {
//     return HMRangeSliderTheme(
//       color: color ?? this.color,
//       radius: radius ?? this.radius,
//       orientation: orientation ?? this.orientation,
//       size: size ?? this.size,
//     );
//   }

//   @override
//   HMRangeSliderTheme lerp(ThemeExtension<HMRangeSliderTheme>? other, double t) {
//     if (other is! HMRangeSliderTheme) {
//       return this;
//     }
//     return HMRangeSliderTheme(
//       color: Color.lerp(color, other.color, t),
//       orientation: other.orientation,
//       size: other.size,
//       radius: other.radius,
//     );
//   }

//   // Optional
//   @override
//   String toString() =>
//       'HMRangeSliderTheme( color: $color, radius: $radius, orientation: $orientation, size: $size)';
// }

class HMSliderTheme extends ThemeExtension<HMSliderTheme> {
  HMSliderTheme({
    this.color,
    this.radius,
    this.size,
    this.orientation,
  });

  final HMOrientation? orientation;
  final Color? color;
  final HMRadius? radius;
  final HMSliderSize? size;

  @override
  HMSliderTheme copyWith({
    HMOrientation? orientation,
    Color? color,
    HMRadius? radius,
    HMSliderSize? size,
  }) {
    return HMSliderTheme(
      color: color ?? this.color,
      radius: radius ?? this.radius,
      orientation: orientation ?? this.orientation,
      size: size ?? this.size,
    );
  }

  @override
  HMSliderTheme lerp(ThemeExtension<HMSliderTheme>? other, double t) {
    if (other is! HMSliderTheme) {
      return this;
    }
    return HMSliderTheme(
      color: Color.lerp(color, other.color, t),
      orientation: other.orientation,
      size: other.size,
      radius: other.radius,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMSliderTheme( color: $color, radius: $radius, orientation: $orientation, size: $size)';
}

class HMSwitchTheme extends ThemeExtension<HMSwitchTheme> {
  HMSwitchTheme({
    this.color,
    this.radius,
    this.size,
    this.duration,
  });

  final Duration? duration;
  final Color? color;
  final HMSwitchSize? size;
  final HMRadius? radius;

  @override
  HMSwitchTheme copyWith({
    Duration? duration,
    Color? color,
    HMRadius? radius,
    HMSwitchSize? size,
  }) {
    return HMSwitchTheme(
      color: color ?? this.color,
      radius: radius ?? this.radius,
      duration: duration ?? this.duration,
      size: size ?? this.size,
    );
  }

  @override
  HMSwitchTheme lerp(ThemeExtension<HMSwitchTheme>? other, double t) {
    if (other is! HMSwitchTheme) {
      return this;
    }
    return HMSwitchTheme(
      color: Color.lerp(color, other.color, t),
      duration: other.duration,
      size: other.size,
      radius: other.radius,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMSwitchTheme( color: $color, radius: $radius, duration: $duration, size: $size)';
}

class HMTextFieldTheme extends ThemeExtension<HMTextFieldTheme> {
  HMTextFieldTheme({
    this.fillColor,
    this.radius,
    this.size,
    this.variant,
    this.iconColor,
  });

  final HMTextVariant? variant;
  final HMTextFieldSize? size;
  final HMRadius? radius;
  final Color? fillColor;
  final Color? iconColor;

  @override
  HMTextFieldTheme copyWith({
    HMTextVariant? variant,
    HMTextFieldSize? size,
    HMRadius? radius,
    Color? fillColor,
    Color? iconColor,
  }) {
    return HMTextFieldTheme(
      fillColor: fillColor ?? this.fillColor,
      iconColor: iconColor ?? this.iconColor,
      radius: radius ?? this.radius,
      variant: variant ?? this.variant,
      size: size ?? this.size,
    );
  }

  @override
  HMTextFieldTheme lerp(ThemeExtension<HMTextFieldTheme>? other, double t) {
    if (other is! HMTextFieldTheme) {
      return this;
    }
    return HMTextFieldTheme(
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      variant: other.variant,
      size: other.size,
      radius: other.radius,
    );
  }

  // Optional
  @override
  String toString() =>
      'HMTextFieldTheme( fillColor: $fillColor, iconColor: $iconColor, radius: $radius, variant: $variant, size: $size)';
}
