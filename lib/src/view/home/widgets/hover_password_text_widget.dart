import 'package:flutter/material.dart';

class HoverPasswordTextWidget extends StatefulWidget {
  final String password;

  const HoverPasswordTextWidget({super.key, required this.password});

  @override
  State<HoverPasswordTextWidget> createState() => _HoverPasswordTextWidgetState();
}

class _HoverPasswordTextWidgetState extends State<HoverPasswordTextWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Text(
        _isHovering ? widget.password : "***************",
        style: const TextStyle(
          fontSize: 12.0,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
      ),
    );
  }
}
