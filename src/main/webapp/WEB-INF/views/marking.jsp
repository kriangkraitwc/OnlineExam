<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
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
	<style type="text/css">
		.modal-lg {
		    max-width: 80%;
		}
		.studentMark{padding:0px !important;
		}
	</style>
</head>
<body>
	<div class="container">
	<h2 class="border-bottom border-gray pb-2 mb-0">Marking</h2>
		<div class="card">
	  		<div class="card-header">Student List</div>
	  		<div class="card-body">
				<c:if test="${not empty students}">
					<c:forEach var="s" items="${students}"> 
						<div class="list-group">
					          <a href="#" id="student_${s.userId}" class="list-group-item list-group-item-action" data-toggle="modal" data-target="#exampleModalLong" value="${s.userId}" onclick="getStudentAnswer(this.id,'${s.firstname} ${s.lastname}');">${s.userId} ${s.firstname} ${s.lastname} <label id="submittedText_${s.userId}" class="float-right submittedText" style="display:none;">Submitted</label></a>
					    </div>
				    </c:forEach>
			    </c:if>
	  		</div>
		</div>
		<br><button type="button" class="btn btn-light" onclick="window.location.href='/service/testList?userId=${userId}'">
		  Back
		</button>
		
		<!-- Modal -->
		<div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
		  <div class="modal-dialog modal-lg" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLongTitle">Marking</h5>
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <form:form method="POST" action="/service/addFeedback" modelAttribute="submitExamForm" onsubmit="return confirm('Do you really want to submit the form?');">
			      <div class="modal-body">
			      	<div id="questionsForm">
						<ul class="list-group" id="questions">
							<%-- <c:if test="${not empty questions}"> --%>
								<%
									int cnt = 0;
								%>
								<c:forEach var="questions" items="${questions}" varStatus="status">
									<c:if test="${questions.type != 'single' && questions.type != 'multiple'}">
										<li id="question_${questions.id }" class="list-group-item list-group">
											<div class="list-group-item">
												<div class="col-4 float-right"><p>Point <form:input path="submitExamForm[${status.index }].mark" type="text" class="studentMark col-3 text-center" id="studentMark_${questions.id }"></form:input><label class="fullMark" id="fullMark_${questions.id }">/${questions.point }</label></p></div>
												<div class="row col-12">
													<div class="col-9">
														<c:if test="${questions.type != 'fillIn'}">
															<div id="questionTxt_${questions.id }">
																<p>${questions.text }</p>
															</div>
														</c:if>
													</div>
												</div>
												<div id="${questions.id }" class="questionOption">
														<c:if test="${questions.type == 'written' }">
															<textarea rows='4' cols='50' id="written_${questions.id }" disabled>${submitArr.answers }</textarea><br>
														</c:if>
														<c:if test="${questions.type == 'fillIn' }">
															${questions.fillInQuestionDis}
														</c:if>
												</div>
											</div>
											<div id="feedback_${questions.id }" class="list-group-item">
												<form:textarea path="submitExamForm[${status.index }].feedback" rows="4" cols="40" id="feedbackText_${questions.id }" placeholder="Add feedback here."></form:textarea>
											</div>
											
											<form:hidden path="submitExamForm[${status.index }].studentId" class="studentIdForm" value=""/>
				                            <form:hidden path="submitExamForm[${status.index }].testId" value="${questions.testId }"/>   
				                            <form:hidden path="submitExamForm[${status.index }].questionId" value="${questions.id }"/>
				                            <form:hidden path="submitExamForm[${status.index }].questionType" value="${questions.type }"/>
				                            <form:hidden path="submitExamForm[${status.index }].questionPoint" value="${questions.point }"/>
										</li>
									</c:if>
								</c:forEach>
							<%-- </c:if> --%>
						</ul>
					</div>
			      </div>
			      <div class="modal-footer">
			        <button type="submit" id="submitBtn" class="btn btn-primary">Submit</button>
			      </div>
		      </form:form>
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
	
	<script type="text/javascript">
	
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
		
		function getStudentAnswer(id,studentName){
			
			var studentId = id.split("_")[1];
			
			$(".studentIdForm").each(function(i,element){
				element.value = studentId;
			});
			
			$("#exampleModalLongTitle").html(studentName);
			//$("#studentIdForm").val(studentId);
			
			// Get student's answers
			$.ajax({
	            type: "get",
	            url : "/service/getAnswers?testId="+getQueryVariable("testId")+"&studentId="+studentId,
	            success : function(submit){
	            	$(".questionOption").each(function(i,element){
	              		 for(var i=0;i<submit.length;i++){
	              			 if(submit[i].questionId == element.id){
	   	            			 if(submit[i].questionType == "fillIn"){
	   	            				 $(".fillInBlank_"+element.id).each(function(j,element){
	   	            					 $(element).val(submit[i].answerArr[j]);
	   	            				 });
	   	            			 }else if(submit[i].questionType == "written"){
	   	            				 $("#written_"+element.id).val(submit[i].answers);
	   	            			 }
	   	            			 $("#feedbackText_"+element.id).val(submit[i].feedback);
	              			 }
	              		 }
	              	 });
	            	
	        		// Check student's answers and show.
	        		var correctSym = "<span class='glyphicon glyphicon-ok text-success'></span>";
	        		var wrongSym = "<span class='glyphicon glyphicon-remove text-danger'></span>";
	        		
	        		 $.ajax({
	                        type: "get",
	                        url : "/service/getQuestions?testId="+getQueryVariable("testId"),
	                        success : function(questions){
	                        	$(".questionOption").each(function(i,element){
	                        		var questionId = element.id;
	                        		for(var j=0;j<questions.length;j++){
	                        			if(questions[j].id == questionId){
	                        				if(questions[j].type == "fillIn"){
	                        					$(".fillInBlank_"+questionId).each(function(k,element1){
	                        						if(questions[j].answerArr[k] == element1.value){
	                        							//$(element).addClass("has-error");
	                        							$(element1).css("border-color", "#89f442");
	                        						}else{
	                        							$(element1).css("border-color", "#f44159");
	                        							$(element1).attr('data-toggle', 'popover');
	                            						$(element1).attr('data-trigger', 'hover');
	                            						$(element1).attr('title', 'Correct answer');
	                            						$(element1).attr('data-content', questions[j].answerArr[k]);
	                            						$(element1).popover();
	                        						}
	                        					});
	                        				}
	                        			}
	                        		}
	                        	});
	                        }
	        		 });
	        		 
	        		 // Get mark for each question.
	        		 $.ajax({
	                        type: "get",
	                        url : "/service/getAnswers?testId="+getQueryVariable("testId")+"&studentId="+studentId,
	                        success : function(mark){
	                        	$(".studentMark").each(function(i,element){
	                        		//alert(element.innerHTML);
	                        		var questionId = element.id.split("_")[1]
	                        		for(var i=0;i<mark.length;i++){
	                        			 if(questionId == mark[i].questionId){
	                        				 //element.innerHTML = mark[i].mark;
	                        				 //element.value = mark[i].mark;
	                        				 $(element).val(mark[i].mark);
	                        			 }
	                        		}
	                        	});
	                        }
	        		 });
	            }
			});
		}
	
		$(document).ready(function(){
			$("#submitBtn").on('click', function(){
			});
			
			// Reset form after closing it.
			$('#exampleModalLong').on('hide.bs.modal', function () {
				  // will only come inside after the modal is shown
				document.forms[0].reset();
			});
			
			$(".submittedText").each(function(i,element){
				 $.ajax({
                     type: "get",
                     url : "/service/submittedStudent?testId=${testId}&studentId="+this.id.split("_")[1],
                     success : function(submitted){
                    	 if(submitted == true){
                    		 $(element).show();
                    	 }
                    	 else{
                    		 $(element).hide();
                    	 }
                     }
				 });
			});
		});
	</script>
</body>
</html>