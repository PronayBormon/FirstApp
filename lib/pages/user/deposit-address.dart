import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class DepositAddress extends StatefulWidget {
  final String deposit;
  const DepositAddress({super.key, required this.deposit});

  @override
  _DepositAddressState createState() => _DepositAddressState();
}

class _DepositAddressState extends State<DepositAddress> {
  final _secureStorage = FlutterSecureStorage();
  String? _walletAddress;
  String? _merchantId;
  int _countdown = 600; // 10-minute countdown (600 seconds)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkTokenAndRedirect();
    _checkSession(); // Check if a session exists
  }

  /// Check if session data exists
  Future<void> _checkSession() async {
    final storedAddress = await _secureStorage.read(key: 'wallet_address');
    final storedTime = await _secureStorage.read(key: 'countdown_end_time');

    if (storedAddress != null && storedTime != null) {
      final endTime = int.parse(storedTime);
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (endTime > currentTime) {
        setState(() {
          _walletAddress = storedAddress;
          _countdown = endTime - currentTime; // Resume countdown
        });
        _startCountdown();
        return;
      }
    }

    // If no valid session, request a new wallet address
    _sendDepositRequest();
  }

  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  Future<void> _sendDepositRequest() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/payment/checkwalletAddress');
    final token = await _secureStorage.read(key: 'access_token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'tokens': token}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final walletAddress = responseData['data']?['data']?['walletAddress'];
        final merchantId = responseData['data']['data']['merchant_id'];

        if (walletAddress != null) {
          setState(() {
            _walletAddress = walletAddress;
            _merchantId = merchantId;
          });

          // Save session data
          await _secureStorage.write(
              key: 'wallet_address', value: walletAddress);
          final endTime =
              (DateTime.now().millisecondsSinceEpoch ~/ 1000) + _countdown;
          await _secureStorage.write(
              key: 'countdown_end_time', value: endTime.toString());

          _sendLiveRequest();
          _startCountdown();
          print('Deposit successful: $_walletAddress');
        } else {
          print('Invalid wallet address response');
        }
      } else {
        print('Deposit failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendLiveRequest() async {
    final url = Uri.parse('https://api.totomonkey.com/api/payment/liveRequest');
    final token = await _secureStorage.read(key: 'access_token');
    final slug = _formatCountdown();

    if (_walletAddress != null && _merchantId != null) {
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'slug': slug,
            'waAddress': _walletAddress,
            'merchant_id': _merchantId,
            'token': token,
          }),
        );

        if (response.statusCode == 200) {
          print('Live request sent successfully: ${response.body}');
        } else {
          print(
              'Live request failed: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _clearSession();
        _redirectToWalletPage();
      }
    });
  }

  void _clearSession() async {
    await _secureStorage.delete(key: 'wallet_address');
    await _secureStorage.delete(key: 'countdown_end_time');
  }

  void _redirectToWalletPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WalletPage()),
    );
  }

  String _formatCountdown() {
    int minutes = _countdown ~/ 60;
    int seconds = _countdown % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard() {
    if (_walletAddress != null) {
      Clipboard.setData(ClipboardData(text: _walletAddress!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address copied: $_walletAddress'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/chevron-left.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_walletAddress == null) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Generating QR Code...',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ] else ...[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_formatCountdown()}',
                  style: const TextStyle(color: mainColor, fontSize: 30),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: deviceWidth(context) * .50,
                // padding: EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: (600 - _countdown) / 600, // Show countdown progress
                  backgroundColor: Colors.white24,
                  color: Colors.green,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan this QR Code to deposit:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: _walletAddress!,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _walletAddress!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white),
                    onPressed: _copyToClipboard,
                    tooltip: 'Copy Address',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
