import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';



class estado extends StatefulWidget {
   
   estado({super.key});

  @override
  State<estado> createState() => _estadoState();
}

class _estadoState extends State<estado> {
  final dropValue = ValueNotifier('');
  final dropOpcoes = [
    "3",
    "2",
    "1",
  ];
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
             height:MediaQuery.of(context).size.height * 0.07,
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
        },
      ),
    );
  }
}

class cidade extends StatefulWidget {
  const cidade({super.key});

  @override
  State<cidade> createState() => _cidadeState();
}

class _cidadeState extends State<cidade> {
    final dropValue = ValueNotifier('');
  final dropOpcoes = [
    "3",
    "2",
    "1",
  ];
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height:MediaQuery.of(context).size.height * 0.07,
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
   final dropValue = ValueNotifier('');
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