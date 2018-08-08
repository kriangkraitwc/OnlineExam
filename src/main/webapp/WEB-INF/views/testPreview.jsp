<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<style>
		.countdown {
		    float: right;	
		}
	</style>
</head>
<body>
	<div class="header" style="background-color:#5bc0de">
		<div class="countdown" style="border-color:#000000">
			<div class="coundownText">Time remaining</div>
			<div id="countDown">0:00:00</div>
		</div>
        <h1><span style="font-size:36px;">Quiz 1</span></h1>
    </div>
    <div class="container">
    		<div id="questionsForm">
    			<form:form method="POST" action="/service/submitExam" modelAttribute="submitExamForm">
	            <ul id="questions">
	                <c:if test="${not empty questions}">
	                		<%int cnt =0;%>
	                    <c:forEach var="questions" items="${questions}" varStatus="status">   
	                        <li id="question_${questions.id }">
	                        	<c:if test="${questions.type != 'fillIn'}">
		                            <div id="questionTxt_${questions.id }">
		                            		<p>${questions.text }</p>
		                            		<p style="float:right;">Point: ${questions.point }</p>
		                            </div>
	                            </c:if>
	                            <div id="questionOption_${questions.id }">
                               		<c:if test="${questions.type == 'single'}">
                                		<ul><form:radiobuttons path="submitExamForm[${status.index }].answers" items="${questions.choicesArr}" element="li" onchange="setCookie(this.id,this.value,1);"/></ul>
                               		</c:if>
                               		<c:if test="${questions.type == 'multiple'}">
                                		<ul><form:checkboxes path="submitExamForm[${status.index }].answersCheckbox" items="${questions.choicesArr}" element="li"/></ul> 
                               		</c:if>
                               		<c:if test="${questions.type == 'written' }">
                               			<form:textarea path="submitExamForm[${status.index }].answers" rows='4' cols='50' id="option ${questions.id }"/>
                               		</c:if>
                               		<c:if test="${questions.type == 'fillIn' }">
	                              		<div class="fillIn" id="fillIn_${questions.id }">
	                              			${questions.fillInQuestion }
	                            		</div>
                               		</c:if>
	                            </div>
	                            <hr>
	                            <!-- HARDCODE STUDENT ID -->
	                            <form:hidden path="submitExamForm[${status.index }].studentId" value="2"/>
	                            <form:hidden path="submitExamForm[${status.index }].testId" value="${questions.testId }"/>   
	                            <form:hidden path="submitExamForm[${status.index }].questionId" value="${questions.id }"/>
	                            <form:hidden path="submitExamForm[${status.index }].questionType" value="${questions.type }"/>
	                            <form:hidden path="submitExamForm[${status.index }].questionPoint" value="${questions.point }"/>
	                        </li>
	                        <%cnt++; %>
	                    </c:forEach>
	                </c:if>
	            </ul>
	            <input type="button" id="submitBtn" value="Submit" disabled/>
        		<input type="button" id="backBtn" value="Back" onclick="goBack();"/>
	            </form:form>
        </div>
    </div>
    <div class="footer"></div>
    
    <script>
	    function startTimer(duration, display) {
	        var timer = duration, hours, minutes, seconds;
	        setInterval(function () {
		        	hours   = Math.floor(timer / 3600 );
		        	minutes = Math.floor(timer % 3600 / 60);
		        seconds = timer % 60;
	            
	            hours = hours < 10 ? "0" + hours : hours;
	            minutes = minutes < 10 ? "0" + minutes : minutes;
	            seconds = seconds < 10 ? "0" + seconds : seconds;
	
	            display.textContent = hours + ":"+ minutes + ":" + seconds;
	
	            if (--timer < 0) {
	                timer = duration;
	            }
        		}, 1000);
	    }
	    
	    function getQueryVariable(variable)
        {
               var query = window.location.search.substring(1);
               var vars = query.split("&");
               for (var i=0;i<vars.length;i++) {
                       var pair = vars[i].split("=");
                       if(pair[0] == variable){return pair[1];}
               }
               return(false);
        }
	    
	    function goBack(){
	    		window.location.href = "/service/createQuestion?testId="+getQueryVariable("testId");
	    }
	    
	    $(document).ready(function(){
		    	var fiveMinutes = 60 * 60,      ///////////////// HARD CODE 60 MINS COUNT DOWN
		        display = document.querySelector('#countDown');
		    startTimer(fiveMinutes, display);
	    
	    });

    </script>
</body>
</html>