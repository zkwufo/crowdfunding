package com.atzkw.crowd.util;

public class ResultEntity<T> {
    public static final String SUCCESS = "SUCCESS";
    public static final String FAILED = "FAILED";
    //用来封装当前请求处理的结果是成功还是失败
    private String result;
    //请求处理失败时返回的错误信息
    private String message;

    private T data;


//    请求处理成功切不需要数据的方法
    public static <E> ResultEntity<E> successWithoutData() {
        return new ResultEntity<E>(SUCCESS,null,null);
    }

    public static <E> ResultEntity<E> successWithData(E data){
        return new ResultEntity<E>(SUCCESS,null,data);
    }

    public static <E> ResultEntity<E> failed(String msg){
        return new ResultEntity<E>(FAILED,msg,null);
    }

    public ResultEntity() {
    }

    public ResultEntity(String result, String message, T data) {
        this.result = result;
        this.message = message;
        this.data = data;
    }

    @Override
    public String toString() {
        return "ResultEntity{" +
                "result='" + result + '\'' +
                ", message='" + message + '\'' +
                ", data=" + data +
                '}';
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
