package com.onlineExam.service;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.onlineExam.domain.Marking;
import com.onlineExam.domain.MarkingEachQuestion;
import com.onlineExam.domain.QuestionAndAns;
import com.onlineExam.domain.Role;
import com.onlineExam.domain.SubmitExam;
import com.onlineExam.domain.Tests;
import com.onlineExam.domain.Users;
import com.onlineExam.repository.MarkingEachRepository;
import com.onlineExam.repository.MarkingRepository;
import com.onlineExam.repository.QuestionAndAnsRepository;
import com.onlineExam.repository.RoleRepository;
import com.onlineExam.repository.TestsRepository;
import com.onlineExam.repository.UsersRepository;
import com.onlineExam.repository.submitExamRepository;

@Service
public class OnlineExamService {

	@Autowired
	private QuestionAndAnsRepository qRepository;
	@Autowired
	private TestsRepository tRepository;
	@Autowired
	private submitExamRepository sRepository;	
	@Autowired
	private MarkingRepository mRepository;
	@Autowired
	private MarkingEachRepository meRepository;
	@Autowired
	private UsersRepository uRepository;
	@Autowired
	private RoleRepository rRepository;
	@Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

	public boolean saveQuestion(QuestionAndAns qa) {
		qRepository.save(qa);
		return true;
	}

	public boolean saveTest(Tests test) {
		tRepository.save(test);
		return true;
	}

	public boolean saveSubmitExam(SubmitExam submitExam) {
		sRepository.save(submitExam);
		return true;
	}
	
	public boolean saveMarking(Marking mark) {
		mRepository.save(mark);
		return true;
	}
	
	public void saveUser(Users user) {
		user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
		user.setActive(1);
        Role userRole = rRepository.findByRole(user.getUserType());
        user.setRoles(new HashSet<Role>(Arrays.asList(userRole)));
		uRepository.save(user);
	}
	
	public boolean saveMarkingEach(MarkingEachQuestion mark) {
		meRepository.save(mark);
		return true;
	}

	public Object findAllQuestion() {
		return qRepository.findAll();
	}
	
	public Iterable<Tests> findAllTest(){
//		List<Tests> testList = new ArrayList<>();
//		String studentId = Integer.toString(id);
//		
//		Iterable<Tests> t = tRepository.findAll();
//		for (Tests t1 : t) {
//			if(t1.getStudents()!=null) {
//				for(int i=0;i<t1.getStudentsArr().length;i++) {
//					if(t1.getStudentsArr()[i].equals(studentId)) {
//						testList.add(t1);
//					}
//				}
//			}
//		}
		
		return tRepository.findAll();
	}

	public List<QuestionAndAns> findByTestId(int id) {
		return qRepository.findByTestId(id);
	}
	
	public Users findByUsername(String username) {
		return uRepository.findByUsername(username);
	}

	public List<Tests> findByUserId(int id) {
		return tRepository.findByUserId(id);
	}

	public Tests findByTestTestId(int id) {
		return tRepository.findOne(id);
	}
	
	public Users findByUserId1(int id) {
		return uRepository.findOne(id);
	}
	
	public Iterable<Users> finAllUser(){
		return uRepository.findAll();
	}

	public boolean deleteByQuestionId(int id) {
		if (qRepository.findOne(id) != null) {
			qRepository.delete(id);
			return true;
		} else
			return false;
	}
	
	public boolean deleteByTestId(int id) {
		if (tRepository.findOne(id) != null) {
			tRepository.delete(id);
			List<QuestionAndAns> q = findByTestId(id);
			for(QuestionAndAns q1: q) {
				deleteByQuestionId(q1.getId());
			}		
			return true;
		} else
			return false;
	}

	public QuestionAndAns findByQuestionId(int id) {
		return qRepository.findOne(id);
	}

	public List<SubmitExam> getSubmitExam(int testId,int userId) {
//		List<SubmitExam> sa = new ArrayList<SubmitExam>();
		
		return sRepository.findByTestIdAndStudentId(testId,userId);
	}
	
	public SubmitExam getSubmitAnswer(int testId, int studentId, int questionId) {
		return sRepository.findByTestIdAndStudentIdAndQuestionId(testId, studentId, questionId);
	}
	
	public Marking getMarking(int testId, int userId){
		return mRepository.findByTestIdAndStudentId(testId, userId);
	}
	
	public List<MarkingEachQuestion> getMarkingEach(int testId, int studentId){
		return meRepository.findByTestIdAndStudentId(testId, studentId);
	}

}
