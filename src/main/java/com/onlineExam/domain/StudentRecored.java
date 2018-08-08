package com.onlineExam.domain;

public class StudentRecored {
	
	
	int studentId;
	int testId;
	double totalMark;
	double studentMark;
	
	public double getTotalMark() {
		return totalMark;
	}
	public void setTotalMark(double totalMark) {
		this.totalMark = totalMark;
	}
	public double getStudentMark() {
		return studentMark;
	}
	public void setStudentMark(double studentMark) {
		this.studentMark = studentMark;
	}
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
	

	
	

}
