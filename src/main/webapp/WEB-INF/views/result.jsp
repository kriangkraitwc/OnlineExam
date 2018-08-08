<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	<style type="text/css">
	
		.modal.modal-wide .modal-dialog {
		  width: 90%;
		}
		.popover{
			width:200px;
    		height:100px; 
		}
	</style>

</head>
<body>
	<div class="container">
	<div class="page-header header_site" style="color:#000000">
		<h1><span style="font-family:Helvetica Neue,Helvetica,Arial,sans-serif; font-size:36px;">Results for ${testName }</span></h1>
	</div>
		<c:if test="${not empty submitAns }">
			<div class="row">
				<div class="col-xs-6">
					<h2><span style="font-family:Helvetica Neue,Helvetica,Arial,sans-serif; color:#000000; font-size:30px; float: right;">Score</span></h2>
				</div>
				<div class="col-xs-6">
					<c:if test="${not empty marking}">
						<h2><small><span style="font-family:Helvetica Neue,Helvetica,Arial,sans-serif; color:#777777; font-size:28px;">${marking.totalStudentPoint }/${marking.totalPoint }</span></small></h2>
					</c:if>
				</div>
			</div>
			<c:if test="${pass == 'true' }">
				<div class="col-md-12 text-center"> 
					<h1 class="text-success" id="passTxt">Pass!</h1>
				</div>
			</c:if>
			<c:if test="${pass != 'true' }">
				<div class="col-md-12 text-center"> 
					<h1 class="text-danger" id="passTxt">Fail!</h1>
				</div>
			</c:if>
			<div class="col-md-12 text-center"> 
				<button type="button" class="btn btn-primary" id="reviewBtn" data-toggle="modal" data-target="#exampleModalLong">Review Answers</button>
			</div>
			
		</c:if>
		<c:if test="${empty submitAns }">
			You haven't taken this test yet.
		</c:if>
		
		<br><button type="button" class="btn btn-secondary text-align-right" onclick="window.location.href='/service/testListStudent'">
		  Back
		</button>
		
		<!-- Modal -->
		<div class="modal modal-wide fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		        <h2 class="modal-title" id="exampleModalLongTitle">Review answers</h2>
		      </div>
		      <div class="modal-body">
		        <div id="questionsForm">
					<ul class="list-group" id="questions">
						<c:if test="${not empty questions}">
							<%
								int cnt = 0;
							%>
							<c:forEach var="questions" items="${questions}">
								<li id="question_${questions.id }" class="list-group-item">
									<div class="row">
										<div class="col-xs-9">
											<c:if test="${questions.type != 'fillIn'}">
												<div id="questionTxt_${questions.id }">
													<p>${questions.text }</p>
												</div>
											</c:if>
										</div>
										<c:forEach var="submitArr" items="${submitAns}">
											<c:if test="${submitArr.questionId == questions.id }">
												<c:choose>
													<c:when test="${questions.type != 'written'}">
														<div class="col-xs-3">
															<h5 class="text-success">Point ${submitArr.mark } / ${questions.point }</h5>
															<c:if test="${not empty submitArr.feedback}">
																<label id="feedback_${submitArr.questionId }" class="float-right">Feedback</label>
															</c:if>
														</div>
													</c:when> 
													<c:when test="${questions.type == 'written'}">
														<c:choose>
															<c:when test="${submitArr.mark == 0.0}">
																<div class="col-xs-3 "><h5 class="text-danger">Wait the professor for marking.</h5></div>
															</c:when>
															<c:when test="${submitArr.mark != 0.0 }">
																<div class="col-xs-3"><h5 class="text-success">Point ${submitArr.mark } / ${questions.point }</h5>
																<c:if test="${not empty submitArr.feedback}">
																	<label id="feedback_${submitArr.questionId }" class="float-right">Feedback</label>
																</c:if>
																</div>
															</c:when>
														</c:choose>
													</c:when>													
												</c:choose>										
											</c:if>
										</c:forEach>
									</div>
									<div id="${questions.id }" class="questionOption">
											<c:if
												test="${questions.type == 'multiple' || questions.type == 'single'}">
												<c:forEach var="arr" items="${questions.choicesArr}">
													<c:choose>
														<c:when test="${questions.type == 'single' }">
															<c:forEach var="submitArr" items="${submitAns}">
																<c:if test="${submitArr.questionId == questions.id }">
																	<c:choose>
																		<c:when test="${submitArr.answers == arr}">
																			<input type="radio" class="option_${questions.id }" value="${arr}" name="radio  ${questions.id }"
																				id="option_<%=cnt %> ${questions.id }" checked disabled><label for="option_<%=cnt %> ${questions.id }" class="label_${questions.id }">${arr}</label><br>
																		</c:when>
																		<c:when test="${submitArr.answers != arr}">
																			<input type="radio" class="option_${questions.id }" value="${arr}" name="radio  ${questions.id }"
																				id="option_<%=cnt %> ${questions.id }" disabled><label for="option_<%=cnt %> ${questions.id }" class="label_${questions.id }">${arr}</label><br>
																		</c:when>
																	</c:choose>
																</c:if>
															</c:forEach>
														</c:when>
														<c:when test="${questions.type == 'multiple' }">
															<input type="checkbox" name="checkbox  ${questions.id }" 
																class="option_${questions.id }" value="${arr}" id="option_<%=cnt %> ${questions.id }" disabled><label for="option_<%=cnt %> ${questions.id }" class="label_${questions.id }">${arr}</label><br>
														</c:when>
													</c:choose>
													<%
														cnt++;
													%>
												</c:forEach>
												<%
													cnt = 0;
												%>
											</c:if>
											<c:if test="${questions.type == 'written' }">
												<c:forEach var="submitArr" items="${submitAns}">
													<c:if test="${submitArr.questionId == questions.id }">
														<textarea rows='4' cols='50' id="option ${questions.id }" disabled>${submitArr.answers }</textarea><br>
													</c:if>
												</c:forEach>
											</c:if>
											<c:if test="${questions.type == 'fillIn' }">
												${questions.fillInQuestionDis}
											</c:if>
									</div>
								</li>
							</c:forEach>
						</c:if>
					</ul>
				</div>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		      </div>
		    </div>
		  </div>
		</div>
	</div>


	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
		
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
	 
	$(document).ready(function(){
		
		
		// Get student's answers.
		$.ajax({
            type: "get",
            url : "/service/getAnswers?testId="+getQueryVariable("testId")+"&studentId="+getQueryVariable("studentId"),
            success : function(submit){
           	 $(".questionOption").each(function(i,element){
           		 for(var i=0;i<submit.length;i++){
           			 if(submit[i].questionId == element.id){
	            			 if(submit[i].questionType == "fillIn"){
	            				 $(".fillInBlank_"+element.id).each(function(j,element){
	            					 $(element).val(submit[i].answerArr[j]);
	            				 });
	            				 
	            			 }
	            			 else if(submit[i].questionType == "multiple"){
	            				 $(".option_"+element.id).each(function(j,element){
	            					//alert(element.value);
	            					/* if(element.value == submit[i].answerArr[j]) */
	            					for(var k=0;k<submit[i].answerArr.length;k++){
	            						if(element.value == submit[i].answerArr[k])
	            							element.checked = true;
	            					}
	            				 });
	            			 }
	            			 
	            			 if(submit[i].feedback!= null){
	            				 $("#feedback_"+submit[i].questionId).attr('data-toggle', 'popover');
	            				 $("#feedback_"+submit[i].questionId).attr('data-trigger', 'hover');
	            				 $("#feedback_"+submit[i].questionId).attr('title', 'Feedback');
	            				 $("#feedback_"+submit[i].questionId).attr('data-content', submit[i].feedback);
	            				 $("#feedback_"+submit[i].questionId).popover();
            				 }
	            			 
           			 }
           		 }
           	 });
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
                				if(questions[j].type == "single"){
                					$(".option_"+questionId).each(function(k,element1){
                						if(element1.checked && element1.value == questions[j].answer.split("|")[0]){
                							$('label[for="'+element1.id+'"]').css("color", "#89f442");
                							$('label[for="'+element1.id+'"]').after(correctSym);
                						}
                						else if(element1.checked && element1.value != questions[j].answer.split("|")[0]){
                							$('label[for="'+element1.id+'"]').css("color", "#f44159");
                							$('label[for="'+element1.id+'"]').after(wrongSym);
                						}
                					});
                				} else if(questions[j].type == "multiple"){
                					var correct=[];
                					var wrong =[];
                					$(".option_"+questionId).each(function(k,element1){
                						for(var l=0;l<questions[j].answerArr.length;l++){
                							/* if(element1.checked && element1.value == questions[j].answerArr[l]){
                								$('label[for="'+element1.id+'"]').css("color", "#89f442");
                    							$('label[for="'+element1.id+'"]').after(correctSym);
                							}else if(element1.checked && element1.value != questions[j].answerArr[l]){
                								$('label[for="'+element1.id+'"]').css("color", "#f44159");
                    							$('label[for="'+element1.id+'"]').after(wrongSym);
                							} */                							
                							if(element1.checked && element1.value == questions[j].answerArr[l]){
                								correct.push(element1.id);
                							}else if(element1.checked && element1.value != questions[j].answerArr[l]){
                								wrong.push(element1.id);
                							}
                						}
                					});
                					for(var m=0;m<wrong.length;m++){
                						for(var n=0;n<correct.length;n++){
                							if(wrong[m] == correct[n])
                								wrong.splice(m,1);
                						}
                					}
                					for(var m=0;m<wrong.length;m++){
                						if($('label[for="'+wrong[m]+'"]').children().length <= 0){
	               							$('label[for="'+wrong[m]+'"]').css("color", "#f44159");
	               							$('label[for="'+wrong[m]+'"]').append(wrongSym);  
                						}
                					}
                					for(var n=0;n<correct.length;n++){
                						$('label[for="'+correct[n]+'"]').css("color", "#89f442");
               							$('label[for="'+correct[n]+'"]').after(correctSym);
                					}           					
                				}
                				else if(questions[j].type == "fillIn"){
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
	});
	
	</script>
</body>
</html>