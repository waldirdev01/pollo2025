import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/models/app_user.dart';
import '../../../core/constants/constants.dart';
import '../../../models/school.dart';
import '../../../providers/school_provider.dart';

class SchoolCardList extends StatelessWidget {
  const SchoolCardList({
    super.key,
    required this.school,
    required this.schoolProvider,
    required this.currentUserType,
  });

  final School school;
  final SchoolProvider schoolProvider;
  final String currentUserType;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        Constants.kSCHOOLDETAILSROUTE,
        arguments: school,
      ),
      child: Card(
        color: AppUiConfig.themeCustom.primaryColor,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 4,
        shadowColor: Colors.white,
        child: ListTile(
          title: Text(school.name, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(school.phone, style: const TextStyle(color: Colors.white)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: currentUserType != UserType.admin.string
                ? []
                : [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          Constants.kSCHOOLEDITROUTE,
                          arguments: school,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteSchool(context),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteSchool(BuildContext context) async {
    // Verifique se o itinerário tem alunos ou escolas associadas antes de tentar excluir
    if ((school.studentsId != null && school.studentsId!.isNotEmpty) ||
        (school.itinerariesId != null && school.itinerariesId!.isNotEmpty)) {
      // Mostre um diálogo de erro em vez de lançar uma exceção
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text(
              'A escola nao pode ser excluída pois há alunos ou itinerários vinculdados.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return; // Pare a execução se existirem escolas ou alunos vinculados
    }

    try {
      await context.read<SchoolProvider>().deleteSchool(school.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Escola ${school.name} excluída com sucesso!'),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
              ),
            ],
          ),
        );
      }
    }
  }
}
