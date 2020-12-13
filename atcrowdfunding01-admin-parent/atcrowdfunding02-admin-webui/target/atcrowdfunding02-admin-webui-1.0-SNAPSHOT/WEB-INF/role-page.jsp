<%--
  Created by IntelliJ IDEA.
  User: zkwuf
  Date: 2020/12/5
  Time: 14:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css">
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>
<script type="text/javascript" src="crowd/my-role.js"></script>
<script type="text/javascript">
    $(function () {
        //1 为分页操作初始化数据
        window.pageNum = 1;
        window.pageSize = 5;
        window.keyword = "";
        //2 调用执行分页的函数，显示分页效果
        generatePage();
        //3 给查询按钮绑定单机响应函数
        $("#searchBtn").click(function () {
            //0 设置页面为第一页
            window.pageNum = 1;
            //1 获取关键词数据赋值给对应的全局变量
            window.keyword = $("#keywordInput").val();
            //2 调用分页函数刷新页面
            generatePage();
        });
        //4 点击新增按钮，打开模态框
        $("#showAddModalBtn").click(function () {
            $("#addModal").modal("show");
        });
        //5 给新增的模态框按钮绑定单机响应函数
        $("#saveRoleBtn").click(function () {
            //获取用户在文本框中输入的角色名称
            //#addModal表示找到整个模态框
            //空格表示在后代元素中继续查找
            //[name=roleName]表示匹配name属性等于roleName的元素
            //trim  去掉前后空格
            var roleName = $.trim($("#addModal [name=roleName]").val());
            $.ajax({
                "url": "role/save.json",
                "type": "post",
                "data": {
                    "name": roleName
                },
                "dataType": "json",
                "success": function (response) {
                    var result = response.result;
                    if (result == "SUCCESS") {
                        layer.msg("操作成功!");
                        //将页码定位到最后一页
                        window.pageNum = 999999;
                        //重新加载分页数据
                        generatePage();
                    }
                    if (result == "FAILED") {
                        layer.msg("操作失败！" + response.message);
                    }
                },
                "error": function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            });
            //关闭模态框
            $("#addModal").modal("hide");
            //清理模态框
            $("#addModal [name=roleName]").val("");
        });
        //6 给页面上的铅笔按钮绑定单机响应函数，目的是打开模态框
        //传统的事件绑定方式只能在第一个页面有效，翻页后失效了
        // $(".pencilBtn").click(function () {
        //     alert("aaa");
        // });
        //使用jQuery对象的on()函数可以解决上面问题
        //1 首先找到所有“动态生成”的元素附着的“静态”元素
        //2 on()函数的第一个参数是事件类型
        //3 on()函数的第二个参数是找到真正要绑定事件的元素的选择器(button 中的pencilBtn类）
        //4 on()函数的第三个参数是事件的响应函数
        $("#rolePageBody").on("click", ".pencilBtn", function () {
            //打开模态框
            $("#editModal").modal("show");
            //获取表格中当前行中的角色名称
            var roleName = $(this).parent().prev().text();
            //获取当前角色的id
            //依据是：var pencilBtn = "<button id ='"+roleId+"' ...这段代码中我们把roleId设置到id属性了
            //为了让执行更新的按钮能够获取到roleId 的值，把他放在全局变量上
            window.roleId = this.id;
            //回显角色名称数据
            $("#editModal [name=roleName]").val(roleName);
        });
        //7 给更新模态框中的更新按钮绑定单机响应函数
        $("#updateRoleBtn").click(function () {
            //从文本框中获取新的角色名称
            var roleName = $("#editModal [name=roleName]").val();
            //发送ajax请求
            $.ajax({
                "url": "role/update.json",
                "type": "post",
                "data": {
                    "id": window.roleId,
                    "name": roleName,
                },
                "dataType": "json",
                "success": function (response) {
                    var result = response.result;
                    if (result == "SUCCESS") {
                        layer.msg("修改成功");
                        generatePage();
                    }
                    if (result == "FAILED") {
                        layer.msg("修改失败");
                    }
                },
                "error": function (response) {
                    layer.msg(response.status + " " + response.statusText);
                },
            });
            $("#editModal").modal("hide");
            //不用清空
        });
        //8 点击 确认 模态框中的确认删除按钮执行删除
        $("#removeRoleBtn").click(function () {
            //从全局变量范围获取roleIdArray，转换为JSON字符串
            var requestBody = JSON.stringify(window.roleIdArray);
            //发送ajax请求
            $.ajax({
                "url": "role/remove/by/role/id/array.json",
                "type": "post",
                "data": requestBody,
                "contentType": "application/json;charset=UTF-8",
                "dataType": "json",
                "success": function (response) {
                    var result = response.result;
                    if (result == "SUCCESS") {
                        layer.msg("角色删除成功");
                        generatePage();
                    }
                    if (result == "FAILED") {
                        layer.msg("删除失败!" + response.message);
                    }
                },
                "error": function (response) {
                    layer.msg(response.status + " " + response.statusText);
                }
            });
            //关闭模态框
            $("#confirmModal").modal("hide");
        });
        //9 给页面上的差号按钮绑定单机响应函数，目的是打开模态框
        //使用jQuery对象的on()函数可以解决上面问题
        //1 首先找到所有“动态生成”的元素附着的“静态”元素
        //2 on()函数的第一个参数是事件类型
        //3 on()函数的第二个参数是找到真正要绑定事件的元素的选择器(button 中的pencilBtn类）
        //4 on()函数的第三个参数是事件的响应函数
        $("#rolePageBody").on("click", ".removeBtn", function () {
            //获取表格中当前行中的角色名称
            var roleName = $(this).parent().prev().text();
            //依据是：var pencilBtn = "<button id ='"+roleId+"' ...这段代码中我们把roleId设置到id属性了
            var roleArray = [{
                roleId: this.id,
                roleName: roleName
            }];
            showConfirmModal(roleArray);
        });
        //10 给总的CheckBox绑定单机响应函数
        $("#summaryCheckBox").click(function () {
            //获取当前多选框自身的状态
            var currentStatus = this.checked;
            $(".itemBox").prop("checked", currentStatus);
        });
        //11 全选，全部选的反响操作
        $("#rolePageBody").on("click", ".itemBox", function () {
            //获取当前已经选中的.itemBox的数量
            var checkedBoxCount = $(".itemBox:checked").length;
            //获取总体itembox的数量
            var totalBoxCount = $(".itemBox").length;
            //使用二者的比较结果设置总的checkbox
            $("#summaryCheckBox").prop("checked", totalBoxCount == checkedBoxCount);
        });
        //12 给批量删除的按钮绑定单击响应函数
        $("#batchRemoveBtn").click(function () {
            //创建一个数组用来存放后面获取到的角色对象
            var roleArray = [];
            // 遍历当前选中的多选框
            $(".itemBox:checked").each(function () {
                //使用this引用当前遍历得到的多选框
                var roleId = this.id;
                //通过dom操作获取角色名称
                var roleName = $(this).parent().next().text();

                roleArray.push({
                    "roleId": roleId,
                    "roleName": roleName,
                });
            });
            //检查roleArray是否是0
            if (roleArray.length == 0) {
                layer.msg("请至少选择一个执行删除");
                return;
            }
            showConfirmModal(roleArray);
        });
    })
</script>
<body>
<%@include file="/WEB-INF/include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@include file="/WEB-INF/include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="keywordInput" class="form-control has-success" type="text"
                                       placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning"><i
                                class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button type="button" id="batchRemoveBtn" class="btn btn-danger"
                            style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <button type="button" id="showAddModalBtn" class="btn btn-primary" style="float:right;"><i
                            class="glyphicon glyphicon-plus"></i> 新增
                    </button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input id="summaryCheckBox" type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody id="rolePageBody"></tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <div id="Pagination" class="pagination"><!-- 这里显示分页 --></div>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/modal-role-add.jsp" %>
<%@include file="/WEB-INF/modal-role-edit.jsp" %>
<%@include file="/WEB-INF/modal-role-remove.jsp" %>
</body>
</html>
