import 'package:flutter/material.dart';

import '../module.dart';

abstract class IBaseListTemplate {
  bool hasTemplate(String templateName);

  Widget getTemplate(String template, dynamic item, ValueChanged<dynamic> onSearchResult);

  Widget getTableWidget(dynamic columns, dynamic rows,
      {bool showHeaders = true,
        bool useHeaderForValue = true,
        ValueChanged<dynamic> onSearchResult}) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: gizContext.width - 16),
          child: DataTable(
              showCheckboxColumn: false,
              columns: DataColumns(columns,
                  showHeaders: showHeaders,
                  useHeaderForValue: useHeaderForValue),
              headingRowHeight: showHeaders ? 45 : 0,
              rows: rows
                  .map<DataRow>(
                      (item) => DataRows(item, onSearchResult))
                  .toList()),
        ),
      );

   List<DataColumn> DataColumns(Map<String, dynamic> item,
      {bool showHeaders = true, bool useHeaderForValue = true}) {
    return item.entries
        .where((element) =>
    !element.key.startsWith("_") &&
        element.key.toLowerCase() != "perform")
        .map<DataColumn>((x) => DataColumn(
        label: !showHeaders
            ? Container()
            : Text(
            useHeaderForValue ? x.value.toString() : x.key.toString())))
        .toList();
  }

   DataRow DataRows(
      Map<String, dynamic> item, ValueChanged<dynamic> onSearchResult) {
    return DataRow(
        onSelectChanged: (value) {
          if (onSearchResult == null)
            perForm(item["Perform"]);
          else
            onSearchResult(item);
        },
        cells: item.entries
            .where((element) =>
        !element.key.startsWith("_") &&
            element.key.toLowerCase() != "perform")
            .map<DataCell>(
              (x) => DataCell(
            Text(x.value.toString() == "null" ? "" : x.value.toString()),
          ),
        )
            .toList());
  }
}
