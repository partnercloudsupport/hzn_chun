import 'package:flutter/material.dart';
import 'package:hzn/utils/sql_util.dart';
import 'package:rxdart/rxdart.dart';

///地址选择器
class SelectAddressWidget extends StatefulWidget {
  SelectAddressWidget({Key key, @required this.valueCb}) : super(key: key);

  ///回调函数
  final Function valueCb;

  @override
  _SelectAddressWidgetState createState() => new _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends State<SelectAddressWidget>
    with SingleTickerProviderStateMixin {
  ///区域信息列表
  List<Dict> provincesList = new List<Dict>();
  List<Dict> citysList = new List<Dict>();
  List<Dict> distrctList = new List<Dict>();

  ///选择的省市县的名字
  String selectProvinceStr = '省份';
  String selectCityStr = '城市';
  String selectDistrictStr = '区/县';

  ///选择的省市县Id
  String selectProvinceId = "";
  String selectCityId = "";
  String selectDistrictId = "";

  ///当前Tab位置
  int currentTabPos = 0;

  Map<String, String> selectMap = new Map();

  ///Tab Text样式
  TextStyle tabTvStyle = new TextStyle(
      color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///给区域Id Map一个初始值
    selectMap['selectProvinceId'] = "";
    selectMap['selectCityId'] = "";
    selectMap['selectDistrictId'] = "";

    ///第一次进来 这里调用我自己的接口 查询全国的所有省 可以替换成其他
    _queryLocalProvinces("0");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        ///去掉左箭头
        automaticallyImplyLeading: false,
        title: new Text(
          '配送至',
          style: new TextStyle(color: const Color(0xff666666)),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.close,
                color: const Color(0xff666666),
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: _getBody(),
    );
  }

  ///构建底部视图
  Widget _getBody() {
    if (_showLoadingDialog()) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return _buildContent();
    }
  }

  ///根据数据是否有返回显示加载条或者列表
  bool _showLoadingDialog() {
    if (provincesList == null || provincesList.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  ///有数据时构建tab和区域列表
  Widget _buildContent() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 15.0)),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: new Text(
                  '$selectProvinceStr',
                  style: tabTvStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: new Text(
                  '$selectCityStr',
                  style: tabTvStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: new Text(
                  '$selectDistrictStr',
                  style: tabTvStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          new Padding(padding: const EdgeInsets.only(top: 18.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 240,
                child: _buildProvincesView(),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 240,
                child: _buildCitysView(),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 240,
                child: _buildDistrctsView(),
              ),
            ],
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  ///构建列表
  Widget _buildProvincesView() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: provincesList.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildProvinceItem(position);
      },
    );
  }

  ///构建列表
  Widget _buildCitysView() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: citysList.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildCityItem(position);
      },
    );
  }

  ///构建列表
  Widget _buildDistrctsView() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: distrctList.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildDistrictItem(position);
      },
    );
  }

  ///构建子项
  Widget _buildProvinceItem(int position) {
    return Container(
        height: 35,
        child: new ListTile(
          title: new Text(
            '${provincesList[position].name}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(color: const Color(0xff666666), fontSize: 15.0),
          ),
          onTap: () => _onLocalSelect(position, 0),
        ));
  }

  ///构建子项
  Widget _buildCityItem(int position) {
    return Container(
        height: 35,
        child: new ListTile(
          title: new Text(
            '${citysList[position].name}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style:
                new TextStyle(color: const Color(0xff666666), fontSize: 15.0),
          ),
          onTap: () => _onLocalSelect(position, 1),
        ));
  }

  ///构建子项
  Widget _buildDistrictItem(int position) {
    return Container(
        height: 35,
        child: new ListTile(
          title: new Text(
            '${distrctList[position].name}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style:
                new TextStyle(color: const Color(0xff666666), fontSize: 15.0),
          ),
          onTap: () => _onLocalSelect(position, 2),
        ));
  }

  ///区域位置选择
  _onLocalSelect(int position, int tabIndex) {
    _setSelectData(position, tabIndex);
    if (tabIndex == 0) {
      _queryLocalCitys(provincesList[position].id);
    }
    if (tabIndex == 1) {
      _queryLocalDistricts(citysList[position].id);
    }
  }

  ///设置选择的数据
  ///根据当前选择的列表项的position 和 Tab的currentTabPos
  ///@params position 当前列表选择的省或市或县的position
  _setSelectData(position, int tabIndex) {
    if (tabIndex == 0) {
      selectProvinceId = provincesList[position].id;
      selectProvinceStr = provincesList[position].name;
      selectMap['provinceId'] = selectProvinceId;
      setState(() {
        selectCityStr = '城市';
        selectDistrictStr = '区/县';
      });
      selectCityId = "";
      selectDistrictId = "";
    }

    if (tabIndex == 1) {
      selectCityId = citysList[position].id;
      selectCityStr = citysList[position].name;
      selectMap['selectCityId'] = selectCityId;
      setState(() {
        selectDistrictStr = '区/县';
      });
      selectDistrictId = "";
    }
    if (tabIndex == 2) {
      selectDistrictId = distrctList[position].id;
      selectDistrictStr = distrctList[position].name;
      selectMap['selectDistrictId'] = selectDistrictId;

      ///拼接区域字符串 回调给上个页面 关闭弹窗
      String localStr =
          selectProvinceStr + ' ' + selectCityStr + ' ' + selectDistrictStr;
      widget.valueCb(selectMap, localStr);
      Navigator.pop(context);
    }
  }

  _queryLocalProvinces(String parentId) async {
    var provinces = List<Dict>();
    List<Map<String, dynamic>> provinceMaps =
        await SqlUtil.getInstance(context).getChildsByPid(parentId);
    Observable.fromIterable(provinceMaps)
        .map((Map<String, dynamic> map) => Dict.fromMap(map))
        .listen((Dict dict) => provinces.add(dict));
    setState(() {
      provincesList = provinces;
    });

    if (provincesList != null && provincesList.length > 0) {
      var province = provincesList.elementAt(0);
      _queryLocalCitys(province.id);
    }
  }

  _queryLocalCitys(String parentId) async {
    var citys = List<Dict>();
    List<Map<String, dynamic>> cityMaps =
        await SqlUtil.getInstance(context).getChildsByPid(parentId);
    Observable.fromIterable(cityMaps)
        .map((Map<String, dynamic> map) => Dict.fromMap(map))
        .listen((Dict dict) => citys.add(dict));

    setState(() {
      citysList = citys;
    });

    if (citysList != null && citysList.length > 0) {
      var city = citysList.elementAt(0);
      _queryLocalDistricts(city.id);
    }
  }

  _queryLocalDistricts(String parentId) async {
    var districts = List<Dict>();
    List<Map<String, dynamic>> districtMaps =
        await SqlUtil.getInstance(context).getChildsByPid(parentId);
    Observable.fromIterable(districtMaps)
        .map((Map<String, dynamic> map) => Dict.fromMap(map))
        .listen((Dict dict) {
      districts.add(dict);

      if (districts.length == 0) {
        String localStr = selectProvinceStr + ' ' + selectCityStr;
        widget.valueCb(selectMap, localStr);
        Navigator.pop(context);
      }

      setState(() {
        distrctList = districts;
      });
    });

    ///这里防止没有区的城市查询不到还不会关闭对话框回调到地址页面 例如三亚市
  }

  @override
  void dispose() {
    super.dispose();
  }
}
