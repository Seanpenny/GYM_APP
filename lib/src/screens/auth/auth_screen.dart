import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../utils/safe_fonts.dart';

// Lime green brand accent
const Color limeGreen = Color(0xFF39FF14);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _useOtp = false;
  bool _biometricEnabled = true;
  bool _acceptTerms = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _toggleMethod() => setState(() => _useOtp = !_useOtp);

  Future<void> _handleContinue() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final identifier = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Enter your email or username.')),
      );
      return;
    }

    if (_useOtp) {
      messenger.showSnackBar(
        const SnackBar(content: Text('OTP login is not available yet. Use password login.')),
      );
      return;
    }

    if (password.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Enter your password.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await ApiService.login(identifier: identifier, password: password);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      final member = data['member'] as Map<String, dynamic>;
      await SessionService.saveSession(
        memberId: member['id'] as int? ?? 0,
        username: member['username']?.toString() ?? '',
        email: member['email']?.toString(),
        firstName: member['firstName']?.toString(),
        lastName: member['lastName']?.toString(),
        qrCode: member['qrCode']?.toString(),
      );
      if (!mounted) return;
      navigator.pushNamedAndRemoveUntil('/dashboard', (route) => false);
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text(result['error']?.toString() ?? 'Login failed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 380 ? 16.0 : 24.0;
    final headingSize = screenWidth < 380 ? 28.0 : 32.0;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Auth screen image error: $error');
              return Container(color: Colors.black);
            },
          ),
          // Dark overlay for readability
          Container(color: Colors.black.withValues(alpha: 0.6)),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to George Loots Gym',
                    style: SafeFonts.interTight(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Secure login with one-tap biometrics or choose your method of the day.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: [_useOtp, !_useOtp],
                      onPressed: (index) {
                        if (index == 0 && !_useOtp) {
                          _toggleMethod();
                        } else if (index == 1 && _useOtp) {
                          _toggleMethod();
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      fillColor: limeGreen,
                      selectedColor: Colors.white,
                      color: Colors.white70,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          child: Text('Email + OTP'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          child: Text('Email + Password'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email or username',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: limeGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 320),
                    crossFadeState: _useOtp
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'One-time passcode',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: limeGreen,
                            width: 2,
                          ),
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Send code',
                            style: TextStyle(color: limeGreen),
                          ),
                        ),
                      ),
                    ),
                    secondChild: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: limeGreen,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.fingerprint, color: limeGreen),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SwitchListTile.adaptive(
                    value: _biometricEnabled,
                    onChanged: (value) =>
                        setState(() => _biometricEnabled = value),
                    activeTrackColor: limeGreen,
                    title: const Text(
                      'Use Face ID / Touch ID next time',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'One-tap entry when you arrive at the club',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: _acceptTerms,
                    onChanged: (value) =>
                        setState(() => _acceptTerms = value ?? true),
                    contentPadding: EdgeInsets.zero,
                    activeColor: limeGreen,
                    checkColor: Colors.white,
                    title: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: limeGreen,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Club Terms',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: limeGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _acceptTerms && !_isLoading ? _handleContinue : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: limeGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Enter your dashboard'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/support'),
                      child: const Text(
                        'Need help accessing your account?',
                        style: TextStyle(color: limeGreen),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/signup'),
                      child: const Text(
                        'New member? Create your profile',
                        style: TextStyle(color: limeGreen),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
