import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final List _list = [];
  int _page = 1;
  bool hasMore = true; //判断有没有数据
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getData();

    //监听滚动条事件
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 40) {
        _getData();
      }
    });
  }

  void _getData() async {
    if (hasMore) {
      var apiUrl =
          "http://www.phonegap100.com/appapi.php?a=getPortalList&catid=20&page=$_page";

      var response = await Dio().get(apiUrl);
      var res = json.decode(response.data)["result"];
      setState(() {
        _list.addAll(res); //拼接
        _page++;
      });
      //判断是否是最后一页
      if (res.length < 20) {
        setState(() {
          hasMore = false;
        });
      }
    }
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {
      print('请求数据完成');
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _list.length > 0
        ? RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _list.length, //20
              itemBuilder: (context, index) {
                //19
                if (index == _list.length - 1) {
                  //列表渲染到最后一条的时候加一个圈圈
                  //拉到底
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("${_list[index]["title"]}", maxLines: 1),
                        onTap: () {
                          Navigator.pushNamed(context, '/newscontent',
                              arguments: {"aid": _list[index]["aid"]});
                        },
                      ),
                      const Divider(),
                      _getMoreWidget()
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("${_list[index]["title"]}", maxLines: 1),
                        onTap: () {
                          Navigator.pushNamed(context, '/newscontent',
                              arguments: {"aid": this._list[index]["aid"]});
                        },
                      ),
                      const Divider()
                    ],
                  );
                }
              },
            ))
        : _getMoreWidget();
  }

  //加载中的圈圈
  Widget _getMoreWidget() {
    if (hasMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '加载中...',
                style: TextStyle(fontSize: 16.0),
              ),
              CircularProgressIndicator(
                strokeWidth: 1.0,
              )
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: Text("--我是有底线的--"),
      );
    }
  }
}
