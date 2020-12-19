//执行分页，生成页面效果，任何时候调用这个函数都会重新加载页面
function generatePage() {
    //1 获取分页数据
    var pageInfo = getPageInfoRemote();
    //2 填充表格
    fillTableBody(pageInfo);

}

//远程访问服务器端程序获取pageInfo数据
function getPageInfoRemote() {
    //调用$.ajax()函数发送请求并接受$.ajax()函数的返回值
    var ajaxResult = $.ajax({
        "url": "role/get/page/info.json",
        "type": "post",
        "data": {
            "pageNum": window.pageNum,
            "pageSize": window.pageSize,
            "keyword": window.keyword
        },
        // 修改同步异步需要在  数据解析之前
        "async": false,
        //返回数据的解析方式
        "dataType": "json"
    });
    // console.log(ajaxResult);
    //判断当前响应状态码是不是200
    var statusCode = ajaxResult.status;
    //若当前响应状态码不是200，怎表示发生了错误或其他情况，显示提示信息，让当前函数停止执行。
    if (statusCode != 200) {
        layer.msg("失败！响应状态码=" + statusCode + "说明信息=" + ajaxResult.statusText);
        return null;
    }
    //如果响应状态码是200，说明请求处理成功，获取pageInfo
    var resultEntity = ajaxResult.responseJSON;
    //从resultEntity中获取result属性
    var result = resultEntity.result;
    // 判断result是否成功
    if (result == "FAILED") {
        layer.msg(resultEntity.message);
        return null;
    }
    //确认result成功后获取pageInfo
    var pageInfo = resultEntity.data;
    //返回pageInfo
    return pageInfo;
}

//填充表格
function fillTableBody(pageInfo) {
    // 清除tbody中的旧数据
    $("#rolePageBody").empty();
    //为了在登录超时以及无查询数据时不显示导航条
    $("#Pagination").empty();

    //判断pageInfo是否有效
    if (pageInfo == null || pageInfo == undefined || pageInfo.list == null || pageInfo.list.length == 0) {
        //向<tBody>中填充信息。
        $("#rolePageBody").append("<tr><td colspan='4' align='center'>抱歉没有查询到搜索的数据</td></tr>");
        return;
    }
    // layer.msg("pageInfo有效")
    //使用pageInfo 的list属性填充tbody
    for (var i = 0; i < pageInfo.list.length; i++) {

        var role = pageInfo.list[i];
        var roleId = role.id;
        var roleName = role.name;

        var numberTd = "<td>" + (i + 1) + "</td>";
        var checkBoxTd = "<td><input id='" + roleId + "' class='itemBox' type='checkbox'></td>";
        var roleNameTd = "<td>" + roleName + "</td>";

        var checkBtn = "<button id='" + roleId + "' type='button' class='btn btn-success btn-xs checkBtn'><i class='glyphicon glyphicon-check'></i></button>";
        //通过button标签的id属性或其他属性，吧roleid值传递到button按钮的单机响应函数中，再单击响应函数中使用this.id
        var pencilBtn = "<button id='" + roleId + "' type='button' class='btn btn-primary btn-xs pencilBtn'><i class=' glyphicon glyphicon-pencil'></i></button>";
        //通过button标签的id属性或其他属性，吧roleid值传递到button按钮的单机响应函数中，再单击响应函数中使用this.id
        var removeBtn = "<button id='" + roleId + "' type='button' class='btn btn-danger btn-xs removeBtn'><i class=' glyphicon glyphicon-remove'></i></button>";
        var buttonTd = "<td>" + checkBtn + " " + pencilBtn + " " + removeBtn + " " + "</td>";
        var tr = "<tr>" + numberTd + checkBoxTd + roleNameTd + buttonTd + "</tr>";
        $("#rolePageBody").append(tr);
    }
    //生成分页导航条
    generateNavigator(pageInfo);
}

//生成分页页码导航条
function generateNavigator(pageInfo) {
    //获取总记录数
    var totalRecord = pageInfo.total;
    //声明相关属性
    var properties = {
        num_edge_entries: 2,
        num_display_entries: 3,
        callback: paginationCallBack,
        items_per_page: pageInfo.pageSize,
        current_page: pageInfo.pageNum - 1,
        prev_text: "上一页",
        next_text: "下一页"
    }
    //调用pagination初始化函数
    $("#Pagination").pagination(totalRecord, properties);
}

//分页的回调函数
function paginationCallBack(pageIndex, jQuery) {
    //翻页时调用回调函数
    //修改window对象的pageNum属性
    window.pageNum = pageIndex + 1;
    //调用分页函数
    generatePage();
    // 取消页码超链接的默认行为
    return false;
}

//声明专门的函数显示确认模态框
function showConfirmModal(roleArray) {
    //打开模态框
    $("#confirmModal").modal("show");
    //清除旧数据
    $("#roleNameDiv").empty();
    //roleId 非全局变量只能在本函数用所以将其变为全局变量，方便下个函数调用并发往后台服务器
    window.roleIdArray = [];
    //遍历roleArray数组
    for (var i = 0; i < roleArray.length; i++) {
        var role = roleArray[i];
        var roleName = role.roleName;
        //写入 roleNameSpan
        $("#roleNameDiv").append(roleName + "<br>");
        var roleId = role.roleId;
        //调用数组对象的push（）方法存入新元素
        window.roleIdArray.push(roleId);
    }
}
function fillAuthTree() {
    //1 发送ajax请求查询Auth数据
    var ajaxReturn = $.ajax({
        "url":"assign/get/all/auth.json",
        "type":"post",
        "dataType":"json",
        "async":false,
    });
    if(ajaxReturn.status != 200){
        layer.msg("请求处理出错！响应状态码是："+ajaxReturn.status+"说明是： "+ajaxReturn.statusText);
        return;
    }
    //2 从响应结果中获取Auth的JSON数据
    //从服务器端查询到的list不需要组装成树形结构，这里我们交给zTree去组装
    var authList = ajaxReturn.responseJSON.data;
    //3 准备对zTree进行设置的JSON对象
    var setting = {
        data: {
            simpleData: {
                //开启简单json功能 ，不需要我们自己做嵌套
                enable: true,
                // 修改pid的关联节点名称为categoryId，让其作为pid
                pIdKey: "categoryId",
            },
            key:{
                //使用title属性显示节点名称，不用默认的name作为属性名
                name:"title"
            }
        },
        check:{
            "enable":true
        }
    };
    // 4生成树形结构
    $.fn.zTree.init($("#treeDemo"),setting,authList);
    // 获取ztree对象
    var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
    // 调用zTreeObj对象的方法，把节点展开
    zTreeObj.expandAll(true);
    //5 查询已分配的Auth的id组成的数组
    var ajaxReturn = $.ajax({
       "url":"assign/get/assigned/auth/id/by/role/id.json",
       "type":"post",
        "data":{
           "roleId":window.roleId
        },
       "dataType":"json",
        "async":false,
    });
    if(ajaxReturn.status !=200){
        layer.msg("请求处理出错！响应状态码是："+ajaxReturn.status+"说明是： "+ajaxReturn.statusText);
        return;
    }
    //从响应结果中获取authIdArray
    var authIdArray = ajaxReturn.responseJSON.data;
    //6 根据authIdArray把树形节点中的对应节点勾选上
    //6.1 遍历数组
    for(var i=0;i<authIdArray.length;i++){
        var authId = authIdArray[i];
        //6.2 根据id查找对应的节点
        var treeNode = zTreeObj.getNodeByParam("id",authId);
        //6.3 将treeNode设置为勾选状态
        var checked = true;
        //6.4 checkTypeFlag 设置为false，表示不“联动”，不联动是为了避免把不该勾选的勾选上
        var checkTypeFlag = false;
        //执行
        zTreeObj.checkNode(treeNode,checked,checkTypeFlag);
    }
}
