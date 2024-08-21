import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/styles.dart';

class WebScreen extends StatefulWidget {
  final bool isPrivacy;
  const WebScreen({super.key, required this.isPrivacy});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller!
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    // ..loadRequest(Uri.parse('https://www.google.com/'));

    // #docregion platform_features

    // #enddocregion platform_features
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => context
        .read<CoreProvider>()
        .getContentScreenData(widget.isPrivacy, context));
    return Scaffold(
      appBar: AppStyles.pinkAppBar(
        context,
        widget.isPrivacy ? "Privacy Policy" : "Terms & Conditions",
      ),
      body: SafeArea(child: Consumer<CoreProvider>(builder: (context, val, _) {
        if (val.loadContentState == States.loading) {
          return const CustomLoadingBarWidget();
        } else if (val.loadContentState == States.failure) {
          return const Center(
            child: CustomText(
              text: 'Something Went Wrong.',
            ),
          );
        } else if (val.loadContentState == States.success) {
          _controller?.loadRequest(Uri.parse(val.contentUrl));
          print("val.contentUrl: ${val.contentUrl}");
          return WebViewWidget(controller: _controller!);
        }

        // ignore: prefer_const_constructors
        return Container(
          height: 100,
          width: 100,
          color: Colors.red,
        );
      })),
    );
  }
}
