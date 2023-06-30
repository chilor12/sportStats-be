package sportStats.sportStatsBe;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import sportStats.sportStatsBe.constant.HttpHeaderKey;
import sportStats.sportStatsBe.core.HttpInterceptor;

@Configuration
@ComponentScan (basePackages = "sportStats.sportStatsBe")
public class WebMvcConfig implements WebMvcConfigurer {
	
	@Autowired
	private HttpInterceptor httpInterceptor;

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(httpInterceptor);
	}
    
	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry
			.addMapping("/**")
			.allowedMethods("*")
			.exposedHeaders(
					HttpHeaderKey.ACCESS_CONTROL_EXPOSE_HEADERS,
					HttpHeaderKey.AUTHORIZATION,
					HttpHeaders.CONTENT_DISPOSITION
			);
	}
    
}
