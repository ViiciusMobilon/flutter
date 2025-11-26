import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tcc/data/http/dio_client.dart' as apiHttp;
import 'package:tcc/data/models/ramo.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:tcc/data/repositories/ramo_repository.dart';

class Area extends StatefulWidget {
  final Userform? usuario;
  final void Function(RamoModel?) onRamoSelecionado;
  final String? erro;
  final VoidCallback onClearerror;

  // 🔥 Novo parâmetro para EDIÇÃO
  final RamoModel? ramoInicial;

  Area({
    super.key,
    this.usuario,
    required this.onRamoSelecionado,
    required this.erro,
    required this.onClearerror,
    this.ramoInicial, // 👈 adicionado
  });

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  late final RamoRepository ramoRepository;
  RamoModel? ramoselecionado;

  @override
  void initState() {
    super.initState();
    ramoRepository = RamoRepository(client: apiHttp.DioClient.dio);

    // 🔥 Se veio do EDITAR, já deixa carregado o ramo atual do usuário
    ramoselecionado = widget.ramoInicial;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DropdownSearch<RamoModel>(
          selectedItem: widget.ramoInicial,      // 👈 IMPORTANTÍSSIMO
          compareFn: (a, b) => a.id == b.id, 

          items: (String filter, infiniteScrollProps) async {
            final ramos = await ramoRepository.getRamo();

            if (filter.isNotEmpty) {
              return ramos
                  .where((ramo) =>
                      ramo.nome.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            }

            return ramos;
          },

          itemAsString: (RamoModel ramo) => ramo.nome,

          onChanged: (RamoModel? ramo) {
            setState(() {
              ramoselecionado = ramo;
            });
            widget.onRamoSelecionado(ramo);
            widget.onClearerror();
          },

          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: "Pesquisar área...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            fit: FlexFit.loose,
            constraints: BoxConstraints(
              maxHeight: 250,
            ),
          ),

          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: "Área de atuação",
              hintText: "Escolha a área de atuação",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorText: widget.erro,
            ),
          ),

          dropdownBuilder: (context, RamoModel? selectedItem) {
            return Text(
              selectedItem?.nome ?? "Escolha a área de atuação",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontFamily: "Poppins",
              ),
            );
          },
        ),
      );
}
