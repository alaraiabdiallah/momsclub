import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/widgets/contact_comm_tab.dart';
import 'package:momsclub/widgets/follower_comm_tab.dart';
import 'package:momsclub/widgets/info_comm_tab.dart';

class CommunityScreen extends StatefulWidget {
  final Community data;

  const CommunityScreen({Key key, this.data}) : super(key: key);
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  TabController _tab_controller;
  @override
  void initState() {
    super.initState();
    _tab_controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(widget.data.name),
            pinned: true,
            backgroundColor: AppColor.PRIMARY,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.data.imageURL),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              controller: _tab_controller,
              tabs: [
                Tab(icon: Icon(Icons.info)),
                Tab(icon: Icon(Icons.supervised_user_circle)),
                Tab(icon: Icon(Icons.phone)),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tab_controller,
              children: <Widget>[
                InfoCommunityTab(text: widget.data.desc),
                FollowersCommunityTab(),
                ContactCommunityTab(data: widget.data.contacts,),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
          backgroundColor: AppColor.PRIMARY,
          child: Icon(Icons.favorite_border),
      ),
    );
  }
}
