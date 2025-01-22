// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/ui/messages.dart';
import '../../../core/validators/validators.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../providers/app_auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordEC = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmPasswordEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Registrar',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(
            child: FittedBox(
              child: AppLogo(),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                AppField(
                  textInputAction: TextInputAction.next,
                  controller: _nameController,
                  label: 'Nome',
                  validator: Validatorless.required('Nome obrigatório'),
                ),
                const SizedBox(height: 20),
                AppField(
                  textInputAction: TextInputAction.next,
                  controller: _phoneController,
                  label: 'Telefone',
                  validator: Validatorless.required('Telefone obrigatório'),
                ),
                const SizedBox(height: 20),
                AppField(
                  textInputAction: TextInputAction.next,
                  controller: _cpfController,
                  label: 'CPF',
                  validator: Validatorless.multiple([
                    Validatorless.required('CPF obrigatório'),
                    Validatorless.cpf('CPF inválido'),
                  ]),
                ),
                const SizedBox(height: 20),
                AppField(
                  controller: _emailEC,
                  textInputAction: TextInputAction.next,
                  label: 'E-mail',
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                ),
                const SizedBox(height: 20),
                AppField(
                  controller: _passwordEC,
                  textInputAction: TextInputAction.next,
                  label: 'Senha',
                  validator: Validatorless.required('Senha obrigatória'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AppField(
                  controller: _confirmPasswordEC,
                  label: 'Confirme a senha',
                  obscureText: true,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(6, 'Senha muito curta'),
                    Validators.compare(_passwordEC, 'Senhas não coincidem'),
                  ]),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: !isLoading
                      ? ElevatedButton(
                          style: AppUiConfig.elevatedButtonThemeCustom,
                          onPressed: () => _register(context),
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                      : const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      final email = _emailEC.text;
      final password = _passwordEC.text;
      final name = _nameController.text;
      final phone = _phoneController.text;
      setState(() {
        isLoading = true;
      });
      try {
        await context.read<AppAuthProvider>().register(
            name: name,
            email: email,
            password: password,
            phone: phone,
            userType: UserType.newUser.toString(),
            cpf: _cpfController.text);
        Messages.of(context).showInfo('Usuário cadastrado com sucesso!');
        Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pushNamedAndRemoveUntil(
          Constants.kUSERLOGINROUTE,
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        String message;

        switch (e.code) {
          case 'email-already-in-use':
            message = 'O e-mail já está cadastrado.';
            break;
          case 'invalid-email':
            message = 'O e-mail fornecido não é válido.';
            break;
          case 'operation-not-allowed':
            message = 'Este tipo de conta está desativado.';
            break;
          case 'weak-password':
            message = 'A senha fornecida é muito fraca. ${e.message}!';
            break;
          default:
            message =
                'Não foi possível criar sua conta. Tente novamente mais tarde.';
        }

        Messages.of(context).showError(message);
      } catch (e) {
        Messages.of(context).showError('Erro inesperado');
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
