import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final int albumId;
  final String albumTitle;

  AlbumCard(this.albumId, this.albumTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 80,
        child: Column(
          children: [
            Text(
              "$albumId",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(albumTitle,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ));
  }
}
