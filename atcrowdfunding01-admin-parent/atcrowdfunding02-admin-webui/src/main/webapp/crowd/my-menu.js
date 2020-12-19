//生成树形结构的函数
function generateTree() {
    //1 准备生成树形结构的JSON数据，数据的来源是发送ajax请求得到
    $.ajax({
        "url": "menu/get/whole/tree.json",
        "type": "post",
        "dataType": "json",
        "success": function (response) {
            var result = response.result;
            if (result == "SUCCESS") {
                //2 创建一个json对象用于存放对ztree做的各种设置
                var setting = {
                    view: {
                        addDiyDom: myAddDiyDom,
                        addHoverDom: myAddHoverDom,
                        removeHoverDom: myRemoveHoverDom
                    },
                    //data 下的key下的url实现点击不跳转，url给任意不存在的属性名即可
                    data: {
                        key: {
                            url: "dontJump",
                        },
                    },
                };

                //3 从响应体中获取用来生成树形结构的JSON数据。
                var zNodes = response.data;
                //4 初始化树形结构
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            }
            if (result == "FAILED") {
                layer.msg(response.message);
            }
        },
        "error": function (response) {
            layer.msg(response.status + " " + response.statusText);
        },
    });
}
function myAddDiyDom(treeId, treeNode) {
    //treeId 是整个树形结构附着的ul标签的id
    // console.log("treeid是:" + treeId);
    //当前树形节点的全部的数据，包括从后端查询得到的menu对象的全部属性
    // console.log(treeNode);
    //zTree生成id的规则
    //例子：treeDemo_7_ico
    //解析：ul标签的id_当前节点的序号_功能
    // 提示：“ul标签的id_当前节点的序号”部分可以通过访问treeNode的tId属性得到
    //根据id生成规则拼接出来span标签的id
    var spanId = treeNode.tId + "_ico";
    //根据控制图标的span标签的id找到这个span标签
    //删除旧的class添加新的class
    $("#" + spanId)
        .removeClass()
        .addClass(treeNode.icon);
}

function myAddHoverDom(treeId, treeNode) {
    //按钮的标签结构<span><a><i></i></a><a><i></i></a></span>
    //按钮组出现的位置：节点中treeDemo_n_a超链接的后面
    var anchorId = treeNode.tId + "_a";
    // 为了后续能移除span则给span添加id
    var btnGroupId = "btnGroup" + treeNode.tId;

    // 判断以前是否已经添加了按钮组
    if ($("#" + btnGroupId).length > 0) {
        return;
    }

    //准备各个按钮的HTML标签
    var addBtn = "<a id='" + treeNode.id + "' " +
        "class='addBtn btn btn-info dropdown-toggle btn-xs' styl='margin-left:10px;padding-top:0px;' href='#' title='添加子节点'>" +
        "&nbsp;&nbsp;<i class='fa fa-fw fa-plus rbg '></i></a>";
    var editBtn = "<a id='" + treeNode.id + "' " +
        "class= 'editBtn btn btn-info dropdown-toggle btn-xs' styl='margin-left:10px;padding-top:0px;' href='#' title='修改子节点'>" +
        "&nbsp;&nbsp;<i class='fa fa-fw fa-edit rbg '></i></a>";
    var removeBtn = "<a id='" + treeNode.id + "' " +
        "class= 'removeBtn btn btn-info dropdown-toggle btn-xs' styl='margin-left:10px;padding-top:0px;' href='#' title='删除子节点'>" +
        "&nbsp;&nbsp;<i class='fa fa-fw fa-times rbg '></i></a>";

    // 获取当前节点的级别数据
    var level = treeNode.level;
    // 声明变量存储拼装好的按钮代码
    var btnHtml = "";
    //判断当前节点的级别
    if (level == 0) {
        btnHtml = addBtn;
    }
    if (level == 1) {
        btnHtml = addBtn + " " + editBtn;
        var length = treeNode.children.length;
        if (length == 0) {
            btnHtml = btnHtml + " " + removeBtn;
        }
    }
    if (level == 2) {
        btnHtml = editBtn + " " + removeBtn;
    }

    //执行在超链接后面附加span元素的操作
    $("#"+anchorId).after("<span id='"+btnGroupId+"'>"+btnHtml+"</span>")
}

function myRemoveHoverDom(treeId, treeNode) {
    var btnGroupId = "btnGroup" + treeNode.tId;
    $("#" + btnGroupId).remove();
}
