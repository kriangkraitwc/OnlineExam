package com.onlineExam.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.onlineExam.domain.QuestionAndAns;

@Repository
public interface QuestionAndAnsRepository extends CrudRepository<QuestionAndAns,Integer>{

	//List<QuestionAndAns> findByparentpath(String parent);
	List<QuestionAndAns> findByTestId(int testId);
	
}
