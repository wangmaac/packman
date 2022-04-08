import 'package:flutter/material.dart';

enum EnemyState { start, moving, block }
enum Direction { left, right, up, down, hold }
enum GameState { over, finish, game }

List<int> pathPoint = [];
List<int> getPoint = [];
final List<int> barriers = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  22,
  33,
  44,
  55,
  66,
  77,
  99,
  110,
  121,
  132,
  143,
  154,
  164,
  153,
  142,
  131,
  120,
  109,
  87,
  76,
  65,
  54,
  43,
  32,
  21,
  78,
  100,
  24,
  35,
  46,
  57,
  79,
  101,
  123,
  134,
  145,
  156,
  80,
  102,
  26,
  37,
  59,
  70,
  81,
  103,
  114,
  125,
  147,
  158,
  38,
  148,
  28,
  39,
  61,
  72,
  83,
  105,
  116,
  127,
  149,
  160,
  84,
  106,
  30,
  41,
  52,
  63,
  85,
  107,
  129,
  140,
  151,
  162,
  86,
  108,
  165,
  175,
  176,
  177,
  178,
  179,
  180,
  181,
  182,
  183,
  184,
  185,
  186,
];
