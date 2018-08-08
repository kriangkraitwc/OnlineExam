<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<title>Registration Form</title>
	<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
	<form th:action="/login" method="get">
		<button class="btn btn-md btn-warning btn-block" type="Submit">Go To Login Page</button>
	</form>	
	
	<div class="container">
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<form:form method="POST" action="/service/registration" modelAttribute="user">
					<h2>Registration Form</h2>
					<div class="form-group">
						<div class="col-sm-9">
						<form:input path="firstname" class="form-control" placeholder="Firstname"/>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-9">
							<form:input path="lastname" class="form-control" placeholder="Lastname"/> 
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-9">
							<form:input path="email" class="form-control" placeholder="Email"/> 
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-9">
							<form:select path="userType" class="form-control">
								<form:option value="STUDENT">STUDENT</form:option>
								<form:option value="PROFESSOR">PROFESSOR</form:option>
							</form:select> 
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-9">
							<form:input path="username" class="form-control" placeholder="Username"/>
							<form:errors path="username" class="control-label text-danger" /> 
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-9">
							<form:password path="password" class="form-control" placeholder="Password"/> 
						</div>
					</div>

					<div class="form-group">
						<div class="col-sm-9">
							<button type="submit" class="btn btn-primary btn-block">Register</button>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>