import 'package:agritechv2/blocs/customer/customer_bloc.dart';
import 'package:agritechv2/models/addresses/barangay.dart';
import 'package:agritechv2/models/addresses/provinces.dart';
import 'package:agritechv2/models/addresses/region.dart';
import 'package:agritechv2/repository/address_api_repository.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/Address.dart';
import '../../../models/addresses/city.dart';
import '../../../styles/color_styles.dart';

class CreateAddressPage extends StatefulWidget {
  List<Address> addresses;
  CreateAddressPage({super.key, required this.addresses});

  @override
  State<CreateAddressPage> createState() => _CreateAddressPageState();
}

class _CreateAddressPageState extends State<CreateAddressPage> {
  final addressRepository = AddressesRepository();
  List<Region> regionList = [];
  List<Province> provinceList = [];
  List<City> cityList = [];
  List<Barangay> barangayList = [];
  Barangay? selectedBarangay;
  City? selectedCity;
  Region? selectedRegion;
  Province? selectedProvince;

  String? fullname;
  String? phone;
  String? postalCode;
  String? landMark;
  String? labelAs;
  List<bool> selectedAddressType = [true, false];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void loadRegions() async {
    try {
      final regions = await AddressesRepository().getAllRegions();
      setState(() {
        regionList = regions;
        print(regionList);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void loadProvincesByRegion(String regionCode) async {
    try {
      final provinces =
          await AddressesRepository().getProvincesByRegion(regionCode);
      setState(() {
        provinceList = provinces;
        print(regionList);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void loadCitiesByProvince(String provinceCode) async {
    try {
      final cities =
          await AddressesRepository().getCitiesByProvince(provinceCode);
      setState(() {
        cityList = cities;
        print(cities);
      });
    } catch (e) {
      print("city error");
      print(e.toString());
    }
  }

  void loadBarangaByCity(String cityCode) async {
    print(cityCode);
    try {
      final barangays = await AddressesRepository().getBarangayByCity(cityCode);
      setState(() {
        barangayList = barangays;
        print(barangayList);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  bool isDefault = false;
  @override
  void initState() {
    super.initState();
    loadRegions();
    print("Addresses : ${widget.addresses.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.brandRed,
        title: const Text('Create Address'),
      ),
      body: BlocProvider(
        create: (context) =>
            CustomerBloc(userRepository: context.read<UserRepository>()),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Contact",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Fullname *',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      fullname = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Fullname is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone *',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      phone = value;
                    },
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone is required";
                      }
                      if (value.length != 11 || !value.startsWith("09")) {
                        return "Invalid Phone number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Address",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                  ),
                  DropdownButtonFormField<Region>(
                    hint: const Text('Select a Region *'),
                    value: selectedRegion,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    onChanged: (Region? newValue) {
                      setState(() {
                        selectedRegion = newValue;
                        if (selectedRegion != null) {
                          loadProvincesByRegion(selectedRegion!.code);
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Region is required";
                      }
                      return null;
                    },
                    items: regionList
                        .map<DropdownMenuItem<Region>>((Region region) {
                      return DropdownMenuItem<Region>(
                        value: region,
                        child: Text(region.name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15.0),
                  DropdownButtonFormField<Province>(
                    hint: const Text('Select a Province * '),
                    value: selectedProvince,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Province is required";
                      }
                      return null;
                    },
                    isExpanded: true,
                    onChanged: (Province? newValue) {
                      setState(() {
                        selectedProvince = newValue;
                        if (selectedProvince != null) {
                          print("Province: " + selectedProvince!.code);
                          loadCitiesByProvince(selectedProvince!.code);
                        }
                      });
                    },
                    items: provinceList
                        .map<DropdownMenuItem<Province>>((Province province) {
                      return DropdownMenuItem<Province>(
                        value: province,
                        child: Text(province.name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15.0),
                  DropdownButtonFormField<City>(
                    hint: const Text('Select a City *'),
                    value: selectedCity,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return "City is required";
                      }
                      return null;
                    },
                    onChanged: (City? newValue) {
                      setState(() {
                        selectedCity = newValue;
                        print("City Code : ${selectedCity!.code}");
                        if (selectedCity != null) {
                          loadBarangaByCity(selectedCity!.code);
                        }
                      });
                    },
                    items: cityList.map<DropdownMenuItem<City>>((City city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text(city.name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15.0),
                  DropdownButtonFormField<Barangay>(
                    hint: const Text('Select a barangay *'),
                    value: selectedBarangay,
                    validator: (value) {
                      if (value == null) {
                        return "Barangay is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    onChanged: (Barangay? newValue) {
                      setState(() {
                        selectedBarangay = newValue;
                      });
                    },
                    items: barangayList
                        .map<DropdownMenuItem<Barangay>>((Barangay barangay) {
                      return DropdownMenuItem<Barangay>(
                        value: barangay,
                        child: Text(barangay.name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Postal Code *',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      postalCode = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Postal Code is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Landmark *',
                        border: OutlineInputBorder(),
                        helperText: "Streeet name ,Building ,House no."),
                    onChanged: (value) {
                      landMark = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Land Mark is required";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Label as: "),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        isSelected: selectedAddressType,
                        onPressed: (int index) {
                          setState(() {
                            for (var i = 0;
                                i < AddressType.values.length;
                                i++) {
                              selectedAddressType[i] = i == index;
                            }
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.red[700],
                        selectedColor: Colors.white,
                        fillColor: Colors.red[200],
                        color: Colors.red[400],
                        constraints: const BoxConstraints(
                            minHeight: 20.0, minWidth: 40.0),
                        children: AddressType.values.map((value) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(value
                                .toString()
                                .split('.')
                                .last), // Display enum value as a string
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("address"),
                      DefaultToggleSwitch(
                          toggle: (data) {
                            setState(() {
                              isDefault = data;
                              print(isDefault);
                            });
                          },
                          isDefault: isDefault),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  BlocConsumer<CustomerBloc, CustomerState>(
                    listener: (context, state) {
                      if (state is CustomerSuccess<String>) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.data)));
                        context.pop();
                      }
                      if (state is CustomerError) {
                        print("error creating address");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      return state is CustomerLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Button(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (isDefault == true) {
                                    for (var address in widget.addresses) {
                                      address.isDefault = false;
                                    }
                                  }
                                  Address address = Address(
                                      region: selectedRegion!.name,
                                      province: selectedProvince!.name,
                                      city: selectedCity!.name,
                                      barangay: selectedBarangay!.name,
                                      postalCode: postalCode!,
                                      landmark: landMark!,
                                      addressType:
                                          selectedAddressType[0] == true
                                              ? AddressType.home
                                              : AddressType.work,
                                      contact: Contact(
                                          name: fullname!, phone: phone!),
                                      isDefault: isDefault);

                                  widget.addresses.add(address);

                                  context.read<CustomerBloc>().add(
                                      CreateAddressEvent(
                                          context
                                              .read<AuthRepository>()
                                              .currentUser!
                                              .uid,
                                          widget.addresses));
                                }
                              },
                              buttonWidth: double.infinity,
                              buttonText: "Save Address",
                              buttonColor: ColorStyle.brandRed,
                              borderColor: ColorStyle.blackColor,
                              textColor: ColorStyle.whiteColor,
                            );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultToggleSwitch extends StatelessWidget {
  Function(bool data) toggle;
  bool isDefault;
  DefaultToggleSwitch(
      {super.key, required this.toggle, required this.isDefault});
  final MaterialStateProperty<Color?> trackColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.amber;
      }

      return null;
    },
  );
  final MaterialStateProperty<Color?> overlayColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      // Material color when switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.amber.withOpacity(0.54);
      }
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.shade400;
      }
      return null;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDefault,
      overlayColor: overlayColor,
      trackColor: trackColor,
      thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
      onChanged: (value) {
        toggle(value);
      },
    );
  }
}
