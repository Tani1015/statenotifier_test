import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:statenotifier_test/model/tag_model.dart';
import 'package:statenotifier_test/state/tag_state.dart';

import 'model/tag_model.dart';
import 'state/tag_state.dart';

void main() {
  runApp(
      const ProviderScope(
        child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const UserListView(),
    );
  }
}

final tagProvider = StateNotifierProvider.autoDispose<TagState,List<TagModel>>((ref)
  => TagState()
);

class UserListView extends StatefulHookConsumerWidget{
  const UserListView({Key? key}) : super(key: key);

  @override
  UserListState createState() => UserListState();
}

class UserListState extends ConsumerState<UserListView>{
  final TextEditingController searchController = TextEditingController();

  final List<TagModel> _tagsToSelect = [
    const TagModel(id: '1', title: 'JavaScript'),
    const TagModel(id: '2', title: 'Python'),
    const TagModel(id: '3', title: 'Java'),
    const TagModel(id: '4', title: 'PHP'),
    const TagModel(id: '5', title: 'C#'),
    const TagModel(id: '6', title: 'C++'),
    const TagModel(id: '7', title: 'Dart'),
    const TagModel(id: '8', title: 'DataFlex'),
    const TagModel(id: '9', title: 'Flutter'),
    const TagModel(id: '10', title: 'Flutter Selectable Tags'),
    const TagModel(id: '11', title: 'Android Studio developer'),
  ];

  String get searchText => searchController.text.trim();

  refresh(VoidCallback fn){
    if(mounted) setState(fn);
  }

  @override
  void initState(){
    super.initState();
    searchController.addListener(() => refresh(() { }));
  }

  @override
  void dispose(){
    super.dispose();
    searchController.dispose();
  }

  List<TagModel> filterSearchResultList() {
    if(searchText.isEmpty) return _tagsToSelect;

    List<TagModel> _templist = [];
    for(int index =0; index < _tagsToSelect.length; index++){
      TagModel tagModel = _tagsToSelect[index];
      if(tagModel.title.toLowerCase().trim()
          .contains(searchText.toLowerCase())
      ) {
        _templist.add(tagModel);
      }
    }
    return _templist;
  }

  Widget tagChip({
    tagModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  '${tagModel.title}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.orange.shade600,
                radius: 8.0,
                child: const Icon(
                  Icons.clear,
                  size: 10.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Tags'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _tagIcon(),
    );
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.local_offer_outlined,
          color: Colors.deepOrangeAccent,
          size: 25.0,
        ),
        _tagsWidget(),
      ],
    );
  }

  Widget _tagsWidget() {
    final tags = ref.watch(tagProvider);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tags',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
          tags.isNotEmpty
              ? Column(children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: tags
                  .map((tagModel) => tagChip(
                tagModel: tagModel,
                onTap: () => ref.read(tagProvider.notifier).removetag(tagModel),
                action: 'Remove',
              ))
                  .toSet()
                  .toList(),
            ),
          ])
              : Container(),
          _buildSearchFieldWidget(),
          _displayTagWidget(),
        ],
      ),
    );
  }

  Widget _buildSearchFieldWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 10.0,
        bottom: 10.0,
      ),
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 5.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        border: Border.all(
          color: Colors.grey.shade500,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search Tag',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          searchText.isNotEmpty
              ? InkWell(
            child: Icon(
              Icons.clear,
              color: Colors.grey.shade700,
            ),
            onTap: () => searchController.clear(),
          )
              : Icon(
            Icons.search,
            color: Colors.grey.shade700,
          ),
          Container(),
        ],
      ),
    );
  }

  _displayTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: filterSearchResultList().isNotEmpty
          ? _buildSuggestionWidget()
          : const Text('No Labels added'),
    );
  }

  Widget _buildSuggestionWidget() {
    final tags = ref.watch(tagProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (filterSearchResultList().length != tags.length) const Text('Suggestions'),
      Wrap(
        alignment: WrapAlignment.start,
        children: filterSearchResultList()
            .where((tagModel) => !tags.contains(tagModel))
            .map((tagModel) => tagChip(
          tagModel: tagModel,
          onTap: () => ref.read(tagProvider.notifier).addTag(tagModel),
          action: 'Add',
        ))
            .toList(),
      ),
    ]);
  }
}

