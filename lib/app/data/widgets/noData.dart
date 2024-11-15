import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitables/app/data/core/app_export.dart';


class NoData extends StatelessWidget {
  final String? svgPath;
  final String? name;
  final String? message;
  const NoData({Key? key, this.message, this.name, this.svgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 100),
          SvgPicture.asset(
            svgPath!,
            height:  getSize(150),
            width:  getSize(150),
          ),
          SizedBox(
              height: getSize(20)),
          MyText(
            title: 
            name??'',
            fontWeight: FontWeight.bold,
            // textAlign: TextAlign.center,
            
                  fontSize:
                    getSize(20),
               ),
          
          SizedBox(
              height:  getSize(5)),
          Container(
            width:  getSize(600),
            alignment: Alignment.center,
            child: Text(
              message!,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: ColorConstant.textGrey,
                  fontSize: getSize(16)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: getSize(100)),
        ],
      ),
    );
  }
}
