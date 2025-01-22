import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/activities/e_c_details_page.dart';
import 'package:pollo2025/app/providers/e_c_activity_provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/ui/ap_ui_config.dart';
import '../../../models/extracurricular_activity.dart';

class ECList extends StatefulWidget {
  const ECList({super.key});

  @override
  State<ECList> createState() => _ECListState();
}

class _ECListState extends State<ECList> {
  @override
  Widget build(BuildContext context) {
    final ecProvider = Provider.of<ECActivityProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Atividades Extracurriculares'),
          iconTheme: AppUiConfig.iconThemeCustom(),
        ),
        body: FutureBuilder<List<ExtracurricularActivity>>(
          future: ecProvider.getECActivities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro: ${snapshot.error}'),
                );
              } else {
                final ecActivities = snapshot.data!;
                ecActivities
                    .sort((a, b) => a.dateOfEvent.compareTo(b.dateOfEvent));

                if (ecActivities.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma atividade extracurricular cadastrada'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      itemCount: ecActivities.length,
                      itemBuilder: (context, index) {
                        final ecActivity = ecActivities[index];
                        return Consumer<ECActivityProvider>(builder:
                            (context, ECActivityProvider ecProvider, child) {
                          return InkWell(
                              child: Card(
                                color: ecActivity.isDone
                                    ? Colors.green[100]
                                    : Colors.red[100],
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        title: Text(ecActivity.title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                            'Data: ${DateFormat('dd/MM/yyyy').format(ecActivity.dateOfEvent)}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              Constants
                                                  .kEXTRACURRICULAREDITROUTE,
                                              arguments: ecActivity);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    Checkbox(
                                      value: ecActivity.isDone,
                                      onChanged: (value) {
                                        ecActivity.isDone = value!;
                                        ecProvider.isDoneECActivity(ecActivity);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ECDetailsPage(
                                          ecActivity: ecActivity))));
                        });
                      },
                    ),
                  );
                }
              }
            }
          },
        ));
  }
}
