package com.onlineExam.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.onlineExam.domain.Marking;

public interface MarkingRepository extends CrudRepository<Marking,Integer>{
	
	Marking findByTestIdAndStudentId(int testId,int studentId);

}
