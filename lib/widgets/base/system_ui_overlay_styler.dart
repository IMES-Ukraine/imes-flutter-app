import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiOverlayStyler extends StatelessWidget {
  const SystemUiOverlayStyler({
    Key key,
    @required this.child,
    this.brightness = Brightness.light,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final isWhiteBackground = brightness == Brightness.light;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness:
            isWhiteBackground ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            isWhiteBackground ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
