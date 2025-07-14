import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/show_snack_bar.dart';
import 'package:ceni_fruit/provider/paypal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalWebView extends ConsumerStatefulWidget {
  final String approvalUrl;

  const PayPalWebView({super.key, required this.approvalUrl});

  @override
  ConsumerState<PayPalWebView> createState() => _PayPalWebViewState();
}

class _PayPalWebViewState extends ConsumerState<PayPalWebView> {
  bool _isLoading = true;
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
            try {
              if (url.contains('http://localhost:2020/pay/success')) {
                final uri = Uri.parse(url);
                String orderId = uri.queryParameters['orderId']!;
                String token = uri.queryParameters['token']!;

                navigator.pop({
                  'status': 'success',
                  'orderId': orderId,
                  "token": token,
                });
                return NavigationDecision.prevent;
              }

              if (url.contains('http://localhost:2020/pay/cancel')) {
                Navigator.pop(context, {"status": "cancel"});
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            } catch (error) {
              navigator.pop({'status': 'fail', "error": error.toString()});
              return NavigationDecision.prevent;
            }
          },
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán PayPal'),
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
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
