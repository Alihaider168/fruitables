// ignore_for_file: constant_identifier_names

import 'package:google_fonts/google_fonts.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget,
      this.controller});

  final ButtonShape? shape;

  final ButtonPadding? padding;

  final ButtonVariant? variant;

  final ButtonFontStyle? fontStyle;

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  final double? width;

  final double? height;

  final String? text;

  final Widget? prefixWidget;

  final Widget? suffixWidget;

  final RoundedLoadingButtonController? controller;

  bool isTapCalled = false;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: controller != null
          ? RoundedLoadingButton(
              width: width ?? double.maxFinite,
              height: height ?? getVerticalSize(46),
              onPressed: () {
                if (controller!.currentState != ButtonState.loading) {
                  onTap!();
                }
              },
              animateOnTap: false,
              elevation: 1,
              borderRadius: _setBorderRadiusForLoadingButton(),
              color: _setColor(),
              controller: controller!,
              child: _buildButtonWithOrWithoutIcon(),
            )
          : TextButton(
              onPressed: () {
                if (!isTapCalled) {
                  isTapCalled = true;
                  onTap!();
                  Future.delayed(
                    const Duration(seconds: 1),
                    () => isTapCalled = false,
                  );
                }
              },
              style: _buildTextButtonStyle(),
              child: _buildButtonWithOrWithoutIcon(),
            ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? const SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? const SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(46),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shadowColor: _setTextButtonShadowColor(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingT14:
        return getPadding(
          top: 14,
          right: 14,
          bottom: 14,
        );
      default:
        return getPadding(
          all: 10,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.FillWhite:
        return ColorConstant.white;
      case ButtonVariant.OutlineGrey:
        return null;
      default:
        return ColorConstant.primaryPink;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineGrey:
        return BorderSide(
          color: ColorConstant.grayBorder
        );
      default:
        return null;
    }
  }

  _setTextButtonShadowColor() {
    switch (variant) {
      case ButtonVariant.FillOrange:
        return ColorConstant.primaryPink;
      case ButtonVariant.FillWhite:
        return null;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder14:
        return BorderRadius.circular(
          getSize(
            14.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getSize(
            8.00,
          ),
        );
    }
  }

  _setBorderRadiusForLoadingButton() {
    switch (shape) {
      case ButtonShape.RoundedBorder14:
        return getSize(
          14.00,
        );
      default:
        return getSize(
          8.00,
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.Grey18:
        return GoogleFonts.getFont(
          "Nunito",
          color: ColorConstant.grayBorder,
          fontSize: getFontSize(
            16,
          ),
          fontWeight: FontWeight.w600,
        );
      
      default:
        return GoogleFonts.getFont(
          "Nunito",
          color: ColorConstant.white,
          fontSize: getFontSize(
            16,
          ),
          fontWeight: FontWeight.w600,
        );
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder14,
}

enum ButtonPadding {
  PaddingT14,
}

enum ButtonVariant {
  FillWhite,
  FillOrange,
  OutlineGrey,

}

enum ButtonFontStyle {
  Grey18,
}
