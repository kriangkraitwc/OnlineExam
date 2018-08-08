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
	<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
	<style>
		.countdown {
		    float: right;	
		}
	</style>
	<script type="text/javascript">
		
		/* if( "${test.publish}" == "unpublish"){
			alert("This test hasn't been published by the professor yet.");
			document.getElementsByTagName("html")[0].style.visibility = "hidden";
			window.history.back();
		}else if("${submitted}" == "true"){
			alert("You have already taken this test.");
		  	document.getElementsByTagName("html")[0].style.visibility = "hidden";
			window.history.back();
		} */
		document.getElementsByTagName("html")[0].style.visibility = "hidden";
	</script>
</head>
<body>
	<div class="header" style="background-color:#5bc0de">
		<div class="countdown" style="border-color:#000000">
			<c:if test="${timelimit != 0 }">
				<div class="coundownText">Time remaining</div>
				<span id="clock"></span>
			</c:if>
		</div>
        <h1><span style="font-size:36px;">Quiz 1</span></h1>
       <!--  <input type="button" onclick="checkCookie()" value="Show cookies">
        <input type="button" onclick="deleteAllCookie()" value="Delete all cookies"> -->
    </div>
    <div class="container">
    		<div id="questionsForm">
    			<form:form method="POST" action="/service/submitExam" modelAttribute="submitExamForm">
	            <ul id="questions">
	                <c:if test="${not empty questions}">
	                		<%int cnt =0;%>
	                    <c:forEach var="questions" items="${questions}" varStatus="status">   
	                        <li id="question_${questions.id }">
		                            <div id="questionTxt_${questions.id }">
		                            	<c:if test="${questions.type != 'fillIn'}">
		                            		<p>${questions.text }</p>
	                            		</c:if>
	                            		<p style="float:right;">Point: ${questions.point }</p>
		                            </div>
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
	                            <form:hidden path="submitExamForm[${status.index }].studentId" value="${studentId }"/>
	                            <form:hidden path="submitExamForm[${status.index }].testId" value="${questions.testId }"/>   
	                            <form:hidden path="submitExamForm[${status.index }].questionId" value="${questions.id }"/>
	                            <form:hidden path="submitExamForm[${status.index }].questionType" value="${questions.type }"/>
	                            <form:hidden path="submitExamForm[${status.index }].questionPoint" value="${questions.point }"/>
	                        </li>
	                        <%cnt++; %>
	                    </c:forEach>
	                </c:if>
	            </ul>
	            <input type="submit" id="submitBtn" value="Submit"/>
	            </form:form>
        </div>
    </div>
    <div class="footer"></div>
    
    
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="/resources/js/jquery.countdown.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
		integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
		crossorigin="anonymous"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"
		integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm"
		crossorigin="anonymous"></script>
    <script>
    function setCookie(cname,cvalue,exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays*24*60*60*1000));
        var expires = "expires=" + d.toGMTString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
    }

    function getCookie(cname) {
        var name = cname + "=";
        var decodedCookie = decodeURIComponent(document.cookie);
        var ca = decodedCookie.split(';');
        for(var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }
    
    var deleteCookie = function(name) {
        //document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        document.cookie = name+"=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    };
    
    function checkCookie(){
    	$.each(document.cookie.split(/; */), function()  {
   		var splitCookie = this.split('=');
    		  // name is splitCookie[0], value is splitCookie[1]
    		  alert("Name: "+ splitCookie[0]+ " Value: "+splitCookie[1]);
   		});
    }
    function deleteAllCookie(){
    	$.each(document.cookie.split(/; */), function()  {
   		var splitCookie = this.split('=');
    		  // name is splitCookie[0], value is splitCookie[1]
    		  //alert("Name: "+ splitCookie[0]+ " Value: "+splitCookie[1]);
   			  deleteCookie(splitCookie[0]);
   		});
    }
    function getAllAnswerFromCookie(){
    	$.each(document.cookie.split(/; */), function()  {
       		var splitCookie = this.split('=');
     		/* if($("#submitExamForm0.answers2").length){     // If exist.
     			if($('#'+splitCookie).is("checkbox")){
    				alert("YAHOOOOOO");
    			} 
    		} */
    		
    	});
    }
    
    if( "${test.publish}" == "unpublish"){
		alert("This test hasn't been published by the professor yet.");
		//document.getElementsByTagName("html")[0].style.visibility = "hidden";
		deleteAllCookie();
		//window.history.back();
		window.location.href = "/service/testListStudent";
	}else if("${submitted}" == "true"){
		alert("You have already taken this test.");
	  	//document.getElementsByTagName("html")[0].style.visibility = "hidden";
	  	deleteAllCookie();
		// window.history.back();
		window.location.href = "/service/testListStudent";
	}else{
		document.getElementsByTagName("html")[0].style.visibility = "visible";
	}
    
    
    $(document).ready(function(){
    	//window.onbeforeunload = function () {return false;}
    	
    	//getAllAnswerFromCookie();
    	
   		// Use ajax to pass only fill in questions.
   		$("#submitBtn").click(function(){    			
   			var list = [];
   			var answer = {};
   			var length = 0;
   			var ansString = ""
   			$(".fillIn").each(function(){
   				length = $(".fillIn").length;
   				answer['questionId']= this.id.split("_")[1];
   				
   				$(".fillInBlank_"+this.id.split("_")[1]).each(function(index){
   					if(this.value == "")
   						ansString += "null";
   					ansString += this.value;
   					if(index !== length - 1)
   						ansString += "|";    					
   				});
   				answer['answers']=ansString;
   				ansString = "";
   				list.push(answer);
   				answer={};
   			});
   			
   			list = JSON.stringify(list);

   			$.ajax({
   				type: 'POST',
   				dataType: 'json',
   				contentType:'application/json',
   				url: "/service/getFillIn",
   				data: list,
   				success: function(){
   		            //$('#result').html('"PassThings()" successfully called.');
   		        }
   		    });
   		    
   		 	$.each(document.cookie.split(/; */), function()  {
	   			var splitCookie = this.split('=');
	   			//alert("Name: "+ splitCookie[0]+ " Value: "+splitCookie[1]);
	   			deleteCookie(splitCookie[0]);
	   		});
   			
   		});
   		//var fiveSeconds = new Date().getTime() + 100000;
   		var timeLimit="";
   		var timelimitDB = ${timelimit};
   		var timeLimitCookie = getCookie("timeLimit");
   		if(timeLimitCookie!=""){
   			timeLimit = timeLimitCookie
   		}else{
   			timeLimit = new Date();
   			setCookie("timeLimit", timeLimit.setMinutes(timeLimit.getMinutes() + timelimitDB), 1);
   		}
   		
   		$('#clock').countdown(timeLimit)
   		.on('update.countdown', function(event) {
   		  var format = '%H:%M:%S';
   		  if(event.offset.totalDays > 0) {
   		    format = '%-d day%!d ' + format;
   		  }
   		  if(event.offset.weeks > 0) {
   		    format = '%-w week%!w ' + format;
   		  }
   		  $(this).html(event.strftime(format));
   		})
   		.on('finish.countdown', function(event) {
   		  if(timelimitDB != 0){	// When time is finished.
	   		  $(this).html("Time's up!")
	   		    .parent().addClass('disabled');
	   		  alert("Time's up");
	   		  //deleteCookie("timeLimit");
	   		  $("#submitBtn").click();
   			}
   		});
   		
   		
	});
	    
    </script>
</body>
</html>