import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '𝔻Æ𝕤𝕚𝕘𝕟',
      theme: ThemeData(
        fontFamily: GoogleFonts.titilliumWeb().fontFamily,
      ),
      home: const DaeSignRegisterConfirmPage(),
    );
  }
}

class DaeSignRegisterConfirmPage extends StatefulWidget {
  const DaeSignRegisterConfirmPage({
    super.key,
    this.email = 'something@gmail.com',
    this.username = 'something_user',
    this.password = '********',
  });

  final String email;
  final String username;
  final String password;

  @override
  State<DaeSignRegisterConfirmPage> createState() =>
      _DaeSignRegisterConfirmPageState();
}

class _DaeSignRegisterConfirmPageState extends State<DaeSignRegisterConfirmPage> {
  bool _showPassword = false;

  void _handleBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No previous page to go back to')),
    );
  }

  void _handleRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Front-end only for now')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final logoSize = (width * 0.14).clamp(46.0, 58.0);
    final subtitleSize = (width * 0.045).clamp(14.0, 19.0);
    final headingSize = (width * 0.06).clamp(22.0, 28.0);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/watercolor_landscape.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: size.height * 0.72,
                      ),
                      padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(42),
                          topRight: Radius.circular(42),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              'DÆsign',
                              style: GoogleFonts.inter(
                                fontSize: logoSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Sign up to DÆsign to start posting your art',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: Colors.grey.shade600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 54),
                          Text(
                            'Confirm your details below',
                            style: TextStyle(
                              fontSize: headingSize,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _ConfirmInfoBox(text: 'Email: ${widget.email}'),
                          const SizedBox(height: 18),
                          _ConfirmInfoBox(text: 'Username: ${widget.username}'),
                          const SizedBox(height: 18),
                          _ConfirmInfoBox(
                            text: _showPassword
                                ? 'Password: ${widget.password}'
                                : 'Password: ********',
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey.shade600,
                                size: 34,
                              ),
                            ),
                          ),
                          const SizedBox(height: 62),
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.72,
                              child: SizedBox(
                                height: 54,
                                child: OutlinedButton(
                                  onPressed: _handleRegister,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 1.4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),

                // Put this AFTER the panel so it stays on top.
                Positioned(
                  top: 12,
                  left: 0,
                  child: _BackPillButton(onTap: _handleBack),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackPillButton extends StatelessWidget {
  const _BackPillButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmInfoBox extends StatelessWidget {
  const _ConfirmInfoBox({
    required this.text,
    this.trailing,
  });

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
