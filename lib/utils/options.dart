import 'package:dio/dio.dart';
import 'package:hzn/utils/sp_uitls.dart';

int pageSize = 50;
bool networkEnable = true;


Options _options= new Options(
    baseUrl:"http://api.huozhiniao.cn",
    connectTimeout:5000,
    receiveTimeout:3000,
    headers: {}
);
Dio dio = new Dio(_options);



/*******接口*******/
final I_SPLASH = "/api/public/splashs";


final I_LOGIN = "/api/user/login";
final I_VAILD_CODE = "/api/public/registerCode";
final I_REG = "/api/user/register";
final I_LOGOUT = "/api/user/logout";
final I_CHANGE_PWD = "/api/user/updatePwd";

final I_BANNER = "/api/index/banners";
final I_PRODUCTS = "/api/index/goods";
final I_PRODUCT_DETAIL = "/api/index/goods/detail";

//支付
final I_PAY= "/api/order/pay";


//设备列表
final I_DEVICES = "/api/device/list";
final I_OPEN_LOCK = "/api/device/openLock";    //开锁
final I_REMOVE_LOCK = "/api/device/delete"; //移除设备
final I_ADD_LOCK = "/api/device/add";    //添加设备



final I_ADD_ORDER = "/api/order/add"; //下单
final I_ORDER_LIST="/api/order/list"; // 订单列表



final I_USER_INFO= "/api/user/info";
final I_USER_SAVE = "/api/user/save";
final I_MOUDLE = "/api/public/moduleSeat/{moduleId}";

//图片上传
final I_FILE_UPLOAD = "/api/user/upload";

//未支付订单 删除
final I_DEL_ORDER = "/api/order/del";

//收货地址
final I_ADDRESS_LIST = "/api/user/address/list";
//新增地址
final I_ADD_ADDRESS = "/api/user/address/add";
//收货地址
final I_DEL_ADDRESS = "/api/user/address/del ";
//修改收货地址
final I_EDIT_ADDRESS = "/api/user/address/update";




