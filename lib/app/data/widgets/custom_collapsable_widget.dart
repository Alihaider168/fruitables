import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';

class CustomCollapsableWidget extends StatelessWidget {
  CustomCollapsableWidget({super.key, required this.header, required this.child,this.banners});

  final Widget child;
  final Widget header;
  final List<Banners>? banners;

  RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Main AppBar with flexible space
        SliverAppBar(
          expandedHeight: 200.0, // Adjust height as needed
          floating: false,
          pinned: false,
          leading: Offstage(),
          backgroundColor: ColorConstant.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Carousel Slider
            CarouselSlider(
              items: banners!.map((banner) {
                return CustomImageView(
                  url: Utils.getCompleteUrl(banner.image?.key),
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              }).toList(),
              options: CarouselOptions(
                height: 200.0,
                viewportFraction: 1.0,
                autoPlay: true,
                onPageChanged: (index, reason) {
                    currentIndex.value = index;
                },
              ),
            ),
            // Dots indicator at the bottom of the carousel
            Positioned(
              bottom: 10.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners!.map((url) {
                  int index = banners!.indexOf(url);
                  return Obx(()=> Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex.value == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ));
                }).toList(),
              ),
            ),
          ],
        )),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [header], // Using the passed Column as child
          ),
        ),
        // Collapsible view at the bottom of AppBar
        SliverList(
          delegate: SliverChildListDelegate(
            [child], // Using the passed Column as child
          ),
        ),

        // SliverPersistentHeader(
        //   pinned: true,
        //   delegate: _CollapsibleViewDelegate(
        //     minHeight: getSize(400),  // Minimum height when collapsed
        //     maxHeight: getSize(400), // Maximum height when expanded
        //     child: header
        //   ),
        // ),
        // Main content below the collapsible view
        // SliverList(
        //   delegate: SliverChildListDelegate(
        //     [child], // Using the passed Column as child
        //   ),
        // ),
      ],
    );
  }
}


// Custom SliverPersistentHeaderDelegate to manage collapsible view
class _CollapsibleViewDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _CollapsibleViewDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}