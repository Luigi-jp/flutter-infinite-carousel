import 'dart:async';
import 'package:flutter/material.dart';

class InfiniteCarousel extends StatefulWidget {
  /// 表示するアイテムの総数
  final int itemCount;
  
  /// 各アイテムを構築するためのビルダー関数
  final Widget Function(BuildContext context, int index) itemBuilder;
  
  /// スクロール方向（デフォルトは水平）
  final Axis scrollDirection;
  
  /// 自動スクロールを有効にするかどうか
  final bool autoPlay;
  
  /// 自動スクロールの間隔
  final Duration autoPlayInterval;
  
  /// 自動スクロールのアニメーション時間
  final Duration autoPlayAnimationDuration;
  
  /// 自動スクロールのカーブ
  final Curve autoPlayCurve;
  
  /// スクロールコントローラー
  final PageController? controller;
  
  /// ページが変更されたときのコールバック
  final void Function(int index)? onPageChanged;
  
  /// パディング
  final EdgeInsets? padding;
  
  const InfiniteCarousel({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.horizontal,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.controller,
    this.onPageChanged,
    this.padding,
  }) : assert(itemCount > 0),
       super(key: key);

  @override
  InfiniteCarouselState createState() => InfiniteCarouselState();
}

class InfiniteCarouselState extends State<InfiniteCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  bool _isDisposed = false;
  
  // ページ数を無限にするために、実際のアイテム数の1000倍にする
  int get _actualItemCount => widget.itemCount * 1000;
  
  // 初期ページ位置を計算（中央付近から開始）
  int get _initialPage => _actualItemCount ~/ 2;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController(initialPage: _initialPage);
    _currentPage = _initialPage;
    _initializeAutoPlay();
  }

  void _initializeAutoPlay() {
    if (widget.autoPlay) {
      _timer = Timer.periodic(widget.autoPlayInterval, (_) {
        if (!_isDisposed && mounted) {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: widget.autoPlayAnimationDuration,
            curve: widget.autoPlayCurve,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    if (widget.controller == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: widget.scrollDirection,
      itemCount: _actualItemCount,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
        if (widget.onPageChanged != null) {
          widget.onPageChanged!(page % widget.itemCount);
        }
      },
      itemBuilder: (context, index) {
        // アイテムのインデックスを実際のアイテム数に基づいてマップする
        final actualIndex = index % widget.itemCount;
        return Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.itemBuilder(context, actualIndex),
        );
      },
    );
  }
  
  /// 次のページに手動でアニメーション
  void nextPage() {
    _pageController.animateToPage(
      _currentPage + 1,
      duration: widget.autoPlayAnimationDuration,
      curve: widget.autoPlayCurve,
    );
  }
  
  /// 前のページに手動でアニメーション
  void previousPage() {
    _pageController.animateToPage(
      _currentPage - 1,
      duration: widget.autoPlayAnimationDuration,
      curve: widget.autoPlayCurve,
    );
  }
  
  /// 特定のページに手動でアニメーション
  void animateToPage(int page) {
    _pageController.animateToPage(
      _initialPage + (page % widget.itemCount),
      duration: widget.autoPlayAnimationDuration,
      curve: widget.autoPlayCurve,
    );
  }
} 