import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/models/music.dart';
import '../widgets/post_template.dart';

class HomePage extends StatefulWidget {
  static String id = 'audio_screen';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  List<Music> data = [];
  int currentPage = 0;
  final _pageController = PageController();
  static final url = '${dotenv.env['URL']}/api/v1/music';

  @override
  void initState() {
    super.initState();
    _fetchAudio();
    _pageController.addListener(_pageListener);
  }

  Future<void> _fetchAudio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    Dio dio = Dio();
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response = await dio.get('$url?page=$currentPage');

    List<dynamic> jsonData = response.data;

    if (response.statusCode == 200) {
      setState(() {
        data.addAll(jsonData.map((e) => Music.fromJson(e)));
        currentPage++;
      });
    }
  }

  void _pageListener() {
    if (_pageController.page == data.length - 1) {
      _fetchAudio();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return PostTemplate(music: data[index]);
              },
            ),
          ),
          // Text('Now Playing: ${data[currentPage]['title']}'),
        ],
      ),
    );
  }
}