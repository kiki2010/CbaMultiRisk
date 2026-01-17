/*
Suqui Tips Screen
Last Edit: 16/01/2026
Change: Comments were added
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets used on the screen
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';

//Quiz Screens
import 'package:cbamultiriskv2/screens/quiz.dart';

//English or Spanish
import 'package:cbamultiriskv2/l10n/app_localizations.dart';
import 'package:cbamultiriskv2/l10n/locale_controller.dart';

class SuquiScreen extends StatefulWidget {
  const SuquiScreen({super.key});

  @override
  State<SuquiScreen> createState() => _SuquiScreenState();
}

class _SuquiScreenState extends State<SuquiScreen> {
  //Suqui Controller
  final SuquiController controller = SuquiController();

  SuquiTip? currentTip;
  bool loaded = false;
  
  //We start everything (call _init for loading the tips)
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

  //When we tap suqui (Gif + Tip controller)
  void _onSuquiTap() {
    setState(() {
      controller.nextPose(5);
      currentTip = controller.randomTip();
    });
  }

  //Specific information (Category tips)
  void _onCategoryTap(String category) {
    setState(() {
      final newTip = controller.randomTip(category: category);

      if (newTip.id != currentTip!.id) {
        controller.nextPose(5);
        currentTip = newTip;
      }
    });
  }

  //Screen time!
  @override
  Widget build(BuildContext context) {
    //Wait until tips were loaded
    if (!loaded || currentTip == null) {
      return const Center(child: CircularProgressIndicator());
    }

    //Locale controller for the tips languege
    final locale = context.watch<LocaleController>().locale.languageCode;

    return Scaffold(
      //App title
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tips),
      ),
      //Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            //Tip SpeechBubble
            speechBubble(
              title: currentTip!.text(locale),
              fontSize: 18,
            ),

            const SizedBox(height: 16),

            //Suqui!
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

            //Category + Game Buttons
            SuquiButtons(
              onCategoryTap: _onCategoryTap,
              onQuizTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizMenuScreen()));
              },
            ),
            
            const SizedBox(height: 12),
          ],
        ),
      )
    );
  }
}