package com.onlineExam.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import com.mysql.jdbc.Connection;

public class SqlConnection {
	
	private static Connection connection = null;
	
	public static Connection getConnection() {
        if (connection != null)
            return connection;
        else {
            try {
             Properties prop = new Properties();
                InputStream inputStream = SqlConnection.class.getClassLoader().getResourceAsStream("/config.properties");
                prop.load(inputStream);
                String driver = prop.getProperty("com.mysql.jdbc.Driver");
                String url = prop.getProperty("jdbc:mysql://localhost:3306/online_examination");
                String user = prop.getProperty("root");
                String password = prop.getProperty("12345678");
                Class.forName(driver);
                connection = (Connection) DriverManager.getConnection(url, user, password);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return connection;
        }
    }
}
