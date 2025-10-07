import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_principal/cadastro/cadastro1.dart';

class BarraDePesquisa extends SearchDelegate<String> {
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

  // -------------------- ESTADO DOS FILTROS --------------------
  String? filtroTempo; // "24h", "7d", "30d", ou "personalizado"
  DateTime? filtroDataInicio;
  DateTime? filtroDataFim;

  RangeValues filtroCurtidas = const RangeValues(0, 1000);
  RangeValues filtroViews = const RangeValues(0, 10000);
  Set<String> filtroSegmentosSelecionados = {};
  double filtroAvaliacaoMinima = 0.0;

  int get _numeroFiltrosAtivos {
    int count = 0;
    if (filtroTempo != null) count++;
    if (filtroCurtidas.start > 0 || filtroCurtidas.end < 1000) count++;
    if (filtroViews.start > 0 || filtroViews.end < 10000) count++;
    if (filtroSegmentosSelecionados.isNotEmpty) count++;
    if (filtroAvaliacaoMinima > 0.0) count++;
    return count;
  }

  @override
  String get searchFieldLabel => "Buscar profissionais...";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
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
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () => _abrirPainelFiltros(context),
          ),
          if (_numeroFiltrosAtivos > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_numeroFiltrosAtivos',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateModal) {
          void limparTudo() {
            setStateModal(() {
              filtroTempo = null;
              filtroDataInicio = null;
              filtroDataFim = null;
              filtroCurtidas = const RangeValues(0, 1000);
              filtroViews = const RangeValues(0, 10000);
              filtroSegmentosSelecionados.clear();
              filtroAvaliacaoMinima = 0.0;
            });
          }

          void aplicar() {
            Navigator.pop(context);
            showResults(context);
          }

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
                      const Text('Filtros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: limparTudo, child: const Text('Limpar')),
                    ],
                  ),
                  const Divider(),

                  // -------- TEMPO --------
                  const Text('Período de publicação', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),

                  // Radios padrão
                  RadioListTile<String?>(
                    title: const Text('Últimas 24 horas'),
                    value: '24h',
                    groupValue: filtroTempo,
                    onChanged: (v) => setStateModal(() {
                      filtroTempo = v;
                      filtroDataInicio = filtroDataFim = null;
                    }),
                  ),
                  RadioListTile<String?>(
                    title: const Text('Últimos 7 dias'),
                    value: '7d',
                    groupValue: filtroTempo,
                    onChanged: (v) => setStateModal(() {
                      filtroTempo = v;
                      filtroDataInicio = filtroDataFim = null;
                    }),
                  ),
                  RadioListTile<String?>(
                    title: const Text('Últimos 30 dias'),
                    value: '30d',
                    groupValue: filtroTempo,
                    onChanged: (v) => setStateModal(() {
                      filtroTempo = v;
                      filtroDataInicio = filtroDataFim = null;
                    }),
                  ),

                  // Filtro personalizado
                  RadioListTile<String?>(
                    title: const Text('Intervalo personalizado'),
                    value: 'personalizado',
                    groupValue: filtroTempo,
                    onChanged: (v) => setStateModal(() => filtroTempo = v),
                  ),
                  if (filtroTempo == 'personalizado')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
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
                              child: Text(filtroDataInicio == null
                                  ? "Data inicial"
                                  : DateFormat('dd/MM/yyyy').format(filtroDataInicio!)),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                              child: Text(filtroDataFim == null
                                  ? "Data final"
                                  : DateFormat('dd/MM/yyyy').format(filtroDataFim!)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),
                  const Divider(),

                  // -------- Curtidas --------
                  const Text('Curtidas (intervalo)', style: TextStyle(fontWeight: FontWeight.w600)),
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

                  const Divider(),

                  // -------- Views --------
                  const Text('Visualizações (intervalo)', style: TextStyle(fontWeight: FontWeight.w600)),
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

                  const Divider(),

                  // -------- Segmentos --------
                  const Text('Segmento', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: segmentosDisponiveis.map((seg) {
                      final selected = filtroSegmentosSelecionados.contains(seg);
                      return FilterChip(
                        label: Text(seg),
                        selected: selected,
                        onSelected: (sel) => setStateModal(
                          () => sel
                              ? filtroSegmentosSelecionados.add(seg)
                              : filtroSegmentosSelecionados.remove(seg),
                        ),
                      );
                    }).toList(),
                  ),

                  const Divider(),

                  // -------- Avaliação mínima --------
                  const Text('Avaliação mínima', style: TextStyle(fontWeight: FontWeight.w600)),
                  Slider(
                    value: filtroAvaliacaoMinima,
                    min: 0,
                    max: 5,
                    divisions: 100,
                    label: filtroAvaliacaoMinima.toStringAsFixed(1),
                    onChanged: (v) => setStateModal(() => filtroAvaliacaoMinima = v),
                  ),

                  const SizedBox(height: 16),

                  // -------- Ações --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: aplicar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Aplicar', style: TextStyle(color: Colors.white),)
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // -------------------- RESULTADOS --------------------
  @override
  Widget buildResults(BuildContext context) {
    final resultados = dados.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Text("Nenhum profissional encontrado", style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final item = resultados[index];
        final meta = _meta[item]!;

        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Cadastro())),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
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
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome e área
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A202C)),
                            ),
                            Text(
                              segmentoMap[item] ?? "Serviço",
                              style: const TextStyle(color: Colors.indigo, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                            Text(" ${meta['rating']}  "),
                            const Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 17),
                            Text(" ${meta['likes']}  "),
                            const Icon(Icons.remove_red_eye_rounded, color: Colors.indigoAccent, size: 17),
                            Text(" ${meta['views']}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => close(context, ""));

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugestoes = query.isEmpty
        ? dados.take(5).toList()
        : dados.where((item) => item.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final sugestao = sugestoes[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
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
