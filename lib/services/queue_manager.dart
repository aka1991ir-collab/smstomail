import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QueueManager {
  late Database _db;

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'sms_queue.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE queue(id INTEGER PRIMARY KEY, sender TEXT, body TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> addMessage(String sender, String body) async {
    await _db.insert('queue', {'sender': sender, 'body': body});
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    return await _db.query('queue');
  }

  Future<void> removeMessage(int id) async {
    await _db.delete('queue', where: 'id = ?', whereArgs: [id]);
  }
}
