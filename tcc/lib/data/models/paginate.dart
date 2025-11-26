class PaginationResult<T> {

  final List<T> data;
  final int currentPage;
  final int lastPage;

  PaginationResult({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

}

