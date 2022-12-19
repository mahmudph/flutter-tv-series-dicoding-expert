import 'package:equatable/equatable.dart';

class CreateTableContract extends Equatable {
  final String tableName;
  final String tableQuery;

  const CreateTableContract({
    required this.tableName,
    required this.tableQuery,
  });

  @override
  List<Object?> get props => [
        tableName,
        tableQuery,
      ];
}
