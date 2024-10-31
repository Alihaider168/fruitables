import 'package:google_fonts/google_fonts.dart';

import '../core/app_export.dart';

TextStyle textStyle =
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

class MyText extends StatefulWidget {
  final String title;
  final String? family;
  final FontWeight? fontWeight;
  final double? fontSize, height, letterSpacing;
  final Color? color;
  final TextOverflow? overflow;
  final bool? center;
  final bool? alignRight;
  final int? line;
  final bool? under, cut;
  final List<FontFeature>? fontFeatures;

  const MyText(
      {super.key,
      required this.title,
      this.family,
      this.fontSize,
      this.color,
      this.fontFeatures,
      this.fontWeight,
      this.height,
      this.center,
      this.alignRight,
      this.line,
      this.under,
      this.overflow,
      this.cut,
      this.letterSpacing});

  @override
  MyTextState createState() => MyTextState();
}

class MyTextState extends State<MyText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      overflow: widget.overflow ?? TextOverflow.visible,
      maxLines: widget.line,
      textScaleFactor: 1.0,
      style: GoogleFonts.getFont(widget.family ?? "Nunito",
          wordSpacing: widget.letterSpacing,
          height: widget.height,
          decoration: widget.under == true
              ? TextDecoration.underline
              : widget.cut == true
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
          fontSize: getFontSize(widget.fontSize ?? 16),
          color: widget.color ?? ColorConstant.black,
          fontWeight: widget.fontWeight ),
      textAlign: widget.center == null
          ? widget.alignRight != null
              ? TextAlign.right
              : TextAlign.left
          : widget.center!
              ? TextAlign.center
              : TextAlign.left,
    );
  }
}
