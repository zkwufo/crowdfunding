<%--
  Created by IntelliJ IDEA.
  User: zkwuf
  Date: 2020/12/2
  Time: 11:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>搭建环境进行测试</title>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script src="layer/layer.js"></script>
    <script type="text/css">
        .reset {
            font-size:200px;
            color:green;
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $("#btn1").click(function () {
                $.ajax({
                    "url": "send/arrayOne.html",        //请求目标资源的地址
                    "type": "post",                  //请求方式
                    "data": {
                        "array": [5, 8, 12]
                    },                //请求参数
                    "dataType": "text",              //如何处理返回数据
                    "success": function (response) {//服务器成功处理请求后调用的回调函数，
                        alert(response);
                    },
                    "error": function (response) {//服务器未成功处理请求后调用的回调函数，
                        alert(response);

                    }
                })

            });
            $("#btn2").click(function () {
                $.ajax({
                    "url": "send/arrayTwo.html",        //请求目标资源的地址
                    "type": "post",                  //请求方式
                    "data": {
                        "array[0]": 5,
                        "array[1]": 8,
                        "array[2]": 12,
                    },                //请求参数
                    "dataType": "text",              //如何处理返回数据
                    "success": function (response) {//服务器成功处理请求后调用的回调函数，
                        console.log(response);
                    },
                    "error": function (response) {//服务器未成功处理请求后调用的回调函数，
                        alert(response);
                    }
                })

            });
            $("#btn3").click(function () {
                var array = [5, 8, 12];
                var requestBody = JSON.stringify(array);
                $.ajax({
                    "url": "send/arrayThree.html",        //请求目标资源的地址
                    "type": "post",                  //请求方式
                    "data": requestBody,               //请求体
                    "contentType": "application/json;charset=UTF-8",//设置请求体的内容类型，告诉服务器是json数据
                    "dataType": "text",              //如何处理返回数据
                    "success": function (response) {//服务器成功处理请求后调用的回调函数，
                        alert(response);
                    },
                    "error": function (response) {//服务器未成功处理请求后调用的回调函数，
                        alert(response);
                    }
                })

            });
            $("#btn4").click(function () {
                var admin = {
                    "id": 123,
                    "loginAcct": "sorata",
                    "userPswd": "zhangk",
                    "userName": "zkwufo",
                    "email": "zkwufo@gmail.com",
                    "createTime": null
                }
                var requestBody = JSON.stringify(admin);
                $.ajax({
                    "url": "send/resultEntity.json",
                    "type": "post",
                    "data": requestBody,
                    "contentType": "application/json;charset=UTF-8",
                    "dataType": "json",
                    "success": function (response) {
                        console.log(response);
                    },
                    "error": function (response) {
                        console.log(response);
                    }
                })
            });
            $("#btn5").click(function () {
                $.ajax({
                    "url": "send/error.html",        //请求目标资源的地址
                    "type": "post",                  //请求方式
                    "data": {
                        "array": [5, 8, 12]
                    },                //请求参数
                    "dataType": "text",              //如何处理返回数据
                    "success": function (response) {//服务器成功处理请求后调用的回调函数，
                        console.log(response);
                    },
                    "error": function (response) {//服务器未成功处理请求后调用的回调函数，

                    }
                })
            });
            $("#btn6").click(function () {
                alert("alert 弹框")

                layer.msg("layer 的弹框")

            });
            $("#btn7").click(function () {
                window.location.href="admin/to/login/page.html";
            });
            $("#btn").click(function () {
                $("div").attr("class", function () {
                    return "reset"
                })
            });
        })
    </script>

</head>
<body>
<a href="test/ssm.html">测试SSM整合环境</a>
</br>
<button id="btn1">send [5,8,12] One</button>
</br>
</br>
<button id="btn2">send [5,8,12] two</button>
</br>
</br>
</br>
<button id="btn3">send [5,8,12] three</button>
</br>
</br>
<button id="btn4">send [5,8,12] four</button>
</br>
</br>
<button id="btn5">test error</button>
</br>
</br>
<a href="send/error.html"> 测试返回</a>
</br>
</br>
<button id="btn6">弹框</button>
<br>
<br>
<button id="btn7">去登录页面</button>
<br>
<br>
<div class="font bg">脚本之家欢迎您</div>
<button id="btn">点击查看效果</button>
</body>
</html>
