import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:animations/animations.dart';

import 'chatbox.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  // Create a webview controller
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // print the loading progress to the console
          // you can use this value to show a progress bar if you want
          debugPrint("Loading: $progress%");
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse("https://usjr.edu.ph"));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              WebViewWidget(
                controller: _controller,
              ),
              Positioned(
                top: 720,
                left: 320,
                child: OpenContainer(
                  closedColor: Color.fromARGB(0, 255, 255, 255),
                  closedBuilder: (_, openContainer) {
                    return Container(
                      width: 75.0,
                      height: 75.0,
                      decoration: BoxDecoration(
                        color: Color(0xff02C636),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  openBuilder: (_, __) {
                    return chatBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
