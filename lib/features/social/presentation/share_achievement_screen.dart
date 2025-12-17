import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ShareAchievementScreen extends StatefulWidget {
  final String type; // 'profile' or 'lesson'
  final Map<String, dynamic> data;

  const ShareAchievementScreen({
    super.key,
    required this.type,
    required this.data,
  });

  @override
  State<ShareAchievementScreen> createState() => _ShareAchievementScreenState();
}

class _ShareAchievementScreenState extends State<ShareAchievementScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _handleShare() async {
    setState(() => _isSharing = true);
    try {
      final image = await _screenshotController.capture(pixelRatio: 3.0);
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/tradequest_share_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await imagePath.writeAsBytes(image);

      final xFile = XFile(imagePath.path);
      
      String shareText = 'Rejoins-moi sur TradeQuest ! 🚀';
      if (widget.type == 'lesson') {
        shareText = 'Je viens de terminer "${widget.data['title']}" sur TradeQuest ! 🧠 +${widget.data['xp']} XP';
      } else {
        shareText = 'Je suis niveau ${widget.data['level']} sur TradeQuest. Peux-tu me battre ? 📈';
      }

      await Share.shareXFiles([xFile], text: shareText);
    } catch (e) {
      debugPrint('Error sharing: $e');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text("PARTAGER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Screenshot(
                controller: _screenshotController,
                child: _buildCardToShare(),
              ),
            ),
            const SizedBox(height: 40),
            _buildShareOptions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCardToShare() {
    final isLesson = widget.type == 'lesson';
    final title = isLesson ? 'MISSION ACCOMPLIE' : 'PROFIL OPÉRATEUR';
    final subtitle = isLesson ? widget.data['title'] : widget.data['username'];
    final xp = widget.data['xp'];
    final secondaryValue = isLesson ? '+${widget.data['xp']} XP' : 'NIVEAU ${widget.data['level']}';

    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.neonBlue, width: 2),
        boxShadow: [
           BoxShadow(color: AppColors.neonBlue.withOpacity(0.3), blurRadius: 40, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.hub, color: AppColors.neonBlue),
              Text('TRADEQUEST', style: TextStyle(color: AppColors.neonBlue, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 32),
          
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonPurple, width: 4),
              boxShadow: [
                BoxShadow(color: AppColors.neonPurple.withOpacity(0.5), blurRadius: 20),
              ],
            ),
            child: Center(
              child: Icon(
                isLesson ? Icons.check_circle_outline : Icons.face, 
                size: 60, 
                color: Colors.white
              ),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          
          const SizedBox(height: 24),
          
          Text(
            title,
            style: const TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 1,
            width: 60,
            color: Colors.white24,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            secondaryValue,
            style: const TextStyle(color: AppColors.neonGreen, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          
          if (!isLesson)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'RANK #${widget.data['rank']}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),

          const SizedBox(height: 32),
          
          Container(
             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
             decoration: BoxDecoration(
               color: Colors.white.withOpacity(0.05),
               borderRadius: BorderRadius.circular(12),
             ),
             child: const Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Icon(Icons.download, size: 14, color: Colors.white54),
                 SizedBox(width: 8),
                 Text('tradequest.app', style: TextStyle(color: Colors.white54, fontSize: 12)),
               ],
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptions() {
    return Column(
      children: [
        const Text(
          "DIFFUSER SUR LE RÉSEAU", 
          style: TextStyle(color: Colors.white54, letterSpacing: 1.5, fontSize: 12),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildShareButton("STORY", Icons.camera_alt, Colors.pinkAccent),
            const SizedBox(width: 24),
            _buildShareButton("FEED", Icons.feed, Colors.blueAccent),
            const SizedBox(width: 24),
            _buildShareButton("LIEN", Icons.link, Colors.white),
          ],
        ),
        const SizedBox(height: 32),
        if (_isSharing)
           const CircularProgressIndicator(color: AppColors.neonBlue)
        else
           SizedBox(
             width: 200,
             child: ElevatedButton(
               onPressed: _handleShare,
               style: ElevatedButton.styleFrom(
                 backgroundColor: AppColors.neonBlue,
                 padding: const EdgeInsets.symmetric(vertical: 16),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
               ),
               child: const Text("PARTAGER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1)),
             ),
           ),
      ],
    );
  }

  Widget _buildShareButton(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: _handleShare, // For now, all trigger the same native share
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
