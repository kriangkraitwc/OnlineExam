<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
</head>
<body>
	<button class="btn btn-md btn-warning btn-block" type="Submit" onclick="location.href = '/service/registration';">Go To Registration Page</button>
	
	<div class="container">
		<form action="/login" method="post" class="form-signin">
			<h3 class="form-signin-heading">Welcome</h3>
			<br/>
			 
			<input type="text" id="username" name="username"  placeholder="Username"
				class="form-control" /> <br/> 
			<input type="password"  placeholder="Password"
				id="password" name="password" class="form-control" /> <br /> 
			<c:if test="${not empty error }">
				<div align="center">
					<p style="font-size: 20; color: #FF1C19;">Email or Password invalid, please verify</p>
				</div>
			</c:if>
			<button class="btn btn-lg btn-primary btn-block" name="Submit" value="Login" type="Submit" th:text="Login">Login</button>
		</form>
	</div>
    
    	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
		integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
		crossorigin="anonymous"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"
		integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm"
		crossorigin="anonymous"></script>
</body>
</html>