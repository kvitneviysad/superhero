import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../core/network/dio_client.dart';

class HeroNetworkImage extends StatefulWidget {
  final String url;
  const HeroNetworkImage({super.key, required this.url});

  @override
  State<HeroNetworkImage> createState() => _HeroNetworkImageState();
}

class _HeroNetworkImageState extends State<HeroNetworkImage> {
  late Future<Uint8List?> _future;

  // ← Встав свій Worker URL сюди
  static const String _workerBase =
      'https://superhero-proxy.kvitneviy-sad.workers.dev/';

  static String _proxyUrl(String url) {
    if (url.isEmpty) return '';
    final encoded = Uri.encodeComponent(url);
    return '$_workerBase?url=$encoded';
  }

  @override
  void initState() {
    super.initState();
    _future = _loadImage(_proxyUrl(widget.url));
  }

  Future<Uint8List?> _loadImage(String url) async {
    if (url.isEmpty) return null;
    try {
      final response = await DioClient.imageClient.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      debugPrint('[HeroNetworkImage] Error loading $url: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: AppTheme.surfaceAlt,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.accent,
              ),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
        return Container(
          color: AppTheme.surfaceAlt,
          child: const Icon(
            Icons.broken_image_outlined,
            color: AppTheme.textSecondary,
            size: 36,
          ),
        );
      },
    );
  }
}