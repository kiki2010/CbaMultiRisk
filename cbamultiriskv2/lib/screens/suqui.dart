import 'package:cbamultiriskv2/l10n/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';
import 'package:provider/provider.dart';

import 'package:cbamultiriskv2/l10n/app_localizations.dart';

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
      controller.nextPose(3);
      currentTip = controller.randomTip();
    });
  }

  void _onCategoryTap(String category) {
    setState(() {
      final newTip = controller.randomTip(category: category);

      if (newTip.id != currentTip!.id) {
        controller.nextPose(3);
        currentTip = newTip;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded || currentTip == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final locale = context.watch<LocaleController>().locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tips),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            
            speechBubble(
              title: currentTip!.text(locale),
              fontSize: 18,
            ),

            const SizedBox(height: 16),

            Expanded(
              child:GestureDetector(
                onTap: _onSuquiTap,
                child: SuquiAvatar(
                  posIndex: controller.currentPose,
                  height: double.infinity,
                  onTap: _onSuquiTap,
                ),
              ),
            ),

            const SizedBox(height: 8),

            SuquiButtons(
              onCategoryTap: _onCategoryTap,
            ),
            
            const SizedBox(height: 12),
          ],
        ),
      )
    );
  }
}