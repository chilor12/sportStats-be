package sportStats.sportStatsBe.service;

import java.security.NoSuchAlgorithmException;

import sportStats.sportStatsBe.dto.ChangePasswordRequestDTO;
import sportStats.sportStatsBe.dto.UserDTO;

public interface IUserService {

	UserDTO findByMailAndPassword(String mail, String password);

//	void changePassword(ChangePasswordRequestDTO body) throws NoSuchAlgorithmException;

//	void resetPassword(String mail) throws NoSuchAlgorithmException;

//	UserDTO updateByEmail(UserDTO dto);

	
}
