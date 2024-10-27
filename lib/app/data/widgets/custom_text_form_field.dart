// ignore_for_file: constant_identifier_names

import 'package:fruitables/app/data/core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.isObscureText = false,
      this.readOnly = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.onTap,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.labelText,
      this.validator});

  final TextFormFieldShape? shape;

  final TextFormFieldPadding? padding;

  final TextFormFieldVariant? variant;

  final TextFormFieldFontStyle? fontStyle;

  final Alignment? alignment;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final bool readOnly;

  final bool? isObscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;
  final String? labelText;

  final void Function()? onTap;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus!,
        readOnly: readOnly,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
        keyboardAppearance: Brightness.dark,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      labelText: labelText,
      labelStyle: _setLabelFontStyle(),
      hintStyle: _setHintFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
      errorMaxLines: 2,
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return GoogleFonts.getFont(
          "Inter",
          color: ColorConstant.black,
          fontSize: getFontSize(
            14,
          ),
          fontWeight: FontWeight.w400,
        );
    }
  }
  _setLabelFontStyle() {
    switch (fontStyle) {
      default:
        return GoogleFonts.getFont(
          "Inter",
          color: ColorConstant.black,
          fontSize: getFontSize(
            16,
          ),
          fontWeight: FontWeight.w600,
        );
    }
  }

  _setHintFontStyle() {
    switch (fontStyle) {
      default:
        return GoogleFonts.getFont(
          "Inter",
          color: ColorConstant.white60,
          fontSize: getFontSize(
            14,
          ),
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      case TextFormFieldShape.RoundedBorder10:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
      case TextFormFieldShape.RoundedBorder5:
        return BorderRadius.circular(
          getHorizontalSize(
            5.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            14.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBlack:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.None:
        return OutlineInputBorder(borderRadius: BorderRadius.circular(10));
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray300,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return ColorConstant.gray50.withOpacity(0.05);
      default:
        return null;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBlack:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT15:
        return getPadding(
          left: 15,
          top: 15,
          bottom: 15,
        );
      case TextFormFieldPadding.PaddingT15_1:
        return getPadding(
          left: 12,
          top: 15,
          right: 12,
          bottom: 15,
        );
      case TextFormFieldPadding.PaddingT36:
        return getPadding(
          left: 16,
          top: 36,
          right: 16,
          bottom: 36,
        );
      case TextFormFieldPadding.PaddingT9:
        return getPadding(
          left: 8,
          top: 9,
          right: 8,
          bottom: 9,
        );
      case TextFormFieldPadding.PaddingT7:
        return getPadding(
          top: 7,
          right: 5,
          bottom: 7,
        );
      default:
        return getPadding(
          all: 15,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder14,
  RoundedBorder10,
  RoundedBorder5,
}

enum TextFormFieldPadding {
  PaddingAll15,
  PaddingT15,
  PaddingT15_1,
  PaddingT36,
  PaddingT9,
  PaddingT7,
}

enum TextFormFieldVariant {
  None,
  OutlineBlack,
}

enum TextFormFieldFontStyle {
  AgeoRegular14,
}
