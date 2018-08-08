package com.onlineExam.domain;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import java.util.List;

@Entity
public class QuestionAndAns {

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name = "questionId")
    int questionId;
	
	@Column(name = "questionType")
	String questionType;
	
	@Column(name = "questionTxt")
	String questionTxt;
	
	@Column(name = "choices")
	String choices;
	
	@Column(name = "answers")
	String answers;
	
	@Column(name = "questionPoint")
	int questionPoint;
	
	@Column(name = "testId")
	int testId;
	
	transient String fillInQuestion;
	
	transient String fillInQuestionDis;
	
	//Getters and Setters
	public int getId() {
		return questionId;
	}
	public void setId(int questionId) {
		this.questionId = questionId;
	}
	
	public String getType() {
		return questionType;
	}
	public void setType(String questionType) {
		this.questionType = questionType;
	}
	
	public String getText() {
		return questionTxt;
	}
	public void setTxt(String questionTxt) {
		this.questionTxt = questionTxt;
	}
	
	public String getChoices() {
		return choices;
	}
	
	private String[] splitByComma(String input) {
		String[] array = input.split("\\|");
		return array;
	}
	public String[] getChoicesArr() {
		return splitByComma(choices);
	}
	
	// Implementing Fisher–Yates shuffle
    public List<String> getShuffleChoicesArr()
	  {
    	// create array list object       
        List<String> arrlist = new ArrayList();
        
        for(int i=0;i<getChoicesArr().length;i++) {
        	arrlist.add(getChoicesArr()[i]);
		}
        
        Collections.shuffle(arrlist);
//        String[] arr = new String[arrlist.size()];
//        arr = (String[]) arrlist.toArray(arr);
        return arrlist;
	  }
	
	public void setChoices (String choices) {
		this.choices = choices;
	}
	
	public String getAnswer() {
		return answers;
	}
	public void setAnswers (String answers) {
		this.answers = answers;
	}
	public String[] getAnswerArr() {
		return splitByComma(answers);
	}
	
	public int getPoint() {
		return questionPoint;
	}
	public void setPoint(int questionPoint) {
		this.questionPoint = questionPoint;
	}
	
	public int getTestId() {
		return testId;
	}
	public void setTestId(int testId) {
		this.testId = testId;
	}
	
	public void setFillInQuestion(String fillInQuestion) {
		this.fillInQuestion = fillInQuestion;
	}
	public String getFillInQuestion() {
		return questionTxt.replace("|", "<input type='text' name = 'fillInBlank' class='fillInBlank_"+ questionId +"'>");
	}
	
	public String getFillInQuestionDis() {
		return questionTxt.replace("|", "<input type='text' name = 'fillInBlank' class='fillInBlank_"+ questionId +"' readonly>");
	}
	
	
	
	
}
