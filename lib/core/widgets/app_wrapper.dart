import 'package:flutter/material.dart';
import 'package:muvo/core/widgets/network_status.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: AlignmentDirectional.topStart,
      children: [
        child,
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NetworkStatus(),
        ),
      ],
    );
  }
} 