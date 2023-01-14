import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kintter/provider/card_provider.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  final String urlImage;
  final bool isFront;

  const ProfileCard({
    Key? key,
    required this.urlImage,
    required this.isFront,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  Widget buildStatus() => Row(children: [
        Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.green),
            width: 12,
            height: 12),
        const SizedBox(width: 8),
        const Text(
          "Exploring recently",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ]);

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.urlImage),
                fit: BoxFit.cover,
                alignment: const Alignment(-0.3, 0)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;

          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: buildCard());
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition();
        },
      );
}
