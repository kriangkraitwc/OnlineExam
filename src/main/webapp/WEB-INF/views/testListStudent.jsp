<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.onlineExam.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">	
</head>
<body>
<div class="container">
		<form action="/logout" method="post" class=" float-right">
			<label class="">Welcome <b>${userName }</b></label>
            <button type="submit" id="addTestBtn" class="btn btn-danger btn-sm">Sign Out</button>
        </form>
	<h2 class="border-bottom border-gray pb-2 mb-0">Test List</h2>
	<c:if test="${not empty tests}">
		<c:forEach var="tests" items="${tests}"> 
			<div class="p-3 bg-white rounded box-shadow border-bottom border-gray" id="test_${tests.testId}">
		        <div class="media text-muted pt-3">
		        	<div class="col-9">
		        		<a class="media-body pb-3 mb-0 small lh-125" href="/service/exam?testId=${tests.testId}">${tests.testName }</a>
		        		<button type="button" class="btn btn-sm btn-outline-primary float-right" onclick="location.href = '/service/result?studentId=${userId }&testId=${tests.testId}';">Result</button>
		        	</div>
		          	<div class="col-3"><label>Status:
			          	<c:choose>
				          	<c:when test="${tests.publish == 'publish'}">
				          		<label class="text-success">Active</label>
				          	</c:when>
				          	<c:when test="${tests.publish != 'publish'}">
				          		<label>Not Active</label>
				          	</c:when>
			          	</c:choose>
			          	</label>
		          	</div>
		        </div> 
		    </div>
	    </c:forEach>
    </c:if>
    <c:if test="${empty tests}">
    	<div class="col-12">You have no test right now.</div>
    </c:if>
</div>

</body>
</html>