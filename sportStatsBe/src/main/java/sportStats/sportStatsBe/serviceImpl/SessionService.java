package sportStats.sportStatsBe.serviceImpl;

import java.security.NoSuchAlgorithmException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import sportStats.sportStatsBe.constant.HttpHeaderKey;
import sportStats.sportStatsBe.constant.JwtKeys;
import sportStats.sportStatsBe.core.JwtConfig;
import sportStats.sportStatsBe.dto.CreateSessionRequestDTO;
import sportStats.sportStatsBe.dto.UserDTO;
import sportStats.sportStatsBe.service.IUserService;

@Service
public class SessionService {

	@Autowired
	private IUserService userService;

	@Autowired
	private JwtConfig jwtConfig;
	
	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public ResponseEntity<UserDTO> create(final CreateSessionRequestDTO requestDTO) throws NoSuchAlgorithmException {
//		validateRequest(requestDTO);
		// find user for username and password
		UserDTO userDTO = userService.findByMailAndPassword(
				requestDTO.getUsername(),
				requestDTO.getPassword());
//				UserService.getHashText(requestDTO.getPassword()));

		// set jwt in http response headers
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.set(
				HttpHeaderKey.AUTHORIZATION,
				JwtKeys.JWT_PREFIX + buildJwt(userDTO.getMail())
		);
		return ResponseEntity.ok().headers(responseHeaders).body(userDTO);
	}

	
	public String buildJwt(final String username) {
		return JWT.create()
				.withSubject(username)
				.withIssuedAt(new Date())
				.withExpiresAt(new Date(System.currentTimeMillis() + jwtConfig.getLife()))
				.sign(Algorithm.HMAC256(jwtConfig.getSecret()));
	}

	public static String getJwtFromAuthorization(final String authorization) {
		return StringUtils.hasText(authorization) ? authorization.substring(authorization.indexOf(" ") + 1) : "";
	}
	
}
