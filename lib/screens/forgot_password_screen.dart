import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/app_i18n.dart';
import '../services/auth_action_settings.dart';
import '../services/auth_error_messages.dart';
import '../utils/form_validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_form_footer_branding.dart';
import '../widgets/auth_form_frame.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/rounded_back_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = FormValidators.normalizeEmail(_email.text);
    setState(() => _loading = true);
    try {
      if (hasCustomAuthHandlerUrl) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
            url: kCustomAuthHandlerUrl,
            handleCodeInApp: false,
            androidPackageName: 'com.example.cpp',
            androidInstallApp: true,
            androidMinimumVersion: '23',
          ),
        );
      } else {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }
      if (!mounted) return;
      setState(() => _loading = false);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            AppI18n.t(ctx, en: 'Check your email', ar: 'تحقق من بريدك'),
          ),
          content: Text(
            AppI18n.t(
              ctx,
              en: 'If an account exists for $email, we sent a password reset link. Open your inbox and follow the link (it may expire after a while).',
              ar: 'إذا كان هناك حساب مرتبط بـ $email، تم إرسال رابط إعادة تعيين كلمة المرور. افتح صندوق الوارد واتبع الرابط.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppI18n.t(ctx, en: 'OK', ar: 'حسنًا')),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: _loading,
      message: AppI18n.t(
        context,
        en: 'Sending email…',
        ar: 'جارٍ إرسال البريد...',
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final logoH = (constraints.maxHeight * 0.26).clamp(120.0, 185.0);
            final topPad = MediaQuery.paddingOf(context).top;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: topPad + 48,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: topPad + 4,
                        left: 8,
                        child: RoundedBackButton(
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ResponsiveScrollableCenter(
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                        child: AuthFormFrame(
                          child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthFormFooterBranding(
                                  title: AppI18n.t(
                                    context,
                                    en: 'Forgot password?',
                                    ar: 'نسيت كلمة المرور؟',
                                  ),
                                  subtitle: AppI18n.t(
                                    context,
                                    en: 'Enter your email — we will send a reset link.',
                                    ar: 'أدخل بريدك الإلكتروني لإرسال رابط إعادة التعيين.',
                                  ),
                                  logoHeight: logoH,
                                ),
                                AppTextField(
                                  controller: _email,
                                  label: AppI18n.t(
                                    context,
                                    en: 'Email',
                                    ar: 'البريد الإلكتروني',
                                  ),
                                  hint: AppI18n.t(
                                    context,
                                    en: 'you@example.com',
                                    ar: 'you@example.com',
                                  ),
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  validator: FormValidators.emailAddress,
                                ),
                                const SizedBox(height: 28),
                                PrimaryActionButton(
                                  label: AppI18n.t(
                                    context,
                                    en: 'Send',
                                    ar: 'إرسال',
                                  ),
                                  isLoading: _loading,
                                  inlineProgress: false,
                                  onPressed: _submit,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
