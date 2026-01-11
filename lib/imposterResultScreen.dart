import 'package:flutter/material.dart';
import 'package:imposter/utilites.dart';

class ImposterResultScreen extends StatelessWidget {
  static const String routeName = 'ImposterResultScreen';

  final String imposterName;
  final AssetImage imposterImage;
  final VoidCallback onContinue;

  const ImposterResultScreen({
    required this.imposterName,
    required this.imposterImage,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isVerySmallScreen = size.height < 600;

    // حساب الأحجام بناءً على حجم الشاشة
    double getTitleFontSize() {
      if (isVerySmallScreen) return 20;
      if (isSmallScreen) return 24;
      return 32;
    }

    double getImageHeight() {
      if (isVerySmallScreen) return size.height * 0.35;
      if (isSmallScreen) return size.height * 0.4;
      return size.height * 0.45;
    }

    double getNameFontSize() {
      if (isVerySmallScreen) return 24;
      if (isSmallScreen) return 28;
      return 35;
    }

    double getSpyIconSize() {
      if (isVerySmallScreen) return 40;
      if (isSmallScreen) return 50;
      return 60;
    }

    double getButtonFontSize() {
      if (isVerySmallScreen) return 22;
      if (isSmallScreen) return 26;
      return 30;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1a0000),
              Color(0xff4a0000),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 24,
                        vertical: isSmallScreen ? 16 : 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: isSmallScreen ? 10 : 20),

                          // عنوان
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'THE IMPOSTER WAS',
                              style: TextStyle(
                                fontSize: getTitleFontSize(),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 20),

                          // صورة الـ Imposter
                          Container(
                            height: getImageHeight(),
                            constraints: BoxConstraints(
                              maxWidth: 400,
                              maxHeight: 450,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xfffd0001),
                                width: isSmallScreen ? 3 : 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xfffd0001).withOpacity(0.5),
                                  blurRadius: isSmallScreen ? 20 : 30,
                                  spreadRadius: isSmallScreen ? 3 : 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                image: imposterImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 8 : 10),

                          // اسم الـ Imposter
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 16 : 20,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                imposterName,
                                style: TextStyle(
                                  fontSize: getNameFontSize(),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfffd0001),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 20),

                          // أيقونة الـ Spy
                          Image(
                            image: AssetImage(AppAssets.spy),
                            width: getSpyIconSize(),
                            height: getSpyIconSize(),
                          ),

                          Spacer(),

                          // زر Continue
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 8 : 10,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xfffd0001),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: isSmallScreen ? 12 : 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: getButtonFontSize(),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 10 : 0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}