package com.onlineExam.domain;

import java.beans.Transient;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import org.springframework.beans.factory.annotation.Autowired;

import com.onlineExam.service.OnlineExamService;

@Entity
public class SubmitExam {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "answerId")
	int answerId;
	@Column(name = "studentId")
	int studentId;
	@Column(name = "testId")
	int testId;
	@Column(name = "questionId")
	int questionId;
	transient int questionPoint;
	@Column(name = "questionType")
	String questionType;
	@Column(name = "answers")
	String answers;
	transient String[] answersCheckbox;
	@Column(name = "feedback")
	String feedback;
	@Column(name = "mark")
	double mark;
	
	public double getMark() {
		return mark;
	}

	public void setMark(double mark) {
		this.mark = mark;
	}

	public String getFeedback() {
		return feedback;
	}

	public void setFeedback(String feedback) {
		this.feedback = feedback;
	}

	public String[] getAnswersCheckbox() {
		return answersCheckbox;
	}

	public void setAnswersCheckbox(String[] answersCheckbox) {
		this.answersCheckbox = answersCheckbox;
	}

	public int getAnswerId() {
		return answerId;
	}

	public void setAnswerId(int answerId) {
		this.answerId = answerId;
	}

	public int getTestId() {
		return testId;
	}

	public void setTestId(int testId) {
		this.testId = testId;
	}

	public int getQuestionPoint() {
		return questionPoint;
	}

	public void setQuestionPoint(int questionPoint) {
		this.questionPoint = questionPoint;
	}

	public String getQuestionType() {
		return questionType;
	}

	public void setQuestionType(String questionType) {
		this.questionType = questionType;
	}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public int getQuestionId() {
		return questionId;
	}

	public void setQuestionId(int questionId) {
		this.questionId = questionId;
	}

	public String getAnswers() {
		return answers;
	}
	private String[] splitByComma(String input) {
		String[] array = input.split("\\|");
		return array;
	}
	public String[] getAnswerArr() {
		return splitByComma(answers);
	}

	public void setAnswers(String answers) {
		this.answers = answers;
	}

}
