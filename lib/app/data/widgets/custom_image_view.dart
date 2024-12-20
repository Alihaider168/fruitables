// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';

class CustomImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  String? svgPath;

  ///[file] is required parameter for fetching image file
  File? file;

  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  double? radius;
  BoxBorder? border;
  Color? bgColor;
  bool boxShadow = false;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView(
      {super.key,
      this.url,
      this.imagePath,
      this.svgPath,
      this.file,
      this.height,
      this.width,
      this.color,
      this.bgColor,
      this.fit,
      this.alignment,
      this.padding,
      this.onTap,
      this.radius,
      this.margin,
      this.border,
      this.placeHolder = 'assets/images/image_not_found.png',
      this.boxShadow = false});

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius??0),
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(

        // padding: getPadding(all:8),
        // decoration: BoxDecoration(
        //                                       color: bgColor,

        //   border: border,
        //   borderRadius: BorderRadius.circular(radius??0),
        // ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return boxShadow == true
          ? Container(                                              color: bgColor ,

            
              height: height,
              width: width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7, // Shadow color
                  ),
                ],
              ),
              child: SvgPicture.asset(
                
                
                svgPath!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.contain,
                color: color,
              ),
            )
          : Container(
                                              color: bgColor ,

              height: height,
              width: width,
              child: SvgPicture.asset(

                svgPath!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.contain,
                color: color,
              ),
            );
    } else if (file != null && file!.path.isNotEmpty) {
      return Container(
                                              color: bgColor,

        child: Image.file(
        
          file!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      return Container(
                                    color: bgColor,

        child: CachedNetworkImage(
          height: height,
          width: width,
          fit: fit,
          imageUrl: url!,
          color: color,
          placeholder: (context, url) => SizedBox(
            height: 30,
            width: 30,
            child: LinearProgressIndicator(
              color: Colors.grey.shade200,
              backgroundColor: Colors.grey.shade100,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            placeHolder,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Container(
        color: bgColor,

        child: Image.asset(
          
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        ),
      );
    }
    return const SizedBox();
  }
}
