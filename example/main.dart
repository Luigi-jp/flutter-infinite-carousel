import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '無限カルーセルのデモ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<InfiniteCarouselState> _carouselKey = GlobalKey();
  bool _autoPlay = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('無限カルーセルのデモ'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: InfiniteCarousel(
              key: _carouselKey,
              itemCount: 5,
              autoPlay: _autoPlay,
              autoPlayInterval: const Duration(seconds: 2),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'アイテム $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                print('現在のページ: $index');
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _carouselKey.currentState?.previousPage();
                },
                child: const Text('前へ'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  _carouselKey.currentState?.nextPage();
                },
                child: const Text('次へ'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('自動再生: '),
              Switch(
                value: _autoPlay,
                onChanged: (value) {
                  setState(() {
                    _autoPlay = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}