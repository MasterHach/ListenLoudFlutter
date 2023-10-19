import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:testing/models/music.dart';

class PostTemplate extends StatefulWidget {
  final Music music;

  const PostTemplate({super.key, required this.music});

  @override
  State<PostTemplate> createState() => _PostTemplateState();
}

class _PostTemplateState extends State<PostTemplate> {
  final audioPlayer = AudioPlayer();
  static const notFound =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png';

  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }

  Future<void> loadAudio() async {
    await audioPlayer.play(UrlSource(widget.music.audioUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ClipOval(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.music.imageUrl ?? notFound),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: const Alignment(-1, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${widget.music.author.username}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.music.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.music.description,
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: const Alignment(1, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 40,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.music.likesCount.toString()),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
