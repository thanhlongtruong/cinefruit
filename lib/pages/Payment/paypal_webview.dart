import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalWebView extends StatefulWidget {
  final String approvalUrl;

  const PayPalWebView({super.key, required this.approvalUrl});

  @override
  State<PayPalWebView> createState() => _PayPalWebViewState();
}

class _PayPalWebViewState extends State<PayPalWebView> {
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

            if (url.contains('http://localhost:2020/pay/success')) {
              // ✅ Thanh toán thành công → parse orderId và token nếu cần
              final uri = Uri.parse(url);
              final orderId = uri.queryParameters['orderId'];
              final token = uri.queryParameters['token'];
              print(orderId);
              // Bạn có thể gọi API xác nhận ở đây nếu muốn
              // await http.get('yourserver.com/pay/success?orderId=...&token=...');

              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }

            if (url.contains('http://localhost:2020/pay/cancel')) {
              Navigator.pop(context, 'cancel');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
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
