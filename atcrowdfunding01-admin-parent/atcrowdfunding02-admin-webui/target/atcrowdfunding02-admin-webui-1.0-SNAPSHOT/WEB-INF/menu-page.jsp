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
<%--导入ztree的css文件--%>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<%--导入ztree的js文件--%>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="crowd/my-menu.js"></script>
<script type="text/javascript">
    $(function () {
        //调用专门封装好的函数初始化树形结构
        generateTree();
        //给添加子节点按钮绑定单击响应函数
        $("#treeDemo").on("click", ".addBtn", function () {
            //将当前节点的id，作为新节点的pid保存到全局变量
            window.pid = this.id;
            //打开模态框
            $("#menuAddModal").modal("show");
                return false;
        });
        //给添加子节点的模态框中的保存按钮绑定单击响应函数
        $("#menuSaveBtn").click(function () {
            //收集表单项中用户输入的数据
            var name= $.trim($("#menuAddModal [name=name]").val());
            var url = $.trim($("#menuAddModal [name=url]").val());
            //单选按钮要定位到被选中的那一个
            var icon = $("#menuAddModal [name=icon]:checked").val();
            //发送ajax请求
            $.ajax({
                "url":"menu/save.json",
                "type":"post",
                "data":{
                    "pid":window.pid,
                    "name":name,
                    "url":url,
                    "icon":icon
                },
                "dataType":"json",
                "success":function (response) {
                    var result = response.result;
                    if(result =="SUCCESS"){
                        layer.msg("新增成功");
                        //显示树形结构
                        generateTree();
                    }
                    if(result =="FAILED"){
                        layer.msg("新增失败:"+response.message);
                        return false;
                    }
                },
                "error":function (response) {
                    layer.msg(response.status+" "+response.statusText);
                }
            });
            //关闭模态框
            $("#menuAddModal").modal("hide");
            //清空表单   jquery调用click（）函数，里面不传任何参数，相当于用户点击一下。
            $("#menuResetBtn").click();
        })
    })
</script>
<body>
<%@include file="/WEB-INF/include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@include file="/WEB-INF/include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

            <div class="panel panel-default">
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
                    <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i
                            class="glyphicon glyphicon-question-sign"></i></div>
                </div>
                <div class="panel-body">
                    <%--                    这个ul标签是ztree动态生成的节点所依附的静态节点--%>
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/modal-menu-add.jsp" %>
<%@include file="/WEB-INF/modal-menu-confirm.jsp" %>
<%@include file="/WEB-INF/modal-menu-edit.jsp" %>
</body>
</html>

