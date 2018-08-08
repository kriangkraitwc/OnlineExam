package com.onlineExam.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.onlineExam.domain.Tests;

@Repository
public interface TestsRepository extends CrudRepository<Tests,Integer>{

	List<Tests> findByUserId(int Id);
}
