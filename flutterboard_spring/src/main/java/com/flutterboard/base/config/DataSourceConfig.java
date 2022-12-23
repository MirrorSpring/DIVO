//DB 사용을 위한 설정 파일로 application.properties에 선언된 spring.datasource.*의 값들로 DataSource를 빌드
//DB 연동은 다른 방법으로도 가능하지만 편리한 유지 보수를 위해 클래스 파일로 분리하는 작업

package com.flutterboard.base.config;

import javax.sql.DataSource;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataSourceConfig {

	@ConfigurationProperties(prefix="spring.datasource")
	public DataSource dataSource() {
		return DataSourceBuilder.create().build();
	}
}
