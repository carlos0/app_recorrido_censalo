import 'package:flutter/material.dart';

class MarkerWidget extends StatelessWidget {
  const MarkerWidget(
      {super.key, required this.man, required this.woman, required this.name});
  final int man;
  final int woman;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xff615793), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 8),
            ),
            Row(
              children: [
                const Icon(
                  Icons.woman,
                  size: 20,
                ),
                Text(
                  "$woman",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.man,
                  size: 20,
                ),
                Text(
                  "$man",
                  style: TextStyle(fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
