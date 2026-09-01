import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Alternative to the Pollinations.ai image URLs used in
/// LessonContentView, using Fireworks AI's hosted FLUX.1 [schnell] model.
/// Unlike Pollinations (a plain GET URL Image.network can load directly),
/// this is a paid, authenticated POST endpoint that returns raw JPEG bytes,
/// so results are cached to disk (keyed by prompt hash) to avoid paying
/// for the same illustration twice.
class FluxImageService {
  static final FluxImageService _instance = FluxImageService._internal();

  static const String _endpoint =
      'https://api.fireworks.ai/inference/v1/workflows/accounts/fireworks/models/flux-1-schnell-fp8/text_to_image';

  String? _apiKey;
  bool _isInitialized = false;

  factory FluxImageService() {
    return _instance;
  }

  FluxImageService._internal();

  void initialize({required String apiKey}) {
    _apiKey = apiKey;
    _isInitialized = true;
  }

  Future<File> _cacheFileFor(String prompt) async {
    final dir = await getApplicationCacheDirectory();
    final hash = sha256.convert(utf8.encode(prompt)).toString();
    return File('${dir.path}/flux_$hash.jpg');
  }

  /// Returns JPEG bytes for [prompt], generating via FLUX.1 schnell on first
  /// request and reusing the cached file afterwards. Returns null on error
  /// so callers can fall back to a placeholder, same as Image.network's
  /// errorBuilder does today.
  Future<Uint8List?> generateImage(
    String prompt, {
    String aspectRatio = '16:9',
  }) async {
    if (!_isInitialized) throw Exception('FluxImageService not initialized');

    try {
      final cacheFile = await _cacheFileFor(prompt);
      if (await cacheFile.exists()) {
        return await cacheFile.readAsBytes();
      }

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Accept': 'image/jpeg',
        },
        body: jsonEncode({
          'prompt': prompt,
          'aspect_ratio': aspectRatio,
          'guidance_scale': 3.5,
          'num_inference_steps': 4,
        }),
      );

      if (response.statusCode != 200) {
        print('FLUX API error ${response.statusCode}: ${response.body}');
        return null;
      }

      final bytes = response.bodyBytes;
      await cacheFile.writeAsBytes(bytes);
      return bytes;
    } catch (e) {
      print('FLUX image generation error: $e');
      return null;
    }
  }
}
