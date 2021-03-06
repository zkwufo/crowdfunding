<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css">
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>
<script type="text/javascript">
    $(function () {
        initPagination();
        var loginUser = "${sessionScope.loginAdmin.loginAcct}";
        $("button #delete").click(function () {
            // layer.msg($(this).parent().parent().parent().find("td").eq(2).text());
            var deleteUser = $(this).parent().parent().parent().find("td").eq(2).text();
            var adminId = $(this).attr("adminId");
            if (loginUser == deleteUser) {
                layer.msg("对不起你不能删除该用户");
                return false;
            } else {
                layer.confirm("你是否要删除" + deleteUser, {
                    btn: ['确认', '关闭']
                }, function () {
                    window.location.href = "admin/remove/" + adminId + "/${requestScope.pageInfo.pageNum}/${param.keyword}.html";
                }, function () {
                    return;
                });
            }
        });
    });

    function initPagination() {
        var totalRecord = "${requestScope.pageInfo.total}";
        var properties = {
            num_edge_entries: 3,                                //边缘页数
            num_display_entries: 5,                             //主体页数
            callback: pageselectCallback,
            items_per_page:${requestScope.pageInfo.pageSize},   //每页显示几项
            current_page:${requestScope.pageInfo.pageNum -1},   //默认从0开始，而pagNum从1开始
            prev_text: "上一页",
            next_text: "下一页",
        };
        $("#Pagination").pagination(totalRecord, properties);

        function pageselectCallback(pageIndex, jQuery) {
            var pageNum = pageIndex + 1;
            window.location.href = "admin/get/page.html?pageNum=" + pageNum + "&keyword=${param.keyword}";
            return false;
        }
    }

</script>
<body>
<%@include file="/WEB-INF/include-nav.jsp" %>
<input>
<div class="container-fluid">
    <div class="row">
        <%@include file="/WEB-INF/include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form action="admin/get/page.html" method="post" class="form-inline" role="form"
                          style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input name="keyword" class="form-control has-success" type="text"
                                       placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i
                            class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <%--                    <button type="button" class="btn btn-primary" style="float:right;"--%>
                    <%--                            onclick="window.location.href='add.html'"><i class="glyphicon glyphicon-plus"></i> 新增--%>
                    <%--                    </button>--%>
                    <a href="admin/to/add/page.html" style="float: right" class="btn btn-primary"><i
                            class="glyphicon glyphicon-plus"></i> 新增</a>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${empty requestScope.pageInfo.list}">
                                <tr>
                                    <td colspan="6" align="center">
                                        抱歉没有查询到数据
                                    </td>
                                </tr>
                            </c:if>
                            <c:if test="${!empty requestScope.pageInfo.list}">
                                <c:forEach items="${requestScope.pageInfo.list}" var="admin" varStatus="myStatus">
                                    <tr>
                                        <td>${myStatus.count}</td>
                                        <td><input type="checkbox"></td>
                                        <td>${admin.loginAcct}</td>
                                        <td>${admin.userName}</td>
                                        <td>${admin.email}</td>
                                        <td>
                                                <%--分配按钮--%>
                                                <%--<button type="button" class="btn btn-success btn-xs"><i--%>
                                                <%--class=" glyphicon glyphicon-check"></i></button>--%>
                                            <a href="assign/to/assign/role/page.html?adminId=${admin.id}&pageNum=${requestScope.pageInfo.pageNum}&keyword=${param.keyword}"
                                               class="btn btn-success btn-xs"><i class="glyphicon glyphicon-check"></i> </a>
                                                <%--修改按钮--%>
                                                <%--<button type="button" class="btn btn-primary btn-xs"><i
                                                <%--class=" glyphicon glyphicon-pencil"></i></button>--%>
                                            <a href="admin/to/edit/page.html?adminId=${admin.id}&pageNum=${requestScope.pageInfo.pageNum}&keyword=${param.keyword}"
                                               class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></a>
                                            <button type="button" class="btn btn-danger btn-xs"><i id="delete"
                                                                                                   adminId="${admin.id}"
                                                                                                   class=" glyphicon glyphicon-remove"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
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
</body>
</html>