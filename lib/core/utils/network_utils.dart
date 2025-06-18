import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkUtils {
  static final NetworkUtils _instance = NetworkUtils._internal();
  factory NetworkUtils() => _instance;
  NetworkUtils._internal();

  final Connectivity _connectivity = Connectivity();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Verificar la conectividad inicial
      await _connectivity.checkConnectivity();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing NetworkUtils: $e');
      // Si hay un error, intentamos reinicializar después de un breve retraso
      await Future.delayed(const Duration(seconds: 1));
      await initialize();
    }
  }

  Future<bool> hasInternetConnection() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  Stream<ConnectivityResult> get onConnectivityChanged {
    if (!_isInitialized) {
      initialize();
    }
    return _connectivity.onConnectivityChanged;
  }
} 