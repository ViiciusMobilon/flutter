import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/cadastro/cadastro1.dart';

class BarraDePesquisa extends SearchDelegate<String> {
  // Lista de dados (profissões disponíveis para busca)
  final List<String> dados = [
    "Pedreiro",
    "Pintor",
    "Eletricista",
    "Encanador",
    "Marceneiro",
    "Jardineiro",
    "Carpinteiro",
    "Soldador",
    "Técnico em Refrigeração",
    "Instalador de Ar Condicionado",
  ];

  // Metadados com informações adicionais de cada profissão
  final Map<String, Map<String, dynamic>> _meta = {
    "Pedreiro": {"likes": 120, "views": 2000, "rating": 4.2, "date": "2025-09-30"},
    "Pintor": {"likes": 45, "views": 800, "rating": 3.8, "date": "2025-10-03"},
    "Eletricista": {"likes": 230, "views": 5000, "rating": 4.7, "date": "2025-09-25"},
    "Encanador": {"likes": 60, "views": 1200, "rating": 4.0, "date": "2025-09-29"},
    "Marceneiro": {"likes": 15, "views": 400, "rating": 3.5, "date": "2025-08-10"},
    "Jardineiro": {"likes": 5, "views": 150, "rating": 3.0, "date": "2025-07-20"},
    "Carpinteiro": {"likes": 90, "views": 1300, "rating": 4.1, "date": "2025-10-01"},
    "Soldador": {"likes": 40, "views": 560, "rating": 3.9, "date": "2025-09-15"},
    "Técnico em Refrigeração": {"likes": 75, "views": 900, "rating": 4.3, "date": "2025-09-27"},
    "Instalador de Ar Condicionado": {"likes": 150, "views": 2200, "rating": 4.6, "date": "2025-09-20"},
  };

  // Mapa de segmentos (empresa ou prestador)
  final Map<String, String> segmentoMap = {
    "Pedreiro": "Empresa",
    "Marceneiro": "Prestador",
    "Carpinteiro": "Empresa",
    "Pintor": "Prestador",
    "Jardineiro": "Empresa",
    "Eletricista": "Prestador",
    "Encanador": "Empresa",
    "Soldador": "Prestador",
    "Técnico em Refrigeração": "Empresa",
    "Instalador de Ar Condicionado": "Prestador",
  };

  // -------------------- FILTROS --------------------

  // Filtro de tempo
  String? filtroTempo;
  DateTime? filtroDataInicio;
  DateTime? filtroDataFim;

  // Filtros de intervalo (curtidas e views)
  RangeValues filtroCurtidas = RangeValues(0, 1000);
  RangeValues filtroViews = RangeValues(0, 10000);

  // Filtros de categoria e avaliação
  Set<String> filtroSegmentosSelecionados = {};
  double filtroAvaliacaoMinima = 0.0;

  // Contador de filtros ativos
  int get _numeroFiltrosAtivos {
    int count = 0;
    if (filtroTempo != null) count++;
    if (filtroCurtidas.start > 0 || filtroCurtidas.end < 1000) count++;
    if (filtroViews.start > 0 || filtroViews.end < 10000) count++;
    if (filtroSegmentosSelecionados.isNotEmpty) count++;
    if (filtroAvaliacaoMinima > 0.0) count++;
    return count;
  }

  // Placeholder do campo de pesquisa
  @override
  String get searchFieldLabel => "Buscar profissionais...";

  // Tema visual da barra de pesquisa
  @override
ThemeData appBarTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
      backgroundColor: Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white70),
    ),
  );
}

  // -------------------- BOTÃO DE FILTROS --------------------
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Stack(
        alignment: Alignment.topRight,
        children: [
          // Ícone de filtro
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () => _abrirPainelFiltros(context),
          ),
          // Indicador de filtros ativos
          if (_numeroFiltrosAtivos > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_numeroFiltrosAtivos',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    ];
  }

  // -------------------- PAINEL DE FILTROS --------------------
  void _abrirPainelFiltros(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            // Função para limpar todos os filtros
            void limparTudo() {
              setStateModal(() {
                filtroTempo = null;
                filtroDataInicio = null;
                filtroDataFim = null;
                filtroCurtidas = RangeValues(0, 1000);
                filtroViews = RangeValues(0, 10000);
                filtroSegmentosSelecionados.clear();
                filtroAvaliacaoMinima = 0.0;
              });
            }

            // Função para aplicar os filtros
            void aplicar() {
              Navigator.pop(context);
              showResults(context);
            }

            // Lista de segmentos únicos
            final segmentosDisponiveis = segmentoMap.values.toSet().toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 12,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtros',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: limparTudo,
                          child: Text('Limpar'),
                        ),
                      ],
                    ),
                    Divider(),

                    // Filtro por período de publicação
                    Text('Período de publicação', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),

                    // Opções padrão de tempo
                    RadioListTile<String?>(
                      title: Text('Últimas 24 horas'),
                      value: '24h',
                      groupValue: filtroTempo,
                      onChanged: (v) => setStateModal(() {
                        filtroTempo = v;
                        filtroDataInicio = filtroDataFim = null;
                      }),
                    ),
                    RadioListTile<String?>(
                      title: Text('Últimos 7 dias'),
                      value: '7d',
                      groupValue: filtroTempo,
                      onChanged: (v) => setStateModal(() {
                        filtroTempo = v;
                        filtroDataInicio = filtroDataFim = null;
                      }),
                    ),
                    RadioListTile<String?>(
                      title: Text('Últimos 30 dias'),
                      value: '30d',
                      groupValue: filtroTempo,
                      onChanged: (v) => setStateModal(() {
                        filtroTempo = v;
                        filtroDataInicio = filtroDataFim = null;
                      }),
                    ),
                    RadioListTile<String?>(
                      title: Text('Intervalo personalizado'),
                      value: 'personalizado',
                      groupValue: filtroTempo,
                      onChanged: (v) => setStateModal(() => filtroTempo = v),
                    ),

                    // Campos de data se "personalizado" estiver ativo
                    if (filtroTempo == 'personalizado')
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            // Data inicial
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: filtroDataInicio ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setStateModal(() => filtroDataInicio = picked);
                                  }
                                },
                                child: Text(
                                  filtroDataInicio == null
                                      ? "Data inicial"
                                      : DateFormat('dd/MM/yyyy').format(filtroDataInicio!),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Data final
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: filtroDataFim ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setStateModal(() => filtroDataFim = picked);
                                  }
                                },
                                child: Text(
                                  filtroDataFim == null
                                      ? "Data final"
                                      : DateFormat('dd/MM/yyyy').format(filtroDataFim!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 10),
                    Divider(),

                    // Filtro por curtidas
                    Text('Curtidas (intervalo)', style: TextStyle(fontWeight: FontWeight.w600)),
                    RangeSlider(
                      values: filtroCurtidas,
                      min: 0,
                      max: 1000,
                      divisions: 1000,
                      labels: RangeLabels(
                        filtroCurtidas.start.round().toString(),
                        filtroCurtidas.end.round().toString(),
                      ),
                      onChanged: (v) => setStateModal(() => filtroCurtidas = v),
                    ),

                    Divider(),

                    // Filtro por visualizações
                    Text('Visualizações (intervalo)', style: TextStyle(fontWeight: FontWeight.w600)),
                    RangeSlider(
                      values: filtroViews,
                      min: 0,
                      max: 10000,
                      divisions: 10000,
                      labels: RangeLabels(
                        filtroViews.start.round().toString(),
                        filtroViews.end.round().toString(),
                      ),
                      onChanged: (v) => setStateModal(() => filtroViews = v),
                    ),

                    Divider(),

                    // Filtro por segmento
                    Text('Segmento', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: segmentosDisponiveis.map((seg) {
                        final selected = filtroSegmentosSelecionados.contains(seg);
                        return FilterChip(
                          label: Text(seg),
                          selected: selected,
                          onSelected: (sel) => setStateModal(() =>
                              sel ? filtroSegmentosSelecionados.add(seg) : filtroSegmentosSelecionados.remove(seg)),
                        );
                      }).toList(),
                    ),

                    Divider(),

                    // Filtro de avaliação mínima
                    Text('Avaliação mínima', style: TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: filtroAvaliacaoMinima,
                      min: 0,
                      max: 5,
                      divisions: 100,
                      label: filtroAvaliacaoMinima.toStringAsFixed(1),
                      onChanged: (v) => setStateModal(() => filtroAvaliacaoMinima = v),
                    ),

                    SizedBox(height: 16),

                    // Botão aplicar filtros
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: aplicar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Aplicar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // -------------------- RESULTADOS DA PESQUISA --------------------
  @override
  Widget buildResults(BuildContext context) {
    // Filtra os dados conforme o texto digitado
    final resultados = dados.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    // Caso nenhum resultado seja encontrado
    if (resultados.isEmpty) {
      return Center(
        child: Text("Nenhum profissional encontrado", style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    // Exibe os resultados encontrados
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final item = resultados[index];
        final meta = _meta[item]!;

        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PerfilDeOutroUsuario())),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF5E35B1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item[0].toUpperCase(),
                        style: TextStyle(color: Color.fromARGB(255, 211, 0, 0), fontSize: MediaQuery.of(context).size.height*0.0035, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),

                  // Informações do resultado
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome e categoria
                        Row(
                          children: [
                            Text(
                            
                              item,
                              style:  TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16)),

                          ],
                        ),
                        Text(
                          segmentoMap[item] ?? "Serviço",
                          style:  TextStyle(
                            color: Colors.indigo,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Estatísticas do profissional
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                            Text(" ${meta['rating']}  "),
                            Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 17),
                            Text(" ${meta['likes']}  "),
                            Icon(Icons.remove_red_eye_rounded, color: Colors.indigoAccent, size: 17),
                            Text(" ${meta['views']}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------- BOTÃO VOLTAR --------------------
  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => close(context, ""),
      );

  // -------------------- SUGESTÕES DE PESQUISA --------------------
  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugestões automáticas com base no texto
    final sugestoes = query.isEmpty
        ? dados.take(5).toList()
        : dados.where((item) => item.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final sugestao = sugestoes[index];
        return ListTile(
          leading: Icon(Icons.search, color: Colors.grey),
          title: Text(sugestao),
          onTap: () {
            query = sugestao;
            showResults(context);
          },
        );
      },
    );
  }
}
