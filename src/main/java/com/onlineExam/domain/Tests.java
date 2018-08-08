package com.onlineExam.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Tests {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name = "testId")
    int testId;
	
	@Column(name = "testName")
	String testName;
	
	@Column(name = "totalQuestion")
	int totalQuestion;
	
	@Column(name = "timlimit")
	int timelimit;
	
	public int getTimelimit() {
		return timelimit;
	}

	public void setTimelimit(int timelimit) {
		this.timelimit = timelimit;
	}
	@Column(name = "userId")
	int userId;
	
	@Column(name = "students")
	String students;
	
	@Column(name = "publish")
	String publish;
	
	@Column(name = "passPercent")
	int passPercent;
	
	public int getPassPercent() {
		return passPercent;
	}

	public void setPassPercent(int passPercent) {
		this.passPercent = passPercent;
	}

	public String getPublish() {
		return publish;
	}

	public void setPublish(String publish) {
		this.publish = publish;
	}

	public String getStudents() {
		return students;
	}
	
	public String[] getStudentsArr() {
		return splitByComma(students);
	}
	
	public void setStudents(String students) {
		this.students = students;
	}
	
	private String[] splitByComma(String input) {
		String[] array = input.split("\\|");
		return array;
	}
	
	public int getTestId() {
		return testId;
	}
	public void setTestId(int testId) {
		this.testId = testId;
	}
	
	public String getTestName() {
		return testName;
	}
	public void setTestName(String testName) {
		this.testName = testName;
	}
	
	public int getTotalQuestion() {
		return totalQuestion;
	}
	public void setTotalQuestion(int totalQuestion) {
		this.totalQuestion = totalQuestion;
	}
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
}
