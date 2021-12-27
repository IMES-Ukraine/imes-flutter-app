import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:imes/resources/repository.dart';

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
          BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            '$BASE_URL$url',
          ),
          configuration: BetterPlayerConfiguration(
              autoPlay: false,
              aspectRatio: 16 / 9,
              fit: BoxFit.cover,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                enableFullscreen: false,
              )),
          playFraction: 0.8,
        ),
      ),
    );
  }
}
