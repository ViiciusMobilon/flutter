import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:projeto_principal/data/models/cep.dart';
import 'package:projeto_principal/data/http/http_client.dart' as apiHttp;
import 'package:projeto_principal/data/models/cidade.dart';
import 'package:projeto_principal/data/models/estado.dart';
import 'package:projeto_principal/data/models/ramo.dart';
import 'package:projeto_principal/data/repositories/cidade_repository.dart';
import 'package:projeto_principal/data/repositories/estado_repository.dart';
import 'package:projeto_principal/data/repositories/ramo_repository.dart';




class estado extends StatefulWidget {
   final TextEditingController controller;
   final void Function(CepModel) onCepBuscado;
   estado({super.key, required this.controller, required this.onCepBuscado});

   final EstadoDropdownState state = EstadoDropdownState(); 
   void setEstadoViaCep(String sigla) {
    state.setEstadoSelecionado(sigla);
  }

  @override
  State<estado> createState() => EstadoDropdownState();
}

class EstadoDropdownState extends State<estado> {
  EstadoModel? estadoSelecionado;
  late final EstadoRepository estadoRepository;
  List<EstadoModel> estados = [];
  @override
  void initState() {
    super.initState();
    estadoRepository = EstadoRepository(client: apiHttp.HttpClient());
    carregarEstados();
  }
   Future<void> carregarEstados() async {
    final lista = await estadoRepository.getestado();
    setState(() {
      estados = lista;
      // Se já tiver algo no controller (ex: ViaCEP), seleciona
      final sigla = widget.controller.text;
      if (sigla.isNotEmpty) {
        estadoSelecionado = estados.firstWhere(
          (e) => e.sigla == sigla,
          orElse: () => estados.first,
        );
      }
    });
  }

  void setEstadoSelecionado(String sigla) async {
  final estados = await estadoRepository.getestado();

  final encontrado = estados.firstWhere(
    (e) => e.sigla == sigla,
    orElse: () => estados.first,
  );
  setState(() {
      estadoSelecionado = encontrado;
      widget.controller.text = encontrado.sigla;
    });
}
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
           height:MediaQuery.of(context).size.height * 0.07,
          child: DropdownSearch<EstadoModel>(
            asyncItems:(String? filtro) => estadoRepository.getestado(),
            itemAsString: (EstadoModel estado) => estado.sigla,
            selectedItem: estadoSelecionado,
            onChanged: (estado) {
              setState(() => estadoSelecionado = estado);
              widget.controller.text = estado?.sigla ?? '';
            },
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  labelText: "Pesquisar estado...",
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
                labelText: "Estado ",
                hintText: "Estado",
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
              ),
            ),
            dropdownBuilder: (context, EstadoModel? selectedItem) {
              return Text(
                selectedItem?.sigla ?? "Estado",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontFamily: "Poppins",
                ),
              );
            },
          ),
        );
      }

  }


class cidade extends StatefulWidget {
  final TextEditingController controller;
  final void Function(CepModel) onCepBuscado;
  const cidade({super.key, required this.controller, required this.onCepBuscado});

  @override
  State<cidade> createState() => _cidadeState();
}

class _cidadeState extends State<cidade> {
  late final CidadeRepository cidadeRepository;

  @override
  void initState(){
    super.initState();
    cidadeRepository = CidadeRepository(client: apiHttp.HttpClient());
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height:MediaQuery.of(context).size.height * 0.07,
            child: DropdownSearch<CidadeModel>(
              asyncItems: (String? filtro) => cidadeRepository.getcidade(),
              itemAsString: (CidadeModel cidade) => cidade.nome,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    labelText: "Pesquisar cidade...",
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
                  labelText: "Cidade ",
                  hintText: "Cidade",
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
                ),
              ),
              dropdownBuilder: (context, CidadeModel? selectedItem) {
                return Text(
                  selectedItem?.nome ?? "Cidade",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontFamily: "Poppins",
                  ),
                );
              },
            ),
          );
        }
  }



class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  
  late final RamoRepository ramoRepository;

  @override
  void initState(){
    super.initState();
    ramoRepository = RamoRepository(client: apiHttp.HttpClient());
  }
  @override
  Widget build(BuildContext context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<RamoModel>(
              asyncItems: (String? filtro) => ramoRepository.getRamo(),
              itemAsString:(RamoModel ramo) => ramo.nome,
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
