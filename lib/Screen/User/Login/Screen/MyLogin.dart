import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/provider/LoginProvider.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../IOSVersionUpdateService.dart';
import '../../../Utils/UpdateService.dart';

class MyLogin extends StatefulWidget {
  static const screenName = '/login';
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _mobileNoController = TextEditingController();
  bool _isHidden = true;
  String? _userName, _password;
  final key = encrypt.Key.fromUtf8('8080808080808080'); //16 chars
  final iv = encrypt.IV.fromUtf8('8080808080808080'); //16 chars

  Future<Map<String, String?>> getStoredUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('userName');  // Retrieve username
    String? storedDistributorCode = prefs.getString('distributorCode');    // Retrieve login ID
    return {'username': storedUsername, 'loginId': storedDistributorCode};
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    }else{
      IosVersionUpdateCheck().checkForUpdate(context);
      debugPrint("Firebase not initialize");
    }
    _loadStoredUserData();
  }

  Future<void> _loadStoredUserData() async {
    Map<String, String?> storedUserData = await getStoredUserData();
    String? storedUsername = storedUserData['username'];
    String? storedMobileNo = storedUserData['MobileNo'];

    if (storedMobileNo != null) {
      setState(() {
        _mobileNoController.text = storedMobileNo;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E3A8A), Color(0xFF1D5A72), Color(0xFF0F766E)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.10),
                  // Logo + App name
                  Image.asset(
                    'assets/playstore.png',
                    height: 110,
                    width: 110,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Niyojan',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Text(
                    'LPG Sales & Inventory',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 36),
                  // Form card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Enter your mobile number to continue',
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _mobileNoController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
                          decoration: InputDecoration(
                            hintText: 'Mobile Number',
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                            prefixIcon: const Icon(Icons.phone_android_rounded, color: Color(0xFF1E3A8A), size: 20),
                            filled: true,
                            fillColor: AppColors.bg,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color:AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              final loginProvider = Provider.of<LoginProvider>(context, listen: false);
                              loginProvider.login(_mobileNoController.text, context);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<LoginProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1E3A8A),
                                ),
                              );
                            }
                            if (provider.errorMessage != null) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFFECACA)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        provider.errorMessage!,
                                        style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),
                  const Text(
                    '© 2024 Niyojan. All rights reserved.',
                    style: TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}



