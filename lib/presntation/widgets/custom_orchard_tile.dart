import 'dart:math';
import 'package:dakhalia_project/data/models/orchard_model.dart';
import 'package:flutter/material.dart';

class CustomOrchardTile extends StatefulWidget {
  final OrchardModel orchard;

  CustomOrchardTile({
    required this.orchard,
  });

  @override
  State<CustomOrchardTile> createState() => _CustomOrchardTileState();
}

class _CustomOrchardTileState extends State<CustomOrchardTile> {
  bool _isHovered = false;
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _imagePath = _getImagePath();
  }

  String _getImagePath() {
    List<String> images = [
      "assets/fruit/carrot.png",
      "assets/fruit/apple.png",
      "assets/fruit/mango.png",
      "assets/fruit/potato.png",
      "assets/fruit/watermelon.jpg",
      "assets/fruit/strwaberry.jpeg",
      "assets/fruit/peach.jpg",
    ];
    return images[Random().nextInt(7)];
  }

  void _setHovered(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.15,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 240, 240, 245),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              bottom: 50,
              child: MouseRegion(
                onEnter: (_) => _setHovered(true),
                onExit: (_) => _setHovered(false),
                child: Container(
                  height: height * 0.04,
                  width: width * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: widget.orchard.pestState == "Minimal"
                        ? Colors.green
                        : (widget.orchard.pestState == "Medium")
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ),
            ),
            if (_isHovered)
              Positioned(
                right: 10,
                bottom: 90,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Pest State Info: ${widget.orchard.pestState}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Orchard ${widget.orchard.id.toString()}",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      _imagePath,
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
                Text("Crop: ${widget.orchard.crop}"),
                Text("${widget.orchard.feddans.toString()} feddans"),
              ],
            ),
            Positioned(
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.expand),
                  Text("${widget.orchard.mm.toString()}mm"),
                  SizedBox(width: 10),
                  Container(
                    width: width * 0.06,
                    height: height * 0.01,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: width *
                                0.06 *
                                (widget.orchard.mm / 100), // Adjust width as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(
                                  255, 255, 255 - (255 * widget.orchard.mm ~/ 100), 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
