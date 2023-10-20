import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/models/music.dart';

class PostTemplate extends StatefulWidget {
  final Music music;

  const PostTemplate({super.key, required this.music});

  @override
  State<PostTemplate> createState() => _PostTemplateState();
}

class _PostTemplateState extends State<PostTemplate> {
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  static final url = '${dotenv.env['URL']}/api/v1/music';

  static const notFound =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png';

  @override
  void initState() {
    super.initState();
    loadAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        this.duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        this.position = position;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(UrlSource(widget.music.audioUrl));
  }

  Future<void> togglePlayback() async {
    _isPlaying ? await audioPlayer.pause() : await audioPlayer.resume();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> rateAudio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    Dio dio = Dio();
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers['Authorization'] = 'Bearer $token';

    await dio.post('$url/${widget.music.id}/likes');
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: togglePlayback,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  widget.music.imageUrl ?? notFound),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (!_isPlaying)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipOval(
                              child: Container(
                                width: 300,
                                height: 300,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            const Icon(
                              Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor:
                        Colors.white, // Set the color of the active track
                    inactiveTrackColor: Colors.white.withOpacity(
                        0.5), // Set the color of the inactive track
                    trackHeight: 5.0, // Set the height of the track
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius:
                            0.0), // Set the thumb shape and size
                    overlayColor: Colors.transparent, // Remove overlay
                  ),
                  child: Slider(
                    min: 0,
                    max: duration.inMilliseconds.toDouble() + 1000.0,
                    value: position.inMilliseconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(milliseconds: value.toInt());
                      await audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration)),
                    ],
                  ),
                ),
              ],
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
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            widget.music.isLiked ? widget.music.likesCount-- : widget.music.likesCount++;
                            widget.music.isLiked = !widget.music.isLiked;
                          });
                          await rateAudio();
                        },
                        child: Icon(
                          widget.music.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 40,
                          color: widget.music.isLiked ? Colors.red : null,
                        ),
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
