package com.onlineExam.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Comparator;

import javax.mail.internet.MimeMessage;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.onlineExam.domain.Marking;
import com.onlineExam.domain.MarkingEachQuestion;
import com.onlineExam.domain.QuestionAndAns;
import com.onlineExam.domain.RegistrationForm;
import com.onlineExam.domain.SubmitExam;
import com.onlineExam.domain.SubmitExamForm;
import com.onlineExam.domain.Tests;
import com.onlineExam.domain.Users;
import com.onlineExam.service.OnlineExamService;

//Rest
@RestController
@RequestMapping(value = { "/service" })
public class OnlineExamController {

	@Autowired
	OnlineExamService service;

	@RequestMapping(value = { "/default" })
	public RedirectView defaultPage() {
		String url = "";
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Users user = service.findByUsername(auth.getName());

		if (user.getUserType().equals("PROFESSOR"))
			url = "testList";
		else if (user.getUserType().equals("STUDENT"))
			url = "testListStudent";

		return new RedirectView(url);
	}

	@RequestMapping(value = { "/testListStudent" })
	public ModelAndView testListStudent() {
		ModelAndView mv = new ModelAndView("testListStudent");
		Iterable<Tests> t = service.findAllTest();
		List<Tests> testList = new ArrayList<Tests>();

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Users user = service.findByUsername(auth.getName());
		String studentId = Integer.toString(user.getUserId());
		for (Tests t1 : t) {
			if (t1.getStudents() != null) {
				for (int i = 0; i < t1.getStudentsArr().length; i++) {
					if (t1.getStudentsArr()[i].equals(studentId)) {
						testList.add(t1);
					}
				}
			}
		}

		mv.addObject("tests", testList);
		mv.addObject("userName", user.getFirstname());
		mv.addObject("userId", user.getUserId());
		return mv;
	}

	@RequestMapping(value = { "/testList" })
	public ModelAndView testList() {

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Users user = service.findByUsername(auth.getName());

		List<Tests> t = service.findByUserId(user.getUserId());
		// for (Tests t1 : t) {
		// // System.out.print(t1.getTestName()+"\n");
		// }
		Iterable<Users> users = service.finAllUser();
		List<Users> students = new ArrayList<Users>();
		for (Users u1 : users) {
			if(u1.getUserType().equals("STUDENT")) students.add(u1);
		}
		
		ModelAndView mv = new ModelAndView("testList");
		mv.addObject("tests", t);
		mv.addObject("students", students);
		mv.addObject("userId", user.getUserId());
		mv.addObject("userName", user.getFirstname());
		return mv;
	}

	@RequestMapping(value = { "/createTest" })
	public int createTest(@RequestParam(value = "testName", required = true) String testName,
			@RequestParam(value = "userId", required = true) int userId) {
		Tests test = new Tests();
		test.setTestName(testName);
		test.setUserId(userId);
		// DEFAULT PASS MARK PERCENT
		test.setPassPercent(50);

		service.saveTest(test);
		// return new ModelAndView("createQuestions");
		return test.getTestId();
	}

	@RequestMapping(value = { "/createQuestion" })
	public ModelAndView questionList(@RequestParam(value = "testId", required = true) int testId) {

		List<QuestionAndAns> q = service.findByTestId(testId);
		Tests t = service.findByTestTestId(testId);
		List<Tests> tests = service.findByUserId(t.getUserId());
		// for (QuestionAndAns qa : q) {
		// // if (qa.getType().equals("fillIn")) {
		// // qa.setTxt(qa.getText().indexOf(ch)("_", "<input type='text'
		// id='option_'>"));
		// for (int i = 0; i < qa.getChoicesArr().length; i++)
		// System.out.print(qa.getChoicesArr()[i] + "\n");
		// // }
		// }

		ModelAndView mv = new ModelAndView("createQuestions2");
		mv.addObject("questions", q);
		mv.addObject("tests", tests);
		mv.addObject("testId", t.getTestId());

		// return new ModelAndView("createQuestions", "questions", q);
		return mv;
	}

	@RequestMapping(value = "/addQuestion")
	public @ResponseBody QuestionAndAns createQuestion(@RequestParam(value = "qType", required = true) String qType,
			@RequestParam(value = "qText", required = true) String qText,
			@RequestParam(value = "choices", required = true) String choices,
			@RequestParam(value = "answers", required = true) String answers,
			@RequestParam(value = "qPoint", required = true) int qPoint,
			@RequestParam(value = "testId", required = true) int testId) {

		QuestionAndAns qa = new QuestionAndAns();
		// CHECK NULL
		qa.setType(qType);
		qa.setTxt(qText);
		// String[] choiceArr = splitByComma(choices);
		qa.setChoices(choices);
		qa.setAnswers(answers);
		qa.setPoint(qPoint);
		qa.setTestId(testId);
		
		Tests t = service.findByTestTestId(testId);
		t.setTotalQuestion(t.getTotalQuestion()+1);
		service.saveTest(t);

		// System.out.print(qText);

		service.saveQuestion(qa);

		return qa;
	}

	@RequestMapping(value = { "/deleteQuestion" })
	public boolean deleteQuestion(@RequestParam(value = "questionId", required = true) int id) {
		QuestionAndAns q = service.findByQuestionId(id);
		Tests t = service.findByTestTestId(q.getTestId());
		t.setTotalQuestion(t.getTotalQuestion()-1);
		
		return service.deleteByQuestionId(id);
	}
	
	@RequestMapping(value = { "/deleteTest" })
	public boolean deleteTest(@RequestParam(value = "testId", required = true) int testId) {
		
		return service.deleteByTestId(testId);
	}

	@RequestMapping(value = { "/testPreview" })
	public ModelAndView testPreview(@RequestParam(value = "testId", required = true) int testId) {
		List<QuestionAndAns> q = service.findByTestId(testId);
		Tests test = new Tests();
		test = service.findByTestTestId(testId);
		ModelAndView mv = new ModelAndView("testPreview");
		mv.addObject("submitExamForm", new SubmitExamForm());
		mv.addObject("questions", q);
		mv.addObject("test", test);

		return mv;
	}

	@RequestMapping(value = { "/exam" })
	public ModelAndView exam(@RequestParam(value = "testId", required = true) int testId) {
		List<QuestionAndAns> q = service.findByTestId(testId);
		Tests test = new Tests();
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Users user = service.findByUsername(auth.getName());
		
		List<SubmitExam> submit = service.getSubmitExam(testId, user.getUserId());
		boolean submitted = false;
		if(submit.size() != 0) {
			submitted = true;
		}else {
			submitted = false;
		}
		System.out.print(submitted);

		test = service.findByTestTestId(testId);
		ModelAndView mv = new ModelAndView("exam");
		mv.addObject("questions", q);
		mv.addObject("test", test);
		mv.addObject("submitted", submitted);
		mv.addObject("studentId", user.getUserId());
		mv.addObject("timelimit", test.getTimelimit());
		mv.addObject("submitExamForm", new SubmitExamForm());

		return mv;
	}

	// @RequestMapping(value = { "/exam1" })
	// public ModelAndView exam1(@RequestParam(value = "testId", required = true)
	// int testId) {
	// List<QuestionAndAns> q = service.findByTestId(testId);
	// Tests test = new Tests();
	//
	// test = service.findByTestTestId(testId);
	// ModelAndView mv = new ModelAndView("exam2");
	// mv.addObject("questions", q);
	// mv.addObject("test", test);
	// mv.addObject("submitExam", new SubmitExam());
	//
	// return mv;
	// }

	List<GetFillIn> getFillInAns = null;

	@RequestMapping(value = { "/getFillIn" }, method = RequestMethod.POST)
	public void getFillIn(@RequestBody List<GetFillIn> answers) {
		if (answers.size() != 0) {
			for (int i = 0; i < answers.size(); i++) {
				// System.out.print(answers.size()+"\t");
				System.out.print(answers.get(i).getQuestionId());
				System.out.print(answers.get(i).getAnswers() + "\n");
			}
			getFillInAns = answers;
		} else {
			getFillInAns = null;
		}

	}

	@RequestMapping(value = { "/registration" }, method = RequestMethod.GET)
	public ModelAndView registration() {
		ModelAndView mv = new ModelAndView("registration");
		mv.addObject("user", new Users());
		return mv;
	}

	@RequestMapping(value = { "/registration" }, method = RequestMethod.POST)
	public ModelAndView createNewUser(@Valid @ModelAttribute("user") Users user, BindingResult bindingResult) {
		ModelAndView modelAndView = new ModelAndView();
		Users userExists = service.findByUsername(user.getUsername());
		if (userExists != null) {
			bindingResult.rejectValue("username", "error.user",
					"There is already a user registered with the username provided");
		}
		if (bindingResult.hasErrors()) {
			modelAndView.setViewName("registration");
		} else {
			service.saveUser(user);
			modelAndView.addObject("successMessage", "User has been registered successfully");
			modelAndView.addObject("user", new Users());
			modelAndView.setViewName("login");
		}

		return modelAndView;
	}

	@RequestMapping(value = { "/submitExam" })
	public ModelAndView submit(@Valid @ModelAttribute("submitExamForm") SubmitExamForm submitExamForm)
			throws IOException {
		// CHECK NULL
		int testId = 0;
		int userId = 0;

		System.out.print("size: " + submitExamForm.getSubmitExamForm().size() + "\n");
		for (int i = 0; i < submitExamForm.getSubmitExamForm().size(); i++) {
			String answers = "";
			if (testId == 0)
				testId = submitExamForm.getSubmitExamForm().get(i).getTestId();
			if (userId == 0)
				userId = submitExamForm.getSubmitExamForm().get(i).getStudentId();
			System.out.print("StudentId: " + submitExamForm.getSubmitExamForm().get(i).getStudentId() + "\n");
			System.out.print("TestId: " + submitExamForm.getSubmitExamForm().get(i).getTestId() + "\n");
			System.out.print("QuestionId: " + submitExamForm.getSubmitExamForm().get(i).getQuestionId() + "\n");
			System.out.print("QuestionType: " + submitExamForm.getSubmitExamForm().get(i).getQuestionType() + "\n");
			System.out.print("QuestionPoint: " + submitExamForm.getSubmitExamForm().get(i).getQuestionPoint() + "\n");

			SubmitExam submit = new SubmitExam();

			submit.setStudentId(submitExamForm.getSubmitExamForm().get(i).getStudentId());
			submit.setTestId(submitExamForm.getSubmitExamForm().get(i).getTestId());
			submit.setQuestionId(submitExamForm.getSubmitExamForm().get(i).getQuestionId());
			submit.setQuestionType(submitExamForm.getSubmitExamForm().get(i).getQuestionType());
			submit.setQuestionPoint(submitExamForm.getSubmitExamForm().get(i).getQuestionPoint());
			submit.setAnswers(submitExamForm.getSubmitExamForm().get(i).getAnswers());

			if (submitExamForm.getSubmitExamForm().get(i).getAnswers() != null
					|| submitExamForm.getSubmitExamForm().get(i).getAnswersCheckbox() != null || getFillInAns != null) {
				System.out.print("Answer: ");
				if (submitExamForm.getSubmitExamForm().get(i).getQuestionType().equals("multiple")) {
					for (int k = 0; k < submitExamForm.getSubmitExamForm().get(i).getAnswersCheckbox().length; k++) {
						System.out.print(submitExamForm.getSubmitExamForm().get(i).getAnswersCheckbox()[k]);
						answers += submitExamForm.getSubmitExamForm().get(i).getAnswersCheckbox()[k];
						if (k < submitExamForm.getSubmitExamForm().get(i).getAnswersCheckbox().length - 1) {
							System.out.print("|");
							answers += "|";
						}
					}
					submit.setAnswers(answers);
				} else if (submitExamForm.getSubmitExamForm().get(i).getQuestionType().equals("single")) {
					System.out.print(submitExamForm.getSubmitExamForm().get(i).getAnswers() + "\n");
					submit.setAnswers(submitExamForm.getSubmitExamForm().get(i).getAnswers());
				} else if (submitExamForm.getSubmitExamForm().get(i).getQuestionType().equals("fillIn")) {
					if (getFillInAns != null) {
						for (int l = 0; l < getFillInAns.size(); l++) {
							if (getFillInAns.get(l).getQuestionId() == submitExamForm.getSubmitExamForm().get(i)
									.getQuestionId()) {
								System.out.print(getFillInAns.get(l).getAnswers() + "\n");
								submit.setAnswers(getFillInAns.get(l).getAnswers());
							}
						}
					}
				}

			} else {
				submit.setAnswers("");
			}

			System.out.print("\n\n");
			service.saveSubmitExam(submit);

		}

		marking(testId, userId);
		// response.sendRedirect("result");
		return new ModelAndView("redirect:/service/result?studentId=" + userId + "&testId=" + testId);
	}

	private void marking(int testId, int userId) {
		List<SubmitExam> submit = service.getSubmitExam(testId, userId);
		double mark = 0;
		System.out.print("*******************Submit Exam******************\n");
		System.out.print(submit.size());
		for (int i = 0; i < submit.size(); i++) {

			SubmitExam s = service.getSubmitAnswer(testId, userId, submit.get(i).getQuestionId());

			MarkingEachQuestion markingEach = new MarkingEachQuestion();
			markingEach.setTestId(testId);
			markingEach.setStudentId(userId);
			markingEach.setQuestionId(submit.get(i).getQuestionId());
			System.out.print("Question: " + submit.get(i).getQuestionId() + "\t");
			if (submit.get(i).getAnswers() != null)
				System.out.print("Answer: " + submit.get(i).getAnswers() + "\t");
			QuestionAndAns q = service.findByQuestionId(submit.get(i).getQuestionId());
			System.out.print("Correct Answer: " + q.getAnswer() + "\t\t\t");
			// for (int j = 0; j < q.getAnswerArr().length; j++) {
			// if (q.getType().equals("single")) {
			// if (submit.get(i).getAnswers().equals(q.getAnswerArr()[j])) {
			// mark += q.getPoint();
			// System.out.print("Correct! Get " + q.getPoint() + " Marks");
			// } else
			// System.out.print("Incorrect!");
			// }
			// else if(q.getType().equals("multiple")) {
			// double totalPoint = q.getPoint();
			// String answer = "";
			// }
			// System.out.println("\n");
			// }
			if (q.getType().equals("single")) {
				if (submit.get(i).getAnswers() != null) {
					if (submit.get(i).getAnswers().equals(q.getAnswerArr()[0])) {
						mark += q.getPoint();
						System.out.print("Correct! Get " + q.getPoint() + " Marks");
						markingEach.setMark(q.getPoint());
						s.setMark(q.getPoint());
					} else {
						s.setMark(0);
						System.out.print("Incorrect! Get 0 Marks");
					}
				}
				service.saveMarkingEach(markingEach);
				System.out.println("\n");
			} else if (q.getType().equals("multiple")) {
				double fullPoint = q.getPoint();
				double pointForEach = fullPoint / q.getAnswerArr().length;
				double totalPoint = 0;
				for (int j = 0; j < submit.get(i).getAnswerArr().length; j++) {
					if (submit.get(i).getAnswerArr().length == q.getAnswerArr().length) {
						for (int k = 0; k < q.getAnswerArr().length; k++) {
							// if (submit.get(i).getAnswerArr()[j].equals(q.getAnswerArr()[k])) {
							// totalPoint += pointForEach;
							// }

							if (submit.get(i).getAnswerArr()[j].equals(q.getAnswerArr()[k])) {
								totalPoint += fullPoint;
							} else {
								totalPoint = 0;
								markingEach.setMark(totalPoint);
								s.setMark(totalPoint);
							}
						}
					}
				}
				mark += totalPoint;
				markingEach.setMark(totalPoint);
				s.setMark(totalPoint);
				service.saveMarkingEach(markingEach);
				System.out.print("Get " + totalPoint + " Marks\n");
			} else if (q.getType().equals("written")) {
				System.out.print("\n");
			} else if (q.getType().equals("fillIn")) {
				double fullPoint = q.getPoint();
				double pointForEach = fullPoint / q.getAnswerArr().length;
				double totalPoint = 0;
				if (getFillInAns != null) {
					for (int m = 0; m < getFillInAns.size(); m++) { // Each fill in question.
						if (getFillInAns.get(m).getQuestionId() == q.getId()) {
							for (int l = 0; l < q.getAnswerArr().length; l++) { // Each correct answer.
								// System.out.print(getFillInAns.get(m).getAnswers()+"hihi");
								// System.out.print("Correct: "+q.getAnswerArr()[l]+" Answer:
								// "+getFillInAns.get(m).getAnswerArr()[l]);
								if (q.getAnswerArr()[l].equals(getFillInAns.get(m).getAnswerArr()[l])) {
									totalPoint += pointForEach;
									System.out.print("TOTAL POINT " + totalPoint
											+ "DKASJDKLSJAUHCNCJDHHALDNASNDSAUDLSANDKSANKJDNASKJDNAJKSN");
								} else {
									totalPoint += 0;
									markingEach.setMark(totalPoint);
									s.setMark(totalPoint);
								}
							}
						}
					}
				}

				mark += totalPoint;
				markingEach.setMark(totalPoint);
				s.setMark(totalPoint);
				service.saveMarkingEach(markingEach);
				service.saveSubmitExam(s);
				System.out.print("Get " + totalPoint + " Marks\n");
				System.out.print("\n");
			}
		}
		Marking marking = new Marking();
		marking.setTestId(testId);
		marking.setStudentId(userId);
		marking.setTotalStudentPoint(mark);
		marking.setTotalPoint(getTotalPoint(testId));
		service.saveMarking(marking);

		System.out.print("\nTotal marks: " + mark + "/" + getTotalPoint(testId) + "\n");
	}

	@RequestMapping(value = { "/result" })
	public ModelAndView result(@RequestParam(value = "studentId", required = true) int studentId,
			@RequestParam(value = "testId", required = true) int testId) {

		Tests t = service.findByTestTestId(testId);
		Marking m = service.getMarking(testId, studentId);
		
		int passPercent = 0;
		double totalMark = 0;
		double passMark = 0;
		double studentMark = 0;
		if(m != null) {
			 passPercent = t.getPassPercent();
			 totalMark = m.getTotalPoint();
			 passMark = (totalMark * passPercent)/100;
			 studentMark = m.getTotalStudentPoint();
		}
//		System.out.print("passPercent: "+passPercent+" totalMark: "+totalMark+"\n");
//		System.out.print("PassMark: "+passMark+" studentMark: "+studentMark);
		boolean pass = false;
		if(studentMark >= passMark)
			pass = true;
			

		ModelAndView mv = new ModelAndView("result");
		mv.addObject("marking", service.getMarking(testId, studentId));
		mv.addObject("questions", service.findByTestId(testId));
		mv.addObject("testName", t.getTestName());
		mv.addObject("pass", pass);
		mv.addObject("submitAns", service.getSubmitExam(testId, studentId));
		mv.addObject("markingEach", service.getMarkingEach(testId, studentId));

		return mv;
	}

	@RequestMapping(value = { "/marking" })
	public ModelAndView markingPage(@RequestParam(value = "testId", required = true) int testId) {
		Tests t = service.findByTestTestId(testId);
		String[] students = t.getStudentsArr();
		List<Users> studentList = new ArrayList<Users>();
		for (int i = 0; i < students.length; i++) {
			studentList.add(service.findByUserId1(Integer.parseInt(students[i])));
		}

		ModelAndView mv = new ModelAndView("marking", "students", studentList);
		mv.addObject("userId", t.getUserId());
		mv.addObject("testId", t.getTestId());
		mv.addObject("questions", service.findByTestId(testId));
		mv.addObject("submitExamForm", new SubmitExamForm());
		return mv;
	}

	private double getTotalPoint(int testId) {
		List<QuestionAndAns> qa = service.findByTestId(testId);
		double totalPoint = 0;
		for (int i = 0; i < qa.size(); i++) {
			totalPoint += qa.get(i).getPoint();
		}

		return totalPoint;
	}

	@RequestMapping(value = { "/getMarkingEach" })
	public List<MarkingEachQuestion> getMarkingEach(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "studentId", required = true) int studentId) {
		return service.getMarkingEach(testId, studentId);
	}

	@RequestMapping(value = { "/getQuestion" })
	public QuestionAndAns getQuestion(@RequestParam(value = "questionId", required = true) int questionId) {
		return service.findByQuestionId(questionId);
	}

	@RequestMapping(value = { "/getQuestions" })
	public List<QuestionAndAns> getQuestions(@RequestParam(value = "testId", required = true) int testId) {
		// ModelAndView mv = new ModelAndView();
		// mv.addObject("questionList", service.findByTestId(testId));
		return service.findByTestId(testId);
	}

	@RequestMapping(value = { "/getAnswers" })
	public List<SubmitExam> getAnswers(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "studentId", required = true) int studentId) {
		return service.getSubmitExam(testId, studentId);
	}

	@RequestMapping(value = { "/addFeedback" })
	public ModelAndView addFeedback(@Valid @ModelAttribute("submitExamForm") SubmitExamForm submitExamForm)
			throws Exception {
		int testId = 0;
		int studentId = 0;
		
		if (submitExamForm != null) {
			System.out.print("SIZE: " + submitExamForm.getSubmitExamForm().size() + "\n");
			for (int i = 0; i < submitExamForm.getSubmitExamForm().size(); i++) {
				if (submitExamForm.getSubmitExamForm().get(i).getQuestionId() != 0) {
					if (submitExamForm.getSubmitExamForm().get(i).getQuestionType().equals("fillIn")
							|| submitExamForm.getSubmitExamForm().get(i).getQuestionType().equals("written")) {
						testId = submitExamForm.getSubmitExamForm().get(i).getTestId();
						studentId = submitExamForm.getSubmitExamForm().get(i).getStudentId();

						SubmitExam s = service.getSubmitAnswer(submitExamForm.getSubmitExamForm().get(i).getTestId(),
								submitExamForm.getSubmitExamForm().get(i).getStudentId(),
								submitExamForm.getSubmitExamForm().get(i).getQuestionId());
						s.setMark(submitExamForm.getSubmitExamForm().get(i).getMark());
						s.setFeedback(submitExamForm.getSubmitExamForm().get(i).getFeedback());

						service.saveSubmitExam(s);
					}
				}
			}

			// Update marking.
			Marking m = service.getMarking(testId, studentId);
			List<SubmitExam> submit = service.getSubmitExam(testId, studentId);
			double totalMark = 0;
			for (SubmitExam s : submit) {
				totalMark += s.getMark();
			}
			m.setTotalStudentPoint(totalMark);
			service.saveMarking(m);
			sendEmail(testId,studentId);
			
//			totalMark = 0;
//			studentId = 0;
//			testId = 0;
		}
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Users user = service.findByUsername(auth.getName());
		
		return new ModelAndView("redirect:/service/marking?testId="+testId);
	}

	@RequestMapping(value = { "/updateQuestion" })
	public @ResponseBody QuestionAndAns updateQuestion(@RequestParam(value = "qId", required = true) int qId,
			@RequestParam(value = "qType", required = true) String qType,
			@RequestParam(value = "qText", required = true) String qText,
			@RequestParam(value = "choices", required = true) String choices,
			@RequestParam(value = "answers", required = true) String answers,
			@RequestParam(value = "qPoint", required = true) int qPoint,
			@RequestParam(value = "testId", required = true) int testId) {

		QuestionAndAns qa = new QuestionAndAns();
		// CHECK NULL
		qa.setId(qId);
		qa.setType(qType);
		qa.setTxt(qText);
		// String[] choiceArr = splitByComma(choices);
		qa.setChoices(choices);
		qa.setAnswers(answers);
		qa.setPoint(qPoint);
		qa.setTestId(testId);

		// System.out.print(qText);
		service.saveQuestion(qa);
		return qa;
	}

	@RequestMapping(value = { "/importQuestion" })
	public boolean importQuestion(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "questionId", required = true) String id) {
		String[] questionId = id.split(",");
		if (questionId != null) {
			QuestionAndAns qa = new QuestionAndAns();
			for (int i = 0; i < questionId.length; i++) {
				qa = service.findByQuestionId(Integer.parseInt(questionId[i]));
				if (qa != null) {
					createQuestion(qa.getType(), qa.getText(), qa.getChoices(), qa.getAnswer(), qa.getPoint(), testId);
				}
			}
			return true;
		} else
			return false;
	}

	@RequestMapping(value = { "/getStudents" })
	public String[] getStudent(@RequestParam(value = "testId", required = true) int testId) {
		Tests t = service.findByTestTestId(testId);
		return t.getStudentsArr();
	}

	@RequestMapping(value = { "/addStudents" })
	public void addStudent(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "students", required = true) String students) {
		Tests t = service.findByTestTestId(testId);
		t.setStudents(students);
		service.saveTest(t);
	}

	@RequestMapping(value = { "/publishTest" })
	public void publishTest(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "publish", required = true) String publish) {
		Tests t = service.findByTestTestId(testId);
		t.setPublish(publish);
		service.saveTest(t);
	}

	@RequestMapping(value = { "/getTest" })
	public Tests getTest(@RequestParam(value = "testId", required = true) int testId) {
		return service.findByTestTestId(testId);
	}

	@RequestMapping(value = { "/updateTest" })
	public void updateTest(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "timelimit", required = true) int timelimit,
			@RequestParam(value = "passPercent", required = true) int passPercent) {
		Tests t = service.findByTestTestId(testId);
		t.setTimelimit(timelimit);
		t.setPassPercent(passPercent);
		service.saveTest(t);
	}

	@RequestMapping(value = { "/submittedStudent" })
	public boolean submittedStudent(@RequestParam(value = "testId", required = true) int testId,
			@RequestParam(value = "studentId", required = true) int studentId) {
		List<SubmitExam> submit = service.getSubmitExam(testId, studentId);
		boolean submitted = false;
		if(submit.size() != 0) {
			submitted = true;
		}else {
			submitted = false;
		}
		return submitted;
	}
	
	@Autowired
    private JavaMailSender sender;
	
//	@RequestMapping(value = { "/sendEmail" })
    private void sendEmail(int testId,int studentId) throws Exception{
    	
    	Tests test = service.findByTestTestId(testId);
    	Users user = service.findByUserId1(studentId);
    	
        MimeMessage message = sender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message);
        
        helper.setTo(user.getEmail());
        helper.setText("Your test result has been updated by the professor. Please visit http://localhost:8080/service/result?studentId="+studentId+"&testId="+testId);
        helper.setSubject("Test "+test.getTestName()+" result.");
        
        sender.send(message);
    }
}
