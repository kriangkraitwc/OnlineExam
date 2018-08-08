<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.onlineExam.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">

<style type="text/css">
.deleteOption,.deleteFillIn {
	font-size: 25px;
	font-weight: bold;
}

.deleteOption:hover, .deleteOption:focus, .deleteFillIn:hover, .deleteFillIn:focus {
	text-decoration: none;
	cursor: pointer;
}

.questionHandles {
	float: right;
	padding: 10px;
	color: #858585
}
</style>
</head>
<body>
	<div class="container">
		<h2>Create Questions</h2>
		<div id="questionsForm">
			<ul class="list-group" id="questions">
				<c:if test="${not empty questions}">
					<%
						int cnt = 0;
					%>
					<c:forEach var="questions" items="${questions}">
						<li id="question_${questions.id }" class="list-group-item">
							<div id="questionHandle ${questions.id }" class="questionHandles col-12 text-right">
								<span id="questionActionButton ${questions.id }"
									onclick="editQuestion(this.id)">Edit</span> <span
									id="questionActionButton ${questions.id }"
									onclick="deleteQuestion(this.id)">Delete</span>
							</div>
							<c:if test="${questions.type != 'fillIn'}">
								<div id="questionTxt_${questions.id }">
									<p>${questions.text }</p>
								</div>
							</c:if>
							<div id="questionOption_${questions.id }">
								<div>
									<c:if
										test="${questions.type == 'multiple' || questions.type == 'single'}">
										<c:forEach var="arr" items="${questions.choicesArr}">
											<c:choose>
												<c:when test="${questions.type == 'single' }">
													<input type="radio" name="radio  ${questions.id }"
														id="option_<%=cnt %> ${questions.id }">${arr}<br>
												</c:when>
												<c:when test="${questions.type == 'multiple' }">
													<input type="checkbox" name="checkbox  ${questions.id }"
														id="option_<%=cnt %> ${questions.id }">${arr}<br>
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
										<textarea rows='4' cols='50' id="option ${questions.id }"></textarea>
										<br>
									</c:if>
									<c:if test="${questions.type == 'fillIn' }">
										${questions.fillInQuestion}
									</c:if>
								</div>
							</div>
						</li>
					</c:forEach>
				</c:if>
			</ul>
		</div>
		<br>
	<input type="button" class="btn btn-primary" id="addQuestionBtn" value="Add Question"
		data-toggle="modal" data-target="#exampleModalLong">
	<input type="button" class="btn btn-primary" id="importBtn" value="Import Questions"
		data-toggle="modal" data-target="#exampleModalLong">
	<input type="button" class="btn btn-warning" id="previewBtn" value="Preview">
	<button type="button" class="btn btn-light float-right" onclick="window.location.href='/service/testList?userId=${testId }'">
		  Back
		</button>
	</div>

	<!--Add a new question dialog-->
	<form class="modal fade" id="exampleModalLong" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLongTitle"
		aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLongTitle">New
						Question</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="addNewQuestion">
						Question types: <select id="questionType">
							<option value="single">Single Choice</option>
							<option value="multiple">Multiple Choice</option>
							<option value="fillIn">Fill In</option>
							<option value="written">Written</option>
						</select> <br>Points: <input type="text" id="questionPoint"><br>
						Question:
						<textarea rows="4" cols="50" id="questionTxt"></textarea>
						<br>
						<div id="choices">
							Choices: <br>
							<div id="option" name="option" class="option">
								<input class="choice" type="text" id="choice" name="choice">
								<input class="correct" type="radio" id="correct" name="correct">correct
								<span class="deleteOption" id="deleteOpBtn" name="deleteOpBtn"
									onclick="deleteOption(this.id)" style="display: none;">&times;</span>
							</div>
							<br> <input type="button" value="Add Option" id="addOption">
						</div>
						<div id="fillIn" style="display: none;">
							<div class="fillIn-content" name="fillIn-content" id="fillIn-content">
								<input type="text" id="fillIn-question" name="fillIn-question" class="fillIn-question" onkeyup="updateFillInQuestionExample(this.id);">
								Answer:<input type="text" id="fillIn-answer" name="fillIn-answer" class="fillIn-answer" onkeyup="updateFillInAnswerExample(this.id);">
								<span class="deleteFillIn" id="deleteFillIn_0" name="deleteFillInBtn" onclick="deleteOption(this.id)" style="display: none;">×</span>
							</div>
							<input type="button" value="Add a Blank" id="addBlank">
							<h6>Example: </h6>
							<div class="fillIn-example">
								<label class="fillIn-question-example" name="fillIn-question-example" id="fillIn-question-example" style="font-size:x-small;"></label><input style="height: 20px; width:120px;font-size:x-small;" type="text" name="fillIn-answer-example" id="fillIn-answer-example" class="fillIn-answer-example" value="" disabled>
							</div>
						</div>
					</div>
					<div class="importQuestion">
						<c:if test="${not empty tests}">
							<c:forEach var="tests" items="${tests}">
								<a id="test ${tests.testId }" href ="#" onclick="getQuestions(this.id)">${tests.testName }</a>
								<br>
							</c:forEach>
						</c:if>
					</div>
					<div class="importQuestionList">
						<input type="checkbox" id="selectAll" onclick="selectAllCheckbox()"> Select all
						<ul class="list-group" id="questionsList" style="list-style-type: none">
							
						</ul>
					</div>


				</div>
				<div class="modal-footer">
					<div class="addNewQuestionFooter">
						<input type="button" value="Save" id="saveBtn"> <input
							type="button" value="Update" id="updateBtn">
					</div>
					<div class="importQuestionFooter">
						<input type="button" value="Import" id="saveImportBtn">
					</div>
				</div>
			</div>
		</div>
	</form>


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
			 // Delete an option.
		        function deleteOption(id){
		            var divId = document.getElementById(id).parentNode.id;
 		            if(document.getElementById(divId).className == "fillIn-content"){
		            	var id = document.getElementById(divId).id.split("_")[1];
		            	document.getElementById("fillIn-question-example_"+id).remove();
		            	document.getElementById("fillIn-answer-example_"+id).remove();
		            }
		            document.getElementById(divId).remove();
		            $("#addOption").prop("disabled",false);
		            
		        }
		        
		        function resetForm(dialog,id){
		            dialog.reset();
		            $(".option").each(function(i,element){
		                if(element.id != id){
		                    element.remove();
		                }
		            });
		            $(".fillInTxt").each(function(i,element){
		            	this.remove();
		            });
		            $("#fillIn").hide();
		            $("#choices").show();
		            
		            $(".fillIn-content").each(function(i,element){
		            	if(i!=0)
		            		this.remove();
		            });
		        }
		        
		        function addQuestionToTestPage(questionObj){
		            var question = JSON.parse(questionObj);
		            if(question.type == 'multiple' || question.type == 'single' || question.type == 'written')
		            		$('#questionsForm ul').append("<li class='list-group-item' id='question_" + question.id + "'><div id='questionHandle "+ question.id +"' class='questionHandles'><span id='questionActionButton "+question.id+"'onclick=''>Edit</span><span id='questionActionButton "+question.id+"'onclick='deleteQuestion(this.id)'>Delete</span></div> <div id='questionTxt_"+question.id+"'><p>"+question.text+"<\/p><\/div><div id='questionOption_"+question.id+"'>"+ generateChoices(question.id,question.choices,question.type,"") +"<\/div><\/li>");
		            else if(question.type == 'fillIn')
		            		$('#questionsForm ul').append("<li class='list-group-item' id='question_" + question.id + "'><div id='questionTxt_"+question.id+"'><p>"+generateFillIn(question.text)+"<\/p>");
		        }
		        
		        function generateFillIn(questionText){
		        		return questionText.replace('|',"<input type='text' id=''>");
		        }
		        
		        function generateChoices(questionId,choicesArr,questionType,disabled){
		            var choices = choicesArr.split('|');
		            var choicesStr = "<div>";
		            var choiceType = "";
		            if(questionType == 'single')
		                choiceType = 'radio';
		            else if(questionType == 'multiple')
		                choiceType = 'checkbox';
		            if(questionType == 'single' || questionType == 'multiple'){
		                for(var i=0;i<choices.length;i++){
		                	if(choices[i] != "")
		                    choicesStr += "<input type='"+ choiceType +"' name='radio "+questionId+"' id='option_"+i+ " "+ questionId +"' "+disabled+">"+ choices[i] +"<\/input><br>";
		                }
		            }
		            else if(questionType == 'written'){
		            		if(choices[i] != "")
		                    choicesStr += "<textarea rows='4' cols='50' id='option "+ questionId +"'></textarea><br>";
		            }
		
		            return choicesStr+"<\/div>";
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
		        
		        function deleteQuestion(id){
		        		var idSplit = id.split(" ")[1];
		        		if(confirm("Do you want to delete this qustion?")){
		            		$.ajax({
		                        type: "get",
		                        url : "/service/deleteQuestion?questionId="+idSplit,
		                        success : function(result){
		                        }
						}); 
		            		
		            		var divId = document.getElementById(id).parentNode.id;
		                divId = document.getElementById(divId).parentNode.id;
		                document.getElementById(divId).remove();
		        		}
		        }
		        qId = 0;
		        function editQuestion(id){
		        	
		        		$("#saveBtn").hide();
		        		$("#updateBtn").show();
		        		$(".importQuestion").hide();
		        		$(".importQuestionList").hide();
		        		
		        		var dialog = document.getElementById('newQuestionDialog');
		        		$('#exampleModalLong').modal('show');
					if(document.getElementById("choice")||document.getElementById("correct")||document.getElementById("deleteOpBtn")){
		                var choiceTxt = document.getElementById("choice").id = "choice_0";
		                var correctCheckbox = document.getElementById("correct").id = "correct_0";
		                var deleteOpBtn = document.getElementById("deleteOpBtn").id = "deleteOpBtn_0";
					}
					qId = id.split(" ")[1];
		            $.ajax({
		                type: "get",
		                url : "/service/getQuestion?questionId="+qId,
		                success : function(question){
		                		var type = $("#questionType").val(question.type);
		                		$("#questionPoint").val(question.point);
		                		$("#questionTxt").val(question.text);
		                		var choices = question.choicesArr;
		                		var answers = question.answerArr;
		                		
		                		$("#choice_0").val(choices[0]);
		                		if($("#questionType").val() == "multiple")
		                			$(".correct")[0].type="checkbox";
		                		else if($("#questionType").val() == "single")
		                			$(".correct")[0].type="radio";
		                		else if($("#questionType").val() == "written"){
		                			$("#choices").hide();
		                         $("#fillIn").hide();
		                		}
		                		else if($("#questionType").val() == "fillIn"){
		                			$("#choices").hide();
		                         $("#fillIn").show();
		                		}
		                		
		                		for(var i=1;i<choices.length;i++){
		                			$("#addOption").click();
		                			$("#choice_"+[i]).val(choices[i]);
		                		}
		                		
		                		 $(".choice").each(function(i,element){ 
		                			 for(var j=0;j<answers.length;j++){
			                   	 	if($(element).val() == answers[j]){
		                            		$("#correct_"+[i]).prop('checked', true);
			                   	 	}
		                			 }
			                 });
		                }
					});
		        }
		        
		        function selectAllCheckbox(){
		        		$(".importQuestionCheckbox").each(function(){
						if($("#selectAll").is(':checked')){
							this.checked = true; 
						}
						else
							this.checked = false; 
					});
		        }
		        
		        function getQuestions(id){
		        		var testId = parseInt(id.split(" ")[1]);
		        		//alert("testId "+testId);
		        		 $.ajax({
				                type: "get",
				                url : "/service/getQuestions?testId="+testId,
				                success : function(questions){
				                		for(var i=0;i<questions.length;i++){
				                			if(questions[i].type == 'multiple' || questions[i].type == 'single' || questions[i].type == 'written'){
				    		            			$('#questionsList').append("<li class='list-group-item id='question_" + questions[i].id + "'><input type='checkbox' class='importQuestionCheckbox' name='question "+questions[i].id+"' id='question"+i+ " "+ questions[i].id +"'></input><div id='questionTxt_"+questions[i].id+"'><p>"+questions[i].text+"<\/p><\/div><div id='questionOption_"+questions[i].id+"'>"+ generateChoices(questions[i].id,questions[i].choices,questions[i].type,"disabled") +"<\/div><\/li>");
				                			}
				                		}
				                		$(".importQuestionList").show();
				                		$(".importQuestion").hide();
				                }
		        		 });
		        		
		        }
		        
		        function updateFillInQuestionExample(id){
		        	//alert(id);
		        	var splitId = id.split("_")[1];
		        	$("#fillIn-question-example_"+splitId).text($("#fillIn-question_"+splitId).val());
		        }
		        
		        function updateFillInAnswerExample(id){
		        	//alert(id);
		        	var splitId = id.split("_")[1];
		        	$("#fillIn-answer-example_"+splitId).val($("#fillIn-answer_"+splitId).val());
		        }
		        
		        $(document).ready(function(){
		            
		            /////////////////// New Question Dialog///////////////////
		            var cnt = 0;
		            
		            // Get option (choice) div
		            var option = document.getElementById('option');
		            option.id = option.getAttribute("name")+cnt;
		            // Get the dialog
		            var dialog = document.getElementById('exampleModalLong');
		
		            // Get the button that opens the dialog
		            var btn = document.getElementById("addQuestionBtn");
		
		            // Get the <span> element that closes the modal
		            var span = document.getElementsByClassName("close")[0];
		            
		            $("#updateBtn").hide();
		
		            // When the user clicks the button, open the modal 
		            btn.onclick = function() {
		              	$("#saveBtn").show();
		              	$(".importQuestion").hide();
		              	$(".addNewQuestion").show();
		              	$(".importQuestionFooter").hide();
		              	$(".addNewQuestionFooter").show();
		              	$(".importQuestionList").hide();
		              	$("#questionTxt").show();
		          		$("#updateBtn").hide();
		          		$("#addOption").prop("disabled",false);
		          		$(".correct")[0].type="radio";
		          		$('#exampleModalLong').modal('show');	
		                if(document.getElementById("choice")||document.getElementById("correct")||document.getElementById("deleteOpBtn")){
		                    //var choiceTxt = document.getElementById("choice").id = "choice_"+cnt;
		                    var correctCheckbox = document.getElementById("correct").id = "correct_"+cnt;
		                    var deleteOpBtn = document.getElementById("deleteOpBtn").id = "deleteOpBtn_"+cnt;
		                    var fillInQuestion = document.getElementById("fillIn-question").id = "fillIn-question_0";
		                    var fillInAnswer = document.getElementById("fillIn-answer").id = "fillIn-answer_0";
		                    var fillInContent = document.getElementById("fillIn-content").id = "fillIn-content_0";
		                    var fillInAnswerEx = document.getElementById("fillIn-answer-example").id = "fillIn-answer-example_0";
		                    var fillInContentEx = document.getElementById("fillIn-question-example").id = "fillIn-question-example_0";
		                }
		            }
		            
					$("#importBtn").click(function(){
						
						$(".importQuestion").show();
		              	$(".addNewQuestion").hide();
		              	$(".importQuestionFooter").show();
		              	$(".addNewQuestionFooter").hide();
		              	$(".importQuestionList").hide();
		            });
					
					$("#saveImportBtn").click(function(){
						var checkedQuestions = [];
						$(".importQuestionCheckbox").each(function(i,element){
							if($(element).is(':checked')){
								checkedQuestions.push(element.id.split(" ")[1]);
							}
						});
						
						$.ajax({
	                        type: "get",
	                        url : "/service/importQuestion?testId="+getQueryVariable("testId")+"&questionId="+checkedQuestions,
	                        dataType : "html",
	                        success : function(result){
	                        		location.reload();
	                        		$('#exampleModalLong').modal('hide');
	                        }
					    });
						
					});
		
		            // When the user clicks on <span> (x), close the dialog	            
		            $('#exampleModalLong').on('hide.bs.modal', function(e){
		            	if (confirm("Do you want to close without saving?")) {
	                        resetForm(dialog,option.id);
	                        fillInNum =0;
	                        cnt=0;
                    	}else{
                    		e.preventDefault();
                    	     e.stopImmediatePropagation();
                    	     return false;
                    	}
		            });
		
		            // Add an option (choice)
		            var addOptionBtn = document.getElementById('addOption');
		            addOptionBtn.addEventListener("click",function(){
		            		
		            		cnt++;                     
		                var lastOption = $('.option');                          // Get the latest element
		                lastOption = lastOption[lastOption.length-1];
		                
		                var clone = lastOption.cloneNode(true);
		                clone.id = clone.getAttribute("name")+"_"+cnt;
		                var childs = clone.children;    //Get all the element inside a div.
		                for(var i=0;i<childs.length;i++){
		                    var childName = childs[i].id = childs[i].getAttribute("name")+"_"+cnt;      // Define unique id for each element.
		                    if(childs[i].nodeName == 'SPAN'){
		                        childs[i].style.display = 'inline';
		                    }
		                }
		                lastOption.after(clone);
		                
		                var lastChoice = $('.choice');
		                lastChoice = lastChoice[lastChoice.length-1].value = "";
		                if($(".choice").length >= 5)
		                	addOptionBtn.disabled = true;
		            });
		            
		            $("#updateBtn").click(function(){
		            	location.reload();
		            	var qType = $("#questionType").val();
		                var qText = $("#questionTxt").val();
		                var qPoint = $("#questionPoint").val();
		                var choiceList = [];
		                var choices = "";
		                var correctAns = "";
		                cnt=0;
		                if(qText != "" || qPoint != ""){
		                    if(Number.isInteger(+qPoint)){    // If question is an integer.
			                    if(qType == 'multiple' || qType == 'single'){
			                        $(".choice").each(function(i,element){    // Get all element with "choice" class and go through them.
			                            var elements = $(element).val();
			                            if(elements != ""){
			                                choiceList[i] = elements;
			                                choices +=elements+"|";
			                            }
			                        });
			
			                        $(".correct").each(function(i,element){   // Get all correct answers.
			                            var elements = $(element).is(':checked');
			                            if(elements == true){
			                                correctAns+= choiceList[i]+"|";   ///////////////////////////////// DELETE LAST COMMA.
			                            }
			
			                        });
			                    }
			                    else if(qType == 'fillIn'){
			                        $(".fillInTxt").each(function(i,element){
			                           var elements = $(element).val();
			                            if(elements != "")
			                                correctAns+= elements+"|";
			                        });
			                    }
			                    $.ajax({
			                        type: "post",
			                        url : "/service/updateQuestion?qId="+qId+"&qType="+qType+"&qText="+qText+"&choices="+choices+"&answers="+correctAns+"&qPoint="+qPoint+"&testId="+getQueryVariable("testId"),
			                        dataType : "html",
			                        success : function(questionJson){
			                            addQuestionToTestPage(questionJson);
			                        }
							    });
			                    		$('#exampleModalLong').modal('hide');
				                    resetForm(dialog,option.id);
		                    	}
		                    else{
		                    		alert("Question point must be only a number.");
		                    		$("#questionPoint").focus();
		                    		$("#questionPoint").select();
		                    }
		           		}
		            		else{
		            			alert("Please fill all the information.");
		            		}
		            });
		
		            // Save a question
		            $('#saveBtn').click(function(){
		            	
		                var qType = $("#questionType").val();
		                var qText = $("#questionTxt").val();
		                var qPoint = $("#questionPoint").val();
		                var choiceList = [];
		                var choices = "";
		                var correctAns = "";
		                cnt=0;
		                //alert($("#questionTxt").val());
		                //if(qText != "" || qPoint != ""){
		                    //if(Number.isInteger(+qPoint)){    // If question is an integer.
			                    if(qType == 'multiple' || qType == 'single'){
			                        $(".choice").each(function(i,element){    // Get all element with "choice" class and go through them.
			                            var elements = $(element).val();
			                            if(elements != ""){
			                                choiceList[i] = elements;
			                                choices += elements;
			                                if(i !== $(".choice").length -1)
			                                		choices += "|";
			                            }
			                        });
			
			                        $(".correct").each(function(i,element){   // Get all correct answers.
			                            var elements = $(element).is(':checked');
			                            if(elements == true){
			                                correctAns+= choiceList[i];
			                                //if(i !== $(".choice").length -1)
			                                		correctAns+= "|";
			                            }
			
			                        });
			                    }
			                    else if(qType == 'fillIn'){
			                    	var fillInQuestion = "";
			                    	var fillInAnswer = "";
			                        $(".fillIn-question").each(function(i,element){
			                           var elements = $(element).val();
			                           if(i == $(".fillIn-question").length-1 && $(".fillIn-answer").last().val() == "")
			                        	   qText += elements;
			                           else
			                        	   qText += elements+"|";
			                        });
			                        alert(qText);
			                        //alert( $(".fillIn-answer").last().val());
			                        $(".fillIn-answer").each(function(i,element){
			                        	var elements = $(element).val();
			                        	correctAns += elements;
			                        	if(i != $(".fillIn-answer").length-1)
			                        		correctAns += "|";
			                        });
			                        alert(correctAns);
			                    }
			                    $.ajax({
			                        type: "post",
			                        url : "/service/addQuestion?qType="+qType+"&qText="+qText+"&choices="+choices+"&answers="+correctAns+"&qPoint="+qPoint+"&testId="+getQueryVariable("testId"),
			                        dataType : "html",
			                        success : function(questionJson){
			                            addQuestionToTestPage(questionJson);
			                        }
							    });
		                    		$('#exampleModalLong').modal('hide');
				                    resetForm(dialog,option.id);
		                    	//}
		                    //else{
		                    		//alert("Question point must be only a number.");
		                    		//$("#questionPoint").focus();
		                    		//$("#questionPoint").select();
		                    //}
		           		//}
		            		//else{
		            			//alert("Please fill all the information.");
		            		//}
		            });
		            
		            // Choose question type and hide the choices when question type is written.
		            $("#questionType").change(function(){
		                var choosenType = $("#questionType").val();
		                if(choosenType == 'written'){
		                    $("#choices").hide();
		                    $("#fillIn").hide();
		                    $("#questionTxt").show();
		                }
		                else if(choosenType == 'fillIn'){
		                    $("#choices").hide();
		                    $("#fillIn").show();
		                    $("#questionTxt").hide();
		                }
		                else if(choosenType == 'single'){
	                		var correctOption = $(".correct").attr("type","radio");
		                    $("#choices").show();
		                    $("#fillIn").hide();
		                    $("#questionTxt").show();
		                }
		                else if(choosenType == 'multiple'){
		                	var correctOption = $(".correct").attr("type","checkbox");
		                	$("#choices").show();
		                    $("#fillIn").hide();
		                    $("#questionTxt").show();
		                }
		            });
		            
		            // Get fill in answer div
		            var fillIn = document.getElementById('fillIn-content');
		            
		            fillInNum = 0;
		            $("#addBlank").on('click', function(){
		                
		                fillInNum++;
		                $("#fillIn-content").show();

	                    var lastFillIn = $('.fillIn-content');
	                    lastFillIn = lastFillIn[lastFillIn.length-1];
	                    
	                    var clone = lastFillIn.cloneNode(true);
	                    clone.id = clone.getAttribute('name')+"_"+fillInNum;
	                    var childs = clone.children;
	                    for(var i=0;i<childs.length;i++){
	                        var childName = childs[i].id = childs[i].getAttribute("name")+"_"+fillInNum;
	                        if(childs[i].nodeName == 'SPAN'){
		                        childs[i].style.display = 'inline';
		                    }
	                    }
	                    lastFillIn.after(clone);
	                    
	                    $(".fillIn-answer").last().val("");
	                    $(".fillIn-question").last().val("");
	                    
	                    /* var lastFillInEx = $('.fillIn-example');
	                    lastFillInEx = lastFillInEx[lastFillInEx.length-1];
	                    var clone1 = lastFillInEx.cloneNode(true);
	                    var childs1 = clone1.children;
	                    for(var i=0;i<childs1.length;i++){
	                    	var childName = childs1[i].id = childs1[i].getAttribute("name")+"_"+fillInNum;
	                    	
	                    }
	                    lastFillInEx.after(clone1); */
	                    
	                    var lastFillInQuastion = $('.fillIn-question-example');
	                    lastFillInQuastion = lastFillInQuastion[lastFillInQuastion.length-1];
	                    var clone1 = lastFillInQuastion.cloneNode(true);
	                    clone1.id = clone1.getAttribute("name")+"_"+fillInNum;
	                    $(".fillIn-answer-example").last().after(clone1);
	                    
	                    var lastFillInAns = $('.fillIn-answer-example');
	                    lastFillInAns = lastFillInAns[lastFillInAns.length-1];
	                    var clone1 = lastFillInAns.cloneNode(true);
	                    clone1.id = clone1.getAttribute("name")+"_"+fillInNum;
	                    $(".fillIn-question-example").last().after(clone1);
	                    
	                    $(".fillIn-answer-example").last().val("");
	                    $(".fillIn-question-example").last().text("");  
		            });
		            
		            $('#previewBtn').click(function(){
		            		location.href = "/service/testPreview?testId="+getQueryVariable('testId');
		            });
		        });
	    </script>
</body>
</html>