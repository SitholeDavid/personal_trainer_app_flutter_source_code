import 'package:flutter/material.dart';
import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/viewmodels/clients_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:stacked/stacked.dart';

class ClientsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            'Clients',
            style:
                largeTextFont.copyWith(fontSize: 20, color: primaryColorDark),
          ),
          leading: IconButton(
            onPressed: model.navigateBackToPrevView,
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColorDark,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.navigateToCreateClient,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: primaryColorDark,
        ),
        body: model.clients.length == 0
            ? Center(
                child: Text(
                  'No clients found',
                  style: mediumTextFont,
                ),
              )
            : ListView.builder(
                itemCount: model.clients.length,
                itemBuilder: (context, index) {
                  return clientTile(
                      model.clients[index], model.navigateToClientDetail);
                }),
      ),
      viewModelBuilder: () => ClientsViewModel(),
      onModelReady: (model) => model.getClients(),
    );
  }
}

Widget clientTile(Client client, Function onTapCallback) {
  return GestureDetector(
    onTap: () => onTapCallback(client),
    child: ListTile(
      title: Text(
        client.name,
        style: largeTextFont.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        client.lastSessionDate,
        style: mediumTextFont,
      ),
      trailing: Icon(Icons.arrow_forward_ios),
    ),
  );
}
