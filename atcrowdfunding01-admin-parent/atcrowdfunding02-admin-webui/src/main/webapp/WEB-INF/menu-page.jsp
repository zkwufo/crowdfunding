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
        });
        //给修改子节点按钮绑定单击响应函数
        $("#treeDemo").on("click", ".editBtn", function () {
            //将当前节点的id，保存到全局变量
            window.id = this.id;
            //打开模态框
            $("#menuEditModal").modal("show");
            //回显数据
            //获取ztreeobj对象
            var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
            // 根据id属性查询节点对象
            //用来搜索节点的属性名
            var key = "id";
            //用来搜索节点的属性值
            var value = window.id;

            var currentNode = zTreeObj.getNodeByParam(key,value);
            //表单回显数据
            $("#menuEditModal [name=name]").val(currentNode.name);
            $("#menuEditModal [name=url]").val(currentNode.url);
            //radio回显的本质是把value属性和currentNode.icon一致的radio选中
            //被选中的radio的value属性可以组成一个数组，然后在用这个数组设置回radio，就能够把对应的值选中
            $("#menuEditModal [name=icon]").val([currentNode.icon]);
            return false;
        });
        //给模态框中的更新按钮绑定单击响应事件。
        $("#menuEditBtn").click(function () {
            //收集表单信息
            var name = $("#menuEditModal [name=name]").val();
            var url = $("#menuEditModal [name=url]").val();
            var icon = $("#menuEditModal [name=icon]:checked").val();
            //发送ajax请求
            $.ajax({
                "url":"menu/update.json",
                "type":"post",
                "data":{
                    "id":window.id,
                    "name":name,
                    "url":url,
                    "icon":icon
                },
                "dataType":"json",
                "success":function (response) {
                    var result = response.result;
                    if(result == "SUCCESS"){
                        layer.msg("更新成功");
                        generateTree();
                    }
                    if(result == "FAILED"){
                        layer.msg("更新失败"+response.message);
                    }
                },
                "error":function (response) {
                    layer.msg(response.status+" "+response.statusText);
                }
            });
            //关闭模态框
            $("#menuEditModal").modal("hide");
        });
        //给删除按钮绑定单击响应函数
        $("#treeDemo").on("click",".removeBtn",function () {
            window.id = this.id;
            //打开模态框
            $("#menuConfirmModal").modal("show");
            //获取ztreeobj对象  这里的treeid就是所依附的静态节点的id
            var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
            // 根据id属性查询节点对象
            //用来搜索节点的属性名
            var key = "id";
            //用来搜索节点的属性值
            var value = window.id;
            var currentNode = zTreeObj.getNodeByParam(key,value);
            $("#removeNodeSpan").html(" [<i class='"+currentNode.icon+"'></i>"+currentNode.name+"]");
            return false;
        });
        //给删除页面模态框的确认按钮绑定单击响应函数
        $("#confirmBtn").click(function () {
            $.ajax({
                "url":"menu/remove.json",
                "type":"post",
                "data":{
                    "id":window.id
                },
                "dataType":"json",
                "success":function (response) {
                    var result = response.result;
                    if(result == "SUCCESS"){
                        layer.msg("删除成功");
                        generateTree();
                    }
                    if(result =="FAILED"){
                        layer.msg("删除失败: "+response.message);
                    }
                },
                "error":function (response) {
                    layer.msg(response.status+" "+response.statusText);
                },
            });
            //关闭模态框
            $("#menuConfirmModal").modal("hide");
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

