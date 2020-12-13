function myAddDiyDom(treeId, treeNode) {
    //treeId 是整个树形结构附着的ul标签的id
    console.log("treeid是:" +treeId);
    //当前树形节点的全部的数据，包括从后端查询得到的menu对象的全部属性
    console.log(treeNode);
    //zTree生成id的规则
    //例子：treeDemo_7_ico
    //解析：ul标签的id_当前节点的序号_功能
    // 提示：“ul标签的id_当前节点的序号”部分可以通过访问treeNode的tId属性得到
    //根据id生成规则拼接出来span标签的id
    var spanId = treeNode.tId+"_ico";
    //根据控制图标的span标签的id找到这个span标签
    //删除旧的class添加新的class
    $("#"+spanId)
        .removeClass()
        .addClass(treeNode.icon);
}