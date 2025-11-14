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
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<String>(
              items: (filter, _) => dropOpcoes,
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
                constraints: const BoxConstraints(maxHeight: 250),
              ),

              /// ✔ CORREÇÃO AQUI → usar decoratorProps
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Área de atuação",
                  hintText: "Escolha a área de atuação",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(121, 180, 217, 1),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
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
