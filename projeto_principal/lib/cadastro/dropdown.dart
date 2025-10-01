import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:projeto_principal/data/http/dio_client.dart' as apiHttp;
import 'package:projeto_principal/data/models/ramo.dart';
import 'package:projeto_principal/data/models/userForm.dart';
import 'package:projeto_principal/data/repositories/ramo_repository.dart';

class Area extends StatefulWidget {
  final Userform usuario;
  final void Function(RamoModel?) onRamoSelecionado;
  final String? erro;
  final VoidCallback onClearerror;
  Area({super.key,  required this.usuario, required this.onRamoSelecionado, required this.erro, required this.onClearerror});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  
  late final RamoRepository ramoRepository;
  RamoModel? ramoselecionado;

  @override
  void initState(){
    super.initState();
    ramoRepository = RamoRepository(client: apiHttp.DioClient.dio);
  }
  @override
  Widget build(BuildContext context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<RamoModel>(
              asyncItems: (String? filtro) => ramoRepository.getRamo(),
              itemAsString:(RamoModel? ramo) => ramo?.nome ?? "",
              onChanged: (RamoModel? ramo){
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
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Área de atuação",
                  hintText: "Escolha a área de atuação",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromRGBO(121, 180, 217, 1),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: widget.erro
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
