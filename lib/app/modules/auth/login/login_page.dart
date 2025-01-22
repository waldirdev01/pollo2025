// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/constants/constants.dart';
import '../../../core/ui/ap_ui_config.dart';
import '../../../core/ui/messages.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/app_auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();
  bool isLoading = false;

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Constants.kCOMPANYNAME,
      ),
      body: LayoutBuilder(
        builder: ((context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.minWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const AppLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            AppField(
                              label: 'E-mail',
                              controller: _emailEC,
                              focusNode: _emailFocus,
                              validator: Validatorless.multiple([
                                Validatorless.required('Email obrigatório'),
                                Validatorless.email('E-mail inválido'),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            AppField(
                              label: 'Senha',
                              obscureText: true,
                              controller: _passwordEC,
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatória'),
                                Validatorless.min(6,
                                    'Senha deve conter pelo menos 6 caracteres'),
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => _resetPassword(context),
                                  child: Text(
                                    'Esqueceu sua senha?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppUiConfig
                                            .themeCustom.primaryColor),
                                  ),
                                ),
                                isLoading
                                    ? const SizedBox()
                                    : ElevatedButton(
                                        onPressed: () => _login(
                                            context.read<AppAuthProvider>()),
                                        style: AppUiConfig
                                            .elevatedButtonThemeCustom,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Login',
                                            style: AppUiConfig.buttonText,
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF0F3F7),
                                border: Border(
                                  top: BorderSide(
                                    width: 2,
                                    color: Colors.grey.withAlpha(50),
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('Não tem conta',
                                          style: TextStyle(fontSize: 18)),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              Constants.kUSERREGISTERROUTE);
                                        },
                                        child: Text(
                                          'Cadastre-se',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppUiConfig
                                                  .themeCustom.primaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _login(AppAuthProvider provider) async {
    if (!(_formkey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    final email = _emailEC.text.trim();
    final password = _passwordEC.text.trim();

    try {
      await provider.login(email: email, password: password);
      if (provider.appUser != null) {
        Navigator.of(context)
            .pushReplacementNamed(Constants.kSELECTUSERPROFILEROUTE);
      }
    } on FirebaseAuthException {
      Messages.of(context).showError('E-mail ou senha inválidos');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _resetPassword(BuildContext context) async {
    if (_emailEC.text.isEmpty) {
      _emailFocus.requestFocus();
      Messages.of(context)
          .showError('Digite um e-mail para recuperar sua senha');
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailEC.text.trim());
      Messages.of(context)
          .showInfo('Um e-mail de recuperação de senha foi enviado');
    } on FirebaseAuthException catch (e) {
      Messages.of(context)
          .showError('Erro ao enviar e-mail de recuperação: ${e.message}');
    }
  }
}
