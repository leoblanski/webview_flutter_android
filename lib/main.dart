import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giver_lojista/core/empty_scaffold.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'components/turn_list_navigation_bar.dart';

class TurnListPage extends StatefulWidget {
  const TurnListPage({Key? key}) : super(key: key);

  @override
  _TurnListPageState createState() => _TurnListPageState();
}

class _TurnListPageState extends State<TurnListPage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  // On destroy stream
  late StreamSubscription _onDestroy;
  // On urlChanged stream
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewHttpError> _onHttpError;
  late StreamSubscription<double> _onProgressChanged;

  @override
  void initState() {
    super.initState();

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          print('onProgressChanged: $progress');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          print('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EmptyScaffold(
      body: Builder(builder: (BuildContext context) {
        return WebviewScaffold(
            url:
                'https://cli.giver.com.br/api/desktop/loginProvider?oauth=96a1505dcdc13494b073459adc3bfba0&provider=android&appVersion=1.1.1&auth_type=pincode&device_id=1047&token_id=10560',
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false);
      }),
    );
  }

  // ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();
}
