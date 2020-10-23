import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class TestVideoCard extends StatelessWidget {
  final String url;

  TestVideoCard({
    Key key,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayerListVideoPlayer(
          BetterPlayerDataSource(BetterPlayerDataSourceType.NETWORK, url),
          configuration: BetterPlayerConfiguration(
            autoPlay: false,
            aspectRatio: 16 / 9,
            fit: BoxFit.cover,
          ),
          playFraction: 0.8,
        ),
      ),
    );
  }
}
