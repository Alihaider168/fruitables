import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';

class OtpTextField extends StatelessWidget {
  final String? semanticsLabel;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final Color? color;
  final Function? onChanged;
  final Function(String)? onComplete;

  OtpTextField(
      {Key? key,
      this.controller,
      this.semanticsLabel,
      this.validator,
      this.focusNode,
      this.onChanged,
      this.onComplete,
      this.color = ColorConstant.textFieldUnderlineColor})
      : super(key: key);

  final Responsive responsive = Responsive();

  @override
  Widget build(BuildContext context) {
    responsive.setContext(context);
    return Semantics(
      label: semanticsLabel,
      
      child: PinCodeTextField(
        appContext: context,
        onChanged: (val) {
          onChanged!(val.toString());
        },
        onCompleted: onComplete,
        
        length: Constants.otpLength,
        autoFocus: false,
        controller: controller,
        focusNode: focusNode,
        animationType: AnimationType.fade,
        enableActiveFill: true,
        autoDismissKeyboard: true,
        validator: validator,
        errorTextSpace: 25,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(10),
            fieldHeight: getSize(50),
            fieldWidth: getSize(51),
            fieldOuterPadding: EdgeInsets.symmetric(horizontal: getSize(3)),
            activeFillColor:  ColorConstant.white,
            inactiveFillColor: ColorConstant.white,
            selectedFillColor: ColorConstant.white,
            selectedColor: ColorConstant.blue,
            activeColor:  ColorConstant.black,
            inactiveColor: ColorConstant.black,
            borderWidth: 1),
        textStyle: GoogleFonts.getFont(
          "Nunito",
          color: ColorConstant.black,
          fontWeight: FontWeight.w500,
          fontSize: responsive.setTextScale(18),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        cursorColor: ColorConstant.black,
        animationDuration: const Duration(milliseconds: 300),
        keyboardType: TextInputType.number,
        beforeTextPaste: (text) {
          return false;
        },
      ),
    );
  }
}
