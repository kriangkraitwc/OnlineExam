package com.onlineExam.controller;

public class GetFillIn {

	private int questionId;
	private String answers;
	
	public int getQuestionId() {
		return questionId;
	}
	public void setQuestionId(int questionId) {
		this.questionId = questionId;
	}
	public String getAnswers() {
		return answers;
	}
	public void setAnswers(String answers) {
		this.answers = answers;
	}
	public String[] getAnswerArr() {
		return splitByComma(answers);
	}
	
	private String[] splitByComma(String input) {
		String[] array = input.split("\\|");
		return array;
	}
}
