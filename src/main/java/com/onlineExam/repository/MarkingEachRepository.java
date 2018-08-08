package com.onlineExam.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.onlineExam.domain.MarkingEachQuestion;
import com.onlineExam.domain.Tests;

public interface MarkingEachRepository extends CrudRepository<MarkingEachQuestion,Integer>{
	
	List<MarkingEachQuestion> findByTestIdAndStudentId(int testId,int studentId);
}
