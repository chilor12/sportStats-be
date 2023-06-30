package sportStats.sportStatsBe.serviceImpl;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import sportStats.sportStatsBe.constant.SportStatsError;
import sportStats.sportStatsBe.dto.UserDTO;
import sportStats.sportStatsBe.entity.User;
import sportStats.sportStatsBe.exception.SportStatsException;
import sportStats.sportStatsBe.mapper.UserMapper;
import sportStats.sportStatsBe.repository.UserRepository;
import sportStats.sportStatsBe.service.IUserService;

@Service
public class UserService implements IUserService {

	@Autowired
	UserRepository userRepository;
	
	@Override
	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public UserDTO findByMailAndPassword(final String username, final String password) {
		Optional<User> optionalUser = userRepository.findByMailAndPasswordAndValid(username, password);
		if (optionalUser.isPresent())
			return UserMapper.INSTANCE.toDTO(optionalUser.get());
		else
			throw new SportStatsException(SportStatsError.INCORRECT_USERNAME_PASSWORD);
	}

}
