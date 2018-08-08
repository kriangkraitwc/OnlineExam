package com.onlineExam.config;

import javax.sql.DataSource;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	private DataSource dataSource;
	
	@Value("${spring.queries.users-query}")
	private String usersQuery;
	
	@Value("${spring.queries.roles-query}")
	private String rolesQuery;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth)
			throws Exception {
		auth.
			jdbcAuthentication()
				.usersByUsernameQuery(usersQuery)
				.authoritiesByUsernameQuery(rolesQuery)
				.dataSource(dataSource)
				.passwordEncoder(bCryptPasswordEncoder);
	}
	
//	@Autowired
//	DataSource dataSource;
//	
//	@Autowired
//	public void configAuthentication(AuthenticationManagerBuilder auth) throws Exception {
//		
//	  auth.jdbcAuthentication().dataSource(dataSource)
//		.usersByUsernameQuery(
//			"select username,password,active from users where username=?")
//		.authoritiesByUsernameQuery(
//			"select u.username, r.role from users u inner join user_role ur on(u.user_id=ur.user_id) inner join role r on(ur.role_id=r.role_id) where u.username=?");
//	}
	
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
        .csrf().disable()
            .authorizeRequests()
                .antMatchers("/login").permitAll()
                .antMatchers("/service/registration").permitAll()
                .antMatchers("/service/testList").hasAuthority("PROFESSOR")
                .antMatchers("/service/createQuestion").hasAuthority("PROFESSOR")
                .antMatchers("/service/testPreview").hasAuthority("PROFESSOR")
                .antMatchers("/service/marking").hasAuthority("PROFESSOR")
                .antMatchers("/service/testListStudent").hasAuthority("STUDENT")
                .antMatchers("/service/result").hasAuthority("STUDENT")
                .antMatchers("/service/exam").hasAuthority("STUDENT")
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
				.defaultSuccessUrl("/service/default")
				.usernameParameter("username")
				.passwordParameter("password")
                .and()
            .logout()
            .logoutSuccessUrl("/login");
    }
    
    @Autowired
	public void configureGlobal(AuthenticationManagerBuilder authenticationMgr) throws Exception {
		authenticationMgr
						.inMemoryAuthentication()
						.withUser("user")
						.password("password")
						.authorities("PROFESSOR");
		authenticationMgr
						.inMemoryAuthentication()
						.withUser("user1")
						.password("password")
						.authorities("STUDENT");
	}
//    @Bean
//    @Override
//    public UserDetailsService userDetailsService() {
//        UserDetails user =
//             User.withDefaultPasswordEncoder()
//                .username("user")
//                .password("password")
//                .roles("USER")
//                .build();
//
//        return new InMemoryUserDetailsManager(user);
//    }
}







