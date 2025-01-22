import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/providers/app_user_provider.dart';
import 'package:pollo2025/app/providers/e_c_activity_provider.dart';

import '../../../core/ui/ap_ui_config.dart';
import '../../../models/extracurricular_activity.dart';

class MonitorForECList extends StatefulWidget {
  const MonitorForECList({super.key});

  @override
  State<MonitorForECList> createState() => _MonitorForECListState();
}

class _MonitorForECListState extends State<MonitorForECList> {
  List<AppUser> monitorList = [];
  List<AppUser> filteredMonitors = [];
  Map<String, bool> selectedMonitors = {};

  @override
  Widget build(BuildContext context) {
    final ecActivity =
        ModalRoute.of(context)!.settings.arguments as ExtracurricularActivity;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Selecionar monitoras para evento',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<AppUser>>(
                  initialData: const [],
                  future: context.read<AppUserProvider>().getAppUsers(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Text('Nenhum estado de conexão.');
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Erro: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('Nenhum dado disponível.');
                        } else {
                          final appUsers = snapshot.data!;
                          monitorList = appUsers
                              .where((user) =>
                                  user.type.toString() ==
                                  UserType.monitor.toString())
                              .toList();
                          monitorList.sort((a, b) => a.name.compareTo(b.name));
                          for (var monitorId in ecActivity.monitorsId) {
                            selectedMonitors.putIfAbsent(monitorId, () => true);
                          }

                          for (var monitor in monitorList) {
                            selectedMonitors.putIfAbsent(
                                monitor.id, () => false);
                          }
                          return ListView.builder(
                            itemCount: monitorList.length,
                            itemBuilder: (context, index) {
                              final monitorSel = monitorList[index];
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    color: AppUiConfig.themeCustom.primaryColor,
                                    child: ListTile(
                                      title: Text(monitorSel.name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      trailing: Checkbox(
                                        value: selectedMonitors[monitorSel.id],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            selectedMonitors[monitorSel.id] =
                                                value!;
                                            // Atualiza a lista de estudantes filtrados com base na seleção
                                            if (value) {
                                              filteredMonitors.add(monitorSel);
                                            } else {
                                              filteredMonitors.removeWhere(
                                                  (s) => s.id == monitorSel.id);
                                              ecActivity.monitorsId.removeWhere(
                                                  (s) => s == monitorSel.id);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ));
                            },
                          );
                        }
                    }
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppUiConfig.themeCustom.primaryColor,
        onPressed: () {
          // Processa apenas os estudantes selecionados
          for (var monitor in filteredMonitors) {
            ecActivity.monitorsId.add(monitor.id);
          }
          context.read<ECActivityProvider>().updateECActivity(ecActivity);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}
