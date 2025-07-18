import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomoWebview extends ConsumerStatefulWidget {
  final String approvalUrl;

  const MomoWebview({super.key, required this.approvalUrl});

  @override
  ConsumerState<MomoWebview> createState() => _MomoWebviewState();
}

class _MomoWebviewState extends ConsumerState<MomoWebview> {
  bool isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            final navigator = Navigator.of(context);
            print("url: $url");
            // NGUYEN VAN A	9704 0000 0000 0018	03/07	OTP	Thành công
            //NGUYEN VAN A	4111 1111 1111 1111	05/26	111	No OTP	Card Successful
            try {
              if (url.contains('http://localhost:2020/redirectUrl?partnerCode=MOMO')) {
                final uri = Uri.parse(url);
                String orderId = uri.queryParameters['orderId']!;

                navigator.pop({'status': 'success', 'orderId': orderId});
                return NavigationDecision.prevent;
              }

              if (url.contains('http://localhost:2020/momo/cancel')) {
                Navigator.pop(context, {"status": "cancel"});
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            } catch (error) {
              navigator.pop({'status': 'fail', "error": error.toString()});
              return NavigationDecision.prevent;
            }
          },
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán MoMo'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {"status": "cancel"});
          },
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
