import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:giz_module/module.dart';

import 'Fragment.dart';
import 'IBaseListTemplate.dart';

class BaseListFragment extends Fragment {
  int menuID;
  bool isChildWidget;
  Color ListBackgroundColor;
  ValueChanged<dynamic> onSearchResult;

  @override
  String get fragmentKey => menuID.toString();

  ValueGetter<dynamic> onDataLoad;
  IBaseListTemplate baseListTemplate;

  BaseListFragment(this.menuID, String title,
      {this.ListBackgroundColor = Colors.white, this.isChildWidget = true, this.onSearchResult, this.onDataLoad, this.baseListTemplate}) {
    this.title = title;
  }

  dynamic data;
  dynamic floating_butons;
  final GlobalKey<ScaffoldState> pageKey = new GlobalKey<ScaffoldState>();

  Widget get appbar => AppBar(
        title: GizText(title),
        actions: [
          if (data["Filters"]?.length > 0)
            IconButton(
                onPressed: () {
                  pageKey.currentState.openEndDrawer();
                },
                icon: Icon(Icons.filter_alt))
        ],
      );

  Widget get FilterPanel => Container(
        decoration: BoxDecoration(color: activeTheme.primaryColor),
        height: MediaQuery.of(buildContext).size.height,
        width: MediaQuery.of(buildContext).size.width * 0.8,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  "Temizle",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
                child: Container(
                    color: Colors.white,
                    child: ListView(
                      children: data["Filters"].where((f) => f["Visible"] && !f["Standart"]).map<Widget>((filter) {
                        return getFilterView(filter);
                      }).toList(),
                    ))),
            Container(
              child: FlatButton(
                child: Text(
                  "Filtreyi Uygula",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );

  void dataLoad() async {
    data = await onDataLoad();
    if (data != null) {
      floating_butons = [];
      if (data["Buttons"] != null && data["Buttons"].length > 0) {
        floating_butons = data["Buttons"].where((x) => x["ButtonType"] == "float_action");
      }

      setState(() {});
    }
  }

  Widget getFilterView(filter) {
    switch (filter["ValueType"]) {
      case "String":
        TextEditingController controller = filter["controller"] = filter["controller"] ?? TextEditingController();
        controller.text = filter["DefaultValue"];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Material(
              elevation: 1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: controller,
                    decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(0), labelText: filter["Caption"]),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              )),
        );
      case "ComboBox":
        return filter["Values"] == null || filter["Values"].length == 0
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(2.0),
                child: Material(
                    elevation: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filter["Caption"],
                          style: TextStyle(
                            color: HexColor.fromHex("9E9E9E"),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            elevation: 2,
                            value: filter["DefaultValue"].toString().isEmpty ? "-9999" : filter["DefaultValue"],
                            hint: Text(filter["Caption"]),
                            onChanged: (value) {
                              filter["DefaultValue"] = value;
                              setState(() {});
                            },
                            items: filter["Values"].map<DropdownMenuItem<dynamic>>((ddv) {
                              return DropdownMenuItem<dynamic>(
                                value: ddv["Key"],
                                child: Text(
                                  ddv["Value"],
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )),
              );
      case "Bool":
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Material(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filter["Caption"],
                    style: TextStyle(
                      color: HexColor.fromHex("9E9E9E"),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                        isExpanded: true,
                        elevation: 2,
                        value: filter["DefaultValue"].toString().isEmpty ? "-9999" : filter["DefaultValue"],
                        hint: Text(filter["Caption"]),
                        onChanged: (value) {
                          filter["DefaultValue"] = value;
                          setState(() {});
                        },
                        items: [
                          DropdownMenuItem<dynamic>(
                            value: "-9999",
                            child: Text(
                              "Tümü",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem<dynamic>(
                            value: "0",
                            child: Text(
                              "Pasif",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem<dynamic>(
                            value: "1",
                            child: Text(
                              "Aktif",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ]),
                  ),
                ],
              )),
        );
      default:
        return Text(filter["ValueType"]);
    }
  }

  @override
  Widget buildFragment(GizState<GizStatefulWidget> state) {
    if (data == null) {
      dataLoad();
      return Scaffold(
        backgroundColor: activeTheme.primaryColor,
        body: Center(
            child: Text(
          "Veri Yükleniyor...",
          style: TextStyle(color: Colors.white),
        )),
      );
    }

    bool hasTemplate = baseListTemplate != null && baseListTemplate.hasTemplate(data["LayoutID"]);

    return SafeArea(
      child: Scaffold(
        appBar: !isChildWidget ? appbar : null,
        key: pageKey,
        backgroundColor: activeTheme.primaryColor,
        body: Container(
          color: ListBackgroundColor,
          width: MediaQuery.of(buildContext).size.width,
          child: hasTemplate
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data["Data"].map<Widget>((item) => baseListTemplate.getTemplate(data["LayoutID"], item, onSearchResult)).toList(),
                  ),
                )
              : data["Data"] == null || data["Data"].length == 0
                  ? Container()
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: baseListTemplate.getTableWidget(data["Lang"], data["Data"],
                          onSearchResult: onSearchResult == null
                              ? null
                              : (x) {
                                  onSearchResult(x);
                                  Navigator.pop(gizContext);
                                }),
                    ),
        ),
        endDrawer: data["Filters"]?.length == 0 ? null : FilterPanel,
        floatingActionButton: floating_butons.length == 0
            ? null
            : floating_butons.length == 1
                ? FloatingActionButton(
                    onPressed: () {
                      perForm(floating_butons[0]["Perform"]);
                    },
                    child: floating_butons[0]["Icon"] != null && floating_butons[0]["Icon"].isNotEmpty
                        ? Icon(IconData(int.parse(floating_butons[0]["Icon"]), fontFamily: 'MaterialIcons'))
                        : Icon(Icons.accessibility),
                  )
                : SpeedDial(
                    icon: Icons.menu,
                    children: floating_butons
                        .map<SpeedDialChild>((btn) => SpeedDialChild(
                              child: btn["Icon"] != null && btn["Icon"].isNotEmpty
                                  ? Icon(IconData(int.parse(btn["Icon"]), fontFamily: 'MaterialIcons'))
                                  : Icon(Icons.accessibility),
                              backgroundColor: activeTheme.primaryColorDark,
                              foregroundColor: Colors.white,
                              label: btn["ButtonName"],
                              onTap: () => perForm(btn["Perform"]),
                            ))
                        .toList()),
      ),
    );
  }
}
