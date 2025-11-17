import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// Widget principal para selecionar a área de atuação
class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  final ValueNotifier<String> dropValue = ValueNotifier('');
  final List<String> dropOpcoes = ['Tecnologia', 'Saúde', 'Educação'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: dropValue,
      builder: (context, value, _) {
        return DropdownSearch<String>(
          items: (filter, infiniteScrollProps) => dropOpcoes,
          selectedItem: value.isEmpty ? null : value,
          onChanged: (newValue) {
            dropValue.value = newValue ?? '';
          },

          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 250),
            menuProps: MenuProps(
              backgroundColor: Colors.white, // fundo branco no menu
            ),

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Pesquisar área...',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: Colors.white, // fundo branco no campo de busca
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(121, 180, 217, 1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Área de atuação',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              hintText: 'Escolha a área de atuação',

              filled: true,
              fillColor: Colors.white, // fundo branco no dropdown

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
        );
      },
    );
  }
}