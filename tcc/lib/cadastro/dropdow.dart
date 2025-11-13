import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// Widget principal para selecionar a área de atuação
class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  // Valor selecionado no dropdown
  final dropValue = ValueNotifier('');
  
  // Opções disponíveis no dropdown
  final dropOpcoes = [
    "3",
    "2",
    "1",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Largura do dropdown
            child: DropdownSearch<String>(
              items: dropOpcoes, // Lista de opções
              selectedItem: value.isEmpty ? null : value, // Valor selecionado
              onChanged: (String? newValue) {
                dropValue.value = newValue ?? ''; // Atualiza o valor selecionado
              },
              popupProps: PopupProps.menu(
                showSearchBox: true, // Permite pesquisar opções
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
                  maxHeight: 250, // Altura máxima do popup
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
                      color: const Color.fromRGBO(121, 180, 217, 1), // Cor ao focar
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Cor padrão
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                // Exibe o texto do item selecionado ou o placeholder
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

