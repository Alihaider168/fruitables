import 'package:rexsa_cafe/app/data/core/app_export.dart';

class CustomGetStartedButton extends StatelessWidget {
  const CustomGetStartedButton({super.key,required this.image, required this.title, this.onTap});

  final String image;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: getPadding(
          left: 12,
          right: 12,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: ColorConstant.black.withOpacity(.03),
          borderRadius: BorderRadius.circular(getSize(10))
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorConstant.white,
                shape: BoxShape.circle
              ),
              margin: getMargin(right: 15),
              padding: getPadding(all: 5),
              child: CustomImageView(
                svgPath: image,
                color: ColorConstant.primaryPink,
                height: getSize(24),
                width: getSize(24),
              ),
            ),
            MyText(
              title: title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

}