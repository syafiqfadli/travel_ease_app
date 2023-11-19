import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;

  const ImageSlider({super.key, required this.images});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: PageView.builder(
              itemCount: widget.images.length,
              pageSnapping: true,
              controller: pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      widget.images[pagePosition],
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _indicators(widget.images.length, activePage),
        )
      ],
    );
  }
}

List<Widget> _indicators(int imagesLength, int currentIndex) {
  return List<Widget>.generate(
    imagesLength,
    (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle,
        ),
      );
    },
  );
}
