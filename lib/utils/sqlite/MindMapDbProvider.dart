// import 'package:FlutterMind/utils/sqlite/BaseDbProvider.dart';
// import 'package:sqflite/sqlite_api.dart';

// class MindMapDbProvider extends BaseDbProvider{
//   ///表名
//   final String name = 'FlutterMind';
//   final String columnId="id";

//   MindMapDbProvider();

//   @override
//   tableName() {
//     return name;
//   }

//   @override
//   createTableString() {
//    return '''
//         create table $name (
//         $columnId integer primary key,
//         )
//       ''';
//   }

//   Future _getProvider(Database db, int id) async {
//     List<Map<String, dynamic>> maps =
//     await db.rawQuery("select * from $name where $columnId = $id");
//     return maps;
//   }

//   // Future insert(String msg) async {
//   //   Database db = await getDataBase();
//   //   var userProvider = await _getProvider(db, 1);
//   //   if (userProvider != null) {
//   //     await db.delete(name, where: "$columnId = ?", whereArgs: [model.id]);
//   //   }
//   //   return await db.rawInsert("insert into $name ($columnId) values (?,?,?)",[1]);
//   // }

//   // Future<void> update(int id) async {
//     // Database database = await getDataBase();
//     // await database.rawUpdate(
//     //     "update $name set $columnMobile = ?,$columnHeadImage = ? where $columnId= ?",[model.mobile,model.headImage,model.id]);
//   // }
// }