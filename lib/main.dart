import 'package:flutter/material.dart';
import 'package:kintter/provider/card_provider.dart';
import 'package:kintter/widget/profile_card.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        title: 'Kintten (Tinder for cats)',
        theme: ThemeData(
            primarySwatch: Colors.grey,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    primary: Colors.white,
                    shape: CircleBorder(),
                    minimumSize: Size.square(80)))),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Container(
          child: buildCards(),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
        )),
      );

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;
    return Stack(
      children: urlImages
          .map((e) => ProfileCard(
                urlImage: e,
                isFront: urlImages.last == e,
              ))
          .toList(),
    );
  }
}
