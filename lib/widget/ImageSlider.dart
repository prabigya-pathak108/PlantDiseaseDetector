import 'package:flutter/material.dart';
import 'dart:async';

class HorizontalImageSlider extends StatefulWidget {
  final List<String> imageAssetPaths;
  final double imageHeight;
  final Duration autoScrollDuration;

  HorizontalImageSlider({
    required this.imageAssetPaths,
    this.imageHeight = 150.0,
    this.autoScrollDuration = const Duration(seconds: 3),
  });

  @override
  _HorizontalImageSliderState createState() => _HorizontalImageSliderState();
}

class _HorizontalImageSliderState extends State<HorizontalImageSlider> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_currentPage < widget.imageAssetPaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: widget.imageHeight,
      width: screenWidth,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageAssetPaths.length,
        itemBuilder: (context, index) {
          return Container(
            child: Image.asset(
              widget.imageAssetPaths[index],
              height: widget.imageHeight,
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}