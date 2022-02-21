import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giz_module/module.dart';

class GizAddressWidget extends GizStateLessWidget {
  ValueNotifier<GizAddress> __GizAddress = new ValueNotifier<GizAddress>(GizAddress());

  GizAddress get address => __GizAddress.value;

  set address(GizAddress vale) => __GizAddress.value = vale;

  bool get isKurumsal => !showSwichBar || AddressType == "Kurumsal";

  String AddressType = "Bireysel";
  bool showSwichBar = true;
  bool showAddressTile = true;
  Color shadowColor;
  ValueChanged<GizAddressWidget> onSave;

  ValueNotifier<KeyValuePair<String, String>> country = ValueNotifier(null);
  ValueNotifier<KeyValuePair<String, String>> city = ValueNotifier(null);
  ValueNotifier<KeyValuePair<String, String>> town = ValueNotifier(null);
  ValueNotifier<KeyValuePair<String, String>> district = ValueNotifier(null);

  GizValueGetter<List<KeyValuePair<String, String>>, GizAddressWidget> countryGetter;
  GizValueGetter<List<KeyValuePair<String, String>>, GizAddressWidget> cityGetter;
  GizValueGetter<List<KeyValuePair<String, String>>, GizAddressWidget> townGetter;
  GizValueGetter<List<KeyValuePair<String, String>>, GizAddressWidget> districtGetter;

  bool isValidateOnSave;
  bool isRequired_AddressName;
  bool isRequired_CustomerName;
  bool isRequired_CustomerSurName;
  bool isRequired_Country;
  bool isRequired_City;
  bool isRequired_Town;
  bool isRequired_District;
  bool isRequired_Address;
  bool isRequired_PostCode;
  bool isRequired_TaxNumber;
  bool isRequired_TaxOffice;
  bool isRequired_MobilePhone;
  bool isRequired_Fax;
  bool isRequired_Email;
  bool isRequired_CompanyName;

  GizAddressWidget({
    this.showSwichBar = true,
    this.showAddressTile = true,
    this.shadowColor,
    this.countryGetter,
    this.cityGetter,
    this.townGetter,
    this.districtGetter,
    this.onSave,
    this.isRequired_AddressName = true,
    this.isRequired_CustomerName = true,
    this.isRequired_CustomerSurName = true,
    this.isRequired_Country = true,
    this.isRequired_City = true,
    this.isRequired_Town = true,
    this.isRequired_District = false,
    this.isRequired_Address = true,
    this.isRequired_PostCode = true,
    this.isRequired_TaxNumber = true,
    this.isRequired_TaxOffice = true,
    this.isRequired_MobilePhone = true,
    this.isRequired_Fax = true,
    this.isRequired_Email = true,
    this.isRequired_CompanyName = true,
    this.isValidateOnSave = false,
  });

  String get textAdresBasligiGir => "Adres Başlığını Giriniz.";

  String get textAdiniGir => "Adınızı Giriniz.";

  String get textSoyadiniGir => "Soyadınızı Giriniz.";

  String get textTelefonGir => "Telefon Numaranızı Giriniz.";

  String get textEPostaGir => "E-Posta Adresinizi Giriniz.";

  String get textAdresGir => "Adresinizi Giriniz.";

  String get textFirmaUnvanGir => "Firma Unvanını Giriniz.";

  String get textVergiDaireGir => "Vergi Dairesini Giriniz.";

  String get textVergiNoGir => "Vergi Numarasını Giriniz.";

  bool Validate() {
    bool unValidated = false;

    unValidated = (isRequired_AddressName && txtAddressName.isEmpty(textAdresBasligiGir)) || unValidated;
    unValidated = (isRequired_CustomerName && txtCustomerName.isEmpty(textAdiniGir)) || unValidated;
    unValidated = (isRequired_CustomerSurName && txtCustomerSurname.isEmpty(textSoyadiniGir)) || unValidated;
    unValidated = (isRequired_MobilePhone && txtPhoneNumber.isEmpty(textTelefonGir)) || unValidated;
    unValidated = (isRequired_Email && txtEmail.isEmpty(textEPostaGir)) || unValidated;
    unValidated = (isRequired_Address && txtAddress.isEmpty(textAdresGir)) || unValidated;

    if (isKurumsal) {
      unValidated = (isRequired_CompanyName && txtCompanyName.isEmpty(textFirmaUnvanGir)) || unValidated;
      unValidated = (isRequired_TaxOffice && txtTaxOffice.isEmpty(textVergiDaireGir)) || unValidated;
      unValidated = (isRequired_TaxNumber && txtTaxNo.isEmpty(textVergiNoGir)) || unValidated;
    }

    if (isRequired_Country && countryGetter != null && (address.countryId == null || address.countryId.isEmpty)) {
      unValidated = true;
      borderCountry.error.value = "Ülke Seçiniz.";
    }

    if (isRequired_City && cityGetter != null && (address.cityId == null || address.cityId.isEmpty)) {
      unValidated = true;
      borderCity.error.value = "Şehir Seçiniz.";
    }

    if (isRequired_Town && townGetter != null && (address.townId == null || address.townId.isEmpty)) {
      unValidated = true;
      borderTown.error.value = "İlçe Seçiniz.";
    }

    if (isRequired_District && districtGetter != null && (address.districtId == null || address.districtId.isEmpty)) {
      unValidated = true;
      borderDistrict.error.value = "Semt Seçiniz.";
    }

    return !unValidated;
  }

  GizEditText txtAddressName = GizEditText(TextEditingController());
  GizEditText txtCustomerName = GizEditText(TextEditingController());
  GizEditText txtCustomerSurname = GizEditText(TextEditingController());
  GizEditText txtPhoneNumber = GizEditText(TextEditingController());
  GizEditText txtCompanyName = GizEditText(TextEditingController());
  GizEditText txtTaxOffice = GizEditText(TextEditingController());
  GizEditText txtTaxNo = GizEditText(TextEditingController());
  GizEditText txtAddress = GizEditText(TextEditingController());
  GizEditText txtEmail = GizEditText(TextEditingController());

  GizWidgetBorder borderCountry;
  GizWidgetBorder borderCity;
  GizWidgetBorder borderTown;
  GizWidgetBorder borderDistrict;

  @override
  Widget buildWidget(BuildContext context) {
    shadowColor = shadowColor ?? activeTheme.shadowColor;
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
          txtEmail.text = addres.email;


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
                          child: InkWell(
                            onTap: () {
                              if (isKurumsal) {
                                print(addres.addressName);
                                print(__GizAddress.value.addressName);
                                AddressType = "Bireysel";
                                setState(() {});
                              }
                            },
                            child: Container(
                                color: !isKurumsal ? shadowColor : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Bireysel",
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: InkWell(
                            onTap: () {
                              if (!isKurumsal) {
                                AddressType = "Kurumsal";
                                print(addres.addressName);
                                print(__GizAddress.value.addressName);
                                setState(() {});
                              }
                            },
                            child: Container(
                                color: isKurumsal ? shadowColor : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("Kurumsal", textAlign: TextAlign.center),
                                )),
                          )),
                    ],
                  ),
                if (showAddressTile)
                  txtAddressName = GizEditText(
                    txtAddressName.controller,
                    icon: Icon(
                      Icons.home,
                    ),
                    hint: "Adres Başlığı",
                    valueChanged: (value) => addres.addressName = value,
                    onSubmitted: (value) => addres.addressName = value,
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
                        txtCustomerName.controller,
                        icon: Icon(
                          Icons.edit,
                        ),
                        hint: "Ad",
                        isFiilSolid: false,
                        shadowColor: shadowColor,
                        valueChanged: (value) => addres.customerName = value,
                        onSubmitted: (value) => addres.customerName = value,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: txtCustomerSurname = GizEditText(
                        txtCustomerSurname.controller,
                        hint: "Soyad",
                        isFiilSolid: false,
                        icon: Icon(
                          Icons.edit,
                        ),
                        shadowColor: shadowColor,
                        valueChanged: (value) => addres.customerSurName = value,
                        onSubmitted: (value) => addres.customerSurName = value,
                      ),
                    ),
                  ],
                ),
                if (isKurumsal) ...{
                  txtCompanyName = GizEditText(
                    txtCompanyName.controller,
                    hint: "Firma Ünvanı",
                    isFiilSolid: false,
                    icon: Icon(
                      Icons.store,
                    ),
                    shadowColor: shadowColor,
                    valueChanged: (value) => addres.companyName = value,
                    onSubmitted: (value) => addres.companyName = value,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: txtTaxOffice = GizEditText(
                          txtTaxOffice.controller,
                          hint: "Vergi Dairesi",
                          isFiilSolid: false,
                          icon: Icon(
                            Icons.storefront_sharp,
                          ),
                          shadowColor: shadowColor,
                          valueChanged: (value) => addres.taxOffice = value,
                          onSubmitted: (value) => addres.taxOffice = value,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: txtTaxNo = GizEditText(
                          txtTaxNo.controller,
                          hint: "Vergi Numarası",
                          isFiilSolid: false,
                          icon: Icon(
                            Icons.dialpad,
                          ),
                          shadowColor: shadowColor,
                          valueChanged: (value) => addres.taxNumber = value,
                          onSubmitted: (value) => addres.taxNumber = value,
                        ),
                      ),
                    ],
                  )
                },
                txtPhoneNumber = GizEditText(
                  txtPhoneNumber.controller,
                  hint: "Telefon Numarası",
                  isFiilSolid: false,
                  icon: Icon(
                    Icons.phone_android,
                  ),
                  shadowColor: shadowColor,
                  valueChanged: (value) => addres.mobilePhone = value,
                  onSubmitted: (value) => addres.mobilePhone = value,
                ),
                txtEmail = GizEditText(
                  txtEmail.controller,
                  hint: "E-Posta Adresi",
                  isFiilSolid: false,
                  icon: Icon(
                    Icons.alternate_email,
                  ),
                  shadowColor: shadowColor,
                  valueChanged: (value) => addres.email = value,
                  onSubmitted: (value) => addres.email = value,
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
                          child: borderCountry = GizWidgetBorder(
                            onTap: () {
                              showCountry();
                            },
                            hint: "Ülke",
                            icon: Icon(Icons.map),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(value == null ? "Seçiniz..." : value.value), Icon(Icons.arrow_drop_down)],
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
                          child: borderCity = GizWidgetBorder(
                            onTap: () {
                              showCity();
                            },
                            hint: "Şehir",
                            icon: Icon(Icons.map),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(value == null ? "Seçiniz..." : value.value), Icon(Icons.arrow_drop_down)],
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
                          child: borderTown = GizWidgetBorder(
                            onTap: () {
                              showTown();
                            },
                            hint: "İlçe",
                            icon: Icon(Icons.map),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(value == null ? "Seçiniz..." : value.value), Icon(Icons.arrow_drop_down)],
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
                          child: borderDistrict = GizWidgetBorder(
                            onTap: () {
                              showDistrict();
                            },
                            hint: "Semt",
                            icon: Icon(Icons.map),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(value == null ? "Seçiniz..." : value.value), Icon(Icons.arrow_drop_down)],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                txtAddress = GizEditText(
                  txtAddress.controller,
                  hint: "Adres",
                  isFiilSolid: false,
                  icon: Icon(
                    Icons.line_style,
                  ),
                  shadowColor: shadowColor,
                  valueChanged: (value) => addres.address = value,
                  onSubmitted: (value) => addres.address = value,
                ),
                if (onSave != null)
                  FlatButton(
                      color: shadowColor,
                      onPressed: () {
                        if (isValidateOnSave) {
                          if (Validate()) onSave(this);
                        } else
                          onSave(this);
                      },
                      child: Text("Bilgileri Kaydet"))
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
            if (countryGetter != null) items = countryGetter(this);
            break;
          case "city":
            title = "Şehirler";
            if (cityGetter != null) items = cityGetter(this);
            print(items);
            break;
          case "town":
            title = "İlçeler";
            if (townGetter != null) items = townGetter(this);
            break;
          case "district":
            title = "Semtler";
            if (districtGetter != null) items = districtGetter(this);
            break;
        }
        print("asdasd");

        return Container(
          constraints: BoxConstraints(maxHeight: gizContext.height, minHeight: gizContext.height),
          height: gizContext.height,
          width: gizContext.width,
          color: shadowColor ?? activeTheme.shadowColor,
          child: ListView(children: [
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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    switch (sheetType) {
                      case "country":
                        country.value = items[i];
                        __GizAddress.value.countryId = country.value.key;
                        __GizAddress.value.countryName = country.value.value;
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
                        __GizAddress.value.districtName = district.value.value;
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
          ]),
        );
      },
    );
    return bottomSheetController;
  }
}

class GizAddress {
  GizAddress(
      {this.addressID,
      this.addressName = "",
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

  int addressID;
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
        addressID: json["AddressID"] ?? 0,
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
        "AddressID": addressID,
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
        "DistrictName": districtName,
        "AddressName": addressName
      });
}

class KeyValuePair<T, E> {
  T key;
  E value;
  dynamic data;

  KeyValuePair(this.key, this.value, this.data);
}
