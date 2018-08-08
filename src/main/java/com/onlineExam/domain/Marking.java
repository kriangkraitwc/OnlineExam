package com.onlineExam.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Marking {

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name = "markId")
    int markId;
	
	@Column(name = "testId")
	int testId;
	
	@Column(name = "studentId")
	int studentId;
	
	@Column(name = "totalStudentPoint")
	double totalStudentPoint;
	
	@Column(name = "totalPoint")
	double totalPoint;

	public int getMarkId() {
		return markId;
	}

	public void setMarkId(int markId) {
		this.markId = markId;
	}

	public int getTestId() {
		return testId;
	}

	public void setTestId(int testId) {
		this.testId = testId;
	}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public double getTotalStudentPoint() {
		return totalStudentPoint;
	}

	public void setTotalStudentPoint(double d) {
		this.totalStudentPoint = d;
	}
	
	public double getTotalPoint() {
		return totalPoint;
	}

	public void setTotalPoint(double d) {
		this.totalPoint = d;
	}
}
