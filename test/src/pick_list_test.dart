import 'package:deep_pick/deep_pick.dart';
import 'package:test/test.dart';

import 'pick_test.dart';

void main() {
  group('pick().asList*', () {
    group('asListOrThrow', () {
      test('pipe through List', () {
        expect(pick([1, 2, 3]).asListOrThrow((it) => it.asInt()), [1, 2, 3]);
      });

      test('null throws', () {
        expect(
          () => nullPick().asListOrThrow((it) => it.asString()),
          throwsA(pickException(containing: [
            'required value at location "unknownKey" in pick(json, "unknownKey" (absent)) is absent. Use asListOrEmpty()/asListOrNull() when the value may be null/absent at some point (List<String>?).'
          ])),
        );
      });

      test('map empty list to empty list', () {
        expect(
          pick([]).asListOrThrow((pick) => Person.fromJson(pick)),
          [],
        );
      });

      test('map to List<Person>', () {
        expect(
          pick([
            {'name': 'John Snow'},
            {'name': 'Daenerys Targaryen'},
          ]).asListOrThrow((pick) => Person.fromJson(pick)),
          [
            Person(name: 'John Snow'),
            Person(name: 'Daenerys Targaryen'),
          ],
        );
      });

      test('map to List<Person?>', () {
        expect(
          pick([
            {'name': 'John Snow'},
            {'name': 'Daenerys Targaryen'},
            null, // <-- valid value
          ]).asListOrThrow((pick) => Person.fromJson(pick)),
          [
            Person(name: 'John Snow'),
            Person(name: 'Daenerys Targaryen'),
            null,
          ],
        );
      });

      test('map reports item parsing errors', () {
        expect(
          () => pick([
            {'name': 'John Snow'},
            {'asdf': 'Daenerys Targaryen'}, // <-- missing name key
          ]).asListOrThrow((pick) => Person.fromJson(pick)),
          throwsA(pickException(containing: [
            'required value at location list index 1 in pick(json, 1 (absent), "name") is absent. Use asListOrEmpty()/asListOrNull() when the value may be null/absent at some point (List<Person>?).'
          ])),
        );
      });

      test('wrong type throws', () {
        expect(
          () => pick('Bubblegum').asListOrThrow((it) => it.asString()),
          throwsA(pickException(
              containing: ['Bubblegum', 'String', 'List<dynamic>'])),
        );
        expect(
          () => pick(Object()).asListOrThrow((it) => it.asString()),
          throwsA(pickException(containing: [
            'value Instance of \'Object\' of type Object at location "<root>" in pick(<root>) can not be casted to List<dynamic>'
          ])),
        );
      });
    });

    test('deprecated asList forwards to asListOrThrow', () {
      // ignore: deprecated_member_use_from_same_package
      expect(pick([1, 2, 3]).asList(), [1, 2, 3]);
      expect(
        // ignore: deprecated_member_use_from_same_package
        () => pick(Object()).asList(),
        throwsA(pickException(containing: [
          "value Instance of 'Object' of type Object at location `<root>` can not be casted to List<dynamic>"
        ])),
      );
    });

    group('asListOrEmpty', () {
      test('pick value', () {
        expect(pick([1, 2, 3]).asListOrEmpty((it) => it.asInt()), [1, 2, 3]);
      });

      test('null returns null', () {
        expect(nullPick().asListOrEmpty((it) => it.asInt()), []);
      });

      test('wrong type returns empty', () {
        expect(pick(Object()).asListOrEmpty((it) => it.asInt()), []);
      });

      test('map empty list to empty list', () {
        expect(
          pick([]).asListOrEmpty((pick) => Person.fromJson(pick)),
          [],
        );
      });

      test('map null list to empty list', () {
        expect(
          nullPick().asListOrEmpty((pick) => Person.fromJson(pick)),
          [],
        );
      });

      test('map to List<Person>', () {
        expect(
          pick([
            {'name': 'John Snow'},
            {'name': 'Daenerys Targaryen'},
          ]).asListOrEmpty((pick) => Person.fromJson(pick)),
          [
            Person(name: 'John Snow'),
            Person(name: 'Daenerys Targaryen'),
          ],
        );
      });

      test('map to List<Person?>', () {
        expect(
          pick([
            {'name': 'John Snow'},
            {'name': 'Daenerys Targaryen'},
            null, // <-- valid value
          ]).asListOrEmpty((pick) => Person.fromJson(pick)),
          [
            Person(name: 'John Snow'),
            Person(name: 'Daenerys Targaryen'),
            null,
          ],
        );
      });

      test('map reports item parsing errors', () {
        expect(
          () => pick([
            {'name': 'John Snow'},
            {'asdf': 'Daenerys Targaryen'}, // <-- missing name key
          ]).asListOrEmpty((pick) => Person.fromJson(pick)),
          throwsA(pickException(containing: [
            'required value at location list index 1 in pick(json, 1 (absent), "name") is absent.'
          ])),
        );
      });
    });

    group('asListOrNull', () {
      test('pick value', () {
        expect(pick([1, 2, 3]).asListOrNull((it) => it.asInt()), [1, 2, 3]);
      });

      test('null returns null', () {
        expect(nullPick().asListOrNull((it) => it.asInt()), isNull);
      });

      test('wrong type returns empty', () {
        expect(pick(Object()).asListOrNull((it) => it.asInt()), isNull);
      });

      test('map empty list to empty list', () {
        expect(
          pick([]).asListOrNull((pick) => Person.fromJson(pick)),
          [],
        );
      });

      test('map null list to null', () {
        expect(
          nullPick().asListOrNull((pick) => Person.fromJson(pick)),
          null,
        );
      });

      test('map to List<Person>', () {
        expect(
          pick([
            {'name': 'John Snow'},
            {'name': 'Daenerys Targaryen'},
          ]).asListOrNull((pick) => Person.fromJson(pick)),
          [
            Person(name: 'John Snow'),
            Person(name: 'Daenerys Targaryen'),
          ],
        );
      });

      test('map to List<Person?>', () {
        expect(
          pick([
            {'name': 'John Snow'},
            {'name': 'Daenerys Targaryen'},
            null, // <-- valid value
          ]).asListOrNull((pick) => Person.fromJson(pick)),
          [
            Person(name: 'John Snow'),
            Person(name: 'Daenerys Targaryen'),
            null,
          ],
        );
      });

      test('map reports item parsing errors', () {
        final data = [
          {'name': 'John Snow'},
          {'asdf': 'Daenerys Targaryen'}, // <-- missing name key
        ];
        expect(
          () => pick(data).asListOrNull((pick) => Person.fromJson(pick)),
          pickException(containing: [
            'required value at location list index 1 in pick(json, 1 (absent), "name") is absent.'
          ]),
        );
      });
    });
  });
}
