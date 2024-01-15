// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      uid: json['uid'] as String,
      firstPlayer: json['firstPlayer'] == null
          ? null
          : UserModel.fromJson(json['firstPlayer'] as Map<String, dynamic>),
      secondPlayer: json['secondPlayer'] == null
          ? null
          : UserModel.fromJson(json['secondPlayer'] as Map<String, dynamic>),
      currentTurn: json['currentTurn'] as String?,
      winner: json['winner'] as String?,
      status: $enumDecode(_$GameStatusEnumMap, json['status']),
      board: (json['board'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'firstPlayer': instance.firstPlayer == null
          ? null
          : instance.firstPlayer!.toJson(),
      'secondPlayer': instance.secondPlayer == null
          ? null
          : instance.secondPlayer!.toJson(),
      'currentTurn': instance.currentTurn,
      'winner': instance.winner,
      'status': _$GameStatusEnumMap[instance.status]!,
      'board': instance.board,
    };

const _$GameStatusEnumMap = {
  GameStatus.waiting: 'waiting',
  GameStatus.playing: 'playing',
  GameStatus.finished: 'finished',
};
