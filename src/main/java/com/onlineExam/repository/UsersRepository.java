package com.onlineExam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import com.onlineExam.domain.Users;

public interface UsersRepository  extends JpaRepository<Users,Integer>{
	Users findByUsername(String username);
}
