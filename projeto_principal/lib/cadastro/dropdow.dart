import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:projeto_principal/data/models/cep.dart';



class estado extends StatefulWidget {
   final TextEditingController controller;
   final void Function(CepModel) onCepBuscado;
   estado({super.key, required this.controller, required this.onCepBuscado});

  @override
  State<estado> createState() => _estadoState();
}

class _estadoState extends State<estado> {
  final dropOpcoes = [
    "SP",
    "RJ",
    "BA",
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
           height:MediaQuery.of(context).size.height * 0.07,
          child: DropdownSearch<String>(
            items: dropOpcoes,
            selectedItem: widget.controller.text.isEmpty ? null : widget.controller.text,
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
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem ?? "Estado",
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
  final dropOpcoes = [
    "Jaú",
    "Bauru",
    "Bariri",
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height:MediaQuery.of(context).size.height * 0.07,
            child: DropdownSearch<String>(
              items: dropOpcoes,
              selectedItem: widget.controller.text.isEmpty ? null : widget.controller.text,
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
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "Cidade",
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

   @override
  void initState() {
    super.initState();
    carregarRamos();
 }
 void carregarRamos() async {
    try{
      String url = 'http://192.168.1.5:8000/api/ramo';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          ramo = List<String>.from(json.decode(response.body).map((item) => item['nome'].toString()));
        });
      } else {
        
      }
    }catch (e) {
      print('Erro ao carregar ramos: $e');
    }
  }
}

class _AreaState extends State<Area> {
   List<String> ramo = [];
   ValueNotifier<String> dropValue = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: ramo,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<String>(
              items: dropOpcoes,
              selectedItem: value.isEmpty ? null : value,
              onChanged: (String? newValue) {
                dropValue.value = newValue ?? '';
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
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "Escolha a área de atuação",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontFamily: "Poppins",
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}