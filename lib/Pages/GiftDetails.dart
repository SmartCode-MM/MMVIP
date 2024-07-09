import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mmvip/Comp/Admob.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PresentDetail extends StatefulWidget {
  const PresentDetail({super.key});

  @override
  State<PresentDetail> createState() => _PresentDetailState();
}

class _PresentDetailState extends State<PresentDetail> {
  var _con;
  BannerAd? banner;

  void loadAds() async {
    banner = await MMVIPAdMob.getBanner(
      context,
      height: 100,
    );
    banner?.load();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (banner != null) {
      banner!.dispose();
    }
    super.dispose();
  }

  Widget showPresent(type, content) {
    print(content);
    print("//////////////////////////////////////////////////");
    if (type == "text") {
      return Expanded(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          alignment: Alignment.center,
          child: Text(
            "\" $content \"",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (type == "image") {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              content,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else if (type == "url") {
      _con = WebViewController() // create controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted) // set js mode
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(content));
      return Expanded(child: Container(child: WebViewWidget(controller: _con)));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      loadAds();
    }
    final List args = ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: banner == null
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              height: 70,
              child: Center(child: Text("Google Ads Banner")),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.transparent),
              ),
              width: double.infinity,
              height: 70,
              child: AdWidget(ad: banner!),
            ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff053b61),
        title: Text(
          args[0],
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        toolbarHeight: 72,
        leadingWidth: 48 + 16,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Icon(
                    Icons.arrow_back_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          showPresent(args[1], args[2]),
          // banner == null
          //     ? Container(
          //         margin:
          //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         height: 88,
          //         child: Center(child: Text("Google Ads Banner")),
          //       )
          //     : Container(
          //         decoration: BoxDecoration(
          //           border: Border.all(width: 1, color: Color(0xFFeaeaea)),
          //         ),
          //         width: double.infinity,
          //         height: 200,
          //         child: AdWidget(ad: banner!),
          //       ),
        ],
      ),
    );
  }
}
