import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/data_sources/api/location.dart';
import 'package:momsclub/models/location_model.dart';

import '../styles/text_styles.dart';
import '../utils/infos.dart';
import '../utils/infos.dart';
import '../utils/str_res.dart';
import '../utils/str_res.dart';

class LocationPickerScreen extends StatefulWidget {

  final Function onChange;

  const LocationPickerScreen({Key key, this.onChange}) : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {

  TextEditingController _provinceTxtCtrl = TextEditingController();
  TextEditingController _cityTxtCtrl = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Province _selected_province;
  City _selected_city;

  List<Province> _provinces;
  List<City> _cities;

  _loadProvince() async {
    try {
      List<Province> prov = await LocationAPI.getProvince();
      setState(() => _provinces = prov);  
    } on Exception catch (e) {
      var sb = SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(sb);
    }
  }

  _loadCities(Province prov) async {
    try {
      List<City> cities = await LocationAPI.getCity(prov.id);
      setState(() {
        _selected_province = prov;
        _provinceTxtCtrl.text = prov.nama;
        _cityTxtCtrl.text = "";
        _selected_city = null;
        _cities = cities;
      });  
    } on Exception catch (e) {
      var sb = SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(sb);
    }
  }

  _onProvinceSelected(Province prov) async {
    await _loadCities(prov);
    Navigator.of(context).pop();
  }

  _onCitySelected(City city) async {
    setState(() {
      _selected_city = city;
      _cityTxtCtrl.text = city.nama;
    });
    widget.onChange(_provinceTxtCtrl.text, _cityTxtCtrl.text);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }


  @override
  void initState() {
    _loadProvince();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(StrRes.COMMUNITY_LOCATION, style: TextStyle(color: AppColor.PRIMARY),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.PRIMARY,), 
          onPressed: (){ 
            Navigator.of(context).pop();
          }
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: <Widget>[
          Text(
              StrRes.PROVINCE,
              style: H5,
          ),
          CupertinoTextField(
            controller: _provinceTxtCtrl,
            readOnly: true,
            onTap: (){
              showModalBottomSheet(
                context: context, 
                builder: (context) => ProvinceSelector(provinces: _provinces, onSelected: _onProvinceSelected,)
              );
            },
            placeholder: StrRes.COMMUNITY_FIELD_INSTR_SELECT,
          ),
          SizedBox(height: 15,),
          Text(
              StrRes.CITY,
              style: H5,
          ),
          CupertinoTextField(
            controller: _cityTxtCtrl,
            readOnly: true,
            onTap: _cities == null ? null : (){
              showModalBottomSheet(
                context: context, 
                builder: (context) => CitySelector(cities: _cities, onSelected: _onCitySelected,)
              );
            },
            placeholder: StrRes.COMMUNITY_FIELD_INSTR_SELECT,
          ),
        ],
      ),
    );
  }
}

class ProvinceSelector extends StatefulWidget {
  const ProvinceSelector({
    Key key,
    @required List<Province> provinces, this.onSelected, this.selected
  }) : provinces = provinces, super(key: key);

  final Function onSelected;
  final Province selected;
  final List<Province> provinces;

  @override
  _ProvinceSelectorState createState() => _ProvinceSelectorState();
}

class _ProvinceSelectorState extends State<ProvinceSelector> {
  
  String _keyword;

  _buildProvinceItem(Province prov) {
    return ListTile(
      title: Text(prov.nama),
      selected: widget.selected != null && prov.id == widget.selected.id,
      onTap: () {
        widget.onSelected(prov);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Province> data = widget.provinces;
    if(_keyword != null){
      data = data.where((e) => e.nama.toLowerCase().contains(_keyword.toLowerCase())).toList();
    }
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(StrRes.SELECT_PROVINCE, style: H4.copyWith(color:Colors.black), textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          CupertinoTextField(
            prefix: Icon(Icons.search),
            placeholder: StrRes.SEARCH_PROVINCE,
            onSubmitted: (text){
              setState(() {
                _keyword = text;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ...data.map((e) => _buildProvinceItem(e)).toList()
              ],
            ),
          )
        ],
      ),
    );
  }
}


class CitySelector extends StatefulWidget {
  const CitySelector({
    Key key,
    @required List<City> cities, this.onSelected, this.selected
  }) : cities = cities, super(key: key);

  final Function onSelected;
  final City selected;
  final List<City> cities;

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  
  String _keyword;

  _buildCityItem(City city) {
    return ListTile(
      title: Text(city.nama),
      selected: widget.selected != null && city.id == widget.selected.id,
      onTap: () {
        widget.onSelected(city);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<City> data = widget.cities;
    if(_keyword != null){
      data = data.where((e) => e.nama.toLowerCase().contains(_keyword.toLowerCase())).toList();
    }
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(StrRes.SELECT_PROVINCE, style: H4.copyWith(color:Colors.black), textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          CupertinoTextField(
            prefix: Icon(Icons.search),
            placeholder: StrRes.SEARCH_PROVINCE,
            onSubmitted: (text){
              setState(() {
                _keyword = text;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ...data.map((e) => _buildCityItem(e)).toList()
              ],
            ),
          )
        ],
      ),
    );
  }
}