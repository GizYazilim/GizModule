import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:giz_module/module.dart';

import 'Fragment.dart';



class FragmentManager extends StatelessWidget {
  static ValueNotifier<List<Fragment>> fragments = new ValueNotifier<List<Fragment>>([]);
  static FragmentManager manager;
  static int fragmentCount = 0;
  bool isTabsChange = false;

  ValueChanged<Fragment> onFragmentChanged;

  FragmentManager({this.onFragmentChanged});

  void openFragment(Fragment fragment, {String key}) {
    isTabsChange = false;
    if (getCurrentFragment() != null) getCurrentFragment().capturePng();

    if (key != null) {
      try {
        var frg = fragments.value
            .where((element) => element.fragmentKey == key)
            .first;
        if (frg != null) fragment = frg;
      } catch (ex) {}
    }
    if (fragments.value.indexOf(fragment) >= 0)
      fragments.value.remove(fragment);
    fragments.value.add(fragment);
    if (onFragmentChanged != null) onFragmentChanged(fragment);
    setState();
  }

  void setState() {
    var frgs = fragments.value;
    fragments.value = [];
    Future.delayed(Duration(milliseconds: 100), () => fragments.value = frgs);
  }

  void closeFragment(Fragment fragment) {
    fragments.value.remove(fragment);

    if (fragments.value.length > 0) {
      if (fragments.value.length <= 1) isTabsChange = false;
      openFragment(fragments.value.last);
    } else if (onFragmentChanged != null) {
      isTabsChange = false;
      onFragmentChanged(null);
      fragments.value = [];
    } else {
      isTabsChange = false;
      fragments.value = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    manager = this;

    return Container(
      child: ValueListenableBuilder(
        valueListenable: fragments,
        builder: (context, value, child) {
          fragmentCount = fragments.value.length;

          if (isTabsChange && fragments.value.length > 1)
            return GridView.count(
                crossAxisCount: 2,
                children: fragments.value
                    .map<Widget>((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 1,
                    color: Colors.white70,
                    child: InkWell(
                      onTap: () {
                        FragmentManager.manager.openFragment(e);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.title),
                                ),
                                IconButton(
                                    onPressed: () => FragmentManager
                                        .manager
                                        .closeFragment(e),
                                    icon: Icon(Icons.close))
                              ],
                            ),
                          ),
                          if (e.byteData != null)
                            Expanded(
                              child: Container(
                                width: double.maxFinite,
                                child: Image.memory(
                                  Uint8List.view(e.byteData.buffer),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ))
                    .toList());

          return fragments.value.length > 0
              ? getCurrentFragment()
              : FutureBuilder(
            future: wait(100),
            builder: (context, snapshot) {
              return Container();
            },
          );
        },
      ),
    );
  }

  Fragment getCurrentFragment() {
    return fragments.value.length > 0 ? fragments.value.last : null;
  }

  Future<int> wait(int i) async {
    await sleep(Duration(milliseconds: i));
    return i;
  }
}