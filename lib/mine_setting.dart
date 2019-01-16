import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hzn/addresses_page.dart';
import 'package:hzn/model/user_save_bean.dart';
import 'package:hzn/repwd_page.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';
import 'package:tip_dialog/tip_dialog.dart';



 class MineSettingPage extends StatefulWidget{

   var userName;

   MineSettingPage(this.userName);

  @override
  State<StatefulWidget> createState() {
    return new MineSettingState(this.userName);
  }

 }

 class MineSettingState extends State<MineSettingPage>{

   final nameController = TextEditingController();
   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
   var userName;

   TipDialogController tipController;

   MineSettingState(this.userName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new TipDialogConnector(
      builder: (context, tipController) {
        this.tipController = tipController;
        return layout(context);
      },
    );
  }


  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: barColor,
        title: const Text(
          '设置',
          textAlign: TextAlign.center,
        ));
  }

  Widget layout(BuildContext context){
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(left: 15,right: 10,top:8),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.perm_contact_calendar ,color: lightBlue,size: 24,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("修改用户名" ,style: TextStyle(fontSize: 16,color: Colors.black87),),
                ),
                Text(userName ,style: TextStyle(fontSize: 16,color: Colors.black87),),
                Icon(Icons.arrow_forward_ios ,color: Colors.grey,size: 20,)
              ],
            ),
          ),
          onTap: (){
            showAlertDialog(context);
          },
        ),

        Divider(color: Colors.grey,),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(left: 15,right: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.security ,color: lightBlue,size: 24,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("修改密码" ,style: TextStyle(fontSize: 16,color: Colors.black87),),
                ),
                Icon(Icons.arrow_forward_ios ,color: Colors.grey,size: 20,)
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
                  return new RePwdPage();
                }));
          },
        ),
        Divider(color: Colors.grey,),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(left: 15,right: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.local_shipping ,color: lightBlue,size: 24,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("收货地址管理" ,style: TextStyle(fontSize: 16,color: Colors.black87),),
                ),
                Text(userName ,style: TextStyle(fontSize: 16,color: Colors.black87),),
                Icon(Icons.arrow_forward_ios ,color: Colors.grey,size: 20,)
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
                  return new AddressesPage();
                }));
          },
        ),

        Divider(color: Colors.grey,),
      ],
    );
  }




   void showAlertDialog(BuildContext context) {
     nameController.text = this.userName;
     showDialog<bool>(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return AlertDialog(
           title:const Text(
             '修改用户名',
           ),
           content: _buildNameField(nameController),
           actions: <Widget>[
             FlatButton(
               child: const Text('取消'),
               onPressed: () {
                 Navigator.of(context).pop(true);
               },
             ),
             FlatButton(
               child: const Text('确定'),
               onPressed: () {
                 Navigator.of(context).pop(true);
                 var name = nameController.text;
                 save(name);
               },
             ),
           ],
         );
       },
     );
   }

   Widget _buildNameField(TextEditingController controller) {
     return new Container(
         height: 50,
         margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
         child: TextField(
           decoration: InputDecoration(
               contentPadding: EdgeInsets.all(10.0),
               border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   borderSide: BorderSide(
                       color: Colors.grey,
                       width: 1.0,
                       style: BorderStyle.solid) //没什么卵效果
               ),
               labelText: '请输入新的用户名'),
           controller: controller,
           maxLines: 1,
           autocorrect: true,
           autofocus: true,
           obscureText: false,
           //是否是密码
           textAlign: TextAlign.center,
           //文本对齐方式
           style: TextStyle(fontSize: 14.0, color: Colors.grey),
           keyboardType: TextInputType.text,
           enabled: true, //是否禁用
         ));
   }



   //下单
   Future<Null> save(String name) async {
     if (!networkEnable) {
       _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('网络开小差了~~')));
       return;
     }

     FormData formData = new FormData.from({
       "realName":"$name",
     });

     var resData = await HttpUtil.getInstance().post(I_USER_SAVE, context,data: formData,tip:tipController);
     var userSaveBean = UserSaveBean.fromJson(resData);
     if(userSaveBean.success){
       showToast("修改成功");
       setState(() {
         this.userName = name;
       });
     }else{
       showToast("${userSaveBean.msg}");
     }
   }



 }