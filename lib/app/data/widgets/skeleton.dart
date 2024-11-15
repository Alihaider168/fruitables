import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;
  final double cornerRadius;
  final bool isReel;

  const Skeleton({this.height = 20, this.width = 200, this.cornerRadius = 4, Key? key, this.isReel = false}) : super(key: key);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  Animation? _gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _gradientPosition = Tween<double>(begin: -3, end: 10).animate(CurvedAnimation(parent: _controller!, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });

    _controller!.repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        gradient: LinearGradient(
          begin: Alignment(_gradientPosition!.value, 0),
          end: const Alignment(-1, 0),
          colors: widget.isReel
              ? [const Color(0xff161616), const Color(0xffF2F2F2), const Color(0xff161616)]
              : [
            const Color(0x0D000000),
            const Color(0x1A000000),
            const Color(0x0D000000),
          ],
        ),
      ),
    );
  }
}
