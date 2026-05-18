import '../../types/domain_models.dart';

abstract class RoomService {
  Future<Room> createRoom(Room room);

  Future<Room> getRoom(String roomId);

  Future<void> joinRoom(String roomId);

  Future<void> leaveRoom(String roomId);

  Future<Room> updateRoomSettings(Room room);

  Future<void> inviteFriends({
    required String roomId,
    required List<String> friendIds,
  });
}
