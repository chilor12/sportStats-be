package sportStats.sportStatsBe.core;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jboss.logging.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import com.auth0.jwt.JWT;
import com.auth0.jwt.RegisteredClaims;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.auth0.jwt.interfaces.DecodedJWT;

import sportStats.sportStatsBe.annotation.NoAuth;
import sportStats.sportStatsBe.constant.HttpHeaderKey;
import sportStats.sportStatsBe.constant.JwtKeys;
import sportStats.sportStatsBe.constant.MDCKeys;
import sportStats.sportStatsBe.constant.SportStatsError;
import sportStats.sportStatsBe.exception.SportStatsException;
import sportStats.sportStatsBe.serviceImpl.SessionService;

@Component
public class HttpInterceptor implements HandlerInterceptor {

	@Autowired
	private SessionService sessionService;

	@Autowired
	private JwtConfig jwtConfig;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HandlerMethod handlerMethod = handler instanceof HandlerMethod ? (HandlerMethod) handler : null;
		if (handlerMethod != null && (!(handlerMethod.getBean() instanceof BasicErrorController)))
			{
				boolean authRequired = !handlerMethod.getMethod().isAnnotationPresent(NoAuth.class);
				MDC.put(MDCKeys.URL, request.getRequestURL().toString() + (StringUtils.hasText(request.getQueryString()) ? ("?" + request.getQueryString()) : ""));
				if (authRequired)
				{
					String authorization = request.getHeader(HttpHeaderKey.AUTHORIZATION);
					if (StringUtils.hasText(authorization))
					{
						String jwt = SessionService.getJwtFromAuthorization(authorization);
						if (StringUtils.hasText(jwt))
						{
							try {
								DecodedJWT decodedJWT = JWT.require(Algorithm.HMAC256(jwtConfig.getSecret())).build().verify(jwt);
								String newJwt = sessionService.buildJwt(decodedJWT.getClaim(RegisteredClaims.SUBJECT).asString());
								MDC.put(MDCKeys.USERNAME, decodedJWT.getSubject());
								response.setHeader(HttpHeaderKey.AUTHORIZATION, JwtKeys.JWT_PREFIX + newJwt);
								return true;
							} catch (TokenExpiredException e) {
								throw new SportStatsException(SportStatsError.EXPIRED_SESSION);
							}
						}
					}
					throw new SportStatsException(SportStatsError.UNAUTHORIZED);
				}
		}
		return true;
	}
	
}
