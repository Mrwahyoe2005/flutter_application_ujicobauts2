import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Kelola Keuanganmu Dengan Cerdas 💡",
      "desc":
          "FinTrack membantu kamu mencatat pemasukan dan pengeluaran dengan mudah agar keuangan tetap sehat.",
      "illustration": _FinanceBarIllustration(),
    },
    {
      "title": "Raih Tujuan Finansialmu 🎯",
      "desc":
          "Atur dan pantau setiap langkah finansialmu menuju kebebasan dan masa depan yang stabil.",
      "illustration": _PiggyBankIllustration(),
    },
    {
      "title": "Mulai Bersama FinTrack 💸",
      "desc":
          "Yuk, wujudkan impian finansialmu. Catat, pantau, dan nikmati hidup tanpa stres keuangan!",
      "illustration": _WalletIllustration(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  Future<void> _nextPage() async {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _controller.forward(from: 0);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seenOnboarding', true);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(animation),
            child: child,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      backgroundColor: const Color(0xFFE3F5F1),
      body: GestureDetector(
        onTap: _nextPage,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(height: 220, child: page["illustration"]),
                    const SizedBox(height: 50),
                    Text(
                      page["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page["desc"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 60),
                    if (_currentPage == 2)
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Mulai Sekarang',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// === ILUSTRASI CODING STYLE PASTEL TEAL ===
//

// 1️⃣ Grafik Bar Keuangan
class _FinanceBarIllustration extends StatelessWidget {
  const _FinanceBarIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _bar(60, Colors.teal.withOpacity(0.3)),
          const SizedBox(width: 10),
          _bar(100, Colors.teal.withOpacity(0.5)),
          const SizedBox(width: 10),
          _bar(140, Colors.teal),
          const SizedBox(width: 10),
          _bar(90, Colors.teal.withOpacity(0.4)),
        ],
      ),
    );
  }

  Widget _bar(double height, Color color) {
    return Container(
      width: 28,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// 2️⃣ Celengan & Koin
class _PiggyBankIllustration extends StatelessWidget {
  const _PiggyBankIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.savings_rounded,
            size: 140, color: Colors.teal.withOpacity(0.9)),
        Positioned(
          top: 10,
          right: 70,
          child: Icon(Icons.circle,
              size: 26, color: Colors.amberAccent.withOpacity(0.8)),
        ),
        Positioned(
          top: 20,
          left: 90,
          child: Icon(Icons.circle,
              size: 18, color: Colors.amber.withOpacity(0.9)),
        ),
      ],
    );
  }
}

// 3️⃣ Dompet & Uang
class _WalletIllustration extends StatelessWidget {
  const _WalletIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 120,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.teal.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const Positioned(
          bottom: 12,
          right: 36,
          child: Icon(Icons.attach_money, color: Colors.white, size: 36),
        ),
        const Positioned(
          bottom: 14,
          left: 36,
          child: Icon(Icons.money, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
