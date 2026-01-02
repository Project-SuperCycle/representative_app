import 'package:flutter/material.dart';

const double kButtonBorderRadius = 20.0;
const double kBorderRadius = 20.0;
const String kBoxName = 'supercycle';
const String kNotVerified = 'NOT_VERIFIED';
const String kProfileIncomplete = 'PROFILE_INCOMPLETE';

const kGradientBackground = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF3BC577), Color(0xFFFFFFFF)],
  stops: [0.58, 1.0],
);

const kGradientButton = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF3BC577), Color(0xFF10B981)],
);

const kGradientContainer = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomRight,
  colors: [Color(0xFF3BC577), Color(0xFFFFFFFF)],
  stops: [0.70, 1.0],
);