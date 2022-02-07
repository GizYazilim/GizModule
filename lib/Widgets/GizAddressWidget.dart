import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giz_module/main.dart';
import 'package:giz_module/module.dart';

class GizAddressWidget extends GizStateLessWidget {
  ValueNotifier<GizAddress> __GizAddress =
      new ValueNotifier<GizAddress>(GizAddress());

  bool showSwichBar = true;
  bool showAddressTile = true;
  Color shadowColor;

  ValueNotifier<KeyValuePair<String, String>> country = ValueNotifier(null);
  ValueNotifier<KeyValuePair<String, String>> city = ValueNotifier(null);
  ValueNotifier<KeyValuePair<String, String>> town = ValueNotifier(null);
  ValueNotifier<KeyValuePair<String, String>> district = ValueNotifier(null);

  ValueGetter<List<KeyValuePair<String, String>>> countryGetter;
  ValueGetter<List<KeyValuePair<String, String>>> cityGetter;
  ValueGetter<List<KeyValuePair<String, String>>> townGetter;
  ValueGetter<List<KeyValuePair<String, String>>> districtGetter;

  GizAddressWidget(
      {this.showSwichBar = true,
      this.showAddressTile = true,
      this.shadowColor,
      this.countryGetter,
      this.cityGetter,
      this.townGetter,
      this.districtGetter});

  GizEditText txtAddressName = GizEditText(TextEditingController());
  GizEditText txtCustomerName = GizEditText(TextEditingController());
  GizEditText txtCustomerSurname = GizEditText(TextEditingController());
  GizEditText txtPhoneNumber = GizEditText(TextEditingController());
  GizEditText txtCompanyName = GizEditText(TextEditingController());
  GizEditText txtTaxOffice = GizEditText(TextEditingController());
  GizEditText txtTaxNo = GizEditText(TextEditingController());
  GizEditText txtAddress = GizEditText(TextEditingController());

  @override
  Widget buildWidget(BuildContext context) {
    shadowColor = shadowColor ?? currentTheme.shadowColor;
    print("ValueListenableBuilder");
    return ValueListenableBuilder<GizAddress>(
        valueListenable: __GizAddress,
        builder: (context, addres, child) {
          txtAddressName.text = addres.addressName;
          txtCustomerName.text = addres.customerName;
          txtCustomerSurname.text = addres.customerSurName;
          txtPhoneNumber.text = addres.mobilePhone;
          txtCompanyName.text = addres.companyName;
          txtTaxOffice.text = addres.taxOffice;
          txtTaxNo.text = addres.taxNumber;
          txtAddress.text = addres.address;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (showSwichBar)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Bireysel",
                              textAlign: TextAlign.center,
                            ),
                          ))),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              color: shadowColor,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("Kurumsal",
                                    textAlign: TextAlign.center),
                              ))),
                    ],
                  ),
                if (showAddressTile)
                  txtAddressName = GizEditText(
                    TextEditingController(),
                    icon: Icon(
                      Icons.edit,
                    ),
                    hint: "Adres Başlığı",
                    valueChanged: (value) => addres.addressName = value,
                    isFiilSolid: false,
                    shadowColor: shadowColor,
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: txtCustomerName = GizEditText(
                        TextEditingController(),
                        icon: Icon(
                          Icons.edit,
                        ),
                        hint: "Ad",
                        isFiilSolid: false,
                        shadowColor: shadowColor,
                        valueChanged: (value) => addres.customerName = value,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: txtCustomerSurname = GizEditText(
                        TextEditingController(),
                        hint: "Soyad",
                        isFiilSolid: false,
                        icon: Icon(
                          Icons.edit,
                        ),
                        shadowColor: shadowColor,
                        valueChanged: (value) => addres.customerSurName = value,
                      ),
                    ),
                  ],
                ),
                txtPhoneNumber = GizEditText(
                  TextEditingController(),
                  hint: "Telefon Numarası",
                  isFiilSolid: false,
                  icon: Icon(
                    Icons.phone_android,
                  ),
                  shadowColor: shadowColor,
                  valueChanged: (value) => addres.mobilePhone = value,
                ),
                txtCompanyName = GizEditText(
                  TextEditingController(),
                  hint: "Firma Ünvanı",
                  isFiilSolid: false,
                  icon: Icon(
                    Icons.store,
                  ),
                  shadowColor: shadowColor,
                  valueChanged: (value) => addres.companyName = value,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: txtTaxOffice = GizEditText(
                        TextEditingController(),
                        hint: "Vergi Dairesi",
                        isFiilSolid: false,
                        icon: Icon(
                          Icons.edit,
                        ),
                        shadowColor: shadowColor,
                        valueChanged: (value) => addres.taxOffice = value,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: txtTaxNo = GizEditText(
                        TextEditingController(),
                        hint: "Vergi Numarası",
                        isFiilSolid: false,
                        icon: Icon(
                          Icons.edit,
                        ),
                        shadowColor: shadowColor,
                        valueChanged: (value) => addres.taxNumber = value,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (countryGetter != null)
                      ValueListenableBuilder<KeyValuePair<String, String>>(
                        valueListenable: country,
                        builder: (context, value, child) => Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: GizWidgetBorder(
                            onTap: () {
                              showCountry();
                            },
                            hint: "Ülke",
                            icon: Icon(Icons.edit),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    value == null ? "Seçiniz..." : value.value),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (cityGetter != null)
                      ValueListenableBuilder<KeyValuePair<String, String>>(
                        valueListenable: city,
                        builder: (context, value, child) => Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: GizWidgetBorder(
                            onTap: () {
                              showCity();
                            },
                            hint: "Şehir",
                            icon: Icon(Icons.edit),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    value == null ? "Seçiniz..." : value.value),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (townGetter != null)
                      ValueListenableBuilder<KeyValuePair<String, String>>(
                        valueListenable: town,
                        builder: (context, value, child) => Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: GizWidgetBorder(
                            onTap: () {
                              showTown();
                            },
                            hint: "İlçe",
                            icon: Icon(Icons.edit),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    value == null ? "Seçiniz..." : value.value),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (districtGetter != null)
                      ValueListenableBuilder<KeyValuePair<String, String>>(
                        valueListenable: district,
                        builder: (context, value, child) => Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: GizWidgetBorder(
                            onTap: () {
                              showDistrict();
                            },
                            hint: "Semt",
                            icon: Icon(Icons.edit),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    value == null ? "Seçiniz..." : value.value),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                txtAddress = GizEditText(
                  TextEditingController(),
                  hint: "Adres",
                  isFiilSolid: false,
                  icon: Icon(
                    Icons.edit,
                  ),
                  shadowColor: shadowColor,
                  valueChanged: (value) => addres.address = value,
                ),
              ],
            ),
          );
        });
  }

  PersistentBottomSheetController showCountry() {
    return showSheet("country");
  }

  PersistentBottomSheetController showCity() {
    return showSheet("city");
  }

  PersistentBottomSheetController showTown() {
    return showSheet("town");
  }

  PersistentBottomSheetController showDistrict() {
    return showSheet("district");
  }

  PersistentBottomSheetController showSheet(String sheetType) {
    PersistentBottomSheetController bottomSheetController;
    bottomSheetController = showBottomSheet(
      context: buildContext,
      builder: (context) {
        List<KeyValuePair<String, String>> items = [];

        String title = "";
        switch (sheetType) {
          case "country":
            title = "Ülkeler";
            if (countryGetter != null) items = countryGetter();
            break;
          case "city":
            title = "Şehirler";
            if (countryGetter != null) items = countryGetter();
            break;
          case "town":
            title = "İlçeler";
            if (townGetter != null) items = townGetter();
            break;
          case "district":
            title = "Semtler";
            if (districtGetter != null) items = districtGetter();
            break;
        }

        return SingleChildScrollView(
          child: Container(
            height: gizContext.height * 0.75,
            width: gizContext.width,
            color: shadowColor ?? currentTheme.shadowColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                //GizEditText(TextEditingController(), shadowColor: Colors.white,isHintInclude: true,hint: 'Ülke Ara',),
                for (int i = 0; i < items.length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        switch (sheetType) {
                          case "country":
                            country.value = items[i];
                            __GizAddress.value.countryId = country.value.key;
                            __GizAddress.value.countryName =
                                country.value.value;
                            break;
                          case "city":
                            city.value = items[i];
                            __GizAddress.value.cityId = city.value.key;
                            __GizAddress.value.cityName = city.value.value;
                            break;
                          case "town":
                            town.value = items[i];
                            __GizAddress.value.townId = town.value.key;
                            __GizAddress.value.townName = town.value.value;
                            break;
                          case "district":
                            district.value = items[i];
                            __GizAddress.value.districtId = district.value.key;
                            __GizAddress.value.districtName =
                                district.value.value;
                            break;
                        }

                        bottomSheetController.close();
                      },
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.flag),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  items[i].value,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
    return bottomSheetController;
  }
}

class GizAddress {
  GizAddress(
      {this.addressName = "",
      this.customerName = "",
      this.customerSurName = "",
      this.countryId = "",
      this.countryName = "",
      this.cityId = "",
      this.cityName = "",
      this.townId = "",
      this.townName = "",
      this.address = "",
      this.postCode = "",
      this.taxNumber = "",
      this.taxOffice = "",
      this.mobilePhone = "",
      this.fax = "",
      this.email = "",
      this.companyName = "",
      this.addressType = "",
      this.districtId,
      this.districtName});

  String addressName;
  String customerName;
  String customerSurName;
  String countryId;
  String countryName;
  String cityId;
  String cityName;

  String townId;
  String townName;

  String districtId;
  String districtName;

  String address;
  String postCode;
  String taxNumber;
  String taxOffice;
  String mobilePhone;
  String fax;
  String email;
  String companyName;
  String addressType;

  factory GizAddress.fromJson(String jsonString) {
    var json = jsonDecode(jsonString);
    return GizAddress(
        addressName: json["AddressName"] ?? "",
        customerName: json["CustomerName"] ?? "",
        customerSurName: json["CustomerSurName"] ?? "",
        countryId: json["CountryID"] ?? "",
        countryName: json["CountryName"] ?? "",
        cityId: json["CityID"] ?? "",
        cityName: json["CityName"] ?? "",
        townId: json["TownID"] ?? "",
        townName: json["TownName"] ?? "",
        address: json["Address"] ?? "",
        postCode: json["PostCode"] ?? "",
        taxNumber: json["TaxNumber"] ?? "",
        taxOffice: json["TaxOffice"] ?? "",
        mobilePhone: json["MobilePhone"] ?? "",
        fax: json["Fax"] ?? "",
        email: json["Email"] ?? "",
        companyName: json["CompanyName"] ?? "",
        addressType: json["AddressType"] ?? "",
        districtId: json["DistrictID"] ?? "",
        districtName: json["DistrictName"] ?? "");
  }

  String toJson() => jsonEncode({
        "CustomerName": customerName,
        "CustomerSurName": customerSurName,
        "CountryID": countryId,
        "CountryName": countryName,
        "CityID": cityId,
        "CityName": cityName,
        "TownID": townId,
        "TownName": townName,
        "Address": address,
        "PostCode": postCode,
        "TaxNumber": taxNumber,
        "TaxOffice": taxOffice,
        "MobilePhone": mobilePhone,
        "Fax": fax,
        "Email": email,
        "CompanyName": companyName,
        "AddressType": addressType,
        "DistrictID": districtId,
        "DistrictName": districtName
      });
}

class KeyValuePair<T, E> {
  T key;
  E value;

  KeyValuePair(this.key, this.value);
}
