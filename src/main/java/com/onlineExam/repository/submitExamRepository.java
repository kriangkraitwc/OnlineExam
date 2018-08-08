package com.onlineExam.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.onlineExam.domain.SubmitExam;

@Repository
public interface submitExamRepository extends CrudRepository<SubmitExam, Integer> {

	List<SubmitExam> findByTestIdAndStudentId(int testId, int studentId);

	SubmitExam findByTestIdAndStudentIdAndQuestionId(int testId, int studentId, int questionId);
}
