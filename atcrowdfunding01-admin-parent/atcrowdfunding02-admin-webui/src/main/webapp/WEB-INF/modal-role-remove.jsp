<%--
  Created by IntelliJ IDEA.
  User: zkwuf
  Date: 2020/12/9
  Time: 20:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="confirmModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">系统弹窗</h4>
            </div>
            <div class="modal-body">
                <h4>请确认是否删除以下数据</h4>
                <div id="roleNameDiv" style="text-align: center"></div>
            </div>
            <div class="modal-footer">
                <button id="removeRoleBtn" type="button" class="btn btn-primary">确认</button>
            </div>
        </div>
    </div>
</div>

