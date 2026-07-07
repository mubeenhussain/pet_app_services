import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/utils/validators.dart';
import 'package:pet_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:pet_app/shared/services/phone_auth_service.dart';
import 'package:pet_app/shared/widgets/app_button.dart';
import 'package:pet_app/shared/widgets/app_checkbox_tile.dart';
import 'package:pet_app/shared/widgets/app_select_field.dart';
import 'package:pet_app/shared/widgets/app_text_field.dart';
import 'package:pet_app/shared/widgets/auth_redirect_prompt.dart';
import 'package:pet_app/shared/widgets/auth_shell.dart';
import 'package:pet_app/shared/widgets/phone_field.dart';

/// Saudi cities offered in the optional city/address selector.
const _cities = [
  'Riyadh',
  'Jeddah',
  'Mecca',
  'Medina',
  'Dammam',
  'Khobar',
  'Tabuk',
  'Abha',
];

/// BRD 6.4 — Register Page (phone + password, then OTP verify)
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedCity;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToOtp(String phone) {
    final normalized = PhoneAuthService.normalizePhone(phone);
    context.push(
      '${RouteNames.otp}?phone=${Uri.encodeComponent(normalized)}&flow=register',
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      context.showAppSnackBar(context.l10n.mustAcceptTerms, isError: true);
      return;
    }

    final phone = _phoneController.text.trim();
    final controller = ref.read(authControllerProvider.notifier);

    await controller.sendRegisterOtp(phone);

    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    // OTP send failure (e.g. Firebase not configured yet) still advances the
    // flow so the UI can be exercised end-to-end during development.
    state.whenOrNull(
      error: (error, _) {
        context.showAppSnackBar(
          controller.mapError(error) ?? context.l10n.errorGeneric,
          isError: true,
        );
        _goToOtp(phone);
      },
      data: (_) => _goToOtp(phone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;

    return AuthShell(
      circleBack: true,
      alignTop: true,
      showBrand: false,
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _usernameController,
              label: l10n.usernameHint,
              hint: l10n.usernameExample,
              prefixIcon: const Icon(Icons.person_outline),
              textInputAction: TextInputAction.next,
              validator: Validators.username,
            ),
            const SizedBox(height: 18),
            PhoneField(
              controller: _phoneController,
              label: l10n.phoneHint,
              hint: l10n.phoneExample,
              validator: Validators.phone,
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _passwordController,
              label: l10n.passwordHint,
              hint: l10n.passwordMinHint,
              helperText: l10n.passwordHelper,
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 18),
            AppSelectField<String>(
              label: l10n.cityAddressLabel,
              optionalLabel: true,
              hint: l10n.selectCity,
              value: _selectedCity,
              items: _cities,
              itemLabel: (city) => city,
              onChanged: (city) => setState(() => _selectedCity = city),
            ),
            const SizedBox(height: 20),
            AppCheckboxTile(
              value: _acceptedTerms,
              onChanged: (v) => setState(() => _acceptedTerms = v),
              label: Text.rich(
                TextSpan(
                  text: '${l10n.agreeToTerms} ',
                  style: context.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: l10n.termsAndPrivacy,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.link,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: l10n.createAccount,
              isLoading: isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            AuthRedirectPrompt(
              prompt: l10n.alreadyHaveAccount,
              actionLabel: l10n.signIn,
              onAction: () => context.go(RouteNames.login),
            ),
          ],
        ),
      ),
    );
  }
}
