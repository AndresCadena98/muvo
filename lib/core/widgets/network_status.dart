import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:muvo/core/utils/network_utils.dart';
import 'package:muvo/core/l10n/app_localizations.dart';

class NetworkStatus extends StatefulWidget {
  const NetworkStatus({super.key});

  @override
  State<NetworkStatus> createState() => _NetworkStatusState();
}

class _NetworkStatusState extends State<NetworkStatus> {
  final NetworkUtils _networkUtils = NetworkUtils();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _initializeNetworkStatus();
  }

  Future<void> _initializeNetworkStatus() async {
    await _networkUtils.initialize();
    if (!mounted) return;
    
    setState(() {
      _isConnected = true;
    });

    _networkUtils.onConnectivityChanged.listen((ConnectivityResult result) {
      if (!mounted) return;
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.red,
        child: Center(
          child: Text(
            l10n.noInternet,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
} 