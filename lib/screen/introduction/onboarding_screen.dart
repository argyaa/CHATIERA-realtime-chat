import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    handleOnSkip() {
      var pref = GetStorage();
      pref.write('isSkipIntro', true);
      Get.offNamed('/login');
    }

    List<PageViewModel> listPagesViewModel = [
      PageViewModel(
        title: "Berinteraksi dengan mudah",
        body: "Kamu hanya perlu di rumah saja untuk mendapatkan teman baru",
        image: Center(child: Image.asset("assets/people_chilling.png")),
      ),
      PageViewModel(
        title: "Temukan Sahabat Baru",
        body: "Jika kamu memang jodoh karena aplikasi ini, kami sangat bahagia",
        image: Center(
          child: Image.asset("assets/conversation.png"),
        ),
      ),
      PageViewModel(
        title: "Aplikasi bebas biaya",
        body: "Kamu jangan khawatir, aplikasi ini bebas biaya",
        image: Center(
          child: Image.asset("assets/skateboard.png"),
        ),
      ),
      PageViewModel(
        title: "Gabung sekarang juga",
        body: "Daftarkan dirimu untuk segera mendapatkan teman baru",
        image: Center(child: Image.asset("assets/welcome.png")),
      ),
    ];

    return Scaffold(
      body: IntroductionScreen(
        pages: listPagesViewModel,
        onDone: () {
          Get.offNamed('/login');
        },
        onSkip: handleOnSkip,
        showBackButton: false,
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text(
          "Next",
          // style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.blueAccent,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
