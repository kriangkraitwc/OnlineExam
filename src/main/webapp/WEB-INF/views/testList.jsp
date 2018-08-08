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

	<style>
		body {font-family: Arial, Helvetica, sans-serif;}
            /*Backgroung*/
        .newTest{
            display: none; /* Hidden by default */
            position: fixed;
            z-index: 1; /*Sit on top*/
            padding-top: 100px;
            width: 100%;
            height: 100%;
            left: 0;  /*To make to full screen*/
            top: 0;
            overflow: auto; /*Enable Scroll*/
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }
        
        /*Dialog Box*/
        .question-content{
            position: relative; /*Middle*/
            background-color: #fefefe;
            margin: auto;
            padding: 0;
            border: 1px solid #888;
            width: 80%;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
        }
        
        /*Close button*/
        .close {
            color: white;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: #000;
            text-decoration: none;
            cursor: pointer;
        }
        
        .question-header {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }
        
        .question-body {padding: 2px 16px;}

        .question-footer {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }   
	</style>
</head>
<body>
<div class="container">
		<form action="/logout" method="post" class=" float-right">
			<label class="">Welcome <b>${userName }</b></label>
            <button type="submit" id="addTestBtn" class="btn btn-danger">Sign Out</button>
        </form>
	<h2 class="border-bottom border-gray pb-2 mb-0">Test List</h2>
	<c:if test="${not empty tests}">
		<c:forEach var="tests" items="${tests}"> 
			<div class="p-3 bg-white rounded box-shadow border-bottom border-gray" id="test_${tests.testId}">
				<button type="button" id="deleteTest_${tests.testId }" class="close ml-2" data-dismiss="modal" aria-label="Close" onclick="deleteTest(this.id);">
	          		<span aria-hidden="true">&times;</span>
	        	</button>
		        <div class="media text-muted pt-3">
		          <a class="media-body pb-3 mb-0 small lh-125" href="/service/createQuestion?testId=${tests.testId}">${tests.testName }</a><br>
		          <button type="button"  class="btn btn-sm btn-outline-secondary" onclick="location.href='/service/createQuestion?testId=${tests.testId}';">Edit Questions</button>
		          <button type="button" class="btn btn-sm btn-outline-secondary" id="testOption_${tests.testId}" data-toggle="modal" data-target="#optionModal">Setting</button>
		          <button type="button" class="btn btn-sm btn-outline-secondary" id="addStudent_${tests.testId}" data-toggle="modal" data-target="#addStudentModal" data-whatever="${tests.testName }" data-testId="${tests.testId}">Add Students</button>
		          <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.href = '/service/marking?testId=${tests.testId}';">Marking</button>
		          <c:choose>
		          	<c:when test="${tests.publish == 'publish' }">
		          		<button type="button" class="btn btn-sm btn-outline-success ml-3" id="publish_${tests.testId }" onclick="publishTest(this.id)" style="width:13%" value="unpublish">Unpublish</button>
		          	</c:when>
		          	<c:when test="${tests.publish != 'publish' }">
		          		<button type="button" class="btn btn-sm btn-outline-secondary ml-3" id="publish_${tests.testId }" onclick="publishTest(this.id)" style="width:13%" value="publish">Publish</button>
		          	</c:when>
		          </c:choose>
		        </div>
		    </div>
	    </c:forEach>
    </c:if>
    <br><button type="button" id="addTestBtn" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">Add Test</button>
    
	<!--Add a new test dialog-->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">New Test</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      	<input type="text" id="testNameTxt"  size="28" placeholder="Enter test name">
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="createTestBtn">Add Test</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!--Add students to test dialog-->
    <div class="modal fade" id="addStudentModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">Add Students</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-addStudent-body">
	      	  <!-- <div class="input-group mb-3">
	      	  	<div class="input-group-prepend">
	      	  		<button class="btn btn-outline-secondary" type="button">Button</button>
      	  		</div>
			    <input type="text" class="form-control col-2 text-center" placeholder="" aria-label="" aria-describedby="basic-addon1">
			    <input type="text" class="form-control col-10 " placeholder="" aria-label="" aria-describedby="basic-addon1">
			  </div> -->
			  <table class="table">
				  <thead>			  	
				    <tr>
				      <th scope="col">ID</th>
				      <th scope="col" style="width: 60%">Student Name</th>
				      <th scope="col">In Test</th>
				    </tr>
				  </thead>
				  <tbody>
				  <button class="btn btn-outline-secondary selectAllStudent" type="button" id="selectAllStudent" value="selected" onclick="selectAll(this.id);">Select All</button>
			  		<c:if test="${not empty students}">
						<c:forEach var="s" items="${students}">
						<%-- <c:if test="${s.userType == 'student' }"> --%>
					    	<tr>
						      <th scope="row" class="studentId" id="studentId_${s.userId }">${s.userId }</th>
						      <td id="studentName_${s.userId }">${s.firstname }  ${s.lastname }</td>
							  <td><button class="btn btn-outline-secondary studentInTest" type="button" style="width: 85%" id="studentInTest_${s.userId }" value="NotInTest" onclick="addStudent(this.id);")>Not In Test</button></td>
					      	</tr>
					      <%-- </c:if> --%>
					    </c:forEach>
				    </c:if>
				  </tbody>
				</table>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="addStudentBtn">Add Students</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- Option Modal -->
	<div class="modal fade" id="optionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	      	<input type="hidden" id="testIdOption" value=""/>
	        <h5 class="modal-title" id="exampleModalLabel">Test Option</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      	<div class="container">
	      		<div class="row">
	      			<div class="input-group mb-3">
			      		Time limit: 
			      		<select class="ml-3" id="timelimitHour">
			      		</select>
			      		<select class="ml-1" id="timelimitMinute">
			      		</select> Hours
		      		</div>
		      		<div class="input-group mb-3">
		      			Pass percentage:
		      			<select class="ml-3 mr-1" id="passPercent">
			      		</select> %
		      		</div>
	      		</div>
	      	</div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	        <button type="button" class="btn btn-primary saveOptionBtn" id="saveOption" name="saveOption" onclick="saveOption(this.id);">Save changes</button>
	      </div>
	    </div>
	  </div>
	</div>
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
        
        <script>
        
        function deleteTest(id){
        	var testId = id.split("_")[1];
        	
        	var result = confirm("Do you want to delete this test?");
        	if (result) {
	        	$.ajax({
	                type: "get",
	                url : "/service/deleteTest?testId="+testId,
	                dataType : "html",
	                success : function(result){
	                	document.getElementById("test_"+testId).remove();
	                }
	        	});
        	}
        }
        
        function addStudent(id){
        	var studentId = id.split("_")[1];
        	var studentStat = $("#"+id).val();
        	if(studentStat == "NotInTest"){
        		$("#"+id).val("InTest");
        		$("#"+id).html("In Test");
        		$("#"+id).removeClass( "btn-outline-secondary" ).addClass( "btn-outline-success ");
        	}else if(studentStat == "InTest"){
        		$("#"+id).val("NotInTest");
        		$("#"+id).html("Not In Test");
        		$("#"+id).removeClass( "btn-outline-success " ).addClass( "btn-outline-secondary");
        	}	
        }
        
        function publishTest(id){
        	var testId = id.split("_")[1];

        	$.ajax({
                type: "get",
                url : "/service/publishTest?testId="+testId+"&publish="+$("#"+id).val(),
                dataType : "html",
                success : function(result){
                	if($("#"+id).val() == "publish"){
                		$("#"+id).val("unpublish");
                		$("#"+id).html("Unpublish");
                		$("#"+id).removeClass( "btn-outline-secondary" ).addClass( "btn-outline-success");
                		alert("The test have been published.");
                	} else {
                		$("#"+id).val("publish");
                		$("#"+id).html("Publish");
                		$("#"+id).removeClass( "btn-outline-success" ).addClass( "btn-outline-secondary");
                	}
                }
		    });
        }
        
        var flag = false;
        var flag1 = false;
        function selectAll(id){
        	$(".studentInTest").each(function(){
        		if(flag == false){
	        		$("#"+this.id).val("InTest");
	        		$("#"+this.id).html("In Test");
	        		$("#"+this.id).removeClass( "btn-outline-secondary" ).addClass( "btn-outline-success ");
        		}else{
        			$("#"+this.id).click();
        		}
        	});
        	if(flag1 == false){
        		$("#"+id).removeClass( "btn-outline-secondary" ).addClass( "btn-outline-success ");
        		flag1 = true;
        	}
        	else{
        		$("#"+id).removeClass( "btn-outline-success " ).addClass( "btn-outline-secondary");
        		flag1=false;
        	}
        	flag = true;
        }
        
        function saveOption(id){
        	var testId = id.split("_")[1];
        	var timelimitHour = parseInt($("#timelimitHour").val());
        	var timelimitMinute = parseInt($("#timelimitMinute").val());
        	var totaltimelimit = (timelimitHour * 60) + timelimitMinute;
        	var passPercent = parseInt($("#passPercent").val());
        	$.ajax({
                type: "get",
                url : "/service/updateTest?testId="+testId+"&timelimit="+totaltimelimit+"&passPercent="+passPercent,
                success : function(result){
                	alert("The setting has been set.")
                	$('#optionModal').modal('hide')
                }
		    });
        }
        
        $(document).ready(function(){
	        $("#createTestBtn").on('click',function(){
        		var testName = $("#testNameTxt").val();
        		if(testName == "")
        			alert("Please type a test name.");
        		else{
        		$.ajax({
                      type: "get",
                      url : "/service/createTest?testName="+testName+"&userId=${userId}",
                      dataType : "html",
                      success : function(testId){
                      		window.location.href='/service/createQuestion?testId='+testId;
                      }
			    });
        		}
	        });
        });
        
        $(document).ready(function(){
        	// When Add Student modal is opened.
        	var testId;
        	$('#addStudentModal').on('show.bs.modal', function (event) {
        	  var button = $(event.relatedTarget) // Button that triggered the modal
        	  var testName = button.data('whatever') 
        	  testId = button.attr('id').split("_")[1];
        	  var modal = $(this)
        	  modal.find('.modal-title').text(testName);
        	  
        	  $.ajax({
                     type: "get",
                     url : "/service/getStudents?testId="+testId,
                     success : function(students){
                    	  for(var i=0;i<students.length;i++){
                    		  $("#studentInTest_"+students[i]).val("InTest");
                    		  $("#studentInTest_"+students[i]).html("In Test");
                    		  $("#studentInTest_"+students[i]).removeClass( "btn-outline-secondary" ).addClass( "btn-outline-success ");
                    	  }
                     }
                 });
        	});
        	
        	var selectHour = document.getElementById("timelimitHour");
    		for (var i = 0; i<=10; i++){
    			var opt = document.createElement('option');
    			opt.value = i;
    		    opt.innerHTML = i;
    		    selectHour.appendChild(opt);
    		}
    		
    		var selectMinute = document.getElementById("timelimitMinute");
    		for (var i = 0; i<60; i++){
    			var opt = document.createElement('option');
    			opt.value = i;
    		    opt.innerHTML = i;
    		    selectMinute.appendChild(opt);
    		}
    		
    		var passPercent = document.getElementById("passPercent");
    		for (var i = 10; i>=1; i--){
    			var opt = document.createElement('option');
    			opt.value = i*10;
    		    opt.innerHTML = i*10;
    		    passPercent.appendChild(opt);
    		}
        	
        	$('#optionModal').on('show.bs.modal', function (event) {
        		var button = $(event.relatedTarget) // Button that triggered the modal
        		testId = button.attr('id').split("_")[1];
        		$("#testIdOption").val(testId);
        		var modal = $(this);
        		modal.find(".saveOptionBtn").attr('id', modal.find(".saveOptionBtn").attr('name')+"_"+testId );
        		
        		$.ajax({
	                type: "get",
	                url : "/service/getTest?testId="+testId,
	                success : function(test){
	                	var timelimit = test.timelimit;
	                	var timelimitHour = Math.floor( timelimit / 60);
	                	var timelimitMinute = timelimit% 60;
	                	var passPercent = test.passPercent;
	                	
	                	$("#timelimitHour").val(timelimitHour);
	                	$("#timelimitMinute").val(timelimitMinute);
	                	$("#passPercent").val(passPercent);
	                	
                       }
			     });
        		
        	});
        	
        	$("#optionModal").on("hidden.bs.modal", function(){
        		$("#timelimitHour").val(0);
        		$("#timelimitMinute").val(0);
        		$("#saveOption").attr('id',$("#saveOption").attr('name'));
        	});
        	
        	$("#addStudentModal").on("hidden.bs.modal", function(){
        	    $(".studentInTest").each(function(){
        	    	$(this).val("NotInTest");
             		    $(this).html("Not In Test");
             		    $(this).removeClass( "btn-outline-success" ).addClass("btn-outline-secondary");
        	    })
        	});
        	
        	 $("#addStudentBtn").click(function(){
        		 var students = "";
        		 
        		 $(".studentInTest").each(function(i, element){
        			 if($(this).val() == "InTest"){
        				 var studentId = $(this).attr('id').split("_")[1];
        				 students += studentId;
        				 if(i !== $(".studentInTest").length-1)
        					 students+='|';
        			 }
        		 });
        		 $.ajax({
                        type: "get",
                        url : "/service/addStudents?testId="+testId+"&students="+students, 
                        dataType : "html",
                        success : function(result){
                        	location.reload();
                        }
			     });
        	 });
        });
        </script>
</body>
</html>