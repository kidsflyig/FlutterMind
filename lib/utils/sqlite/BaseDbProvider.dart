// import 'package:FlutterMind/utils/sqlite/SqlManager.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:meta/meta.dart';

// /**
//  * Created with IntelliJ IDEA.
//  * Package: db
//  * Author: sirai
//  * Create Time: 2019-06-27 15:29
//  * QQ: 785716471
//  * Email: 785716471@qq.com
//  * Description:数据库表
//  */

// abstract class BaseDbProvider {
//   bool isTableExits = false;

//   createTableString();

//   tableName();

//   ///创建表sql语句
//   tableBaseString(String sql) {
//     return sql;
//   }

//   Future<Database> getDataBase() async {
//     return await open();
//   }

//   ///super 函数对父类进行初始化
//   @mustCallSuper
//   prepare(name, String createSql) async {
//     isTableExits = await SqlManager.isTableExits(name);
//     if (!isTableExits) {
//       Database db = await SqlManager.getCurrentDatabase();
//       return await db.execute(createSql);
//     }
//   }

//   @mustCallSuper
//   open() async {
//     if (!isTableExits) {
//       await prepare(tableName(), createTableString());
//     }
//     return await SqlManager.getCurrentDatabase();
//   }

// }