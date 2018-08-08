package com.onlineExam.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class MarkingEachQuestion {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name = "markEachId")
    int markEachId;
	@Column(name = "studentId")
	int studentId;
	@Column(name = "testId")
	int testId;
	@Column(name = "questionId")
	int questionId;
	@Column(name = "mark")
	double mark;
	
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public int getTestId() {
		return testId;
	}
	public void setTestId(int testId) {
		this.testId = testId;
	}
	public int getQuestionId() {
		return questionId;
	}
	public void setQuestionId(int questionId) {
		this.questionId = questionId;
	}
	public double getMark() {
		return mark;
	}
	public void setMark(double mark) {
		this.mark = mark;
	}

}
