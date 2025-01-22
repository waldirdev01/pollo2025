import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/models/app_user.dart';

import '../../core/ui/messages.dart';
import '../../providers/app_auth_provider.dart';

class SelectUserProfilePage extends StatefulWidget {
  const SelectUserProfilePage({super.key});

  @override
  createState() => _SelectUserProfilePageState();
}

class _SelectUserProfilePageState extends State<SelectUserProfilePage> {
  late int timeLoading;
  Duration splashDuration = const Duration(seconds: 2);
  late Timer _timer;
  bool loading = true;
  AppUser? _appUser;
  @override
  void initState() {
    super.initState();
    _appUser = context.read<AppAuthProvider>().appUser;
    _timer = Timer(splashDuration, _navigate);
  }

  void _navigate() {
    if (_appUser != null) {
      if (_appUser != null) {
        switch (_appUser!.type) {
          case UserType.newUser:
            setState(() {
              loading = false;
            });
            break;
          case UserType.coordinator:
            Navigator.of(context).pushReplacementNamed(Constants.kHOMEROUTE);
            break;
          case UserType.monitor:
            Navigator.of(context).pushReplacementNamed(
                Constants.kUSERMONITORHOMEPAGEROUTE,
                arguments: _appUser);
            break;
          case UserType.admin:
            Navigator.of(context).pushReplacementNamed(Constants.kHOMEROUTE);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CadastroDireto()));
            break;
          case UserType.schoolMember:
            Navigator.of(context)
                .pushReplacementNamed(Constants.kSCHOOLMEMBERHOMEPAGEROUTE);
            break;
          case UserType.tcb:
            Navigator.of(context).pushReplacementNamed(Constants.kHOMEROUTE);
            break;
        }
      } else {
        Messages.of(context).showError('Erro ao carregar usuário');
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 200,
            child: Image.asset('assets/images/bus.png'),
          ),
          Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width / 12,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRANSPORTE ESCOLAR ${Constants.kCOMPANYNAME}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Divider(),
                  Text(
                    'CRE-PARANOÁ',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              )),
          Positioned(
            right: MediaQuery.of(context).size.width / 5,
            bottom: 60,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Seja bem-vindo(a)!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  loading
                      ? const Text(
                          'Aguarde a aprovação do seu cadastro.',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                  const Divider(),
                  TextButton(
                      onPressed: () {
                        context.read<AppAuthProvider>().logout();
                        Navigator.of(context)
                            .pushReplacementNamed(Constants.kUSERLOGINROUTE);
                      },
                      child: const Text(
                        'SAIR',
                        style: TextStyle(fontSize: 24),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
