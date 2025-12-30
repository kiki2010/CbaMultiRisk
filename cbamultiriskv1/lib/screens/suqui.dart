import 'package:flutter/material.dart';
import 'package:cbamultiriskv1/widgets/avatar.dart';
import 'package:cbamultiriskv1/widgets/cards.dart';

class SuquiScreen extends StatefulWidget {
  const SuquiScreen({super.key});

  @override
  State<SuquiScreen> createState() => _SuquiScreenState();
}

class _SuquiScreenState extends State<SuquiScreen> {
  final SuquiController controller = SuquiController();

  SuquiTip? currentTip;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await controller.loadTips();
    setState(() {
      currentTip = controller.randomTip();
      loaded = true;
    });
  }

  void _onSuquiTap() {
    setState(() {
      controller.nextPose(3); // poses 1,2,3
      currentTip = controller.randomTip();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded || currentTip == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final locale = 'es';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Globo
            speechBubble(
              title: currentTip!.text(locale),
              fontSize: 18,
            ),

            const SizedBox(height: 16),

            // Suqui
            suquiAvatar(
              posIndex: controller.currentPose,
              onTap: _onSuquiTap,
            ),
          ],
        ),
      ),
    );
  }
}
