package com.example.demo;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import org.testcontainers.containers.GenericContainer;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class DemoApplicationTests {

	@Autowired
	TestRestTemplate restTemplate;
	public static GenericContainer<?> appDev = new GenericContainer<>("devapp").withExposedPorts(8080);
	public static GenericContainer<?> appProd = new GenericContainer<>("prodapp").withExposedPorts(8081);

	@BeforeAll
	public static void setUp() {
		appDev.start();
		appProd.start();
	}

	@AfterAll
	public static void setDown() {
		appDev.stop();
		appProd.stop();
	}

	@Test
	void contextLoads() {
		ResponseEntity<String> forEntityDev = restTemplate
				.getForEntity("http://localhost:" + appDev.getMappedPort(8080) + "/profile", String.class);
		ResponseEntity<String> forEntityProd = restTemplate
				.getForEntity("http://localhost:" + appProd.getMappedPort(8081)+ "/profile", String.class);


		String bodyDev = forEntityDev.getBody(),
				bodyProd = forEntityProd.getBody();
		System.out.println(bodyDev);
		Assertions.assertTrue("Current profile is dev".equals(bodyDev));
		System.out.println(bodyProd);
		Assertions.assertTrue("Current profile is production".equals(bodyProd));
	}

}
