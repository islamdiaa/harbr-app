import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HarbrSwitch extends Switch {
  HarbrSwitch({
    Key? key,
    required bool value,
    required void Function(bool)? onChanged,
  }) : super(
          key: key,
          value: value,
          onChanged: onChanged == null
              ? null
              : (value) {
                  HapticFeedback.lightImpact();
                  onChanged(value);
                },
        );
}
