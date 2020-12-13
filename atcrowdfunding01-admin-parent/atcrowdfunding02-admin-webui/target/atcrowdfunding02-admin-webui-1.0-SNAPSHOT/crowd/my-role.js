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
    if (pageInfo == null || pageInfo == undefined || pageInfo.list == null ||pageInfo.list.length == 0) {
        //向<tBody>中填充信息。
        $("#rolePageBody").append("<tr><td colspan='4' align='center'>抱歉没有查询到搜索的数据</td></tr>");
        return ;
    }
    // layer.msg("pageInfo有效")
    //使用pageInfo 的list属性填充tbody
    for(var i = 0;i<pageInfo.list.length;i++){

        var role = pageInfo.list[i];
        var roleId = role.id;
        var roleName = role.name;

        var numberTd = "<td>"+(i+1)+"</td>";
        var checkBoxTd = "<td><input id='"+roleId+"' class='itemBox' type='checkbox'></td>";
        var roleNameTd = "<td>"+roleName+"</td>";

        var checkBtn = "<button type='button' class='btn btn-success btn-xs'><i class='glyphicon glyphicon-check'></i></button>";
        //通过button标签的id属性或其他属性，吧roleid值传递到button按钮的单机响应函数中，再单击响应函数中使用this.id
        var pencilBtn = "<button id='"+roleId+"' type='button' class='btn btn-primary btn-xs pencilBtn'><i class=' glyphicon glyphicon-pencil'></i></button>";
        //通过button标签的id属性或其他属性，吧roleid值传递到button按钮的单机响应函数中，再单击响应函数中使用this.id
        var removeBtn = "<button id='"+roleId+"' type='button' class='btn btn-danger btn-xs removeBtn'><i class=' glyphicon glyphicon-remove'></i></button>";
        var buttonTd ="<td>"+checkBtn+" "+pencilBtn+" "+removeBtn+" "+"</td>";
        var tr = "<tr>"+numberTd+checkBoxTd+roleNameTd+buttonTd+"</tr>";
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
        num_edge_entries:2,
        num_display_entries:3,
        callback:paginationCallBack,
        items_per_page:pageInfo.pageSize,
        current_page:pageInfo.pageNum-1,
        prev_text: "上一页",
        next_text: "下一页"
    }
    //调用pagination初始化函数
    $("#Pagination").pagination(totalRecord,properties);
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
    for(var i=0;i<roleArray.length;i++){
        var role = roleArray[i];
        var roleName = role.roleName;
        //写入 roleNameSpan
        $("#roleNameDiv").append(roleName+"<br>");
        var roleId = role.roleId;
        //调用数组对象的push（）方法存入新元素
        window.roleIdArray.push(roleId);
    }
}
